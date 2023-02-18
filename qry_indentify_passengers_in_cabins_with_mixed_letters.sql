select * from  
train 
where cabin in  
      (
            select distinct cabin 
            from    
            train 
            where charindex(' ',cabin,1) > 0 and
		(
			charindex('A',cabin,1) + 
			charindex('B',cabin,1) +
			charindex('C',cabin,1) +
			charindex('D',cabin,1) +
			charindex('E',cabin,1) +
			charindex('F',cabin,1) +
			charindex('O',cabin,1) +
			charindex('G',cabin,1) +
			charindex('T',cabin,1)
		) > 1
	)