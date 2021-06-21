-- v1 by Diego Bosca on 20201210
-- Create an auxiliary table for care_site
CREATE TABLE if not exists care_site_aux (
	fullname varchar(25),
	name varchar(5),
	care_site_id SERIAL
);

INSERT INTO care_site_aux(name,fullname) SELECT DISTINCT split_part(i2b2.visit_dimension.location_cd, ':', 2),i2b2.visit_dimension.location_cd FROM i2b2.visit_dimension WHERE i2b2.visit_dimension.location_cd LIKE 'ES_12OCTUBRE_LOC%';