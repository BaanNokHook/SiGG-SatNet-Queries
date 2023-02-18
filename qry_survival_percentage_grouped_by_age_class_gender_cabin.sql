
-- percentage buckets of those that perished based on class, sex, age, cabin class

select *, round(cast(survived as float)/(cast(total as float)),2) * 100 as percent_live, round(cast(died as float)/(cast(total as float)),2) * 100 as percent_died
from
(
	select pclass as class, sex,  age_group, substring(cabin,1,1) as cabin_class, count(pclass) as total, sum(cast(survived as int)) as survived, count(pclass) - sum(cast(survived as int)) as died
	from
	(
		select *, [dbo].fn_get_age_bracket(cast(age as decimal)) as age_group
		from train
	) t
	group by pclass, sex, age_group,  substring(cabin,1,1)
) d

order by class, sex, age_group, cabin_class