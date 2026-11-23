# Real Estate Property Management Database

We built this MySQL database for a database management systems course. We started with a property manager’s day-to-day questions. Which leases have payments on record? Who is assigned to a maintenance request? Which contractors work at more than one property?

The database links each lease to a tenant and a property, and each payment to a lease. Separate assignment tables let a contractor or staff member work across several properties. The demo uses placeholder contact numbers and identification numbers. The sample has 10 rows in each of the 10 tables. One result we liked is a tie: Marina Heights 1204 and Khalifa City Villa 22 each have three contractors. The first query returns both.

## Explore the project

| File | What’s inside |
| --- | --- |
| [Project report](docs/Project-Report.pdf) · [Word copy](docs/Project-Report.docx) | The case study, business rules, ER diagrams, relational schema, and query results. |
| [SQL script](real_estate_db.sql) | The schema, sample records, and all five reporting queries in one file. |
| [Workbench model](real_estate_db.mwb) | The editable database model. Open it in MySQL Workbench. |
| [Watch the demo online](https://al-tam.github.io/real-estate-database/) · [MP4 file](docs/Demo-Walkthrough.mp4) | A walkthrough of the setup, queries, checks, and database diagram. |
| [Demo SQL](demo/) | The build script, table counts, five queries, and four inserts that should fail. |

## Run the demo

**Use a disposable MySQL instance.** Both the full SQL script and the demo drop and recreate the database named `real_estate_db`. Running either on an instance with an existing database of that name will erase its contents.

1. Start MySQL Server 8.0.16 or newer and make sure the MySQL command-line client is installed. MySQL Workbench is optional for viewing the model.
2. Download or clone the repository. If you downloaded a ZIP, extract it first.
3. On Windows, double-click `START_DEMO_Windows.bat`. On macOS, run `bash START_DEMO_Mac.command`. On Linux, run `bash start_demo.sh`.
4. Enter your local MySQL username and password when prompted. The demo builds the database, shows the table counts, and steps through the query results. At the constraint step, four rejected inserts are the expected result.

To run just the SQL, open [real_estate_db.sql](real_estate_db.sql) in MySQL Workbench on your disposable instance and execute the full script.

## The five queries

1. Which properties have the most contractors, including ties?
2. Which properties have commercial leases and no residential leases?
3. Which contractors service at least two different properties?
4. How much was paid in each category for each lease?
5. Which staff members have no maintenance request assigned to them?
