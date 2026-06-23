component displayname="Employees" hint="Employees data access and DataTables JSON endpoint." {

    // ---- tuning knobs ----
    variables.dsn               = "cf_user";
    variables.maxPageSize       = 500;   // prevent someone from requesting 1,000,000 rows
    variables.cacheTotalCount   = createTimeSpan(0, 0, 10, 0); // 10 minutes
    variables.cacheFiltered     = createTimeSpan(0, 0, 1, 0);  // 1 minute
    variables.cachePageNoSearch = createTimeSpan(0, 0, 0, 30); // 30 seconds
    variables.cachePageSearch   = createTimeSpan(0, 0, 0, 15); // 15 seconds

    // Handle calls to missing remote methods gracefully without exposing internals. 
    // You could also choose to 404 or similar.
    remote any function onMissingMethod(string missingMethodName, struct missingMethodArguments) {
        // Don't leak internals; do log it (adjust log category as you like)
        writeLog(
            file   = "application",
            type   = "warning",
            text   = "Employees.cfc: Missing remote method '#arguments.missingMethodName#' called. Args: #serializeJSON(arguments.missingMethodArguments)#"
        );
        return "An error occurred.";
    }


    // Get total employee count for DataTables. This is a separate query to allow for 
    // better caching of the total count.
    private numeric function getAllEmployeesCount() output="false" {
        var sql = "SELECT COUNT(*) AS total FROM employees";

        var options = {
            datasource   : variables.dsn,
            cachedWithin : variables.cacheTotalCount
        };

        try {
            var result = QueryExecute(sql, {}, options);  
        } 
        catch( any cfcatch ){
            // Log the error with details for debugging
            writeLog(
                file   = "application",
                type   = "error",
                text   = "Employees.cfc: Error executing total count query. Error: #cfcatch.message#. SQL: #sql#"
            );
            // Return 0 to avoid breaking the DataTables client; it will just show no data.
            return 0;
              
        }
        
        // Return numeric. No numberFormat() here.
        return int(result.total);
    }

    /* Notes: 
        DataTables sends start=0 for the first page, so we adjust our paging logic accordingly.

        returnformat="JSON" is not used here since we are manually serializing the response; 
        this allows us to control the structure and avoid issues with CF's default JSON 
        serialization of complex data. You could also choose to return a struct and let CF 
        handle the JSON serialization, but be mindful of how it handles arrays and structs.

        output="false" is used to prevent CF from trying to render any output; we are directly 
        returning the JSON string.

        We are using named parameters in QueryExecute for better readability and to avoid 
        SQL injection risks.

        We are validating and sanitizing all inputs that will be used in the SQL query to prevent 
        SQL injection and other issues.
        
        We are also using different cache durations for the total count, filtered count, 
        and paged data to optimize performance while keeping data reasonably fresh

        This method is designed to work with DataTables' server-side processing mode, which expects a 
            specific JSON structure in the response.

        The SQL queries are optimized for typical DataTables usage, with a separate count query for the 
            total number of records (which can be cached longer) and a paged query for the actual data 
            (which is cached for a shorter duration).
        
        SECURITY NOTE: Always be cautious when accepting parameters that will be used in SQL queries. 
            Parameterize all user inputs and validate/sanitize them as much as possible.

        TODO: In a production environment, you would want to add error handling around the database queries 
            and return appropriate error responses to the client if something goes wrong.
        
        TODO: Depending on your needs, you might want to implement additional features such as 
                column-specific searching, more complex ordering, or support for additional 
                DataTables parameters.

        TODO: Consider implementing rate limiting or other protections if this endpoint will be publicly 
                accessible to prevent abuse.

        
        TODO: Depending on your database and driver, you might want to adjust the way parameters 
                are defined in QueryExecute, especially for the LIKE patterns. Some drivers may 
                require different handling for wildcards in parameters.
    */
    remote string function getEmployeesJSON() output="false" returnformat="plain" {

        // DataTables posts a JSON body so ColdFusion's strict remote-argument
        // matching does not reject the call before this method can run.
        var dt = {
            "draw"   : 1,
            "start"  : 0,
            "length" : 10
        };

        var http = getHttpRequestData();
        var rawBody = "";

        if (isStruct(http) && structKeyExists(http, "content")) {
            rawBody = trim(http.content ?: "");
        }

        if (len(rawBody)) {
            try {
                dt = deserializeJSON(rawBody);
            }
            catch (any cfcatch) {
                writeLog(
                    file = "application",
                    type = "warning",
                    text = "Employees.cfc: Invalid DataTables JSON payload. Error: #cfcatch.message#. Raw: #left(rawBody, 250)#"
                );

                return serializeJSON({
                    "draw"            : 1,
                    "recordsTotal"    : 0,
                    "recordsFiltered" : 0,
                    "data"            : []
                });
            }
        }

        // ---------- sanitize paging inputs ----------
        // DataTables uses start=0; 
        var pageStart  = max(0, int(val(dt.start ?: 0)));
        var pageLength = int(val(dt.length ?: 10));

        // length = -1 means "all"; we still cap it for safety.
        if (pageLength EQ -1) {
            pageLength = variables.maxPageSize;
        } else {
            pageLength = max(0, min(pageLength, variables.maxPageSize));
        }

        // ---------- sanitize ordering inputs ----------
        var orderDir = "asc";
        if (structKeyExists(dt, "order") && isArray(dt.order) && arrayLen(dt.order) && structKeyExists(dt.order[1], "dir")) {
            var requestedDir = lCase(trim(dt.order[1].dir));
            if (listFindNoCase("asc,desc", requestedDir)) {
                orderDir = requestedDir;
            }
        }

        // Map DataTables column index to known-safe column names only
        var orderColumn = "id";
        if (structKeyExists(dt, "order") && isArray(dt.order) && arrayLen(dt.order) && structKeyExists(dt.order[1], "column")) {
            switch (int(val(dt.order[1].column))) {
                case 0: orderColumn = "id";          break;
                case 1: orderColumn = "name";        break;
                case 2: orderColumn = "position";    break;
                case 3: orderColumn = "salary";      break;
                case 4: orderColumn = "office";      break;
                case 5: orderColumn = "extn";        break;
                case 6: orderColumn = "start_date";  break;
                default: orderColumn = "id";
            }
        }

        // ---------- build parameterized WHERE clause ----------
        var whereClause = "WHERE 1 = 1";
        var params      = {}; // named params for QueryExecute
        var hasSearch   = false;

        if (structKeyExists(dt, "search") && isStruct(dt.search) && structKeyExists(dt.search, "value") 
                && len(trim(dt.search.value))) {
            hasSearch = true;

            var searchTerms = trim(dt.search.value);
            var searchUpper = uCase(searchTerms);

            // LIKE patterns (parameterized)
            params.sLike = { value = "%#searchUpper#%", cfsqltype = "cf_sql_varchar" };
            params.dLike = { value = "%#searchTerms#%", cfsqltype = "cf_sql_varchar" };

            // If numeric, allow numeric fields to be searched safely as text
            // (CAST to CHAR avoids needing to inject untyped LIKE fragments).
            var isNum = isNumeric(searchTerms);
            if (isNum) {
                // Keep it as varchar LIKE so a search for "12" matches "1200", etc.
                params.nLike = { value = "%#trim(searchTerms)#%", cfsqltype = "cf_sql_varchar" };
            }

            whereClause &= "
                AND (
                    UPPER(name)     LIKE :sLike OR
                    UPPER(position) LIKE :sLike OR
                    UPPER(office)   LIKE :sLike OR
                    DATE_FORMAT(start_date, '%m/%d/%Y') LIKE :dLike
            ";

            if (isNum) {
                whereClause &= "
                    OR CAST(id          AS CHAR) LIKE :nLike
                    OR CAST(extn        AS CHAR) LIKE :nLike
                    OR CAST(salary      AS CHAR) LIKE :nLike
                ";
            }

            whereClause &= " )";
        }

        // ---------- counts (better caching) ----------
        // Total count: long cache (table-wide)
        var recordsTotal = getAllEmployeesCount();

        // Filtered count: only run when searching; otherwise it's total
        var recordsFiltered = recordsTotal;

        if (hasSearch) {
            var countSql = "SELECT COUNT(*) AS count FROM employees #whereClause#";
            var countOptions = {
                datasource   : variables.dsn,
                cachedWithin : variables.cacheFiltered
            };

            var filtered = QueryExecute(countSql, params, countOptions);
            recordsFiltered = int(filtered.count);
        }

        params.pageLength = { value = pageLength, cfsqltype = "cf_sql_integer" };
        params.pageStart  = { value = pageStart,  cfsqltype = "cf_sql_integer" };

        // ---------- data query (paged), with short cache ----------
        var sql = "
            SELECT id AS employee_id,
                   name,
                   position,
                   salary,
                   office,
                   extn,
                   DATE_FORMAT(start_date, '%m/%d/%Y') AS start_date
              FROM employees
              #whereClause#
             ORDER BY #orderColumn# #orderDir#
             LIMIT :pageLength OFFSET :pageStart
        ";

        var dataOptions = {
            datasource   : variables.dsn,
            returnType   : "array",
            cachedWithin : (hasSearch ? variables.cachePageSearch : variables.cachePageNoSearch)
        };

        try {
            var employees = QueryExecute(sql, params, dataOptions);
        } 
        catch( any cfcatch ){
            // Log the error with details for debugging
            writeLog(
                file   = "application",
                type   = "error",
                text   = "Employees.cfc: Error executing employee data query. Error: #cfcatch.message#. Detail: #cfcatch.detail#. SQL: #sql#. Params: #serializeJSON(params)#"
            );
            // Return an empty data set with appropriate counts to avoid breaking the DataTables client
            var employees = [];
            recordsFiltered = 0;
        }
        // ---------- DataTables response ----------
        var results = {
            "draw"            : int(val(dt.draw ?: 1)),
            "recordsTotal"    : int(recordsTotal),
            "recordsFiltered" : int(recordsFiltered),
            "data"            : employees
        };

        return serializeJSON(results);
    }
}
