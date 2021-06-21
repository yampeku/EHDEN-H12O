--by Diego Bosca 20210115
INSERT INTO condition_occurrence
(
    condition_occurrence_id, -- Assign next number (auto-increment) 
    person_id,
    condition_concept_id,
    condition_start_date,
    condition_start_datetime,
    condition_end_date,
    condition_end_datetime,
    condition_type_concept_id, -- EHR encounter diagnosis (concept_id = 32020)
    stop_reason,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    condition_source_value,
    condition_source_concept_id,
    condition_status_source_value,
    condition_status_concept_id
)
SELECT
 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
     nextval('condition_occurrence_id_seq') AS condition_occurrence_id,

 -- [MAPPING COMMENT] A record should be created per unique instance_num and where the concept_cd (matched to the concept_dimension table) is a condition code (most likely ICPC2, HOSPITAL:DIAG codes and ICD-10CM, ICD_O)  
    patient_num AS person_id,

 -- [MAPPING   LOGIC] *Atttached document   Mapping to be provided from ICPC2 / Local hospital codes       For local hospital codes, take the code and join with concept_dimension table. Retrieve the concept_path and take the last portion of that string - indicating the corresponding ICD10CM code. Join this ICD10CM code in the OMOP concept and concept_relationship table to the corresponding standard (SNOMED) Code      For ICPC codes - similar approach and -in addition - check on the mappings for Pharmo and determine if appropriate for this mapping      For ICD-O codes, combine the histology code from modifier_cd (e.g. ‘9732/3’ from ‘ES_12OCT_TR_MOR:9732.3’) with the topography code from concept_cd (e.g. ‘C42.1’ from ‘ICD-O:C42.1’) to form an ICDO Condition code (e.g. ‘9732/3-C42.1’). Use this concept_code to look up the standard ICDO Condition concept_id from the ICDO3 vocabulary.  
 -- [MAPPING COMMENT] Evaluate any missing ICD10 and or SNOMED mappings from hospital diagnosis codes.
 -----TODO----
 	CASE
		WHEN concept_cd LIKE 'ICD10CM%' THEN COALESCE((SELECT TARGET_CONCEPT_ID FROM source_to_concept_map WHERE SOURCE_CODE=concept_cd AND INVALID_REASON IS NULL limit 1),0)
		WHEN concept_cd LIKE 'ICD-O%'  THEN COALESCE((SELECT TARGET_CONCEPT_ID FROM source_to_concept_map WHERE SOURCE_CODE=concept_cd AND INVALID_REASON IS NULL limit 1),0)
		WHEN concept_cd LIKE 'ICPC2%' THEN COALESCE((SELECT TARGET_CONCEPT_ID FROM source_to_concept_map WHERE SOURCE_CODE=concept_cd AND INVALID_REASON IS NULL limit 1),0)
		WHEN concept_cd LIKE 'ES_12OCTUBRE_DIAG:%' THEN COALESCE((SELECT TARGET_CONCEPT_ID FROM source_to_concept_map WHERE SOURCE_CODE=concept_cd AND INVALID_REASON IS NULL limit 1),0)
		ELSE 0
	END AS condition_concept_id,
    

    --modifier_cd AS condition_concept_id,

	start_date::date AS condition_start_date,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    start_date AS condition_start_datetime,


	end_date::date AS condition_end_date,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
   end_date AS condition_end_datetime,

 -- [Fixed to] EHR encounter diagnosis (concept_id = 32020)
    32020 AS condition_type_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS stop_reason,

 -- [MAPPING   LOGIC] Use only the numerical part of the provider_id (e.g. HPHCIS_PROVIDER:69695) 
	coalesce((select provider_id from provider where i2b2_condition.provider_id=provider.provider_source_value limit 1),0) AS provider_id,

    encounter_num AS visit_occurrence_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS visit_detail_id,

    concept_cd AS condition_source_value,

 -- [MAPPING   LOGIC] get the OMOP code by splitting the vocabulary and the code (e.g. LOINC:12345) 
	CASE
		WHEN concept_cd LIKE 'ICD10CM%' THEN COALESCE((SELECT SOURCE_CONCEPT_ID FROM source_to_concept_map WHERE SOURCE_CODE=concept_cd AND INVALID_REASON IS NULL limit 1),0)
		WHEN concept_cd LIKE 'ICD-O%'  THEN COALESCE((SELECT SOURCE_CONCEPT_ID FROM source_to_concept_map WHERE SOURCE_CODE=concept_cd AND INVALID_REASON IS NULL limit 1),0)
		--WHEN concept_cd LIKE 'ES_12OCTUBRE_DIAG:%' THEN (SELECT SOURCE_CONCEPT_ID FROM source_to_concept_map WHERE SOURCE_CODE=concept_cd AND INVALID_REASON IS NULL limit 1)
		ELSE 0
	END AS condition_source_concept_id,
    
  

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS condition_status_source_value,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS condition_status_concept_id

FROM i2b2_condition offset 3000000 limit 1000000
;