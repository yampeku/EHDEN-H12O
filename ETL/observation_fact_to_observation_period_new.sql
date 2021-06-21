--by Diego Bosca 20201222
INSERT INTO observation_period
(
    observation_period_id,
    person_id,
    observation_period_start_date,
    observation_period_end_date,
    period_type_concept_id -- Assign concept_id 44814724 (period covering healthcare encounters) 
)
SELECT  
   -- Autogenerate
 nextval('observation_period_id_seq') AS observation_period_id,
	patient_num AS person_id,
   -- First occurring start_date
    ( SELECT start_date FROM i2b2.observation_fact
        WHERE  patient_num = o.patient_num
        ORDER BY start_date LIMIT 1
    ) AS observation_period_start_date,
   -- Last occurring end_date or if it is null, last ocurring start_date
    COALESCE(( SELECT end_date FROM i2b2.observation_fact
        WHERE  patient_num = o.patient_num
        ORDER BY end_date DESC LIMIT 1
    ), ( SELECT start_date FROM i2b2.observation_fact
        WHERE  patient_num = o.patient_num
        ORDER BY start_date DESC LIMIT 1
    )) AS observation_period_end_date,
   -- Fixed to 44814724 (period covering healthcare encounters) 
	44814724 AS period_type_concept_id
FROM (SELECT DISTINCT patient_num FROM i2b2.observation_fact) o
;
