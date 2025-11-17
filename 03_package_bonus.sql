CREATE OR REPLACE PACKAGE bonus_pkg IS

  TYPE t_employee_rec IS RECORD (
    emp_id    employees.emp_id%TYPE,
    first_name employees.first_name%TYPE,
    last_name  employees.last_name%TYPE,
    dept_id    employees.dept_id%TYPE,
    salary     employees.salary%TYPE,
    on_leave   employees.on_leave%TYPE
  );

  
  TYPE t_emp_assoc IS TABLE OF t_employee_rec INDEX BY BINARY_INTEGER;

  TYPE t_bonus_row IS RECORD (
    emp_id   NUMBER,
    dept_id  NUMBER,
    bonus    NUMBER
  );
  TYPE t_bonus_tbl IS TABLE OF t_bonus_row;

  PROCEDURE calculate_and_store_bonuses(p_bonus_pct IN NUMBER);
  PROCEDURE print_bonus_report;
END bonus_pkg;
/
SHOW ERRORS PACKAGE bonus_pkg;


CREATE OR REPLACE PACKAGE BODY bonus_pkg IS


  g_bonus_list t_bonus_tbl := t_bonus_tbl();

  PROCEDURE calculate_and_store_bonuses(p_bonus_pct IN NUMBER) IS
    CURSOR c_emps IS
      SELECT emp_id, first_name, last_name, dept_id, salary, on_leave FROM employees ORDER BY dept_id, emp_id;

    v_emp_rec c_emps%ROWTYPE;
    v_index   BINARY_INTEGER := 0;

  
    v_grouped t_emp_assoc;
    v_group_cnt INTEGER;

    -- helper variables
    v_bonus_amt NUMBER;

  BEGIN

    g_bonus_list.DELETE;

    -- fetch cursor
    OPEN c_emps;
    LOOP
      FETCH c_emps INTO v_emp_rec;
      EXIT WHEN c_emps%NOTFOUND;

     
      DECLARE
        v_emp t_employee_rec;
      BEGIN
        v_emp.emp_id    := v_emp_rec.emp_id;
        v_emp.first_name:= v_emp_rec.first_name;
        v_emp.last_name := v_emp_rec.last_name;
        v_emp.dept_id   := v_emp_rec.dept_id;
        v_emp.salary    := v_emp_rec.salary;
        v_emp.on_leave  := v_emp_rec.on_leave;

        
        IF v_emp.on_leave = 'Y' THEN-- jump to SKIP_EMPLOYEE label to handle skipping logic
          GOTO SKIP_EMPLOYEE;
        END IF;

        
        v_bonus_amt := ROUND(v_emp.salary * p_bonus_pct / 100, 2);
        IF v_bonus_amt < 100 THEN
          v_bonus_amt := 100;
        END IF;

        -- Add to nested table (report)
        g_bonus_list.EXTEND;
        g_bonus_list(g_bonus_list.COUNT) := t_bonus_row(v_emp.emp_id, v_emp.dept_id, v_bonus_amt);

        -- continue normal flow
        <<CONTINUE_NORMAL>>
        NULL; -- placeholder label body (not used)

        -- Label where we land when skipping
        <<SKIP_EMPLOYEE>>
        NULL;
        IF v_emp.on_leave = 'Y' THEN
          -- Optionally insert a row to bonuses marking skipped with zero bonus (or skip inserting)
          g_bonus_list.EXTEND;
          g_bonus_list(g_bonus_list.COUNT) := t_bonus_row(v_emp.emp_id, v_emp.dept_id, 0);
        END IF;
      END;
    END LOOP;
    CLOSE c_emps;

    -- Persist the computed bonuses into the bonuses table
    FOR i IN 1 .. g_bonus_list.COUNT LOOP
      INSERT INTO bonuses(emp_id, dept_id, bonus_amt)
      VALUES (g_bonus_list(i).emp_id, g_bonus_list(i).dept_id, g_bonus_list(i).bonus);
    END LOOP;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END calculate_and_store_bonuses;


  PROCEDURE print_bonus_report IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('EMP_ID | DEPT_ID | BONUS');
    DBMS_OUTPUT.PUT_LINE('------------------------');
    FOR i IN 1 .. g_bonus_list.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE(
        g_bonus_list(i).emp_id || ' | ' ||
        g_bonus_list(i).dept_id || ' | ' ||
        TO_CHAR(g_bonus_list(i).bonus, 'FM9999990.00')
      );
    END LOOP;
  END print_bonus_report;

END bonus_pkg;
/
SHOW ERRORS PACKAGE BODY bonus_pkg;


