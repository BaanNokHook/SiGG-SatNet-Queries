select * from
vw_train_and_test_combined
where sex = 'male' and survived = 1
and pclass = 2
and age > 18
order by fare asc



select 
pclass, 
count(passengerId) as count_total, sum(survived) as survived, 
[dbo].[fn_get_percent](sum(survived),count(passengerId)) as percent_survived
from
vw_train_and_test_combined
where sex = 'male'
and age > 18
group by pclass