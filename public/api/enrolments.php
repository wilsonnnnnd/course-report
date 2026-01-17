<?php
// Load database connection and SQL helper functions.
require_once __DIR__ . '/../../src/db.php';
require_once __DIR__ . '/../../src/queries.php';

// Read pagination values from the query string (GET parameters).
// force numbers and use safe defaults to avoid invaild input.
$page = max(1, (int)($_GET['page'] ?? 1));
// pageSize: default 25, minimum 10, maximum 50
$pageSize = min(50, max(10, (int)($_GET['pageSize'] ?? 25)));
// Calculate offset for SQL LIMIT/OFFSET
$offset = ($page - 1) * $pageSize;

// Read filter inputs. Use trim on search to remove extra spaces.
$search = trim($_GET['search'] ?? '');
// Minimum 2 search length to apply filtering 
$minSearchLen = 2;

// Use mb_strlen when available, fall back to strlen to avoid fatal errors
$searchLen = function_exists('mb_strlen') ? mb_strlen($search) : strlen($search);

$status = $_GET['status'] ?? '';

// Build WHERE clauses and parameter map for prepared statements.
$where = [];
$params = [];

// If the user provided a search term, match it using PREFIX LIKE so indexes can be used.
if ($search !== '' && $searchLen >= $minSearchLen) {
    $where[] = "(
        u.last_name LIKE :q
        OR u.first_name LIKE :q
        OR c.description LIKE :q
    )";
    // Prefix matching: can use B-Tree indexes (Route A)
    $params[':q'] = $search . '%';
}

// If a status filter is provided, add it to the WHERE clause.
$allowedStatuses = ['completed', 'in progress', 'not started'];
if (in_array($status, $allowedStatuses, true)) {
    $where[] = "e.completion_status = :status";
    $params[':status'] = $status;
}

// Join all WHERE parts with AND, or leave empty if there are none.
$whereSql = $where ? 'WHERE ' . implode(' AND ', $where) : '';

// Prepare and run a COUNT query to get the total number of rows
// that match the filters. This is used for pagination metadata.
$stmt = $pdo->prepare(enrolments_total_sql($whereSql));
// Bind parameters robustly (accepts both 'q' and ':q' keys)
foreach ($params as $k => $v) {
    $paramName = is_string($k) && strpos($k, ':') === 0 ? $k : ':' . ltrim((string)$k, ':');
    $stmt->bindValue($paramName, $v);
}
$stmt->execute();
$total = (int)$stmt->fetchColumn();

// Get the data SQL. The helper will include LIMIT and OFFSET
// using the integer values we computed above.
// Handle ordering from DataTables. Map column index to SQL expression.
$orderCol = isset($_GET['orderCol']) ? (int)$_GET['orderCol'] : null;
$orderDir = (isset($_GET['orderDir']) && strtolower($_GET['orderDir']) === 'asc') ? 'ASC' : 'DESC';

$columnsMap = [
    0 => "u.first_name",
    1 => "c.description",
    2 => "e.completion_status",
    3 => "e.enrolled_at",
    4 => "e.completed_at"
];

$orderSql = '';
if (array_key_exists($orderCol, $columnsMap)) {
    $orderSql = 'ORDER BY ' . $columnsMap[$orderCol] . ' ' . $orderDir;
}

$dataSql = enrolments_data_sql($whereSql, (int)$pageSize, (int)$offset, $orderSql);

// Prepare and execute the main data query. We bind the same
// search/status parameters so the data matches the count.
// LIMIT/OFFSET are safe because they were inlined as integers.
$stmt = $pdo->prepare($dataSql);
foreach ($params as $k => $v) {
    $paramName = is_string($k) && strpos($k, ':') === 0 ? $k : ':' . ltrim((string)$k, ':');
    $stmt->bindValue($paramName, $v);
}
$stmt->execute();

// Return JSON with pagination metadata and the result rows.
// Using json_encode ensures proper JSON output for the API.
echo json_encode([
    'page' => $page,
    'pageSize' => $pageSize,
    'total' => $total,
    'rows' => $stmt->fetchAll()
]);