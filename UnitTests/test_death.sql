\echo 'No death with empty date'
select  
case
--no death with empty death date
when count(death.death_date)=0 then 'PASS: DEATH DATE ETL CORRECT'
else 'FAIL'
end
from death where death.death_date is null;