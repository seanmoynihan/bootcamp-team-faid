SELECT
    planeInfo.MFR as PlaneManufacturer,
    planeInfo.MODEL as PlaneModel,
    carrierInfo.description as CompanyName,
    count(*) as PlaneCount
FROM
    master m
    LEFT OUTER JOIN transponder transponderData ON (trim(m.mode_s_code_hex) = trim(transponderData.icao))
    JOIN actref planeInfo ON (m.mfr_mdl_code = planeInfo.code)
    JOIN flights_parquet planToCompanyMapping ON (concat("N", trim(m.n_number)) = trim(planToCompanyMapping.tailnum))
    JOIN carrier_company carrierInfo ON (trim(carrierInfo.code) = trim(planToCompanyMapping.carrier))
GROUP BY planeInfo.MFR, planeInfo.MODEL, carrierInfo.description

