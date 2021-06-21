--20210330 by Diego Bosca
INSERT INTO care_site
(
    care_site_id,
    care_site_name,
    place_of_service_concept_id,
    location_id,
    care_site_source_value,
    place_of_service_source_value
)
SELECT 
 -- [MAPPING COMMENT] care_site_id from aux table
	care_site_aux.care_site_id AS care_site_id,

 -- [MAPPING COMMENT] name as care_site_name
    care_site_aux.name AS care_site_name,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS place_of_service_concept_id,

 -- We assigned 1 as H12O location_id
    1 AS location_id,

 -- [MAPPING COMMENT] fullname as source_value
    care_site_aux.fullname AS care_site_source_value,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS place_of_service_source_value

FROM care_site_aux
;