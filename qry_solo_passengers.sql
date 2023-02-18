
-- solo travellers on the titanic find out about their fate

select pclass, sex, count(passengerId) as total_count, sum(survived) as number_survived, 
round((cast(sum(survived) as float)/count(passengerId)),2) * 100 as percent_survived
from
(
	select * 
	from vw_train_and_test_combined
	where parch = 0 and sibsp = 0
	and dataset = 'train'
	and cabin in (
		select cabin
		from vw_train_and_test_combined
		where dataset = 'train'
		group by cabin
		having count(passengerId) = 1
	)
) 
group by pclass, sex