DECLARE @DateOfBirth DATE = '2023/01/02',        
        @CurrentDate DATE = GETDATE();  

SELECT CurrentAge = (CONVERT(INT, CONVERT(CHAR(8), @CurrentDate, 112))
                      -  CONVERT(INT, COnVERT(CHAR(8), @DateofBirth, 112))      
                     ) / 10000;   