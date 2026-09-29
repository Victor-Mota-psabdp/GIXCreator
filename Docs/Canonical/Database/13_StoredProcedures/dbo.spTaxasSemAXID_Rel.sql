SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spTaxasSemAXID_Rel --'2022-01-01','2022-01-31'
	@StartDate datetime,
	@EndDate Datetime
as

select 
	PP.Apelido Cliente
	,cta.Num_Proc_HIA
	,c.DATA [Saida ou Chegada]
	,year(convert(datetime,cta.dt_ins_hia,105)) Ano
	,convert(datetime,cta.Dt_Ins_HIA,105) [Data de Criação]
	,credor.Apelido [Credor / Devedor]
	,TT.Nome_Tp_Tx [Nome de Taxa]
	,Cta.Cd_Tp_Moeda [Moeda]
	,Cta.Vlr_Org_HIA [Valor]
from 
	vwcta_cte cta
	Left Join  [dbo].[vwAXDocs_ALL] AX on AX.num_proc=cta.Num_Proc_HIA and ax.cd_tp_tx_Atl=cta.Cd_Tp_Tx and ax.dc=cta.dc_hia and dt_canc is null
	Join vwCliente C on C.num_proc=cta.Num_Proc_HIA
	join pessoa pp on pp.cd_pes=c.cd_cliente
	Join pessoa credor on credor.cd_pes = cta.Cd_Cred_Dev_HIA
	Join Tipo_taxa TT on tt.cd_tp_tx=Cta.Cd_Tp_Tx
where 
	Desp_Org_HIA='N' 
	and ax.dc is null
	and convert(datetime,cta.Dt_Ins_HIA,105) between @StartDate and @EndDate
GO
