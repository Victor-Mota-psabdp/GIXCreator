SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--select [dbo].[Dias_Uteis]('06-18-2014',2)
CREATE FUNCTION [dbo].[Dias_Uteis]
(
@Data		DateTime,
@Dias		Int
)  
RETURNS DateTime AS  
BEGIN 
	--SET DATEFIRST 7 
	Declare @IntUteis int
	declare @week int
	declare @Feriados int
	
	
	
	Set @IntUteis=0
	Set @Week=0
	While @IntUteis<@Dias
		Begin
			Set @Data=@Data+1
			Set @Week=(select DATEPART(dw,@data))
			if @Week<>6 and @Week<>7 
				Begin
					if exists(select * from feriados_Nacionais where data=@Data)
						Begin
							Set @IntUteis=@IntUteis+1
						End
				END
			
		END
	Return @Data
END


GO
