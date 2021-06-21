\echo 'Every condition_era has a concept_id from "Condition"'
with cte as (select count(concept.domain_id) as total, concept.domain_id as domains FROM condition_era JOIN concept on condition_era.condition_concept_id=concept.concept_id where concept.domain_id != 'Condition' group by concept.domain_id)
select  
case
when  sum(total)=0 then 'PASS: NO CONDITION ERA CODE FROM NON CONDITION DOMAIN'
else 'FAIL: found ' || sum(total) || ' from domains ' || string_agg(domains, ',')
end
from cte;

\echo 'Every condition has a standard concept_id'
with cte as (select count(condition_era.condition_concept_id) as total FROM condition_era JOIN concept on condition_era.condition_concept_id=concept.concept_id where concept.standard_concept != 'S' )
select  
case
when  total=0 then 'PASS: EVERY CONCEPT IS STANDARD'
else 'FAIL: found ' || total 
end
from cte;
