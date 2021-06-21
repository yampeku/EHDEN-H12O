--v20210106 create indexes in mapping tables
CREATE INDEX indexconcept ON source_to_concept_map(source_code);
CREATE INDEX indexunits ON units_cd_lookup(units_cd);
CREATE INDEX indexroute ON route_lookup(route_code);
