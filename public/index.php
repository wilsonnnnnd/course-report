<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Course Report</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" rel="stylesheet">
</head>
<body class="p-4">

<h2>Course Enrolment Report</h2>
<div class="mb-2">
  <label for="statusFilter" class="me-2">Status:</label>
  <select id="statusFilter" class="form-select form-select-sm" style="width:200px; display:inline-block; vertical-align:middle;">
    <option value="">All</option>
    <option value="completed">Completed</option>
    <option value="in progress">In Progress</option>
    <option value="not started">Not Started</option>
  </select>
</div>

<table id="report" class="table table-striped">
  <thead>
    <tr>
      <th>User</th>
      <th>Course</th>
      <th>Status</th>
      <th>Enrolled At</th>
      <th>Completed At</th>
    </tr>
  </thead>
</table>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="assets/app.js"></script>
</body>
</html>
