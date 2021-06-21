--by Diego Bosca 20210317
INSERT INTO death
(
    person_id,
    death_date,
    death_datetime,
    death_type_concept_id, -- Assign concept_id 32817 (EHR) 
    cause_concept_id,
    cause_source_value,
    cause_source_concept_id
)
SELECT
 -- [MAPPING COMMENT] Only needs to be created if death_date is filled 
    i2b2.patient_dimension.patient_num AS person_id,

    i2b2.patient_dimension.death_date AS death_date,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS death_datetime,

 -- [Fixed to]  32817 (EHR) 
    32817 AS death_type_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS cause_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS cause_source_value,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS cause_source_concept_id

FROM i2b2.patient_dimension where i2b2.patient_dimension.death_date is not null
;