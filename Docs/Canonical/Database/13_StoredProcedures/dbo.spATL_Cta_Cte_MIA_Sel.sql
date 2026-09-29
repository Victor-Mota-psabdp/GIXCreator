SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Cta_Cte_MIA_Sel]
(
	@Num_Proc_Master		Varchar(14),
	@Cd_tp_tx	varchar(3),
	@DC			varchar(1),
	@Tipo		char(1)
)

AS

if @Tipo = 'A' or @Tipo = 'B'
	Begin	
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_MIA						[JOB],
			CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
			(case when CXA.Num_Lcto = 'REMESSA' then
				CXA.Num_Rcb_HIA
			else
				isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_MIA							[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev_MIA					[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org_MIA						[Value],
			convert(datetime, CC.Dt_Ins_MIA,103) [Register Date],					
			convert(datetime, CC.Dt_Prev_Pgto_MIA,103) [Prevision Date],
			CC.Num_DCN_MIA						[Invoice],
			CC.Org_Ins_MIA						[Departament],
			CC.Num_NF_MIA						[Nota Fiscal],
			CC.Desp_Org_MIA						[Origin],
			CC.CPMF_MIA							[CPMF],
			CC.Comp_RP_MIA						[Comp_RP],
			CC.Comp_DN_MIA						[Comp_DN],
			CC.Comp_CN_MIA						[Comp_CN],
			CC.Comp_CPA_MIA						[Comp_CPA],
			AX.ID_AX							[ID_AX],				
				
			CC.Ref_Acesso_NF_MIA				[Ref_Acesso_NF],
			CC.Vlr_Pgto_NF_MIA					[Vlr_Pgto_NF],
			CC.Par_NF_MIA						[Par_NF],			
			CC.Contab							[Contab],
			CC.Vlr_Contab						[Vlr_Contab],
			CC.Contab_Ant						[Contab_Ant],
			CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
			CC.Contab_Mes_Ano					[Contab_Mes_Ano],
			CC.Val_Con_Comp						[Val_Con_Comp]
			--CC.IC	
		FROM Cta_Cte_Mas_Imp_Aer	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_MIA = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev_MIA = PS.cd_pes
			left join vwCXAS CXA with(nolock)  on	CC.num_proc_MIA	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_MIA	= CXA.dc_HIA
			Left join vwAXDocs AX on CC.Num_proc_MIA = AX.NumeroInternoAX  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_MIA = ax.dc
		WHERE 
			CC.Num_Proc_MIA = @Num_Proc_Master	
		ORDER BY
			1, 2 desc
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_MIA						[JOB],
			CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
			(case when CXA.Num_Lcto = 'REMESSA' then
				CXA.Num_Rcb_HIA
			else
				isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_MIA							[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev_MIA					[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org_MIA						[Value],
			convert(datetime, CC.Dt_Ins_MIA,103) [Register Date],					
			convert(datetime, CC.Dt_Prev_Pgto_MIA,103) [Prevision Date],
			CC.Num_DCN_MIA						[Invoice],
			CC.Org_Ins_MIA						[Departament],
			CC.Num_NF_MIA						[Nota Fiscal],
			CC.Desp_Org_MIA						[Origin],
			CC.CPMF_MIA							[CPMF],
			CC.Comp_RP_MIA						[Comp_RP],
			CC.Comp_DN_MIA						[Comp_DN],
			CC.Comp_CN_MIA						[Comp_CN],
			CC.Comp_CPA_MIA						[Comp_CPA],
			AX.ID_AX							[ID_AX],				
				
			CC.Ref_Acesso_NF_MIA				[Ref_Acesso_NF],
			CC.Vlr_Pgto_NF_MIA					[Vlr_Pgto_NF],
			CC.Par_NF_MIA						[Par_NF],			
			CC.Contab							[Contab],
			CC.Vlr_Contab						[Vlr_Contab],
			CC.Contab_Ant						[Contab_Ant],
			CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
			CC.Contab_Mes_Ano					[Contab_Mes_Ano],
			CC.Val_Con_Comp						[Val_Con_Comp]
			--CC.IC	
		FROM Cta_Cte_Mas_Imp_Aer	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_MIA = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev_MIA = PS.cd_pes
			left join vwCXAS CXA with(nolock)  on	CC.num_proc_MIA	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_MIA	= CXA.dc_HIA
			Left join vwAXDocs AX on CC.Num_proc_MIA = AX.NumeroInternoAX  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_MIA = ax.dc
		WHERE 
			CC.Num_Proc_MIA = @Num_Proc_Master and 
			CC.Cd_tp_tx = @Cd_tp_tx and
			CC.DC_MIA = @DC
		ORDER BY
			1, 2 desc	
	End



GO
