
select cabin, sum(survived) as survived, count(passengerId) as occupants,
(cast(sum(survived) as float)/ count(passengerId)) * 100 as percent_survived,
sum(case when survived is null then 1 else 0 end) as fate_not_in_dataset
from
(
	select passengerId, survived, pclass, sex, cabin
	from
	vw_train_and_test_combined
	where cabin in
	(
		select d.cabin
		from
		(
			select * from
			vw_train_and_test_combined
			where cabin in (
				select cabin
				from
				vw_train_and_test_combined
				group by cabin
				having count(cabin) > 1
			)
		) d
		group by d.cabin
		having sum(cast(d.sibsp as int)) + sum(cast(d.parch as int)) = 0
	)
) u
group by cabin



select * from vw_train_and_test_combined
where cabin in ('F33')