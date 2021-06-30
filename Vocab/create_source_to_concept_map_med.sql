--by Diego Bosca v20210525
CREATE TABLE source_to_concept_map_med as
SELECT * from source_to_concept_map WHERE SOURCE_CODE LIKE 'AEMPS%' OR SOURCE_CODE LIKE 'ES12_OCTUBRE_MED%';