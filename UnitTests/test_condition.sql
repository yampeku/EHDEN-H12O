\echo 'Every source concept is from a condition source terminology (ICPC2, ICD-O, ES_12OCTUBRE_DIAG, ICD10CM)'
select  
case
--no condition that is not a condition in source
when count(condition_occurrence.condition_concept_id)=0 then 'PASS: NO CONDITION_OCURRENCE FROM NO SOURCE CONDITION DOMAINS'
else 'FAIL'
end
FROM condition_occurrence 
WHERE condition_occurrence.condition_source_value not LIKE 'ICPC2%' 
AND condition_occurrence.condition_source_value not LIKE 'ES_12OCTUBRE_DIAG%' 
AND condition_occurrence.condition_source_value not LIKE 'ICD-O%' 
AND condition_occurrence.condition_source_value not LIKE 'ICD10CM%';

\echo 'Every condition has a concept_id from "Condition" domain'
with cte as (select count(concept.domain_id) as total, concept.domain_id as domains FROM condition_occurrence JOIN concept on condition_occurrence.condition_concept_id=concept.concept_id where concept.domain_id != 'Condition' group by concept.domain_id)
select  
case
--no condition that is not a condition
when  sum(total)=0 then 'PASS: NO CONDITION_OCURRENCE CODE FROM NON CONDITION DOMAIN'
else 'FAIL: found ' || sum(total) || ' from domains ' || string_agg(domains, ',')
end
from cte;

\echo 'No conditions mapped to 0'
with cte as (select count(condition_occurrence.condition_concept_id) as total FROM condition_occurrence where condition_concept_id = 0)
select  
case
--no condition mapped to 0
when  total=0 then 'PASS: NO CONDITION_OCURRENCE MAPPED TO 0'
else 'FAIL: found ' || total 
end
from cte;

\echo 'Every condition has a standard concept_id'
with cte as (select count(condition_occurrence.condition_occurrence_id) as total FROM condition_occurrence JOIN concept on condition_occurrence.condition_concept_id=concept.concept_id where concept.standard_concept != 'S' )
select  
case
when  total=0 then 'PASS: EVERY CONCEPT IS STANDARD'
else 'FAIL: found ' || total 
end
from cte;
