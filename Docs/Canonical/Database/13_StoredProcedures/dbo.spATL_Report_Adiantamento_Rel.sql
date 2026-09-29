SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Report_Adiantamento_Rel]--[dbo].[spATL_Report_Adiantamento_Rel] '2013-11-30'
	@Data	Datetime
AS

select 
	Cta.num_proc_hia [BDP Ref.],
	PP.cd_pes [Customer Code - ATL],
	PP.nome_Raz_soc [Customer Name],
	P.Cd_AX [Customer Code - AX],
	convert(Datetime,dt_ins_hia,105) [Issued Dt],
	convert(datetime,dt_prev_pgto_hia,105) [Due Dt],
	'BRL'  [Currency],
	dbo.valor(Vlr_org_hia,cta.dc_hia) [Value],
	TT.nome_tp_tx [Name TX],
	cxa.num_lcto [Num. Cx],
	AD.id_Ax [AX DOC]
from 
	vwcta_cte cta
	Left Join vwcxas CXA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia and convert(Datetime,dt_pgto_Rcto_hia,105) <=@Data
	join tipo_taxa TT on TT.cd_tp_tx = CTA.cd_tp_tx
	Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia	
	Join Pessoa_ATL_AX P on P.cd_pes=PP.cd_pes and TIpo='C'
	Left Join vwAXDocs AD with(nolock) on Cta.Num_Proc_HIA = AD.num_proc and Cta.Cd_Tp_Tx = AD.cd_tp_tx_Atl and Cta.DC_HIA = AD.dc 
where 
	cxa.num_lcto is null
	and desp_org_hia='N'
	and cta.dc_hia = 'C'
	and convert(datetime,dt_ins_hia,105) >='01-01-2010'
	and convert(datetime,dt_ins_hia,105)<=@Data	
	and nome_tp_tx like 'adiant%'



GO
