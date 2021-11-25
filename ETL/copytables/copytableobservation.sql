create table i2b2_observation as select observation_fact.*,concept_path FROM i2b2.observation_fact LEFT JOIN i2b2.concept_dimension on observation_fact.concept_cd=concept_dimension.concept_cd
WHERE (observation_fact.concept_cd LIKE 'SNOMED-CT%' OR observation_fact.concept_cd LIKE 'ES12_OCTUBRE_LAB%') AND concept_dimension.concept_path like '%SNOMED%';
