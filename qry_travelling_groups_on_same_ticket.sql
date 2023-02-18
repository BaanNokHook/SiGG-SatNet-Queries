
-- groups of people travelling on the same ticket on the titanic

select 
pclass, ticket, fare, embarked, 
count(passengerId) as group_count, 
sum(case when sex = 'male' then 1 else 0 end) as male_count, 
sum(case when sex = 'female' then 1 else 0 end) as female_count, 
sum(case when survived = '1' then 1 else 0 end) as total_survived,
sum(case when survived is null then 1 else 0 end) as fate_unknown,
sum(case when survived = '1' and Sex = 'male' then 1 else 0 end) as male_survived,
sum(case when survived = '1' and Sex = 'female' then 1 else 0 end) as female_survived,
min(cast(parch as int)) as min_parch,
max(cast(parch as int)) as max_parch,
case when min(cast(parch as int)) + max(cast(Parch as int)) < count(passengerId)
then count(passengerId) else min(cast(Parch as int)) + max(cast(Parch as int)) end  as group_size

from vw_train_and_test_combined
group by Pclass, Ticket, Fare, Embarked  
order by group_count desc