create table i2b2_measurement as select * FROM i2b2.observation_fact 
WHERE observation_fact.concept_cd LIKE 'LOINC%' 
OR observation_fact.concept_cd LIKE 'ES12_OCTUBRE_LAB%';
