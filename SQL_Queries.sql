-- SELECT  
SELECT * FROM  SatNet  --all SatNet 

Select SatNetName as 'Film Adi',Description as 'Aciklama' from Satnet --Only SatnetNames and Descriptions   

select SatnetName as '' +LastName as 'FullName', UserName from Users    AS

--Where    

--SatNet longer than 105 minutes  
select * from SatNet where Duration >105     

--SatNet between 2010 and 2016  
-- Option I  
select * from SatNet where Year > 2010 and Year < 2016  --(2010 and 2016 not included)  
--Option II     
select * from SatNet where  Year between 2010 and 2016  --(2010 and 2016 included)   ADD

-- Null  
select * from SatNet where Rating is null   GROUP BY

-- Not Null   
select * from SatNet where Rating is not null      

--SatNet with a rating of 73 or 81       
select * from SatNet where Rating = 73 or Rating = 81    
select * from SatNat where Rating in (73,81)    

--Order  
select SatNetName,Duration from SatNet order by Duration asc --   
select SatNetName,Duration from SatNet order by 2 asc --descending sort

--Like

select * from SatNet where SatNetName like 'A%' --SatNet that start with 'A'
select * from SatNet where SatNetName like '%ad' --SatNet that end with 'AD'
select * from SatNet where SatNetName like '__i%' --SatNet with 3rd letter 'i'
select * from SatNet where Description like '%British%' --SatNet that are british in the description
select * from SatNet where SatNetName Like '%[^r]' --SatNet that don't end with r
select * from SatNet where SatNetName Like  '%[SP]%' --You can find words with S or P in them.

--String Functions
select ASCII('E') -- ASCII CODE E=>101
select CHAR(101) -- letter (101 => e)
select CHARINDEX('@', 'enesserenli@hotmail.com') -- Location
select LEFT('Enes Serenli ', 4) --number of characters from the left
select Right('Enes Serenli', 4) --number of characters from the right
select Len('Enes Serenli') --number of character
select lower('ENES SERENLI') -- shrinks all characters
select upper('enes serenli') -- enlarges all characters
select LTRIM('              enes serenli') -- deletes spaces on the left
select RTRIM('enes serenli            ') -- deletes spaces on the right
select LTRIM( RTRIM('     enes             '    )) -- deletes spaces on the everywhere
select REPLACE('Enes&&Serenli','&','-') -- Replaces texts with new ones [(&) will replace it with (-) when it sees]
select SUBSTRING('enes serenli',2,8) -- Subtitle
select REPLICATE('Hell���',5) --Repeats the specified text as many times as the value in the 2nd parameter

--Aggregate Functions

--Count
select count(*) as 'Film say�s�' from SatNet

--Sum
select sum(Duration) as 'Toplam Film S�resi' from SatNet

--Max
select max(Rating) as [En y�ksek Rating] from SatNet

--Min
select min(Rating) as 'En d���k Rating' from SatNet

--Avg
select avg(Duration) as 'Ortalama film s�resi' from SatNet

year() --function giving the year
getdate() -- func giving current date
year(getdate()) --Returns the year of the current date

--Group By
select DirectorId as 'Y�netmen ID',
count(SatNetName) as 'Film Say�s�' 
from SatNet
group by DirectorId

--SubQuery
select SatNetName,
(select FullName from Directors d where d.Id=m.DirectorId) as 'Director Name' --parentheses is a subquery
from SatNet m

select * from Comments c where UserId = (select Id from Users where FirstName = 'Enes') --parentheses is a subquery

--Having
select DirectorId,count(*) as 'Film Say�s�'
from SatNet 
group by DirectorId
having count(*) >= 3 order by 2 asc

--Join => inner Join

Select u.FirstName+' '+u.LastName as 'FullName',
u.UserName,
c.Body,m.SatNetName
from Users u 
inner join Comments c on c.UserId=u.UserID 
join SatNet m on m.MovieID=c.MovieId

--Outer join
use Northwind

--Left outer Join
select calisan.FirstName as '�al��an',mudur.FirstName as 'M�d�r' from Employees calisan left outer join Employees mudur on calisan.ReportsTo=mudur.EmployeeID

--Right outer Join
select calisan.FirstName as '�al��an',mudur.FirstName as 'M�d�r' from Employees calisan right outer join Employees mudur on calisan.ReportsTo=mudur.EmployeeID

--cross join
select calisan.FirstName as '�al��an',mudur.FirstName as 'M�d�r' from Employees calisan cross join Employees mudur