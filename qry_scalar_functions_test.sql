
-- testing scalar functions in database

select * 
from
(
	select 
	[dbo].fn_get_title_from_name(Name) as title,
	[dbo].fn_get_name_sans_title(Name) as name_sans_title,
	[dbo].fn_get_surname(Name) as surname,
	[dbo].fn_get_alias(Name) as alias,
	[dbo].fn_get_name_sans_title_alias(Name) as name_sans_title_alias,
	[Name]
	from vw_train_and_test_combined
) 