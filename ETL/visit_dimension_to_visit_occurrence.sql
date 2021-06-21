--By Diego Bosca 20201222
-- Needs clarification on visit_end_date and provider_id
INSERT INTO visit_occurrence
(
    visit_occurrence_id,
    person_id,
    visit_concept_id, -- 38004515 Hospital? 8717 Inpatient Hospital?
    visit_start_date,
    visit_start_datetime,
    visit_end_date,
    visit_end_datetime,
    visit_type_concept_id, -- Map to 44818518 (visit derived from EHR record) 
    provider_id,
    care_site_id,
    visit_source_value,
    visit_source_concept_id,
    admitting_source_concept_id,
    admitting_source_value,
    discharge_to_concept_id,
    discharge_to_source_value,
    preceding_visit_occurrence_id
)
SELECT
    visit_dimension.encounter_num AS visit_occurrence_id,

    visit_dimension.patient_num AS person_id,

 -- [MAPPING   LOGIC] Map as follows      AMB -> 9202 (outpatient visit)   URG -> 9203 (emergency room)   ADM -> 9201 (inpatient)   PC_MADRID:Type X: TBD (ad interim map to 9202 - outpatient)   (Primary care of Madrid)  
    CASE
		WHEN visit_dimension.inout_cd='ES_12OCTUBRE_TYPE:AMB' THEN 9202
		WHEN visit_dimension.inout_cd='ES_12OCTUBRE_TYPE:URG' THEN 9203
		WHEN visit_dimension.inout_cd='ES_12OCTUBRE_TYPE:ADM' THEN 9201
		ELSE 9202 --TBD
	END AS visit_concept_id,

 -- [MAPPING COMMENT] If no start_date given, create record with 1/1/1970 as visit_start_date  
    CASE
		WHEN visit_dimension.start_date IS NULL THEN '1970-01-01 00:00:00'::timestamp::date
		ELSE visit_dimension.start_date::date
	END AS visit_start_date,

    CASE
		WHEN visit_dimension.start_date IS NULL THEN '1970-01-01 00:00:00'::timestamp
		ELSE visit_dimension.start_date
	END AS visit_start_datetime,

----------------VISIT END DATE CAN BE NULL AND IS MANDATORY-------------------------
    coalesce(visit_dimension.end_date,NOW()::timestamp) AS visit_end_date,

    visit_dimension.end_date AS visit_end_datetime,

 -- [Fixed to]  44818518 (visit derived from EHR record) 
    44818518 AS visit_type_concept_id,

---------------CHECK WHERE DO WE GET THE PROVIDER FROM-------------------------
    visit_dimension.encounter_num AS provider_id,

 -- [MAPPING   LOGIC] Take code and map through custom table to care_site_id 
 -- [MAPPING COMMENT] each one of the reference care_site should be created in the care_site table 
    (SELECT care_site_id FROM care_site WHERE care_site_source_value=visit_dimension.location_cd) AS care_site_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS visit_source_value,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS visit_source_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS admitting_source_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS admitting_source_value,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS discharge_to_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS discharge_to_source_value,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS preceding_visit_occurrence_id

FROM i2b2.visit_dimension
;