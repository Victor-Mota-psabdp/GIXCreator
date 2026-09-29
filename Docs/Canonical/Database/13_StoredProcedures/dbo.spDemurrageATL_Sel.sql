SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[spDemurrageATL_Sel]--'IMATL201701001BRB'
	@Fatura Char(17)

as

select 
	Processo,Processo+Fatura Fat, Apelido Importador, Atracacao, 
	Vencimento, Moeda, Valor, Desconto, Desc_Obs, HBL,Tipo, Dt_Emis, Navio,dem.Paridade,
	--T.Status_Descricao,
	(CASE WHEN cxa.Num_Lcto IS Not null then 'Closed' 
		else
	(Case when F.FatCod IS null then 'Invoice Canceled'
		else
		T.Status_Descricao	
	END) END) [Status_Descricao]		
from demurrage_ATL DEM
	left join Tipo_Status_Demurrage T on T.ID_Status = DEM.ID_Status
	left join vwFaturasValidas F on F.Fatcod = DEM.processo + DEM.fatura
	Left Join vwCXAS CXA with (nolock) on F.num_proc=CXA.num_proc_HIA and F.cd_tp_tx=CXA.cd_tp_tx and F.dc=cxa.DC_HIA
Where 
	DEM.processo=left(@Fatura,16) and 
	DEM.fatura=right(@Fatura,1)




GO
