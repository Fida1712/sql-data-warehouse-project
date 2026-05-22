/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure creates tables of 'bronze' schema. 
    It performs the following actions:
    - Drops the bronze tables before loading data.
    - Uses the `INFILE LOADING` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL load_bronze;
===============================================================================
*/



-- create bronze layer creating tables procedure 
-- (MYSQL doesn't support data infile loading)

-- drop if exist
drop procedure if exists load_bronze;

-- procedure call
call load_bronze();

-- ====================================================
--  ********** procedure start for tables creation******
-- =====================================================
delimiter //
create procedure load_bronze()
begin
	
    declare start_time datetime;
    declare end_time datetime;
    declare batch_start_time datetime;
    declare batch_end_time datetime;
    
	declare error_message text;
    declare error_number int;
    declare error_state text;
    
    declare exit handler for sqlexception
    begin
		get diagnostics condition 1
			error_number = mysql_errno,
            error_message = message_text,
            error_state = returned_sqlstate;
		
        select 
			error_number as error_number,
            error_state as error_state,
            error_message as error_message;
	end;
    
    -- Batch start time
    
set batch_start_time = now();

select ' =====================================' as message;
select '    Loading Bronze Layer   'as message;
select ' ======================================' as message;

set start_time = now();

-- CRM customer info

select '---------------------------------------' as message;
select '   Loading CRM Tables   'as message;
select '---------------------------------------'as message;
drop table if exists bronze_crm_cust_info;
create table bronze_crm_cust_info(
cst_id int,
cst_key varchar(50),
cst_firstname varchar(50),
cst_lastname varchar(50),
cst_marital_status varchar(50),
cst_gndr varchar(50),
cst_create_date date);

-- CRM Product Info

drop table if exists bronze_crm_prod_info;
create table bronze_crm_prod_info(
prd_id int,
prd_key varchar(50),
prd_nm varchar(50),
prd_cost int,
prd_line varchar(50),
prd_start_dt datetime,
prd_end_dt datetime
);

-- CRM Sales Details

drop table if exists bronze_crm_sales_details;
create table bronze_crm_sales_details(
sls_ord_num varchar(50),
sls_prd_key varchar(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
);

set end_time = now();
select concat(
'CRM Tables Created In ', 
timestampdiff(microsecond, start_time, end_time) /1000000, 
'seconds') as duration;


select '--------------------------------'as message;
select '  Loading ERP Tables   'as message;
select '--------------------------------'as message;

set start_time = now();

-- ERP Customer

drop table if exists bronze_erp_cust_az12;
create table bronze_erp_cust_az12 (
cid varchar(50),
bdate date,
gen varchar(50)
);

-- ERP Location

drop table if exists bronze_erp_loc_a101;
create table bronze_erp_loc_a101(
cid varchar(50),
cntry varchar(50)
);


-- ERP PX
drop table if exists bronze_erp_px_cat_g1v2;
create table bronze_erp_px_cat_g1v2(
id varchar(50),
cat varchar(50),
subcat varchar(50),
maintenance varchar(50)
);

set end_time = now();
select concat(
'ERP Tables Created In ', 
timestampdiff(microsecond, start_time, end_time) /1000000, 
'seconds') as duration;

set batch_end_time = now();
select concat(
'TOTAL TABLE CREATION TIME ', 
timestampdiff(microsecond, batch_start_time, batch_end_time) /1000000, 
'seconds') as total_tablecreation_duration;

end//
delimiter ;






-- ===================================================
-- *******LOADING TABLES FROM CSVS********************
-- CAN"T DIRECTLY PULL DATA FROM CSVS THROUGH PROCEDURE
-- ====================================================

-- start total time
set @batch_start_time = now();

-- ---------------------------------------
-- Loading Customer Info File
-- ----------------------------------------

set @start_time = now();

select '>> Truncating Table: bronze_crm_cust_info';
truncate table bronze_crm_cust_info;

select '>>  Loading Table: bronze_crm_cust_info';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE bronze_crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    @cst_create_date
)
SET
    cst_id = NULLIF(@cst_id, ''),
    cst_create_date = NULLIF(@cst_create_date, '');
    
    set @end_time = now();
    select concat(
'CRM_cust_info Table Loaded In ', 
timestampdiff(microsecond, @start_time, @end_time) /1000000, 
'seconds') as duration;

select count(*) from bronze_crm_cust_info;

-- -----------------------------------------
-- Loading Product Info File
-- -----------------------------------------

set @start_time = now();
select '>>  Truncating Table: bronze_crm_prd_info';
truncate table bronze_crm_prod_info;

select '>>  Loading Table : bronze_crm_prd_info ';
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
into table bronze_crm_prod_info
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows
(
prd_id,
prd_key,
prd_nm,
@prd_cost,
prd_line,
@prd_start_dt,
@prd_end_dt
)
set 
prd_cost = nullif(@prd_cost, ''),
prd_start_dt = nullif(@prd_start_dt, ''),
prd_end_dt = nullif(@prd_end_dt, '')
;

set @end_time = now();
select concat(
'CRM_prod_info Loaded In ', 
timestampdiff(microsecond, @start_time, @end_time) /1000000, 
'seconds') as duration;


-- ---------------------------------
-- Loading Sales Details 
-- ---------------------------------

set @start_time = now();

select '>>  Truncating Table : bronze_crm_sales_details ';
truncate table bronze_crm_sales_details;

select '>>  Loading Table : bronze_crm_sales_details ';
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
into table bronze_crm_sales_details
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows
(
sls_ord_num,
@sls_prd_key,
sls_cust_id ,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
@sls_sales,
sls_quantity,
@sls_price)

set
sls_prd_key = nullif(@sls_prd_key, ''),
sls_sales = nullif(@sls_sales, ''),
sls_price = nullif(@sls_price, '');

set @end_time = now();
select concat(
'CRM_sales_details Table Loaded In ', 
timestampdiff(microsecond, @start_time, @end_time) /1000000, 
'seconds') as duration;



-- -----------------------------------
-- Loading  custaz12 
-- -----------------------------------

set @start_time = now();

select '>>  Truncating Table : bronze_erp_cust_az12 ';
truncate table bronze_erp_cust_az12;

select '>>  Loading Table : bronze_erp_cust_az12 ';
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_AZ12.csv'
into table bronze_erp_cust_az12
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows
(
@cid,
@bdate,
@gen)
set
cid = nullif(@cid, ''),
bdate = nullif(@bdate, ''),
gen = nullif(@gen, '')
;

set @end_time = now();
select concat(
'ERP_cust_az12 Table Loaded In ', 
timestampdiff(microsecond, @start_time, @end_time) /1000000, 
'seconds') as duration;


-- ----------------------------------------
-- Loading PX_CAT_G1V2
-- ----------------------------------------

set @start_time = now();

select '>>  Truncaing Table : bronze_erp_px_cat_g1v2 ';
truncate table bronze_erp_px_cat_g1v2;

select '>>  Loading Table : bronze_erp_px_cat_g1v2 ';
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PX_CAT_G1V2.csv'
into table bronze_erp_px_cat_g1v2
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows
(
@id,
@cat,
@subcat,
@maintenance
)
set
id = nullif(@id, ''),
cat = nullif(@cat, ''),
subcat = nullif(@subcat, ''),
maintenance = nullif(@maintenance, '')
;

set @end_time = now();
select concat(
'ERP_px_cat_g1v2 Table Loaded In ', 
timestampdiff(microsecond, @start_time, @end_time) /1000000, 
'seconds') as duration;


-- ----------------------------------------
-- Loading LOC_A101
-- -----------------------------------------

set @start_time = now();

select '>>  Truncating Table : bronze_erp_loc_a101 ';
truncate table bronze_erp_loc_a101;

select '>>  Loading Table : bronze_erp_loc_a101 ';
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LOC_A101.csv'
into table bronze_erp_loc_a101
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows
(
@cid,
@cntry
)
set
cid = nullif(@cid, ''),
cntry = nullif(@cntry, '');

set @end_time = now();
select concat(
'ERP_loc_a101 Table Loaded In ', 
timestampdiff(microsecond, @start_time, @end_time) /1000000, 
'seconds') as duration;

-- -------------------------------------
-- Total Load Duration
-- -------------------------------------
set @batch_end_time = now();
select concat(
'TOTAL DATA LOAD DURATION ', 
timestampdiff(microsecond, @batch_start_time, @batch_end_time) /1000000, 
'seconds') as total_loading_duration;
