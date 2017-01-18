--hive -d DB=sean -d DATA=/data

--***ingest faa data
--hdfs dfs -copyFromLocal master.txt /data/testflightdata/

-- *****ingest transponder data
-- hdfs dfs -mkdir /data/transponder
--hdfs dfs -copyFromLocal site01-20141101-100.txt /data/transponder/
--hdfs dfs -copyFromLocal site02-20141101-100.txt /data/transponder/


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
    location '${DATA}/testflightdata';
    
    
CREATE EXTERNAL TABLE IF NOT EXISTS transponder ( 
clock STRING,
clock_value STRING,
hexid STRING,
hexid_value STRING,
ident STRING,
ident_value    STRING,
squawk STRING,
squawk_value STRING,
alt STRING,
alt_value STRING,
speed STRING,
speed_value STRING,
airGround STRING,
airGround_value STRING,
lat STRING,
lat_value STRING,
lon STRING,
lon_value STRING,
heading STRING,
heading_value STRING
)
COMMENT 'transponder data'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE
    location '${DATA}/transponder';

CREATE TABLE IF NOT EXISTS transponder_cleansed 
as select
clock_value,
hexid_value,
ident_value,
squawk_value,
alt_value,
speed_value,
airGround_value,
lat_value,
lon_value,
heading_value
from transponder;



