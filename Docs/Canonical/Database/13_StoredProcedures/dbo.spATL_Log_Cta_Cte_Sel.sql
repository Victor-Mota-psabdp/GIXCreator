SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Log_Cta_Cte
CREATE PROCEDURE [dbo].[spATL_Log_Cta_Cte_Sel]--'IMATL202109003BR','','','A'
(
	@Num_Proc_CC	VarChar(16),
	@Cd_tp_tx	varchar(3),
	@DC_CC			varchar(1),
	@Tipo		char(1)
)

AS

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_CC						[JOB],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_CC								[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev						[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org							[Value],
			--convert(datetime, CC.Dt_Ins,103)	[Register Date],					
			--convert(datetime, CC.Dt_Prev_Pgto,103) [Prevision Date],
			CC.Dt_Ins						[Register Date],					
			 CC.Dt_Prev_Pgto				[Prevision Date],	
			CC.Org_Ins						[Departament],
			CC.Desp_Org_Dst						[Origin],
			CC.CPMF							[CPMF],
			CC.Comp_RP						[Comp_RP],
			CC.Comp_DN						[Comp_DN],
			CC.Comp_CN						[Comp_CN],
			CC.Comp_CPA						[Comp_CPA],	
			CC.Contab						[Contab],
			CC.Vlr_Contab					[Vlr_Contab],
			CC.Contab_Ant					[Contab_Ant],	
			CC.Cointab_Mes_Ano				[Contab_Mes_Ano]
		FROM Log_Cta_Cte	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_CC = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev = PS.cd_pes
			left join Tipo_Log_Oper	TL with(nolock) on CC.Tp_Oper_CC = TL.Cd_Tp_Log_Oper
	WHERE 
		CC.Num_Proc_CC = @Num_Proc_CC
	ORDER BY
		1, 2 desc
End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_CC						[JOB],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_CC								[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev						[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org							[Value],
			--convert(datetime, CC.Dt_Ins,103)	[Register Date],					
			--convert(datetime, CC.Dt_Prev_Pgto,103) [Prevision Date],
			CC.Dt_Ins						[Register Date],					
			 CC.Dt_Prev_Pgto				[Prevision Date],	
			CC.Org_Ins						[Departament],
			CC.Desp_Org_Dst						[Origin],
			CC.CPMF							[CPMF],
			CC.Comp_RP						[Comp_RP],
			CC.Comp_DN						[Comp_DN],
			CC.Comp_CN						[Comp_CN],
			CC.Comp_CPA						[Comp_CPA],	
			CC.Contab						[Contab],
			CC.Vlr_Contab					[Vlr_Contab],
			CC.Contab_Ant					[Contab_Ant],	
			CC.Cointab_Mes_Ano				[Contab_Mes_Ano]
		FROM Log_Cta_Cte	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_CC = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev = PS.cd_pes
			left join Tipo_Log_Oper	TL with(nolock) on CC.Tp_Oper_CC = TL.Cd_Tp_Log_Oper
		WHERE 
			CC.Num_Proc_CC = @Num_Proc_CC and 
			CC.Cd_tp_tx = @Cd_tp_tx and
			CC.DC_CC = @DC_CC	
		ORDER BY
			1, 2 desc
	End




GO
