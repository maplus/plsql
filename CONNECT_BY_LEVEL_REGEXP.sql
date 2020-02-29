DECLARE
    l_txt2 CONSTANT VARCHAR2(100) := '1|3';
    l_txt3 CONSTANT VARCHAR2(100) := '2|4|6';
    l_txt5 CONSTANT VARCHAR2(100) := '1|3|5|7';
    l_txt7 CONSTANT VARCHAR2(100) := '1';
    l_txt VARCHAR2(100);
BEGIN
    BEGIN EXECUTE IMMEDIATE 'DROP TABLE REGEXP_TEST PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
    EXECUTE IMMEDIATE 'CREATE TABLE REGEXP_TEST(ZRNR NUMBER, ZRNR_TXT VARCHAR2(100))';
    FOR idx in 1..2 LOOP
        CASE
            WHEN MOD(idx, 2) = 0 THEN l_txt := l_txt2;
            WHEN MOD(idx, 3) = 0 THEN l_txt := l_txt3;
            WHEN MOD(idx, 5) = 0 THEN l_txt := l_txt5;
            ELSE l_txt := l_txt7;
        END CASE;
        EXECUTE IMMEDIATE 'INSERT INTO REGEXP_TEST VALUES(:1, :2)' USING idx, l_txt;
    END LOOP;
    COMMIT;
END;

SELECT DISTINCT
    x1.zrnr,
    REGEXP_SUBSTR(
        x1.zrnr_txt,
        '[^\|]+',
        1,
        LEVEL
    ) zrnr_txts
FROM regexp_test x1
CONNECT BY LEVEL <= REGEXP_COUNT(x1.zrnr_txt, '\|') + 1;

SELECT
    x1.zrnr,
    x1.zrnr_txt,
    REGEXP_SUBSTR(
        x1.zrnr_txt,
        '[^|]+',
        1,
        1
    ) zrnr_txts,
    REGEXP_COUNT(
        x1.zrnr_txt,
        '\|'
    ) zrnr_txts2
FROM regexp_test x1;
