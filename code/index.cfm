<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>DataTables + ColdFusion Demo</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.datatables.net/2.1.8/css/dataTables.bootstrap5.css">

        <style>
            body {
                padding: 1.5rem 0;
            }

            .dt-container .dt-paging .pagination {
                gap: 0 !important;
                margin: 0 !important;
                justify-content: center;
            }

            .dt-container .dt-paging .page-item {
                margin: 0 1px !important;
                padding: 0 !important;
            }

            .dt-container .dt-paging .page-link {
                padding: .2rem .45rem !important;
                min-width: 1.9rem;
                line-height: 1.05;
                font-size: .95rem;
            }

            .dt-container .dt-paging .page-item:first-child,
            .dt-container .dt-paging .page-item:last-child {
                margin: 0 2px !important;
            }
        </style>
    </head>

    <body>
        <main class="container-fluid px-4">
            <div class="row">
                <div class="col text-center">
                    <h3>DataTables Demo using a cfscript based CFC, jQuery and Bootstrap 5</h3>
                    <p class="text-start">
                        <a class="btn btn-sm btn-outline-secondary hideNotes" href="##" id="showInstructions" title="Show/Hide Instructions">
                            <span class="link-text">Show/Hide Notes</span>
                        </a>
                    </p>
                </div>
            </div>

            <div class="row" id="quickInstructions">
                <div class="col">
                    <p>Some Notes:</p>
                    <ul>
                        <li>This demo shows how to use DataTables with ColdFusion 2023.</li>
                        <li>It uses CommandBox to run ColdFusion 2023, and DataTables to query a MySQL database.</li>
                        <li>The SQL file with the demo data is included in <strong>db_data/cf_user_employee.sql</strong>.</li>
                        <li>Create the <strong>cf_user</strong> database, then run <strong>cf_user_employee.sql</strong>.</li>
                        <li>Create a ColdFusion datasource named <strong>cf_user</strong>.</li>
                        <li>This page demonstrates server-side sorting, pagination, and searching.</li>
                        <li>
                            DataTables sends many request fields. This page posts them as a JSON body so recent ColdFusion
                            remote argument matching changes do not reject the request before the CFC can process it.
                        </li>
                    </ul>
                    <p>
                        <a class="btn btn-sm btn-outline-secondary hideNotes" href="##" id="hideOrShowNotes" title="Show/Hide Instructions">
                            <span class="link-text">Hide Notes</span>
                        </a>
                    </p>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <div class="table-responsive">
                        <table id="employees" class="table table-sm table-striped table-hover table-bordered compact dt-center rounded">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Position</th>
                                    <th>Salary</th>
                                    <th>Office</th>
                                    <th>Extension</th>
                                    <th>Start date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>

        <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdn.datatables.net/2.1.8/js/dataTables.js"></script>
        <script src="https://cdn.datatables.net/2.1.8/js/dataTables.bootstrap5.js"></script>

        <script>
            $(function() {
                $('#quickInstructions').hide();

                let table = $('#employees').DataTable({
                    autoWidth: true,
                    processing: true,
                    serverSide: true,
                    rowId: 'employee_id',
                    ajax: {
                        url: 'com/Employees.cfc?method=getEmployeesJSON',
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        data: function(data) {
                            return JSON.stringify(data);
                        }
                    },
                    language: {
                        infoEmpty: 'No records available'
                    },
                    paging: true,
                    pageLength: 10,
                    lengthMenu: [10, 25, 50, { label: 'All', value: -1 }],
                    drawCallback: function() {
                        $('#employees_wrapper .pagination').addClass('pagination-sm');
                    },
                    columns: [
                        {
                            title: 'ID',
                            data: 'employee_id',
                            searchable: false,
                            orderable: true,
                            className: 'dt-center fs-6',
                            type: 'num',
                            width: '25px'
                        },
                        {
                            title: 'Name',
                            data: 'name',
                            type: 'string',
                            searchable: true,
                            orderable: true,
                            className: 'dt-center fs-6'
                        },
                        {
                            title: 'Position',
                            data: 'position',
                            type: 'string',
                            searchable: true,
                            orderable: true,
                            className: 'dt-center fs-6'
                        },
                        {
                            title: 'Salary',
                            data: 'salary',
                            type: 'num-fmt',
                            searchable: true,
                            orderable: true,
                            className: 'dt-center fs-6',
                            render: function(data) {
                                return new Intl.NumberFormat('en-US', {
                                    style: 'currency',
                                    currency: 'USD'
                                }).format(data);
                            }
                        },
                        {
                            title: 'Office',
                            data: 'office',
                            type: 'string',
                            searchable: true,
                            orderable: true,
                            className: 'dt-center fs-6'
                        },
                        {
                            title: 'Extension',
                            data: 'extn',
                            type: 'string',
                            searchable: true,
                            orderable: true,
                            className: 'dt-center fs-6'
                        },
                        {
                            title: 'Start Date',
                            data: 'start_date',
                            type: 'date',
                            searchable: false,
                            orderable: false,
                            className: 'dt-center fs-6',
                            render: function(data) {
                                return new Date(data).toLocaleDateString('en-CA', {
                                    year: 'numeric',
                                    month: 'long',
                                    day: '2-digit'
                                });
                            }
                        }
                    ]
                });

                $('.hideNotes').on('click', function(event) {
                    event.preventDefault();
                    $('#quickInstructions').toggle('slow');
                });
            });
        </script>
    </body>
</html>
