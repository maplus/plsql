--GRANT execute ON DBMS_LOCK TO mydwh;
--GRANT CREATE ANY JOB TO mydwh;
--GRANT EXECUTE ON DBMS_SCHEDULER to mydwh;
--GRANT MANAGE SCHEDULER TO mydwh;

CREATE OR REPLACE PROCEDURE allocate_seats_p AS
BEGIN
    dbms_lock.sleep(1);
END;
/
CREATE OR REPLACE PROCEDURE capture_customer_details_p AS
BEGIN
    dbms_lock.sleep(1);
END;
/
CREATE OR REPLACE PROCEDURE receive_payment_p AS
BEGIN
    dbms_lock.sleep(1);
END;
/

CREATE OR REPLACE PROCEDURE notify_customer_p AS
BEGIN
    dbms_lock.sleep(10);
END;
/
CREATE OR REPLACE PROCEDURE upsell_food_p AS
BEGIN
    dbms_lock.sleep(10);
END;
/
CREATE OR REPLACE PROCEDURE update_central_crm_p AS
BEGIN
    dbms_lock.sleep(10);
END;
/

CREATE OR REPLACE PROCEDURE post_booking_flow_p(booking_id IN VARCHAR2) AS
BEGIN
  dbms_output.put_line('START post_booking_flow');
  notify_customer_p();
  upsell_food_p();
  update_central_crm_p();
  dbms_output.put_line('END post_booking_flow');
END;
/

-- CALL post_booking_flow_p(1);

-- Non-critical processing asynchronous
-- with DBMS_SCHEDULER.CREATE_JOB
CREATE OR REPLACE PROCEDURE create_booking_p(booking_id in varchar2) AS
BEGIN
    dbms_output.put_line('START create_booking');    
    -- Critical parts of booking: main flow, any failure 
    -- here must fail the entire booking
    allocate_seats_p();
    capture_customer_details_p();
    receive_payment_p();
 
    -- Non-critical parts of booking: wrapped in 
    -- a separate procedure called asynchronously
    dbms_output.put_line('Before post_booking_flow_job');
    dbms_scheduler.create_job(
        job_name   =>  'post_booking_flow_job' || booking_id,
        job_type   => 'PLSQL_BLOCK',
        job_action => 
        'BEGIN 
           post_booking_flow_p(''' || booking_id || ''');
         END;',
        enabled   =>  TRUE,  
        auto_drop =>  TRUE, 
        comments  =>  'Non-critical post-booking steps'
    );
   
    dbms_output.put_line('After post_booking_flow_job');  
    dbms_output.put_line('END create_booking');  
END;
/


call create_booking_p('A001');

SELECT * FROM ALL_SCHEDULER_JOB_LOG order by log_date desc;

SELECT * FROM ALL_SCHEDULER_JOB_RUN_DETAILS order by log_date desc;