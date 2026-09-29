SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE FUNCTION StrHoje
(
@Date		DateTime
)
RETURNS VarChar(10) 
AS  
	BEGIN 
		Declare @Hoje 		VarChar(10)  
		Set @Hoje = Right('0' + Cast(DatePart(dd, @Date) as VarChar(2)), 2) 
		Set @Hoje = @Hoje + '/' + Right('0' + Cast(DatePart(mm, @Date) as VarChar(2)), 2) + '/' 
		Set @Hoje = @Hoje + Cast(DatePart(yyyy, @Date) as VarChar(4))
		Return @Hoje

	END









GO
