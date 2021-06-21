-- by Diego Bosca 20210120
INSERT INTO drug_exposure
(
    drug_exposure_id, -- Assign Next Number (Auto-Increment) 
    person_id,
    drug_concept_id,
    drug_exposure_start_date,
    drug_exposure_start_datetime,
    drug_exposure_end_date,
    drug_exposure_end_datetime,
    verbatim_end_date,
    drug_type_concept_id, -- Assign concept_id 38000177 (prescription written) 
    stop_reason,
    refills,
    quantity,
    days_supply,
    sig,
    route_concept_id,
    lot_number,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    drug_source_value,
    drug_source_concept_id,
    route_source_value,
    dose_unit_source_value
)
SELECT
 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
     nextval('drug_exposure_id_seq') AS drug_exposure_id,

    observation_fact_med.patient_num AS person_id,

 -- [MAPPING   LOGIC] Map at ATC level to corresponding RxNORM or RxNORM extension (at ingredient)      Note that certain drugs are also codes in coding systems OMG4 , ES12_OCTUBRE_MED, a limited set of ES12_OCT_AP_TOP codes and certain ICPC2 Codes. For mapping all these code systems, check if the corresponding ATC code is represented in the concept_path      Check also if there is for this observation_id also a MOD:DOSE modifier record. If so, use the combination of ATC code and DOSE to identify drug_concept_id at a lower level of granularity.      More information can be checked in name_char.  
    CASE
		WHEN observation_fact_med.concept_cd LIKE 'AEMPS%'  THEN COALESCE((SELECT TARGET_CONCEPT_ID FROM source_to_concept_map_med WHERE SOURCE_CODE=observation_fact_med.concept_cd AND INVALID_REASON IS NULL),0)
		WHEN observation_fact_med.concept_cd LIKE 'ES12_OCTUBRE_MED%' THEN COALESCE((SELECT TARGET_CONCEPT_ID FROM source_to_concept_map_med WHERE SOURCE_CODE=observation_fact_med.concept_cd AND INVALID_REASON IS NULL),0)
		ELSE 0
	END AS drug_concept_id,

    observation_fact_med.start_date AS drug_exposure_start_date,

    observation_fact_med.start_date AS drug_exposure_start_datetime,

    coalesce(observation_fact_med.end_date,observation_fact_med.start_date) AS drug_exposure_end_date,

    coalesce(observation_fact_med.end_date,observation_fact_med.start_date) AS drug_exposure_end_datetime,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS verbatim_end_date,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    CASE
	WHEN observation_fact_med.modifier_cd='ES_12OCTUBRE_ADMI:prescription' THEN 38000177 --presctiption written
	WHEN observation_fact_med.modifier_cd='ES_12OCTUBRE_ADMI:substance administration' THEN 38000180 --inpatient administration
	ELSE 38000177 -- 38000177 (prescription written)
    END AS drug_type_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS stop_reason,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS refills,

 -- [MAPPING   LOGIC] The dosis is identified in nval_num for those concepts who have the modifier MOD:Dose associated 
	CASE
		WHEN  observation_fact_med.modifier_cd='MOD:Dose' THEN observation_fact_med.nval_num
		ELSE NULL
	END AS quantity,
		

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS days_supply,

 -- [!WARNING!] we can put here a signature of the prescription if needed
    NULL AS sig,

 -- [MAPPING   LOGIC] The route of administration corresponds with the modifiers ES_12OCTUBRE_ROUTE:
	CASE
		WHEN  observation_fact_med.modifier_cd LIKE 'ES_12OCTUBRE_ROUTE%' THEN (select route_lookup.concept_id from route_lookup where route_lookup.route_code=observation_fact_med.modifier_cd)
		ELSE 0
	END AS route_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS lot_number,

 -- [MAPPING COMMENT] Try to get the provider from table, else 0
	coalesce((select provider_id from provider where observation_fact_med.provider_id=provider.provider_source_value limit 1),0) AS provider_id,

    observation_fact_med.encounter_num AS visit_occurrence_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS visit_detail_id,

    observation_fact_med.concept_cd AS drug_source_value,

     NULL AS drug_source_concept_id,

    observation_fact_med.modifier_cd AS route_source_value,

    observation_fact_med.units_cd AS dose_unit_source_value

--observation_fact_med is i2b2.observation_fact where concept_cd is AEMPS or ES12_OCTUBRE_MED
FROM observation_fact_med;
;