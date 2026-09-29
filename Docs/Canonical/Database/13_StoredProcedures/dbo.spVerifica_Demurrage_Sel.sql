SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spVerifica_Demurrage_Sel]--''IMCSR201112219BRA'

	@FatCod varchar(17)
as

	select 
		Processo			
	from demurrage_ATL DEM
	Where 
		DEM.processo=left(@FatCod,16) and 
		DEM.fatura=right(@FatCod,1)
GO
