SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION fLastDayMonth 
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

	if left(@Periodo, 2) = 12 
		Begin 
			Set @Ano = @Ano + 1 
			Set @Ret = '01/01/' + Cast(@Ano as Varchar(4))
		End 
	Else
		Begin 
			Set @Mes = @Mes + 1 
			Set @Ret = '01/' + Cast(@Mes as VarChar(2))  + '/' + Cast(@Ano as VArchar(4))
		End 
	Set @retdt =  Convert(Datetime, @Ret, 105) 
	Set @retdt = DateAdd(day, -1, @retdt)
	Return @retdt
END



GO
