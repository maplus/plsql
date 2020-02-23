BEGIN EXECUTE IMMEDIATE 'DROP TABLE TESTS_UPD'; EXCEPTION WHEN OTHERS THEN NULL; END; 
CREATE TABLE tests_upd(tests_id INT, tests_txt varchar2(30));
CREATE TABLE tests_upd2(tests_id INT, tests_txt varchar2(30));
INSERT INTO tests_upd2 VALUES(1, 'a');
COMMIT;

CREATE OR REPLACE PROCEDURE test_upd2_p(p_id INT) IS
BEGIN
    UPDATE tests_upd2 SET tests_txt = 'b' WHERE tests_id = p_id;
END;

CREATE OR REPLACE TRIGGER tests_upd_t01
FOR UPDATE ON tests_upd
COMPOUND TRIGGER
AFTER STATEMENT IS
BEGIN
    test_upd2_p(:new.tests_id);
END AFTER STATEMENT;
END;

INSERT INTO tests VALUES(1, 'a');
INSERT INTO tests VALUES(2, 'b');
ROLLBACK;
