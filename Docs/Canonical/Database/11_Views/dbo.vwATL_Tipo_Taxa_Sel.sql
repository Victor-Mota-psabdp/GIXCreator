SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Taxa
CREATE VIEW [dbo].[vwATL_Tipo_Taxa_Sel]
AS
select 
	Cd_Tp_Tx			[Code],
	Nome_Tp_Tx			[Type of Tax],
	Nome_Tp_Tx			[Charge Type Name],
	Tipo_DC				[DC Type],
	DC.Descricao_TP_DC	[DC Type Name],
	TT.cd_cta_ctb_atv	[Cost of Services Code],
	ATV.Nome_Cta_Ctb	[Cost of Services Name],
	TT.Cd_Tp_Tx_Ofc		[Official Code],			
	Nome_Tp_Tx_Ing		[Charge Type English Name],
	TT.ND_Tx			[Modal Type Code],
	TMT.Modal_Type_Name	[Modal Type Name],
	TT.cd_cta_ctb_pas	[Revenue Account Code],
	PAS.Nome_Cta_Ctb	[Revenue Account Name],

	TT.CD_AX_Resultado		[AX Resultado Code],
	TTS.descricao_ingles	[AX Resultado Name],
	TT.Cd_AX_Repasse		[AX Repasse Code],
	TTP.descricao_ingles	[AX Repasse Name],
	TT.Tipo_Prod_Code		[BDP Product Code],
	BP.Nome_BDP_Produto		[BDP Product Name],
	TT.Repasse_Tx			[Repasse],
	TT.IRRF_Tx				[IRRF],
	TT.Rateio_Tx			[Ratio],
	TT.CPMF_Tx				[IVA/CPMF],
	TT.Pft_Aer				[Profit],
	TT.NF					[NF],
	TT.Rentabilidade		[Profitability],
	TT.Desat_Tx				[Disable]			
from Tipo_Taxa TT with(nolock)
	left join Cta_Ctb ATV with(nolock) on ATV.Cd_Cta_Ctb= TT.cd_cta_ctb_atv
	left join vwTipo_Modal_Taxa TMT with(nolock) on TMT.Code= TT.ND_Tx
	left join Cta_Ctb PAS with(nolock) on PAS.Cd_Cta_Ctb= TT.cd_cta_ctb_pas
	left join tipo_taxa_ax TTS with(nolock) on TT.cd_ax_Resultado= TTS.cd_charge_ax
	left join tipo_taxa_ax TTP with(nolock) on TT.cd_ax_Repasse= TTP.cd_charge_ax
	left join BDP_Produto BP with(nolock) on BP.ID_PD= TT.Tipo_Prod_Code
	left join Tipo_DC DC with(nolock) on DC.Cd_Tp_DC= TT.Tipo_DC			
where
	Desat_Tx ='N'




GO
