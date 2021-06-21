-- v1 by Diego Bosca on 20201217
INSERT INTO location
(
    location_id,
    address_1,
	address_2,
    city,
    state,
    zip,
	county,
	location_source_value
)
-- This location will be used for care sites in 12O Hospital
VALUES  (1,'Avenida de Córdoba s/n',NULL,'Madrid','MD','28041','Madrid','Hospital Universitario 12 de Octubre')
;