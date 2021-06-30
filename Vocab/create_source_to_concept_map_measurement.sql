--by Diego Bosca v20210525
CREATE TABLE source_to_concept_map_measurement as
SELECT * from source_to_concept_map WHERE SOURCE_CODE LIKE 'LOINC%' OR SOURCE_CODE LIKE 'ES12_OCTUBRE_LAB%';