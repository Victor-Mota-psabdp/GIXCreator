SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE FUNCTION Hoje
(
@Date		DateTime
)
RETURNS DateTime 
AS  
	BEGIN 
		Declare @Hoje 		DateTime 
		Set @Hoje = Cast(DatePart(yyyy, @Date) as VarChar(4))+ '-'  +  Cast(DatePart(mm, @Date) as VarChar(2)) + '-' +  Cast(DatePart(dd, @Date) as VarChar(2)) 
		Return @Hoje

	END




GO
