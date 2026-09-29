SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Cta_Cte_Hou_Exp_Out
--select * from Cta_Cte_Hou_Exp_Out where convert(datetime, Dt_Ins_HEO,103) > '2019-01-01'

--select * from Cta_Cte_Hou_Exp_Out where num_proc_HEO = 'IOCSR201910140BR'
--[spATL_Cta_Cte_HEO_Sel]'EOATL201908001BR','','','A'
CREATE PROCEDURE [dbo].[spATL_Cta_Cte_HEO_Sel]--'EOATL201908001BR','','','A'
(
	@Num_Proc	VarChar(16),
	@Cd_tp_tx	varchar(3),
	@DC			varchar(1),
	@Tipo		char(1)
)

AS

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT
		'Saved'								[Status],
		CC.Num_Proc_HEO						[JOB],
		CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
		(case when CXA.Num_Lcto = 'REMESSA' then
			CXA.Num_Rcb_HIA
		else
			isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
		CC.Cd_Tp_Tx							[Charge Type Code],
		TT.Nome_Tp_Tx						[Charge Type Name],			
		CC.DC_HEO							[D/C Code],
		TDC.Descricao_TP_DC					[D/C Name],
		CC.Cd_Cred_Dev_HEO					[Creditor/Debitor Code],
		PS.Apelido							[Creditor/Debitor Name],
		CC.Cd_Tp_Moeda						[Currency Code],
		TM.Nome_Tp_moeda					[Currency Name],
		CC.Vlr_Org_HEO						[Value],
		convert(datetime, CC.Dt_Ins_HEO,103) [Register Date],					
		convert(datetime, CC.Dt_Prev_Pgto_HEO,103) [Prevision Date],
		CC.Num_DCN_HEO						[Invoice],
		CC.Org_Ins_HEO						[Departament],
		CC.Num_NF_HEO						[Nota Fiscal],
		CC.Desp_Org_HEO						[Origin],
		CC.CPMF_HEO							[CPMF],
		CC.Comp_RP_HEO						[Comp_RP],
		CC.Comp_DN_HEO						[Comp_DN],
		CC.Comp_CN_HEO						[Comp_CN],
		CC.Comp_CPA_HEO						[Comp_CPA],
		dbo.[FBusca_UltimaFatura](CC.num_proc_HEO,CC.dc_HEO,CC.cd_tp_tx) [Invoice Number],		
		max(AX.ID_AX)						[ID_AX],
		vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
		,CC.Dt_Ctb_CC_HEO					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HEO				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HEO					[Vlr_Pgto_NF],
		CC.Par_NF_HEO						[Par_NF],
		CC.Comp_Job_HEO						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC		
	FROM Cta_Cte_Hou_Exp_Out	CC with(nolock) 
		left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left join Tipo_dc		TDC with(nolock) on CC.DC_HEO = TDC.Cd_Tp_DC 
		left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HEO = PS.cd_pes
		left join vwCXAS CXA with(nolock)  on	CC.num_proc_HEO	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HEO	= CXA.dc_HIA
		Left join vwAXDocs AX with(nolock)  on CC.Num_proc_HEO = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HEO = ax.dc
		left join vwFaturasValidas vw on CC.Num_Proc_HEO = vw.num_proc and CC.DC_HEO = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
	WHERE 
		CC.Num_Proc_HEO = @Num_Proc
	GROUP BY
		CC.Num_Proc_HEO,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HEO	
		,CC.Cd_Cred_Dev_HEO,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HEO,CC.Dt_Ins_HEO,CC.Dt_Prev_Pgto_HEO
		,CC.Num_DCN_HEO,CC.Org_Ins_HEO,CC.Num_NF_HEO,CC.Desp_Org_HEO,CC.CPMF_HEO,CC.Comp_RP_HEO,CC.Comp_DN_HEO,CC.Comp_CN_HEO
		,CC.Comp_CPA_HEO,CC.num_proc_HEO,CC.dc_HEO,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
		,TDC.Descricao_TP_DC
			,CC.Dt_Ctb_CC_HEO,CC.Ref_Acesso_NF_HEO,CC.Vlr_Pgto_NF_HEO,CC.Par_NF_HEO,CC.Comp_Job_HEO,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
	ORDER BY
		1, 2 desc
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_HEO						[JOB],
			CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
			(case when CXA.Num_Lcto = 'REMESSA' then
				CXA.Num_Rcb_HIA
			else
				isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_HEO							[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev_HEO					[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org_HEO						[Value],
			convert(datetime, CC.Dt_Ins_HEO,103) [Register Date],
			convert(datetime, CC.Dt_Prev_Pgto_HEO,103) [Prevision Date],
			CC.Num_DCN_HEO						[Invoice],
			CC.Org_Ins_HEO						[Departament],
			CC.Num_NF_HEO						[Nota Fiscal],
			CC.Desp_Org_HEO						[Origin],
			CC.CPMF_HEO							[CPMF],
			CC.Comp_RP_HEO						[Comp_RP],
			CC.Comp_DN_HEO						[Comp_DN],
			CC.Comp_CN_HEO						[Comp_CN],
			CC.Comp_CPA_HEO						[Comp_CPA],
			dbo.[FBusca_UltimaFatura](CC.num_proc_HEO,CC.dc_HEO,CC.cd_tp_tx) [Invoice Number],		
			max(AX.ID_AX)						[ID_AX],
			vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
			,CC.Dt_Ctb_CC_HEO					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HEO				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HEO					[Vlr_Pgto_NF],
		CC.Par_NF_HEO						[Par_NF],
		CC.Comp_Job_HEO						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC		
		FROM Cta_Cte_Hou_Exp_Out	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_HEO = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HEO = PS.cd_pes
				left join vwCXAS CXA with(nolock)  on	CC.num_proc_HEO	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HEO	= CXA.dc_HIA
			Left join vwAXDocs AX with(nolock)  on CC.Num_proc_HEO = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HEO = ax.dc
			left join vwFaturasValidas vw on CC.Num_Proc_HEO = vw.num_proc and CC.DC_HEO = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
		WHERE 
			CC.Num_Proc_HEO = @Num_Proc and 
			CC.Cd_tp_tx = @Cd_tp_tx and
			CC.DC_HEO = @DC
		GROUP BY
			CC.Num_Proc_HEO,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HEO	
			,CC.Cd_Cred_Dev_HEO,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HEO,CC.Dt_Ins_HEO,CC.Dt_Prev_Pgto_HEO
			,CC.Num_DCN_HEO,CC.Org_Ins_HEO,CC.Num_NF_HEO,CC.Desp_Org_HEO,CC.CPMF_HEO,CC.Comp_RP_HEO,CC.Comp_DN_HEO,CC.Comp_CN_HEO
			,CC.Comp_CPA_HEO,CC.num_proc_HEO,CC.dc_HEO,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
			,TDC.Descricao_TP_DC	
				,CC.Dt_Ctb_CC_HEO,CC.Ref_Acesso_NF_HEO,CC.Vlr_Pgto_NF_HEO,CC.Par_NF_HEO,CC.Comp_Job_HEO,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
		ORDER BY
			1, 2 desc
	End




GO
