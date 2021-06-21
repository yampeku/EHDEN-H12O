\echo 'Every source concept is from a procedure source terminology (ICD10PCS, ES_12OCTUBRE_PROC)'
select  
case
--no procedure that is not a procedure in source
when count(PROCEDURE_OCCURRENCE.procedure_source_value)=0 then 'PASS: NO PROCEDURE_OCCURRENCE FROM NO PROCEDURE DOMAINS'
else 'FAIL'
end
FROM PROCEDURE_OCCURRENCE 
WHERE PROCEDURE_OCCURRENCE.procedure_source_value not LIKE 'ICD10PCS%' 
AND PROCEDURE_OCCURRENCE.procedure_source_value not LIKE 'ES_12OCTUBRE_PROC%';

\echo 'Every procedure has a concept_id from "Procedure"'
with cte as (select count(concept.domain_id) as total, concept.domain_id as domains FROM PROCEDURE_OCCURRENCE JOIN concept on PROCEDURE_OCCURRENCE.procedure_concept_id=concept.concept_id where concept.domain_id != 'Procedure')
select  
case
--no procedure that is not a procedure
when  sum(total)=0 then 'PASS: NO PROCEDURE_OCCURRENCE CODE FROM NON PROCEDURE DOMAIN'
else 'FAIL: found ' || sum(total)|| ' from domains ' || string_agg(domains, ',')
end
from cte;

\echo 'Every procedure has a standard concept_id'
with cte as (select count(PROCEDURE_OCCURRENCE.procedure_concept_id) as total FROM PROCEDURE_OCCURRENCE JOIN concept on PROCEDURE_OCCURRENCE.procedure_concept_id=concept.concept_id where concept.standard_concept != 'S' )
select  
case
when  total=0 then 'PASS: EVERY CONCEPT IS STANDARD'
else 'FAIL: found ' || total 
end
from cte;
