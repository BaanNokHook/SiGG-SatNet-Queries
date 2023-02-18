drop table if exists #tmp_married ADD

CREATE TABLE #tmp_married(  
	[pclass] [int] NULL,
	[ticket] [nvarchar](50) NULL,
	[fare] [float] NULL,
	[embarked] [nvarchar](50) NULL,
	[title] [nvarchar](50) NULL,
	[surname] [nvarchar](50) NULL,
	[name] [nvarchar](200) NULL,
	[age] [int] NULL,
	[sex] [nvarchar](50) NULL,
	[sibsp] [nvarchar](50) NULL,
	[parch] [nvarchar](50) NULL,
	[survived] [int] NULL,
	[dataset] [nvarchar](50) NULL,
) ON [PRIMARY]
GO

insert into #tmp_married
select pclass,ticket,fare,embarked, [dbo].[fn_get_title_from_name](Name) as title, 
[dbo].[fn_get_surname](Name) as surname,
name, age, sex, sibsp, parch, survived, dataset
from
vw_train_and_test_combined
where [dbo].[fn_get_title_from_name](Name) not in ('Master','Miss')
and sibsp >= 1
order by pclass,ticket,fare, embarked, [dbo].[fn_get_surname](Name) 


select
m.pclass,m.ticket,m.fare,m.embarked,m.title,m.surname,m.age,
f.title, f.surname, f.age, m.survived,f.survived
from
(
	select 
	pclass,ticket,fare,embarked,title,surname,age,sibsp,parch,survived
	from
	#tmp_married
	where sex = 'male' and parch = 0
	and surname in (select distinct surname from #tmp_married where sex = 'female')
) m
left join
(
	select pclass,ticket,fare,embarked,title,surname,age,sibsp,parch,survived
	from
	#tmp_married
	where sex = 'female' and parch = 0
	and surname in (select distinct surname from #tmp_married where sex = 'male')
) f
on m.pclass = f.pclass and m.ticket = f.ticket and m.fare = f.fare

order by m.survived desc, f.survived desc, m.pclass asc


drop table #tmp_married