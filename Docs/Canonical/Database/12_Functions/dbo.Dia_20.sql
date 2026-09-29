SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[Dia_20]
(
@Data		DateTime
)  
RETURNS DateTime AS  

BEGIN 
Declare @Prevista datetime

	If DAY(@Data) > 20
		Begin
			Set @Prevista = (select(convert(datetime, convert(char(4),Year(getdate())) + '-' + convert(char(2),MONTH(GETDATE())+1) + '-' + '20')))
		end
	Else
		Begin
			Set @Prevista = (select(convert(datetime, convert(char(4),Year(getdate())) + '-' + convert(char(2),MONTH(GETDATE())) + '-' + '20')))
		end
		
	Return @Prevista
END






GO
