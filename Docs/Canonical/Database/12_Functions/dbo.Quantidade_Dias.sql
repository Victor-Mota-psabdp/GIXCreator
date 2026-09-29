SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[Quantidade_Dias]
(
@Data		DateTime,
@DataFinal	Datetime
)  
RETURNS Int AS  
BEGIN 
	--SET DATEFIRST 7 
	Declare @DataTemp Datetime
	Declare @Dia	int
	Declare @Week	int
	Set @week=0
	Set @Dia=1
	Set @DataTemp=@Data+1

	While @DataFinal > @DataTemp
		Begin
			Set @week=(select DATEPART(dw,@DataTemp))
			if @week<>1 and @week<>7 
				Begin
					if not exists(select * from feriados_Nacionais where data=@Data)
						Begin
							Set @Dia=@Dia+1
						End
				END
			Set @DataTemp=@DataTemp+1
		END
		
	Return @Dia
END








GO
