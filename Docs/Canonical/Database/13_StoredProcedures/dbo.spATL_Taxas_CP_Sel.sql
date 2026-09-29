SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from taxas_cp
--sp_help Taxas_CP
CREATE procedure [dbo].[spATL_Taxas_CP_Sel](
	@CD_TP_MODAL	varchar(2),
	@Cd_Tp_Carga	varchar(1),
	@Cd_Tp_Moeda	varchar(3),
	@Cd_Tp_Tx		varchar(3),
	@Tipo			char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'  OR @Tipo = 'B'
	Begin
		select 
			TCP.cd_tp_tx		[Charge Type Code],
			TT.Nome_Tp_tx		[Charge Type Name],	
			tcp.Modal			[Modal Type Code], 
			tmie.Nome_TP_MODAL	[Modal Type Name],
			TCP.Cd_Tp_Carga		[Cargo Type Code],
			TC.Nome_Tp_Carga	[Cargo Type Name],
			Vlr_Taxa			[Value],
			TCP.Moeda			[Currency Type Code],
			tm.nome_Tp_moeda	[Currency Type Name],
			TCP.IVA				[IVA]
		from 
			Taxas_CP TCP
			left join tipo_taxa TT	on TT.cd_tp_tx = TCP.CD_Tp_Tx collate Latin1_General_CI_AI
			left join tipo_moeda TM	on TM.Cd_Tp_Moeda = TCP.Moeda collate Latin1_General_CI_AI
			left join Tipo_Modal_Imp_Exp TMIE	on TMIE.CD_TP_MODAL = TCP.Modal collate Latin1_General_CI_AI
			left join Tipo_Carga TC	on TC.Cd_Tp_Carga = TCP.Cd_Tp_Carga collate Latin1_General_CI_AI
		where 
			TCP.Modal collate Latin1_General_CI_AI = @CD_TP_MODAL
			and TCP.cd_Tp_Carga = @Cd_Tp_Carga
	
	End

if @Tipo = 'C'  OR @Tipo = 'D'
	Begin
		select 
			TCP.cd_tp_tx		[Charge Type Code],
			TT.Nome_Tp_tx		[Charge Type Name],	
			tcp.Modal			[Modal Type Code], 
			tmie.Nome_TP_MODAL	[Modal Type Name],
			TCP.Cd_Tp_Carga		[Cargo Type Code],
			TC.Nome_Tp_Carga	[Cargo Type Name],
			Vlr_Taxa			[Value],
			TCP.Moeda			[Currency Type Code],
			tm.nome_Tp_moeda	[Currency Type Name],
			TCP.IVA				[IVA]
		from 
			Taxas_CP TCP
			left join tipo_taxa TT	on TT.cd_tp_tx = TCP.CD_Tp_Tx collate Latin1_General_CI_AI
			left join tipo_moeda TM	on TM.Cd_Tp_Moeda = TCP.Moeda collate Latin1_General_CI_AI
			left join Tipo_Modal_Imp_Exp TMIE	on TMIE.CD_TP_MODAL = TCP.Modal collate Latin1_General_CI_AI
			left join Tipo_Carga TC	on TC.Cd_Tp_Carga = TCP.Cd_Tp_Carga collate Latin1_General_CI_AI
		where 
			TCP.Modal collate Latin1_General_CI_AI = @CD_TP_MODAL
			and TCP.cd_Tp_Carga = @Cd_Tp_Carga	
			and tcp.Cd_Tp_Tx = @Cd_Tp_Tx
	End
	
if @Tipo = 'N'  OR @Tipo = 'O'
	Begin
		select 
			TCP.cd_tp_tx		[Charge Type Code],
			TT.Nome_Tp_tx		[Charge Type Name],	
			tcp.Modal			[Modal Type Code], 
			tmie.Nome_TP_MODAL	[Modal Type Name],
			TCP.Cd_Tp_Carga		[Cargo Type Code],
			TC.Nome_Tp_Carga	[Cargo Type Name],
			Vlr_Taxa			[Value],
			TCP.Moeda			[Currency Type Code],
			tm.nome_Tp_moeda	[Currency Type Name],
			TCP.IVA				[IVA]
		from 
			Taxas_CP TCP
			left join tipo_taxa TT	on TT.cd_tp_tx = TCP.CD_Tp_Tx collate Latin1_General_CI_AI
			left join tipo_moeda TM	on TM.Cd_Tp_Moeda = TCP.Moeda collate Latin1_General_CI_AI
			left join Tipo_Modal_Imp_Exp TMIE	on TMIE.CD_TP_MODAL = TCP.Modal collate Latin1_General_CI_AI
			left join Tipo_Carga TC	on TC.Cd_Tp_Carga = TCP.Cd_Tp_Carga collate Latin1_General_CI_AI
		where 
			TCP.Modal collate Latin1_General_CI_AI = @CD_TP_MODAL
			and TCP.cd_Tp_Carga = @Cd_Tp_Carga
			and tcp.Cd_Tp_Tx = @Cd_Tp_Tx	
			AND TCP.Moeda = @Cd_Tp_Moeda
			
	End
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		select 
--			Cd_Tp_Tx			[Code],
--			Nome_Tp_Tx			[Type of Tax],
--			Nome_Tp_Tx			[Charge Type Name],
--			Tipo_DC				[DC Type],
--			DC.Descricao_TP_DC	[DC Type Name],
--			TT.cd_cta_ctb_atv	[Cost of Services Code],
--			ATV.Nome_Cta_Ctb	[Cost of Services Name],
--			TT.Cd_Tp_Tx_Ofc		[Official Code],			
--			Nome_Tp_Tx_Ing		[Charge Type English Name],
--			TT.ND_Tx			[Modal Type Code],
--			TMT.Modal_Type_Name	[Modal Type Name],
--			TT.cd_cta_ctb_pas	[Revenue Account Code],
--			PAS.Nome_Cta_Ctb	[Revenue Account Name],
		
--			TT.CD_AX_Resultado		[AX Resultado Code],
--			TTS.descricao_ingles	[AX Resultado Name],
--			TT.Cd_AX_Repasse		[AX Repasse Code],
--			TTP.descricao_ingles	[AX Repasse Name],
--			TT.Tipo_Prod_Code		[BDP Product Code],
--			BP.Nome_BDP_Produto		[BDP Product Name],
--			TT.Repasse_Tx			[Repasse],
--			TT.IRRF_Tx				[IRRF],
--			TT.Rateio_Tx			[Ratio],
--			TT.CPMF_Tx				[IVA/CPMF],
--			TT.Pft_Aer				[Profit],
--			TT.NF					[NF],
--			TT.Rentabilidade		[Profitability],
--			TT.Desat_Tx				[Disable]			
--		from Tipo_Taxa TT with(nolock)
--			left join Cta_Ctb ATV with(nolock) on ATV.Cd_Cta_Ctb= TT.cd_cta_ctb_atv
--			left join vwTipo_Modal_Taxa TMT with(nolock) on TMT.Code= TT.ND_Tx
--			left join Cta_Ctb PAS with(nolock) on PAS.Cd_Cta_Ctb= TT.cd_cta_ctb_pas
--			left join tipo_taxa_ax TTS with(nolock) on TT.cd_ax_Resultado= TTS.cd_charge_ax
--			left join tipo_taxa_ax TTP with(nolock) on TT.cd_ax_Repasse= TTP.cd_charge_ax
--			left join BDP_Produto BP with(nolock) on BP.ID_PD= TT.Tipo_Prod_Code
--			left join Tipo_DC DC with(nolock) on DC.Cd_Tp_DC= TT.Tipo_DC	
--		where 
--			Nome_Tp_Tx = @Nome_Tp_Tx AND Cd_Tp_Tx <> @Cd_Tp_Tx
--	End

GO
