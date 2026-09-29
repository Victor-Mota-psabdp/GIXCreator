SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure spATL_ReportVolumePorProduto_Rel-- '07-01-2013','07-31-2013'

	@DataInicial Datetime,
	@DataFinal   Datetime
	
AS

Declare @CHBImport int
Declare @CHBExport int
Declare @AirExport int
Declare @OceanExport int
Declare @AirImport int
Declare @OceanImport int

Set @CHBImport=(select count(*) from tarefas_processos where id_Task=4 and dt_conclusao between @DataInicial and @DataFinal and left(num_proc,1)='I')
Set @CHBExport=(select count(*) from tarefas_processos where id_Task=4 and dt_conclusao between @DataInicial and @DataFinal and left(num_proc,1)='E')
Set @AirExport=(select count(*) from vwcliente where data between @DataInicial and @DataFinal and left(num_proc,2)='EA' and master<>'JOB')
Set @OceanExport=(select count(*) from vwcliente where data between @DataInicial and @DataFinal and left(num_proc,2)='EM' and master<>'JOB')
Set @OceanImport=(select count(*) from vwcliente where data between @DataInicial and @DataFinal and left(num_proc,2)='IM'and master<>'JOB' )
Set @AirImport=(select count(*) from vwcliente where data between @DataInicial and @DataFinal and left(num_proc,2)='IA' and master<>'JOB')


Select  'CHB - Import' Product, @CHBImport Files
Union all
Select  'CHB - Export' Product, @CHBExport Files
Union all
Select  'Ocean Import - Transportation' Product, @OceanImport Files
Union all
Select  'Ocean Export - Transportation' Product, @OceanExport Files

Union all
Select  'Air Import - Transportation' Product, @AirImport Files
Union all
Select  'Air Export - Transportation' Product, @AirExport Files

Union all
Select  'TOTAL' Product, @AirExport+@AirImport+@OceanExport+@OceanImport+@CHBExport+@CHBImport Files


GO
