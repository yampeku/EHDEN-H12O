\echo 'Every Drug_era has a concept_id from "Drug"'
with cte as (select count(concept.domain_id) as total, concept.domain_id as domains FROM drug_era JOIN concept on drug_era.drug_concept_id=concept.concept_id where concept.domain_id != 'Drug')
select  
case
--no drug that is not a drug
when  sum(total)=0 then 'PASS: NO drug_era CODE FROM NON DRUG DOMAIN'
else 'FAIL: found ' || sum(total) || ' from domains ' || string_agg(domains, ',')
end
from cte;

\echo 'Every drug  has a standard concept_id'
with cte as (select count(drug_era.drug_concept_id) as total FROM drug_era JOIN concept on drug_era.drug_concept_id=concept.concept_id where concept.standard_concept != 'S' )
select  
case
when  total=0 then 'PASS: EVERY CONCEPT IS STANDARD'
else 'FAIL: found ' || total 
end
from cte;


