create table i2b2_condition as select * FROM i2b2.observation_fact 
WHERE observation_fact.concept_cd LIKE 'ICPC2%' 
OR observation_fact.concept_cd LIKE 'ES_12OCTUBRE_DIAG:' 
OR  observation_fact.concept_cd LIKE 'ICD-O%' 
OR observation_fact.concept_cd LIKE 'ICD10CM%';

