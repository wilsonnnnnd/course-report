$(function () {
  // Initialize DataTable and keep reference to the instance
  const table = $('#report').DataTable({
    serverSide: true,
    processing: true,
    searching: true,
    pageLength: 25,
    ajax: function (data, callback) {
      const page = Math.floor(data.start / data.length) + 1;

      // send ordering info to server: column index and direction
      const order = (data.order && data.order.length) ? data.order[0] : null;

      // read status filter value from the dropdown
      const status = $('#statusFilter').val();

      $.getJSON('/api/enrolments.php', {
        page: page,
        pageSize: data.length,
        search: data.search.value,
        status: status,
        orderCol: order ? order.column : undefined,
        orderDir: order ? order.dir : undefined
      }, function (res) {
        callback({
          recordsTotal: res.total,
          recordsFiltered: res.total,
          data: res.rows.map(r => [
            r.user_name,
            r.course,
            r.completion_status,
            r.enrolled_at,
            r.completed_at ?? ''
          ])
        });
      });
    }
  });

  // When status filter changes, reload the table data
  $('#statusFilter').on('change', function () {
    table.ajax.reload();
  });
});
