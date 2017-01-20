-- TABLES:
--
-- master           : FAA provided aircraft registration data
-- transponderData  : ADS-B exchange data
-- actref           : FAA provided aircraft model data
-- flights_parquet  : Flight information collected in Parquet format
-- carrier_company  : Carrier Company information from Bureau of transportation statistics


create table distinct_flights_parquet as
select distinct tailnum, carrier from flights_parquet;

SELECT
    planeInfo.MFR as PlaneManufacturer,
    planeInfo.MODEL as PlaneModel,
    carrierInfo.description as CompanyName,
    count(*) as PlaneCount
FROM
    master m
    LEFT OUTER JOIN transponder transponderData ON (trim(m.mode_s_code_hex) = trim(transponderData.icao))
    JOIN actref planeInfo ON (m.mfr_mdl_code = planeInfo.code)
    JOIN distinct_flights_parquet planToCompanyMapping ON (concat("N", trim(m.n_number)) = trim(planToCompanyMapping.tailnum))
    JOIN carrier_company carrierInfo ON (trim(carrierInfo.code) = trim(planToCompanyMapping.carrier))
WHERE
    transponderData.icao IS NULL
GROUP BY
    planeInfo.MFR, planeInfo.MODEL, carrierInfo.description