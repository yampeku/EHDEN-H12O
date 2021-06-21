\echo 'Every source concept is from a observation source terminology (SNOMED, ES12_OCTUMBRE_LAB)'
select  
case
--no measurement that is not a measurement in source
when count(observation.observation_concept_id)=0 then 'PASS: NO OBSERVATION FROM NO SOURCE OBSERVATION DOMAINS'
else 'FAIL'
end
FROM observation
WHERE observation.observation_source_value not LIKE 'SNOMED%' 
AND observation.observation_source_value not LIKE 'ES12_OCTUBRE_LAB%';

\echo 'Every observation has a concept_id from "Observation" domain'
with cte as (select count(concept.domain_id) as total, concept.domain_id as domains FROM observation JOIN concept on observation.observation_concept_id=concept.concept_id where concept.domain_id != 'Observation' group by concept.domain_id)
select  
case
--no observation that is not a observation
when  sum(total)=0 then 'PASS: NO OBSERVATION CODE FROM NON OBSERVATION DOMAIN'
else 'FAIL: found ' || sum(total)|| ' from domains ' || string_agg(domains, ',')
end
from cte;

\echo 'No observation mapped to 0'
with cte as (select count(observation.observation_concept_id) as total FROM observation where observation_concept_id = 0)
select  
case
--no observation mapped to 0
when  total=0 then 'PASS: NO OBSERVATION MAPPED TO 0'
else 'FAIL: found ' || total 
end
from cte;

\echo 'Value as number, value as concept id and value as string in observation are not null'
with cte as (select count(observation.observation_concept_id) as total FROM observation where value_as_number is null and value_as_concept_id is null and value_as_string is null)
select  
case
--no observation all values null
when  total=0 then 'PASS: NO OBSERVATION HAS ALL VALUES TO NULL'
else 'FAIL: found ' || total 
end
from cte;

\echo 'Every observation has a standard concept_id'
with cte as (select count(observation.observation_concept_id) as total FROM observation JOIN concept on observation.observation_concept_id=concept.concept_id where concept.standard_concept != 'S' )
select  
case
when  total=0 then 'PASS: EVERY CONCEPT IS STANDARD'
else 'FAIL: found ' || total 
end
from cte;

\echo 'Every observation value concept id has a standard concept_id'
with cte as (select count(observation.value_as_concept_id) as total FROM observation JOIN concept on observation.value_as_concept_id=concept.concept_id where concept.standard_concept != 'S' )
select  
case
when  total=0 then 'PASS: EVERY CONCEPT IS STANDARD'
else 'FAIL: found ' || total 
end
from cte;


