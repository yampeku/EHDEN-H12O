--
--In 'create_location' we created a single location for H12O. Every other PC location (e.g. ES_PCMADRID_LOC:16011310) was considered as a location
--
INSERT INTO location
(
    location_id,
    address_1,
    address_2,
    city,
    state,
    zip,
    county,
    location_source_value
)
SELECT DISTINCT
 -- [MAPPING COMMENT] Get id as part of the location_id
	(SELECT split_part(i2b2.visit_dimension.location_cd, ':', 2)::INTEGER) AS location_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS address_1,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS address_2,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS city,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS state,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS zip,

 -- [FIXED TO] 'Madrid'
    'Madrid' AS county,

 -- [MAPPING COMMENT] Use original location_cd as source value
    i2b2.visit_dimension.location_cd AS location_source_value

FROM i2b2.visit_dimension
WHERE i2b2.visit_dimension.location_cd LIKE 'ES_PCMADRID_LOC%'
;