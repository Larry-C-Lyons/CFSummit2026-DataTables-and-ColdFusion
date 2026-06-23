# ColdFusion 2023 + DataTables Demo

## Overview
This demo shows how to use **DataTables** with **ColdFusion 2023**.  

It runs on **CommandBox** with ColdFusion 2023 and connects to a **MySQL database**.  
A SQL file and JSON file are included with sample data.

---

## Setup Instructions

1. **Create the database**
   - Create a database named **`cf_user`**
   - Run the file **`cf_user_employee.sql`** (for MySQL)

2. **Start ColdFusion**
   - If you are using **CommandBox**:
     1. Open **Command Prompt** (Windows) or **Terminal** (Mac)
     2. Navigate to this demo directory
     3. Run:
        ```bash
        box start
        ```
   - If you have ColdFusion installed directly, skip this step.

3. **Configure the datasource**
   - Open the **ColdFusion Administrator**
   - Navigate to:  
     `Data & Services > Data Sources`
   - Create a datasource called **`cf_user`**

4. **Explore the demo**
   - Once the datasource is created, open the index page in your browser.
   - This demo shows:
     - Server-side sorting
     - Pagination
     - Searching

---

## Notes

- For advanced DataTables features (cell rendering, collapsible cells, buttons, autofill, etc.), see the [DataTables Website](https://datatables.net/).
- Additional comments and explanations are provided in:
  - `index.cfm`
  - `/com/Employees.cfc?method=getEmployeesJSON`
- A `Readme.txt` file is also included in the archive.
- Contact: [larryclyons@gmail.com](mailto:larryclyons@gmail.com)

---

## ColdFusion Updates & Argument Validation Issue

If you encounter an error like:

```text
coldfusion.runtime.UDFMethod$IllegalArgumentException: 
Function example does not support y as an argument in 
c:\inetpub\wwwroot\example.cfc at coldfusion.runtime.UDFMethod.validateArguments
```

This happens because of stricter argument handling introduced in:
- ColdFusion **2025 Update 2**
- ColdFusion **2023 Update 14**
- ColdFusion **2021 Update 20**

### Cause
ColdFusion now enforces **strict argument matching** in remote functions:
- All expected arguments must be explicitly declared (using `cfargument` or function signature).
- Extra arguments are **not allowed**.
- Since DataTables sends multiple fields per column (plus general search/sort params), this can cause errors.

### Solutions
1. **Add all missing arguments** to your remote functions.  
   _(Not practical, since DataTables sends many fields.)_

2. **Prevent passing extra arguments** to methods.  
   _(Requires altering DataTables, which is not ideal.)_

3. **Disable strict checking with JVM arguments**:
   - In ColdFusion Administrator → *Java & JVM* (or `jvm.config`), add:
     ```bash
     -Dcoldfusion.runtime.remotemethod.matchArguments=false
     ```
     Then restart ColdFusion services.

4. **For CommandBox**:  
   Add the following to your `server.json`:
   ```json
   "jvm": {
     "args": [
       "-Dcoldfusion.runtime.remotemethod.matchArguments=false"
     ]
   }
   ```

   ⚠️ **Note**: Do not forget the leading **hyphen (-)** in the JVM argument.

---

## Reference
For more details, see Charlie Arehart’s excellent blog post:  
👉 [ColdFusion Updates Released May 13, 2025](https://www.carehart.org/blog/2025/5/14/coldfusion_updates_released_may_13_2025)
