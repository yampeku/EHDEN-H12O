--by Diego Bosca 20210120
INSERT INTO measurement
(
    measurement_id, -- Assign Next Number (Auto-increment) 
    person_id,
    measurement_concept_id,
    measurement_date,
    measurement_datetime,
    measurement_time,
    measurement_type_concept_id, -- Map as concept-id 44818702 (lab result) 
    operator_concept_id,
    value_as_number,
    value_as_concept_id,
    unit_concept_id,
    range_low,
    range_high,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    measurement_source_value,
    measurement_source_concept_id,
    unit_source_value,
    value_source_value
)
SELECT DISTINCT -- DISTINCT to avoid duplicate records with same values with only different instance_num, tex_search_index, etc. 
 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
     nextval('measurement_id_seq') AS measurement_id,

 -- [MAPPING   LOGIC] Map only records from i2b2_measurement where the corresponding concept_id is part of the measurement domain (most likely codes belonging to code systems LOINC, ES12_OCTUBRE_LAB, ES12_OCT_AP_TOP, ICPC2, SNOMED-CT)  
    i2b2_measurement.patient_num AS person_id,

 -- [MAPPING   LOGIC] *Atttached document   For LOINC Codes: direct mapping to retrieve concept-id   For codes from the hospital (ES_12OCTUBRE_LAB) check on mapping through concept_path ((concept_dimension table) and check if there is a LOINC code in there. Codes where there is no corresponding LOINC code in the concept_path should be manually reviewed  
	CASE
		WHEN i2b2_measurement.concept_cd LIKE 'LOINC%' THEN coalesce((SELECT TARGET_CONCEPT_ID FROM source_to_concept_map_measurement WHERE SOURCE_CODE=i2b2_measurement.concept_cd),0)
		WHEN i2b2_measurement.concept_cd LIKE 'ES12_OCTUBRE_LAB%' THEN coalesce((SELECT TARGET_CONCEPT_ID FROM source_to_concept_map_measurement WHERE SOURCE_CODE=i2b2_measurement.concept_cd),0)
		ELSE 0
	END AS measurement_concept_id,
 
	i2b2_measurement.start_date::date AS measurement_date,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    i2b2_measurement.start_date AS measurement_datetime,


	i2b2_measurement.start_date::time AS measurement_time,


 -- [Fixed to] Map as concept-id 44818702 (lab result)
    44818702 AS measurement_type_concept_id,

 -- [MAPPING   LOGIC] if tval_char == G then operator_concept_id is set to 4172704 ( > ), if tval_char == L then operator_concept_id is set to 4171756 ( < ).  
	CASE
		WHEN i2b2_measurement.tval_char='G' THEN 4172704
		WHEN i2b2_measurement.tval_char='L' THEN 4171756
		--WHEN i2b2_measurement.tval_char='E'
		ELSE 0
	END AS operator_concept_id,

--------- should we only generate a row for this table in this case? --------------------
 -- [MAPPING   LOGIC] Only populate for records where valtype_cd ='N' and only when modifier_cd='@'  
    CASE	
		WHEN i2b2_measurement.valtype_cd='N' AND i2b2_measurement.modifier_cd='@' THEN i2b2_measurement.nval_num
		ELSE NULL
	END AS value_as_number,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL::integer AS value_as_concept_id,

 -- [MAPPING   LOGIC] convert to corresponding omop units 
    coalesce((select units_cd_lookup.concept_id from units_cd_lookup where units_cd_lookup.units_cd=i2b2_measurement.units_cd),0) AS unit_concept_id,

    i2b2_measurement.val_lln AS range_low,

    i2b2_measurement.val_uln AS range_high,

	coalesce((select provider_id from provider where i2b2_measurement.provider_id=provider.provider_source_value limit 1),0) AS provider_id,

    i2b2_measurement.encounter_num AS visit_occurrence_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL::integer AS visit_detail_id,

    i2b2_measurement.concept_cd AS measurement_source_value,
	
	CASE
		WHEN i2b2_measurement.concept_cd LIKE 'LOINC%' THEN (SELECT SOURCE_CONCEPT_ID FROM source_to_concept_map_measurement WHERE SOURCE_CODE=i2b2_measurement.concept_cd)
		ELSE NULL
	END AS measurement_source_concept_id,

--     (SELECT TARGET_CONCEPT_ID FROM source_to_standard WHERE SOURCE_CONCEPT_ID=i2b2_measurement.concept_cd AND SOURCE_VOCABULARY_ID = 'LOINC' AND INVALID_REASON IS NULL) AS measurement_source_concept_id,

    i2b2_measurement.units_cd AS unit_source_value,

    substring(i2b2_measurement.observation_blob,0,50) AS value_source_value

--i2b2_measurement is i2b2.observation_fact where concept_cd is LOINC or ES_12OCTUBRE_LAB
FROM i2b2_measurement
;