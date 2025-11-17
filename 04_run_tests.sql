-- Clean any previous results
TRUNCATE TABLE bonuses;

-- Call the procedure to calculate bonuses at 10%
BEGIN
  bonus_pkg.calculate_and_store_bonuses(10); -- 10% bonus
END;
/

-- Query bonuses table to show results
SET SERVEROUTPUT ON SIZE 1000000;
SELECT b.bonus_id, b.emp_id, e.first_name || ' ' || e.last_name AS name, d.name AS dept, b.bonus_amt
FROM bonuses b
LEFT JOIN employees e ON e.emp_id = b.emp_id
LEFT JOIN departments d ON d.dept_id = b.dept_id
ORDER BY b.emp_id;

-- Print the in-memory report (note: print_bonus_report prints only the in-memory g_bonus_list,
-- which in this implementation exists in the package body for the session that invoked calculate)
BEGIN
  bonus_pkg.print_bonus_report;
END;
/


