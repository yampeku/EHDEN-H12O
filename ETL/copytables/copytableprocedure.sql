create table i2b2_procedure as select * FROM i2b2.observation_fact 
WHERE observation_fact.concept_cd LIKE 'ICD10PCS%' 
OR observation_fact.concept_cd LIKE 'ES_12OCTUBRE_PROC%';
