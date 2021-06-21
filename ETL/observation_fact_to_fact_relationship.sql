--by Diego Bosca 20201223
INSERT INTO fact_relationship
(
    domain_concept_id_1, -- domain_concept_id will correspond to ''drug_exposure" 
    fact_id_1,
    domain_concept_id_2, -- domain_concpept_id should correspond to ''condition_occurrence'' 
    fact_id_2,
    relationship_concept_id -- Hard coded as 46233685 (Condition relevant to)
)
SELECT
 -- [Fixed to] 13,  # Drug
    13 AS domain_concept_id_1,

 -- [MAPPING   LOGIC] Medication prescribed. Retrieve drug_exposure_id from the record which has associated the modifier ‘RelatedTo’. This drug_exposure_id should be used to populate fact_id_1 
	(SELECT drug_exposure_id FROM drug_exposure WHERE drug_source_value=observation_fact.concept_cd) AS fact_id_1,

 -- [Fixed to] 19,  # Condition       
    19 AS domain_concept_id_2,

 -- [MAPPING   LOGIC] Reference to the diagnosis for which a medication was prescribed. To populate fact_id_2 retrieve t_val_char from the record where modifier_cd=' MOD:RelatedTo'. Use this value to retrieve in condition_occurrence _table (condition_source_value....) and use the 'condition_occurrence_id' from this record to populate the fact_id_2  
    (SELECT condition_occurrence_id FROM condition_occurrence WHERE condition_source_value=observation_fact.tval_char) AS fact_id_2,

 -- [Fixed to]  46233685  # Condition relevant to
    46233685 AS relationship_concept_id

FROM i2b2.observation_fact
WHERE observation_fact.modifier_cd='MOD:RelatedTo'
;