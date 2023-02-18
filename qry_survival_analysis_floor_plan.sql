drop table if exists #tmp_cabin_data

select 

	passengerId, survived,pclass,name,sex,age,sibsp,parch,ticket,fare,cabin,embarked,dataset
	first_cabin, first_cabin_number,side, deck, [dbo].[fn_get_cabin_number_location_on_deck](cast(first_cabin_number as int)) as location
	
	into #tmp_cabin_data

from
(
	select passengerId, survived,pclass,name,sex,age,sibsp,parch,ticket,fare,cabin,embarked,dataset
	,case when charindex(' ',cabin,1) = 0 then cabin else substring(cabin,1,charindex(' ',cabin,1)) end as first_cabin
	,[dbo].[fn_remove_deck_from_cabin](case when charindex(' ',cabin,1) = 0 then cabin else substring(cabin,1,charindex(' ',cabin,1)) end) as first_cabin_number
	,case when [dbo].[fn_remove_deck_from_cabin](case when charindex(' ',cabin,1) = 0 then cabin else substring(cabin,1,charindex(' ',cabin,1)) end) % 2 = 0 then 'port' else 'starboard' end as side
	,substring(cabin,1,1) as deck
	from
	vw_train_and_test_combined
	where survived is not null and cabin is not null
) d
where d.first_cabin_number <> ''


-- summary of survivors by cabin location on deck

select 
	location,side,deck,pclass, 
	count(passengerId) as total_passengers,
	sum(survived) as survived,
    [dbo].[fn_get_percent](sum(survived),count(passengerId)) as percent_survived
from #tmp_cabin_data
group by location,side,deck,pclass


select 
	location,side,deck,
	count(passengerId) as total_passengers,
	sum(survived) as survived,
    [dbo].[fn_get_percent](sum(survived),count(passengerId)) as percent_survived
from #tmp_cabin_data
group by location,side,deck


select 
	location,side,
	count(passengerId) as total_passengers,
	sum(survived) as survived,
    [dbo].[fn_get_percent](sum(survived),count(passengerId)) as percent_survived
from #tmp_cabin_data
group by location,side


select 
	location,side,pclass,
	count(passengerId) as total_passengers,
	sum(survived) as survived,
    [dbo].[fn_get_percent](sum(survived),count(passengerId)) as percent_survived
from #tmp_cabin_data
group by location,side,pclass




drop table #tmp_cabin_data