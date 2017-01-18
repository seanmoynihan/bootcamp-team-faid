ADD JAR /vagrant/exercises/lib/hive-json-serde-0.3.jar;
ADD JAR /vagrant/exercises/lib/json-path-0.5.4.jar;
ADD JAR /vagrant/exercises/lib/json-smart-1.0.6.3.jar;

SELECT count(*)
FROM master m
LEFT OUTER JOIN transponder tc
ON (trim(tc.icao)=trim(m.MODE_S_CODE_HEX))
where tc.icao is null;

SELECT count(*)
FROM master m
JOIN transponder tc
ON (trim(tc.icao)=trim(m.MODE_S_CODE_HEX));

--master = 315314
--transponder = 25540


INSERT OVERWRITE LOCAL DIRECTORY '/vagrant/results/' select * from vw_aircraft_no_transponder limit 50;


--top aircraft model codes
select MFR_MDL_CODE, count(*) from vw_aircraft_no_transponder
group by MFR_MDL_CODE
having count(*) >3000;