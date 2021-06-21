\echo 'Every source concept is from a drug source terminology (AEMPS, ES12_OCTUBRE_MED)'
select  
case
--no drug that is not a drug
when count(drug_exposure.drug_source_value)=0 then 'PASS: NO DRUG_EXPOSURE FROM NO DRUG DOMAINS'
else 'FAIL'
end
FROM drug_exposure 
WHERE drug_exposure.drug_source_value not LIKE 'AEMPS%' 
AND drug_exposure.drug_source_value not LIKE 'ES12_OCTUBRE_MED%';

\echo 'Every drug has a concept_id from "Drug"'
with cte as (select count(concept.domain_id) as total, concept.domain_id as domains FROM drug_exposure JOIN concept on drug_exposure.drug_concept_id=concept.concept_id where concept.domain_id != 'Drug' group by concept.domain_id)
select  
case
--no procedure that is not a procedure
when  sum(total)=0 then 'PASS: NO drug_exposure CODE FROM NON DRUG DOMAIN'
else 'FAIL: found ' || sum(total) || ' from domains ' || string_agg(domains, ',')
end
from cte;

\echo 'No drugs mapped to 0'
with cte as (select count(drug_exposure.drug_concept_id) as total FROM drug_exposure where drug_concept_id = 0)
select  
case
--no condition mapped to 0
when  total=0 then 'PASS: NO DRUG_EXPOSURE MAPPED TO 0'
else 'FAIL: found ' || total 
end
from cte;

\echo 'Every drug has a standard concept_id'
with cte as (select count(drug_exposure.drug_exposure_id) as total FROM drug_exposure JOIN concept on drug_exposure.drug_concept_id=concept.concept_id where concept.standard_concept != 'S' )
select  
case
when  total=0 then 'PASS: EVERY CONCEPT IS STANDARD'
else 'FAIL: found ' || total 
end
from cte;

