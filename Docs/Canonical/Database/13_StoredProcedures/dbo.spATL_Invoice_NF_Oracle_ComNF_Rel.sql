SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[spATL_Invoice_NF_Oracle_ComNF_Rel]'','2026-01-01','2026-01-31'
--select top 1 * from vwNF_Fatura_ALL
CREATE procedure [dbo].[spATL_Invoice_NF_Oracle_ComNF_Rel]--'',2026,2
(
	@Grupo Varchar(50),
	@InitialDate Datetime,
	@EndDate Datetime
)
as

If @Grupo is NULL
begin
	set @Grupo = ''
end

select 
	LEFT(HOU.Num_proc,2)			Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)		 [Grupo],
	
	HOU.Num_proc					[JOB],
	CLI.Apelido						[Cliente],
	month(Inv.FatDtEmissao)			[Mês],
	DEV.Num_CPF_CNPJ				[CNPJ], 
	DEV.apelido						[Company], 
	TT.Nome_Tp_Tx					[Taxa],
	CTA.DC_HIA 						[DC], 
	
	Inv.Vlr_Org						[Valor],
	Inv.Paridade					[Paridade],
	Inv.Cd_Tp_Moeda					[Moeda],	
	
	Inv.Vlr_RS						[Valor em Real],
	
	isnull(NF.Ref_Acesso + ' - ' + ST.Nome_Site,'Sem NF') [Site],
	isnull(NF.Nota_Fiscal,'') 		[Nota Fiscal], 
	isnull(NF.RPS_NFE,'') 			[NFe],
	NF.Cd_Status					[Status NF],
	Inv.FatDtEmissao					[Dt. Emissão]
	,Inv.FatCod										[invoice_number]
	,isnull(NFI.RPS_NFE,Inv.FatCod	)				[invoice_numberNF]
from vwNF_Fatura_ALL Inv  with(nolock)
	left join vwcta_Cte CTA with(nolock) on CTA.Num_Proc_HIA = Inv.Num_Proc and CTA.Cd_Tp_Tx = Inv.cd_tp_Tx and CTA.DC_HIA = Inv.DC
	
	Join vwCliente_Alerta		HOU with(nolock) on HOU.num_proc=cta.Num_Proc_HIA
	Join Pessoa					CLI with(nolock) on HOU.cd_cliente=CLI.cd_pes
	left Join Pessoa_LLP		PLLP with(nolock) on HOU.cd_cliente=PLLP.cd_pes
	left Join Pessoa			PP with(nolock)	on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa				TT with(nolock)	on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa					Dev with(nolock) on Inv.Cd_Pes_Fat = Dev.cd_pes
	left Join Base_Nota_Fiscal	NF with(nolock) on CTA.Num_NF_HIA =NF.Nota_Fiscal  and CTA.Ref_Acesso_NF_HIA = NF.Ref_Acesso
	left join Site				ST with(nolock) on CTA.Ref_Acesso_NF_HIA =ST.Cd_Site
	left Join Base_Nota_Fiscal	NFI with(nolock) on INv.FNota_Fiscal =NFI.Nota_Fiscal  and Inv.FRef_Acesso = NFI.Ref_Acesso
Where
	Inv.FatDtEmissao between @InitialDate and @EndDate
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'

union all



select 
	LEFT(HOU.Num_proc,2)			Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)		 [Grupo],
	
	HOU.Num_proc					[JOB],
	CLI.Apelido						[Cliente],
	month(Inv.FatDtEmissao)			[Mês],
	DEV.Num_CPF_CNPJ				[CNPJ], 
	DEV.apelido						[Company], 
	TT.Nome_Tp_Tx					[Taxa],
	CTA.DC_HIA 						[DC], 
	
	ItemFat.Vlr_Org						[Valor],
	ItemFat.Paridade					[Paridade],
	ItemFat.Cd_Tp_Moeda					[Moeda],	
	
	ItemFat.Vlr_RS						[Valor em Real],
	
	isnull(NF.Ref_Acesso + ' - ' + ST.Nome_Site,'Sem NF') [Site],
	isnull(NF.Nota_Fiscal,'') 		[Nota Fiscal], 
	isnull(NF.RPS_NFE,'') 			[NFe],
	NF.Cd_Status						[Status NF],
	Inv.FatDtEmissao				[Dt. Emissão]
	,Inv.FatCod						[invoice_number]
	,Inv.FatCod						[invoice_numberNF]
from Fatura Inv  with(nolock)
	Join Item_Fat ItemFat with(nolock) on ItemFat.FatCod=Inv.FatCOd
	left join vwcta_Cte CTA with(nolock) on CTA.Num_Proc_HIA = ItemFat.Num_Proc and CTA.Cd_Tp_Tx = ItemFat.cd_tp_Tx and CTA.DC_HIA = ItemFat.DC
	left join vwNF_Fatura_ALL NFF with(nolock) on NFF.Num_Proc = ItemFat.Num_Proc and NFF.Cd_Tp_Tx = ItemFat.cd_tp_Tx and NFF.DC = ItemFat.DC
	
	Join vwCliente_Alerta		HOU with(nolock) on HOU.num_proc=cta.Num_Proc_HIA
	Join Pessoa					CLI with(nolock) on HOU.cd_cliente=CLI.cd_pes
	left Join Pessoa_LLP		PLLP with(nolock) on HOU.cd_cliente=PLLP.cd_pes
	left Join Pessoa			PP with(nolock)	on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa				TT with(nolock)	on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa					Dev with(nolock) on Inv.Cd_Pes = Dev.cd_pes
	left Join Base_Nota_Fiscal	NF with(nolock) on CTA.Num_NF_HIA =NF.Nota_Fiscal  and CTA.Ref_Acesso_NF_HIA = NF.Ref_Acesso
	left join Site				ST with(nolock) on CTA.Ref_Acesso_NF_HIA =ST.Cd_Site	
Where
	Inv.FatDtEmissao between @InitialDate and @EndDate
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'
	and NFF.ID is null

Order by 19
	
OPTION(HASH JOIN)




GO
