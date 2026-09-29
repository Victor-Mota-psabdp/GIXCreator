SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Metrics]
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as
	
if @Grupo = 'GRUPO DOW' or @grupo = 'GRUPO ROHM & HAAS' or @grupo = 'GRUPO Styron' 
	or @grupo = 'GRUPO BC QUIMICA' or @grupo = 'GRUPO BLUE CUBE'
	BEGIN
		exec [dbo].[spATL_MetricsKPI_DOW] @Grupo, @DtInicial,@DtFinal

	end
else
	BEGIN
		exec [dbo].[spATL_MetricsKPI_BDP] @Grupo, @DtInicial,@DtFinal 
	END
	
GO
