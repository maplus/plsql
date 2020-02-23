SET SERVEROUTPUT ON
DECLARE
    l_salary NUMBER;
    PROCEDURE nested_block IS
        PRAGMA autonomous_transaction;
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE emp SET salary = salary + 15000 WHERE emp_no = 1002';
        COMMIT;
    END;
BEGIN
    BEGIN EXECUTE IMMEDIATE 'DROP TABLE emp'; EXCEPTION WHEN OTHERS THEN NULL; END;
    EXECUTE IMMEDIATE 'CREATE TABLE emp(emp_no INT, salary NUMBER)';
    EXECUTE IMMEDIATE 'INSERT INTO emp VALUES(1001, 8000)';
    EXECUTE IMMEDIATE 'INSERT INTO emp VALUES(1002, 10000)';
    COMMIT;

    EXECUTE IMMEDIATE 'SELECT salary FROM emp WHERE emp_no = 1001' INTO l_salary;

    dbms_output.put_line('Before Salary of 1001 is '|| l_salary);

    EXECUTE IMMEDIATE 'SELECT salary FROM emp WHERE emp_no = 1002' INTO l_salary;

    dbms_output.put_line('Before Salary of 1002 is '|| l_salary);    

    EXECUTE IMMEDIATE 'UPDATE emp SET salary = salary + 5000 WHERE emp_no = 1001';

    nested_block;

    ROLLBACK;

    EXECUTE IMMEDIATE 'SELECT salary FROM emp WHERE emp_no = 1001' INTO l_salary;

    dbms_output.put_line('After Salary of 1001 is '|| l_salary);

    EXECUTE IMMEDIATE 'SELECT salary FROM emp WHERE emp_no = 1002' INTO l_salary;

    dbms_output.put_line('After Salary of 1002 is '|| l_salary);
END;
/