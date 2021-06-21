--v2 by Diego Bosca 20210317
INSERT INTO person
(
    person_id,
    gender_concept_id,
    year_of_birth,
    month_of_birth,
    day_of_birth,
    birth_datetime,
    race_concept_id, -- 0
    ethnicity_concept_id, -- 0
    location_id,
    provider_id,
    care_site_id,
    person_source_value,
    gender_source_value,
    gender_source_concept_id, -- 0
    race_source_value,
    race_source_concept_id,
    ethnicity_source_value,
    ethnicity_source_concept_id
)
SELECT
    i2b2.patient_dimension.patient_num AS person_id,

 -- [MAPPING   LOGIC] Conversion logic on basis of sex_cd:   ES_12OCTUBRE_GENDER:M (female)-> 8532   ES_12OCTUBRE_GENDER:V (male)-> 8507  
    CASE
		WHEN i2b2.patient_dimension.sex_cd='ES_12OCTUBRE_GENDER:M' THEN 8532
		WHEN i2b2.patient_dimension.sex_cd='ES_12OCTUBRE_GENDER:V' THEN 8507
		ELSE 0
	END AS gender_concept_id,

 -- [MAPPING   LOGIC] Extract year portion from birth_date 
     date_part('year', i2b2.patient_dimension.birth_date) AS year_of_birth,

 -- [MAPPING   LOGIC] Extract month portion from birth_date 
    date_part('month', i2b2.patient_dimension.birth_date) AS month_of_birth,

 -- [MAPPING   LOGIC] Extract day portion from birth_date 
    date_part('day', i2b2.patient_dimension.birth_date) AS day_of_birth,

    i2b2.patient_dimension.birth_date AS birth_datetime,

 -- [MAPPING COMMENT] not available in source, put 0
    0 AS race_concept_id,

 -- [MAPPING COMMENT] not available in source, put 0
    0 AS ethnicity_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS location_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS provider_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS care_site_id,

    i2b2.patient_dimension.patient_num AS person_source_value,

    i2b2.patient_dimension.sex_cd AS gender_source_value,

-- [MAPPING COMMENT] local terminology in source, put 0
    0 AS gender_source_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS race_source_value,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS race_source_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS ethnicity_source_value,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS ethnicity_source_concept_id

FROM i2b2.patient_dimension where i2b2.patient_dimension.birth_date is not null
;