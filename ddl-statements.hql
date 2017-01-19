
--***ingest faa data
--hdfs dfs -mkdir /data/skynetdata
--hdfs dfs -mkdir /data/skynetdata/master
--hdfs dfs -mkdir /data/skynetdata/ref
--hdfs dfs -copyFromLocal master.txt /data/skynetdata/master/
--hdfs dfs -copyFromLocal ACFTREF.txt /data/skynetdata/ref/

-- *****ingest transponder data
-- hdfs dfs -mkdir /data/skynetdata/transponder
-- hdfs dfs -copyFromLocal transponder-data/ /data/skynetdata/transponder


-- hdfs dfs -mkdir /data/skynetdata/carrier
-- hdfs dfs -copyFromLocal carrier_companies.csv /data/skynetdata/carrier



-- hive -d DB=sean -d DATA=/data
-- bin/hive.sh

ADD JAR /vagrant/exercises/lib/hive-json-serde-0.3.jar;
ADD JAR /vagrant/exercises/lib/json-path-0.5.4.jar;
ADD JAR /vagrant/exercises/lib/json-smart-1.0.6.3.jar;

--use skynet
--create table
CREATE EXTERNAL TABLE IF NOT EXISTS MASTER(
N_NUMBER STRING,
SERIAL_NUMBER STRING,
MFR_MDL_CODE STRING,
ENG_MFR_MDL STRING,
YEAR_MFR STRING,
TYPE_REGISTRANT STRING,
NAME STRING,
STREET STRING,
STREET2 STRING,
CITY STRING,
STATE STRING,
ZIP_CODE STRING,
REGION STRING,
COUNTY STRING,
COUNTRY STRING,
LAST_ACTION_DATE STRING,
CERT_ISSUE_DATE STRING,
CERTIFICATION STRING,
TYPE_AIRCRAFT STRING,
TYPE_ENGINE STRING,
STATUS_CODE STRING,
MODE_S_CODE STRING,
FRACT_OWNER STRING,
AIR_WORTH_DATE STRING,
OTHER_NAMES_1 STRING,
OTHER_NAMES_2 STRING,
OTHER_NAMES_3 STRING,
OTHER_NAMES_4 STRING,
OTHER_NAMES_5 STRING,
EXPIRATION_DATE STRING,
UNIQUE_ID STRING,
KIT_MFR STRING,
KIT_MODEL STRING,
MODE_S_CODE_HEX STRING)
    COMMENT 'fas data from master.txt'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    location '/data/skynetdata/master';
    ******todo change the location here
    
    
CREATE EXTERNAL TABLE IF NOT EXISTS ACTREF(    
    CODE String, 
MFR String, 
MODEL String, 
TYPE_ACFT String, 
TYPE_ENG String, 
AC_CAT String, 
BUILD_CERT_IND String, 
NO_ENG String, 
NO_SEATS String, 
AC_WEIGHT String, 
SPEED STRING)
    COMMENT 'fas data from master.txt'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    location '/data/skynetdata/ref';
    
drop table transponder;

CREATE TABLE IF NOT EXISTS transponder (icao   STRING)
ROW FORMAT SERDE "org.apache.hadoop.hive.contrib.serde2.JsonSerde"
WITH SERDEPROPERTIES (
  "icao"="$.icao"
)
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/vagrant/bootcamp-team-faid/data/transponder/2017-01-16' overwrite into table transponder;


**todo change the location here

drop view vw_aircraft_no_transponder;

create view vw_aircraft_no_transponder as 
SELECT m.N_NUMBER, m.MODE_S_CODE_HEX, m.MFR_MDL_CODE
FROM master m
LEFT OUTER JOIN transponder tc
ON (trim(tc.icao)=trim(m.MODE_S_CODE_HEX))
where tc.icao is null;


CREATE EXTERNAL TABLE IF NOT EXISTS carrier_company(    
    description String, 
    CODE String
    )
    COMMENT 'fas data from master.txt'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    location '/data/skynetdata/carrier';

create view vw_aircraft_airline as 
SELECT fp.tailnum, cc.code
FROM flights_parquet fp
inner JOIN carrier_company cc
ON (trim(fp.carrier)=trim(cc.code));

view count = 42535041
			 36161302


create view vw_master_no_trans_airline as 
SELECT MNT.N_NUMBER, MNT.MODE_S_CODE_HEX, MNT.MFR_MDL_CODE
FROM vw_aircraft_no_transponder MNT
inner JOIN vw_aircraft_airline AA
ON (trim(substr(MNT.N_NUMBER, 2, length(MNT.N_NUMBER) - 1))=trim(AA.tailnum));








