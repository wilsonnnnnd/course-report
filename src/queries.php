<?php

function enrolments_total_sql($whereSql = '')
{
    return "
        SELECT COUNT(*) FROM Enrolments e
        JOIN Users u ON u.user_id = e.user_id
        JOIN Courses c ON c.course_id = e.course_id
        $whereSql
    ";
}

function enrolments_data_sql($whereSql = '', $limit = 25, $offset = 0, $orderSql = '')
{
    // $orderSql should be a safe SQL fragment like "ORDER BY e.enrolled_at DESC"
    // If empty, caller can provide default ordering.
    return "
        SELECT
            e.enrolment_id,
            CONCAT(u.first_name, ' ', u.last_name) AS user_name,
            c.description AS course,
            e.completion_status,
            e.enrolled_at,
            e.completed_at
        FROM Enrolments e
        JOIN Users u ON u.user_id = e.user_id
        JOIN Courses c ON c.course_id = e.course_id
        $whereSql
        " . ($orderSql ?: "ORDER BY e.enrolment_id DESC") . "
        LIMIT $limit OFFSET $offset
    ";
}
