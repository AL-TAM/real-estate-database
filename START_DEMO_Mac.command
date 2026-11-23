#!/usr/bin/env bash
# Real Estate Property Management Database | demo launcher (macOS / Linux)
cd "$(dirname "$0")" || exit 1

pause() { echo; read -r -p "Press Enter to continue . . . " _; echo; }
banner() { echo; echo "=================================================================="; echo "  $1"; echo "=================================================================="; echo; }

# ---- find the MySQL client ----
MYSQL="${MYSQL_BIN:-}"
if [ -z "$MYSQL" ]; then
  for c in mysql /usr/local/mysql/bin/mysql /opt/homebrew/bin/mysql /opt/homebrew/opt/mysql/bin/mysql /usr/local/bin/mysql; do
    if command -v "$c" >/dev/null 2>&1; then MYSQL="$(command -v "$c")"; break; fi
  done
fi
if [ -z "$MYSQL" ]; then
  echo "MySQL client not found. Install MySQL Server first, then run this again."
  read -r -p "Press Enter to close." _; exit 1
fi

banner "Real Estate Property Management Database | Demo"
echo "MySQL client: $MYSQL"
read -r -p "MySQL user [root]: " MUSER; MUSER="${MUSER:-root}"
read -r -s -p "MySQL password (leave empty if none): " MPASS; echo

CNF="$(mktemp)"; trap 'rm -f "$CNF"' EXIT
{ echo "[client]"; echo "user=$MUSER"; echo "password=\"$MPASS\""; [ -n "${MYSQL_SOCKET:-}" ] && echo "socket=$MYSQL_SOCKET"; } > "$CNF"
chmod 600 "$CNF"
m() { "$MYSQL" --defaults-extra-file="$CNF" "$@"; }

if ! m -e "SELECT VERSION();" >/dev/null 2>&1; then
  echo; echo "Could not connect to MySQL. Check the user and password, and that the MySQL server is running."
  read -r -p "Press Enter to close." _; exit 1
fi
echo "Connected to MySQL $(m -N -e 'SELECT VERSION();')."

banner "Step 1 of 6: Build the database (10 tables, 100 tuples)"
echo "Running demo/00_build.sql ..."
if m < demo/00_build.sql > build_log.txt 2>&1; then
  echo "Done. Database real_estate_db is ready."
else
  echo "The build failed. See build_log.txt"; read -r -p "Press Enter to close." _; exit 1
fi
pause

banner "Step 2 of 6: The tables and their tuples"
m -t -vvv real_estate_db < demo/01_tables.sql
pause

banner "Step 3 of 6: Query (a) | Properties with the most contractors"
m -t -vvv real_estate_db < demo/02_query_a.sql; pause
banner "Step 3 of 6: Query (b) | Properties under commercial leases only"
m -t -vvv real_estate_db < demo/03_query_b.sql; pause
banner "Step 3 of 6: Query (c) | Contractors with at least two properties"
m -t -vvv real_estate_db < demo/04_query_c.sql; pause
banner "Step 3 of 6: Query (d) | Total payments per category for each lease"
m -t -vvv real_estate_db < demo/05_query_d.sql; pause
banner "Step 3 of 6: Query (e) | Staff with no maintenance request"
m -t -vvv real_estate_db < demo/06_query_e.sql; pause

banner "Step 4 of 6: The constraints reject bad data"
echo "Each insert below breaks a rule, so MySQL must refuse it with an ERROR:"
echo "  1. A lease that ends before it starts        (CHECK End_date > Start_date)"
echo "  2. A contractor rated 6                       (CHECK Rating from 1 to 5)"
echo "  3. A payment for a lease that does not exist  (foreign key to Lease)"
echo "  4. A second Ejari certificate for lease 1     (UNIQUE LeaseID)"
echo
m -t -vvv --force real_estate_db < demo/07_constraints.sql 2>&1
pause

if [ -z "${DEMO_NO_SHELL:-}" ]; then
  banner "Step 5 of 6: Try it yourself"
  echo "You are now in the MySQL prompt, inside real_estate_db."
  echo "Try:  SELECT * FROM Lease;     or     SHOW TABLES;"
  echo "Type  exit  to leave."
  echo
  m real_estate_db
fi

banner "Step 6 of 6: ER model in MySQL Workbench"
read -r -p "Open real_estate_db.mwb in MySQL Workbench? (y/n) " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
  if command -v open >/dev/null 2>&1 && [ "$(uname)" = "Darwin" ]; then open real_estate_db.mwb
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open real_estate_db.mwb >/dev/null 2>&1 &
  else echo "Open real_estate_db.mwb from MySQL Workbench (File > Open Model)."; fi
fi
echo; echo "Demo finished."
