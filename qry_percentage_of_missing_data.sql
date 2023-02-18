
-- percentage of missing data from the training dataset

select d.*, round(cast(d.filled as float) / d.total,3) * 100 as perc_filled, round(cast(d.missing as float) / d.total,3) * 100 as perc_missing 

from

(
  select 'Age' as variable, count(PassengerId) as total, sum(case when Age is not null then 1 else 0 end) as filled, sum(case when Age is null then 1 else 0 end) as missing
  from [titanic].[dbo].[train]
  union
  select 'Sex' as variable, count(PassengerId) as total, sum(case when Sex is not null then 1 else 0 end) as filled, sum(case when Sex is null then 1 else 0 end) as missing
  from [titanic].[dbo].[train]
  union
  select 'Pclass' as variable, count(PassengerId) as total, sum(case when Pclass is not null then 1 else 0 end) as filled, sum(case when Pclass is null then 1 else 0 end) as missing
  from [titanic].[dbo].[train]
  union
  select 'SibSp' as variable, count(PassengerId) as total, sum(case when SibSp is not null then 1 else 0 end) as filled, sum(case when SibSp is null then 1 else 0 end) as missing
  from [titanic].[dbo].[train]
  union
  select 'Parch' as variable, count(PassengerId) as total, sum(case when Parch is not null then 1 else 0 end) as filled, sum(case when Parch is null then 1 else 0 end) as missing
  from [titanic].[dbo].[train]
  union
  select 'Ticket' as variable, count(PassengerId) as total, sum(case when Ticket is not null then 1 else 0 end) as filled, sum(case when Ticket is null then 1 else 0 end) as missing
  from [titanic].[dbo].[train] 
  union
  select 'Fare' as variable, count(PassengerId) as total, sum(case when Fare is not null then 1 else 0 end) as filled, sum(case when Fare is null then 1 else 0 end) as missing
  from [titanic].[dbo].[train]
  union
  select 'Cabin' as variable, count(PassengerId) as total, sum(case when Cabin is not null then 1 else 0 end) as filled, sum(case when Cabin is null then 1 else 0 end) as missing
  from [titanic].[dbo].[train]
  union
  select 'Embarked' as variable, count(PassengerId) as total, sum(case when Embarked is not null then 1 else 0 end) as filled, sum(case when Embarked is null then 1 else 0 end) as missing
  from [titanic].[dbo].[train]
  ) d