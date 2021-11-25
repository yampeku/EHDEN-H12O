create table source_to_concept_map_measurement as select * FROM source_to_concept_map
WHERE (source_to_concept_map.source_code LIKE 'LOINC%' 
OR source_to_concept_map.source_code LIKE 'ES12_OCTUBRE_LAB%') AND INVALID_REASON IS NULL;
create index idx_source_to_concept_map_measurement on source_to_concept_map_measurement(source_code)
