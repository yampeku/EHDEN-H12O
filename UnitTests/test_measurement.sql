\echo 'Every source concept is from a measurement source terminology (LOINC, ES_12OCTUBRE_LAB)'
select  
case
--no measurement that is not a measurement in source
when count(measurement.measurement_concept_id)=0 then 'PASS: NO MEASUREMENT FROM NO SOURCE MEASURMENT DOMAINS'
else 'FAIL'
end
FROM measurement 
WHERE measurement.measurement_source_value not LIKE 'LOINC%' 
AND measurement.measurement_source_value not LIKE 'ES12_OCTUBRE_LAB%'; 

\echo 'Every measurement has a concept_id from "Measurement" domain'
with cte as (select count(concept.domain_id) as total, concept.domain_id as domains FROM measurement JOIN concept on measurement.measurement_concept_id=concept.concept_id where concept.domain_id != 'Measurement' group by concept.domain_id)
select  
case
--no measurment that is not a measurment 
when  sum(total)=0 then 'PASS: NO MEASUREMENT CODE FROM NON MEASUREMENT DOMAIN'
else 'FAIL: found ' || sum(total) || ' from domains ' || string_agg(domains, ',')
end
from cte;

\echo 'No measurement mapped to 0'
with cte as (select count(measurement.measurement_concept_id) as total FROM measurement where measurement_concept_id = 0)
select  
case
--no measurement mapped to 0
when  total=0 then 'PASS: NO MEASUREMENT MAPPED TO 0'
else 'FAIL: found ' || total 
end
from cte;

\echo 'Both value as number and value as concept id in measurement are not null'
with cte as (select count(measurement.measurement_concept_id) as total FROM measurement where value_as_number is null and value_as_concept_id is null)
select  
case
--no measurement both values null
when  total=0 then 'PASS: NO MEASUREMENT HAS BOTH VALUES TO NULL'
else 'FAIL: found ' || total 
end
from cte;

\echo 'Every measurement has a standard concept_id'
with cte as (select count(measurement.measurement_concept_id) as total FROM measurement JOIN concept on measurement.measurement_concept_id=concept.concept_id where concept.standard_concept != 'S' )
select  
case
when  total=0 then 'PASS: EVERY CONCEPT IS STANDARD'
else 'FAIL: found ' || total 
end
from cte;

\echo 'Every measurement value concept id has a standard concept_id'
with cte as (select count(measurement.value_as_concept_id) as total FROM measurement JOIN concept on measurement.value_as_concept_id=concept.concept_id where concept.standard_concept != 'S' )
select  
case
when  total=0 then 'PASS: EVERY CONCEPT IS STANDARD'
else 'FAIL: found ' || total 
end
from cte;

