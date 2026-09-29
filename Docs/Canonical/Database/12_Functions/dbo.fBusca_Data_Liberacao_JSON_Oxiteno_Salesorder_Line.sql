SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fBusca_Data_Liberacao_JSON_Oxiteno_Salesorder_Line]
(
	@ID_Salesorder BigInt
)
RETURNS datetime 
AS
BEGIN 
	Declare @data datetime		
		Begin			
			set @data = (select max(data_liberacao) from ATL_INT.dbo.JSON_Oxiteno_Salesorder_Line  with(nolock) where ID_Salesorder=@ID_Salesorder)
		End
return @data
	
END


GO
