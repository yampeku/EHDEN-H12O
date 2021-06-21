--v2 by Diego Bosca 20210318
INSERT INTO provider
(
    provider_id,
    provider_name,
    npi,
    dea,
    specialty_concept_id,
    care_site_id,
    year_of_birth,
    gender_concept_id,
    provider_source_value,
    specialty_source_value,
    specialty_source_concept_id,
    gender_source_value,
    gender_source_concept_id
)
SELECT DISTINCT
 -- we need to to keep the numerical part of the string (e.g. 'ES_PCMADRID_PROVIDER:1191177881')
 -- In postgres this is done with the split_part function(path, char, order) NOTE: order starts at 1
 -- some providers do not have a code, so we get an id if it is null
    COALESCE((NULLIF(split_part(i2b2.provider_dimension.provider_id, ':', 2),''))::INTEGER,nextval('provider_id_seq') ) AS provider_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS provider_name,

    substring(i2b2.provider_dimension.name_char,1,20) AS npi,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS dea,

 -- [MAPPING   LOGIC] Take the text portion behind the second '/' to map to the specialty  EXAMPLE: /12deoct/REUMATOLOGIA/JEFE SECCION/1099999  > REUMATOLOGIA should relate to specialty_concept_id 38004491  (rheumatology)  
 -- In postgres this is done with the split_part function(path, char, order) NOTE: order starts at 1
	(SELECT TARGET_CONCEPT_ID FROM source_concept_map WHERE SOURCE_CONCEPT_ID=split_part(i2b2.provider_dimension.provider_path, '/', 3) AND SOURCE_VOCABULARY_ID = 'I2B2_SPECIALITY' AND INVALID_REASON IS NULL) AS specialty_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL::integer AS care_site_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL::integer AS year_of_birth,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL::integer AS gender_concept_id,
	
 -- [MAPPING COMMENT] provider path can be longer than 50, trim to 50
    substring(i2b2.provider_dimension.provider_path,1,50) AS provider_source_value,

 -- [MAPPING   LOGIC] Take the text portion behind the second '/' to map to the specialty 
    (split_part(i2b2.provider_dimension.provider_path, '/', 3)) AS specialty_source_value,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL::integer AS specialty_source_concept_id,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL AS gender_source_value,

 -- [MAPPING COMMENT] no mapping logic defined. Put NULL
    NULL::integer AS gender_source_concept_id

FROM i2b2.provider_dimension
;