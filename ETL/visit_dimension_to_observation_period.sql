--v1 by Diego Bosca 20210318
INSERT INTO observation_period
(
    observation_period_id,
    person_id,
    observation_period_start_date,
    observation_period_end_date,
    period_type_concept_id -- Assign concept_id 44814724 (period covering healthcare encounters) 
)
SELECT
 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
	nextval('observation_period_id_seq') AS observation_period_id,

    patient_num AS person_id,

 -- [MAPPING   LOGIC] Take min(start_date) for a given patient across the observation_fact and i2b2.visit_dimension tables, and use this as observation_period_start_date  
    (select start_date FROM i2b2.visit_dimension WHERE patient_num=v.patient_num order by start_date limit 1) AS observation_period_start_date,

 -- [MAPPING   LOGIC] Take max(end_date) for a given patient across the observation_fact and i2b2.visit_dimension tables, and use this as observation_period_end_date 
    (select end_date FROM i2b2.visit_dimension WHERE patient_num=v.patient_num order by end_date DESC limit 1) AS observation_period_end_date,

 -- [Fixed to] 44814724 (period covering healthcare encounters) 
    44814724 AS period_type_concept_id

FROM (select distinct patient_num from i2b2.visit_dimension) v
;