SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Cta_Cte_MEM_Sel]
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
			CC.Num_Proc_MEM						[JOB],
			CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
			(case when CXA.Num_Lcto = 'REMESSA' then
				CXA.Num_Rcb_HIA
			else
				isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_MEM							[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev_MEM					[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org_MEM						[Value],
			convert(datetime, CC.Dt_Ins_MEM,103) [Register Date],					
			convert(datetime, CC.Dt_Prev_Pgto_MEM,103) [Prevision Date],
			CC.Num_DCN_MEM						[Invoice],
			CC.Org_Ins_MEM						[Departament],
			CC.Num_NF_MEM						[Nota Fiscal],
			CC.Desp_Dst_MEM						[Origin],
			CC.CPMF_MEM							[CPMF],
			CC.Comp_RP_MEM						[Comp_RP],
			CC.Comp_DN_MEM						[Comp_DN],
			CC.Comp_CN_MEM						[Comp_CN],
			CC.Comp_CPA_MEM						[Comp_CPA],
			AX.ID_AX							[ID_AX],				
				
			CC.Ref_Acesso_NF_MEM				[Ref_Acesso_NF],
			CC.Vlr_Pgto_NF_MEM					[Vlr_Pgto_NF],
			CC.Par_NF_MEM						[Par_NF],			
			CC.Contab							[Contab],
			CC.Vlr_Contab						[Vlr_Contab],
			CC.Contab_Ant						[Contab_Ant],
			CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
			CC.Contab_Mes_Ano					[Contab_Mes_Ano],
			CC.Val_Con_Comp						[Val_Con_Comp]
			--CC.IC	
		FROM Cta_Cte_Mas_EXP_Mar	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_MEM = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev_MEM = PS.cd_pes
			left join vwCXAS CXA with(nolock)  on	CC.num_proc_MEM	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_MEM	= CXA.dc_HIA
			Left join vwAXDocs AX on CC.Num_proc_MEM = AX.NumeroInternoAX  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_MEM = ax.dc
		WHERE 
			CC.Num_Proc_MEM = @Num_Proc_Master	
		ORDER BY
			1, 2 desc
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_MEM						[JOB],
			CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
			(case when CXA.Num_Lcto = 'REMESSA' then
				CXA.Num_Rcb_HIA
			else
				isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_MEM							[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev_MEM					[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org_MEM						[Value],
			convert(datetime, CC.Dt_Ins_MEM,103) [Register Date],					
			convert(datetime, CC.Dt_Prev_Pgto_MEM,103) [Prevision Date],
			CC.Num_DCN_MEM						[Invoice],
			CC.Org_Ins_MEM						[Departament],
			CC.Num_NF_MEM						[Nota Fiscal],
			CC.Desp_Dst_MEM						[Origin],
			CC.CPMF_MEM							[CPMF],
			CC.Comp_RP_MEM						[Comp_RP],
			CC.Comp_DN_MEM						[Comp_DN],
			CC.Comp_CN_MEM						[Comp_CN],
			CC.Comp_CPA_MEM						[Comp_CPA],
			AX.ID_AX							[ID_AX],				
				
			CC.Ref_Acesso_NF_MEM				[Ref_Acesso_NF],
			CC.Vlr_Pgto_NF_MEM					[Vlr_Pgto_NF],
			CC.Par_NF_MEM						[Par_NF],			
			CC.Contab							[Contab],
			CC.Vlr_Contab						[Vlr_Contab],
			CC.Contab_Ant						[Contab_Ant],
			CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
			CC.Contab_Mes_Ano					[Contab_Mes_Ano],
			CC.Val_Con_Comp						[Val_Con_Comp]
			--CC.IC	
		FROM Cta_Cte_Mas_EXP_Mar	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_MEM = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev_MEM = PS.cd_pes
			left join vwCXAS CXA with(nolock)  on	CC.num_proc_MEM	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_MEM	= CXA.dc_HIA
			Left join vwAXDocs AX on CC.Num_proc_MEM = AX.NumeroInternoAX  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_MEM = ax.dc
		WHERE 
			CC.Num_Proc_MEM = @Num_Proc_Master and 
			CC.Cd_tp_tx = @Cd_tp_tx and
			CC.DC_MEM = @DC
		ORDER BY
			1, 2 desc	
	End



GO
