select *
from
vw_train_and_test_combined
where cabin in
(
	select d.cabin --, sum(cast(d.sibsp as int)) as s, sum(cast(d.parch as int)) as d
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
order by cabin