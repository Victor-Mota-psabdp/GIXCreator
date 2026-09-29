SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION fFirstDayMonth 
(
@Periodo	Varchar(7)
)  
RETURNS DateTime AS  
BEGIN 
	Declare @ret 	varchar(10) 
	Declare @retdt 	Datetime 
	Declare @Mes 	Int 
	Declare @Ano	Int 
	Set @Mes = Cast(Left(@Periodo, 2) as Integer) 
	Set @Ano = Cast(Right(@Periodo, 4) as Integer) 

	Set @Ret = '01/' + Cast(@Mes as VarChar(2))  + '/' + Cast(@Ano as VArchar(4))

	Set @retdt =  Convert(Datetime, @Ret, 105) 

	Return @retdt
END




GO
