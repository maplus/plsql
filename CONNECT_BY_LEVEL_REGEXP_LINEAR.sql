CREATE OR REPLACE TYPE zrnr_o IS OBJECT(
    zrnr NUMBER,
    zrnr_txt VARCHAR2(100),
    zrnr_txt2 VARCHAR2(100)
);

CREATE OR REPLACE TYPE zrnr_t AS TABLE OF zrnr_o;

CREATE OR REPLACE FUNCTION zrnr_f
    RETURN zrnr_t PIPELINED AS
    l_zrnr_t zrnr_t := zrnr_t();
    TYPE l_ref_cur IS REF CURSOR;
    l_cur l_ref_cur;
    l_sql CONSTANT VARCHAR2(100) :=
        q'/SELECT x1.zrnr, x1.zrnr_txt FROM regexp_test x1/';
    l_zrnr NUMBER;
    l_zrnr_txt VARCHAR2(100);
    l_zrnr_txt_cnt INT;
    l_zrnr_idx_from INT;
    l_zrnr_idx_to INT;
    l_txt VARCHAR2(100);
    l_out_rec zrnr_o;
BEGIN
    OPEN l_cur FOR l_sql;
    LOOP
        FETCH l_cur INTO l_zrnr, l_zrnr_txt;
        EXIT WHEN l_cur%NOTFOUND;
        
        l_zrnr_idx_from := 1;
        FOR idx IN 1..COALESCE(REGEXP_COUNT(l_zrnr_txt, '\|') + 1, 0) LOOP
            l_zrnr_idx_to := INSTR(l_zrnr_txt, '|', l_zrnr_idx_from, 1);
            l_zrnr_idx_to := CASE WHEN l_zrnr_idx_to = 0 THEN LENGTH(l_zrnr_txt) ELSE l_zrnr_idx_to -1 END;
            l_txt := TRIM(SUBSTR(l_zrnr_txt, l_zrnr_idx_from, l_zrnr_idx_to - l_zrnr_idx_from + 1));
            
            l_out_rec := zrnr_o(l_zrnr, l_zrnr_txt, l_txt);
            PIPE ROW(l_out_rec);
            
            l_zrnr_idx_from := l_zrnr_idx_to + 2;
        END LOOP;
    END LOOP;
    CLOSE l_cur;
    RETURN;
END;

SELECT x1.zrnr, x1.zrnr_txt, x1.zrnr_txt2
FROM TABLE(zrnr_f()) x1
ORDER BY x1.zrnr, x1.zrnr_txt, x1.zrnr_txt2;



SET SERVEROUTPUT ON
DECLARE
    l_zrnr_t zrnr_t := zrnr_t();
    TYPE l_ref_cur IS REF CURSOR;
    l_cur l_ref_cur;
    l_sql CONSTANT VARCHAR2(100) := q'/SELECT x1.zrnr, x1.zrnr_txt FROM regexp_test x1 WHERE x1.zrnr = 5/';
    l_zrnr NUMBER;
    l_zrnr_txt VARCHAR2(100);
    l_zrnr_txt_cnt INT;
    l_zrnr_idx_from INT;
    l_zrnr_idx_to INT;
    l_txt VARCHAR2(100);
BEGIN
    OPEN l_cur FOR l_sql;
    LOOP
        FETCH l_cur INTO l_zrnr, l_zrnr_txt;
        EXIT WHEN l_cur%NOTFOUND;
        
        l_zrnr_idx_from := 1;
        FOR idx IN 1..COALESCE(REGEXP_COUNT(l_zrnr_txt, '\|') + 1, 0) LOOP
            l_zrnr_idx_to := INSTR(l_zrnr_txt, '|', l_zrnr_idx_from, 1);
            l_zrnr_idx_to := CASE WHEN l_zrnr_idx_to = 0 THEN LENGTH(l_zrnr_txt) ELSE l_zrnr_idx_to -1 END;
            l_txt := TRIM(SUBSTR(l_zrnr_txt, l_zrnr_idx_from, l_zrnr_idx_to - l_zrnr_idx_from + 1));
            dbms_output.put_line(l_zrnr || ', ' || l_zrnr_txt || ', ' || idx || ', ' || l_zrnr_idx_from || ', ' || l_zrnr_idx_to || ', ' || l_txt);
            
            l_zrnr_idx_from := l_zrnr_idx_to + 2;
        END LOOP;
    END LOOP;
    CLOSE l_cur;
    RETURN;
END;
/


