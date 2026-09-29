SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create function [dbo].[fBusca_Data_vwFaturasValidas]
(
	@Num_Proc	varchar(16)
)
RETURNS datetime

AS

BEGIN
	Declare @Resultado datetime
				SET @Resultado =(
							select 
								top 1 isnull(fatdtemissao,fatdtvenc) 
							from 
								vwFaturasValidas  
							where  
								Num_Proc=@Num_Proc order by 1 desc)

	RETURN @Resultado
END


GO
