@echo off
setlocal EnableExtensions
title Real Estate Property Management Database - Demo
cd /d "%~dp0"

rem ---- find the MySQL client ----
set "MYSQL="
set "PF86=%ProgramFiles(x86)%"
for /f "delims=" %%i in ('where mysql.exe 2^>nul') do if not defined MYSQL set "MYSQL=%%i"
if not defined MYSQL for /d %%d in ("%ProgramFiles%\MySQL\MySQL Server *") do if exist "%%d\bin\mysql.exe" set "MYSQL=%%d\bin\mysql.exe"
if not defined MYSQL for /d %%d in ("%PF86%\MySQL\MySQL Server *") do if exist "%%d\bin\mysql.exe" set "MYSQL=%%d\bin\mysql.exe"
if not defined MYSQL (
  echo MySQL was not found on this computer.
  echo Install MySQL Server 8.0 or newer, then run this file again.
  pause
  exit /b 1
)

call :banner "Real Estate Property Management Database | Demo"
echo MySQL client: %MYSQL%
set "MUSER="
set /p "MUSER=MySQL user [root]: "
if not defined MUSER set "MUSER=root"
set "CNF=%TEMP%\property_demo_%RANDOM%.cnf"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$p=Read-Host 'MySQL password (leave empty if none)' -AsSecureString; $t=[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($p)); [IO.File]::WriteAllLines($env:CNF, [string[]]@('[client]', ('user=' + $env:MUSER), ('password=' + [char]34 + $t + [char]34)))"
set "M="%MYSQL%" --defaults-extra-file="%CNF%""

%M% -e "SELECT VERSION();" >nul 2>&1
if errorlevel 1 (
  echo.
  echo Could not connect to MySQL. Check the user and password, and that the MySQL server is running.
  del "%CNF%" 2>nul
  pause
  exit /b 1
)
for /f "delims=" %%v in ('call %M% -N -e "SELECT VERSION();"') do echo Connected to MySQL %%v.

call :banner "Step 1 of 6: Build the database (10 tables, 100 tuples)"
echo Running demo\00_build.sql ...
%M% < demo\00_build.sql > build_log.txt 2>&1
if errorlevel 1 (
  echo The build failed. See build_log.txt
  del "%CNF%" 2>nul
  pause
  exit /b 1
)
echo Done. Database real_estate_db is ready.
echo.
pause

call :banner "Step 2 of 6: The tables and their tuples"
%M% -t -vvv real_estate_db < demo\01_tables.sql
echo.
pause

call :banner "Step 3 of 6: Query (a) | Properties with the most contractors"
%M% -t -vvv real_estate_db < demo\02_query_a.sql
echo.
pause
call :banner "Step 3 of 6: Query (b) | Properties under commercial leases only"
%M% -t -vvv real_estate_db < demo\03_query_b.sql
echo.
pause
call :banner "Step 3 of 6: Query (c) | Contractors with at least two properties"
%M% -t -vvv real_estate_db < demo\04_query_c.sql
echo.
pause
call :banner "Step 3 of 6: Query (d) | Total payments per category for each lease"
%M% -t -vvv real_estate_db < demo\05_query_d.sql
echo.
pause
call :banner "Step 3 of 6: Query (e) | Staff with no maintenance request"
%M% -t -vvv real_estate_db < demo\06_query_e.sql
echo.
pause

call :banner "Step 4 of 6: The constraints reject bad data"
echo Each insert below breaks a rule, so MySQL must refuse it with an ERROR:
echo   1. A lease that ends before it starts        (CHECK End_date ^> Start_date)
echo   2. A contractor rated 6                       (CHECK Rating from 1 to 5)
echo   3. A payment for a lease that does not exist  (foreign key to Lease)
echo   4. A second Ejari certificate for lease 1     (UNIQUE LeaseID)
echo.
%M% -t -vvv --force real_estate_db < demo\07_constraints.sql 2>&1
echo.
pause

call :banner "Step 5 of 6: Try it yourself"
echo You are now in the MySQL prompt, inside real_estate_db.
echo Try:  SELECT * FROM Lease;     or     SHOW TABLES;
echo Type  exit  to leave.
echo.
%M% real_estate_db

call :banner "Step 6 of 6: ER model in MySQL Workbench"
choice /c YN /m "Open real_estate_db.mwb in MySQL Workbench"
if errorlevel 2 goto :done
start "" "real_estate_db.mwb"

:done
del "%CNF%" 2>nul
echo.
echo Demo finished.
pause
exit /b 0

:banner
echo.
echo ==================================================================
echo   %~1
echo ==================================================================
echo.
exit /b 0
