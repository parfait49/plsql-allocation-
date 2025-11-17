-- Departments
INSERT INTO departments (dept_id, name) VALUES (10, 'Engineering');
INSERT INTO departments (dept_id, name) VALUES (20, 'Sales');
INSERT INTO departments (dept_id, name) VALUES (30, 'HR');

-- Employees (some on leave)
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, on_leave) VALUES (101, 'Alice', 'K.', 10, 6000, 'N');
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, on_leave) VALUES (102, 'Bob', 'M.', 10, 4500, 'Y');
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, on_leave) VALUES (103, 'Carol', 'R.', 20, 5500, 'N');
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, on_leave) VALUES (104, 'Dan', 'S.', 20, 3000, 'N');
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, on_leave) VALUES (105, 'Eve', 'T.', 30, 4000, 'N');

COMMIT;


