\echo 'Every ES_12OCTUBRE_GENDER:M is mapped to 8532'
select  
case
--if min and max are the same value then pass
when count(distinct person.gender_concept_id)=1 and max(person.gender_concept_id)=8532 and min(person.gender_concept_id)=8532 then 'PASS: ES_12OCTUBRE_GENDER:M ETL CORRECT'
else 'FAIL'
end
from person where person.gender_source_value='ES_12OCTUBRE_GENDER:M';

\echo 'Every ES_12OCTUBRE_GENDER:V is mapped to 8507'
select  
case
--if min and max are the same value then pass
when count(distinct person.gender_concept_id)=1 and max(person.gender_concept_id)=8507 and min(person.gender_concept_id)=8507 then 'PASS: ES_12OCTUBRE_GENDER:V ETL CORRECT'
else 'FAIL'
end
from person where person.gender_source_value='ES_12OCTUBRE_GENDER:V';