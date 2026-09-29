SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Cta_Cte_Hou_Bdp_Out
--select * from Cta_Cte_Hou_Bdp_Out where convert(datetime, Dt_Ins_HBO,103) > '2019-01-01'
--select * from Cta_Cte_Hou_Bdp_Out where num_proc_HBO = 'BOARC201810001BR'
--[spATL_Cta_Cte_HBO_Sel]'BOARC201810001BR','','','A'
CREATE PROCEDURE [dbo].[spATL_Cta_Cte_HBO_Sel]--'EAATL201902022BR','','','A'
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
		CC.Num_Proc_HBO						[JOB],
		CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
		(case when CXA.Num_Lcto = 'REMESSA' then
			CXA.Num_Rcb_HIA
		else
			isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
		CC.Cd_Tp_Tx							[Charge Type Code],
		TT.Nome_Tp_Tx						[Charge Type Name],			
		CC.DC_HBO							[D/C Code],
		TDC.Descricao_TP_DC					[D/C Name],
		CC.Cd_Cred_Dev_HBO					[Creditor/Debitor Code],
		PS.Apelido							[Creditor/Debitor Name],
		CC.Cd_Tp_Moeda						[Currency Code],
		TM.Nome_Tp_moeda					[Currency Name],
		CC.Vlr_Org_HBO						[Value],
		convert(datetime, CC.Dt_Ins_HBO,103) [Register Date],					
		convert(datetime, CC.Dt_Prev_Pgto_HBO,103) [Prevision Date],
		CC.Num_DCN_HBO						[Invoice],
		CC.Org_Ins_HBO						[Departament],
		CC.Num_NF_HBO						[Nota Fiscal],
		CC.Desp_Org_HBO						[Origin],
		CC.CPMF_HBO							[CPMF],
		CC.Comp_RP_HBO						[Comp_RP],
		CC.Comp_DN_HBO						[Comp_DN],
		CC.Comp_CN_HBO						[Comp_CN],
		CC.Comp_CPA_HBO						[Comp_CPA],
		dbo.[FBusca_UltimaFatura](CC.num_proc_HBO,CC.dc_HBO,CC.cd_tp_tx) [Invoice Number],		
		max(AX.ID_AX)						[ID_AX],
		vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
		,CC.Dt_Ctb_CC_HBO					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HBO				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HBO					[Vlr_Pgto_NF],
		CC.Par_NF_HBO						[Par_NF],
		CC.Comp_Job_HBO						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC			
	FROM Cta_Cte_Hou_Bdp_Out	CC with(nolock) 
		left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left join Tipo_dc		TDC with(nolock) on CC.DC_HBO = TDC.Cd_Tp_DC 
		left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HBO = PS.cd_pes
		left join vwCXAS CXA with(nolock)  on	CC.num_proc_HBO	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HBO	= CXA.dc_HIA
		Left join vwAXDocs AX with(nolock)  on CC.Num_proc_HBO = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HBO = ax.dc
		left join vwFaturasValidas vw on CC.Num_Proc_HBO = vw.num_proc and CC.DC_HBO = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
	WHERE 
		CC.Num_Proc_HBO = @Num_Proc
	GROUP BY
		CC.Num_Proc_HBO,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HBO	
		,CC.Cd_Cred_Dev_HBO,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HBO,CC.Dt_Ins_HBO,CC.Dt_Prev_Pgto_HBO
		,CC.Num_DCN_HBO,CC.Org_Ins_HBO,CC.Num_NF_HBO,CC.Desp_Org_HBO,CC.CPMF_HBO,CC.Comp_RP_HBO,CC.Comp_DN_HBO,CC.Comp_CN_HBO
		,CC.Comp_CPA_HBO,CC.num_proc_HBO,CC.dc_HBO,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
		,		TDC.Descricao_TP_DC
			,CC.Dt_Ctb_CC_HBO,CC.Ref_Acesso_NF_HBO,CC.Vlr_Pgto_NF_HBO,CC.Par_NF_HBO,CC.Comp_Job_HBO,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
	ORDER BY
		1, 2 desc
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_HBO						[JOB],
			CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
			(case when CXA.Num_Lcto = 'REMESSA' then
				CXA.Num_Rcb_HIA
			else
				isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_HBO							[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev_HBO					[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org_HBO						[Value],
			convert(datetime, CC.Dt_Ins_HBO,103) [Register Date],
			convert(datetime, CC.Dt_Prev_Pgto_HBO,103) [Prevision Date],
			CC.Num_DCN_HBO						[Invoice],
			CC.Org_Ins_HBO						[Departament],
			CC.Num_NF_HBO						[Nota Fiscal],
			CC.Desp_Org_HBO						[Origin],
			CC.CPMF_HBO							[CPMF],
			CC.Comp_RP_HBO						[Comp_RP],
			CC.Comp_DN_HBO						[Comp_DN],
			CC.Comp_CN_HBO						[Comp_CN],
			CC.Comp_CPA_HBO						[Comp_CPA],
			dbo.[FBusca_UltimaFatura](CC.num_proc_HBO,CC.dc_HBO,CC.cd_tp_tx) [Invoice Number],		
			max(AX.ID_AX)						[ID_AX],
			vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
			,CC.Dt_Ctb_CC_HBO					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HBO				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HBO					[Vlr_Pgto_NF],
		CC.Par_NF_HBO						[Par_NF],
		CC.Comp_Job_HBO						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC		
		FROM Cta_Cte_Hou_Bdp_Out	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_HBO = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HBO = PS.cd_pes
				left join vwCXAS CXA with(nolock)  on	CC.num_proc_HBO	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HBO	= CXA.dc_HIA
			Left join vwAXDocs AX with(nolock)  on CC.Num_proc_HBO = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HBO = ax.dc
			left join vwFaturasValidas vw on CC.Num_Proc_HBO = vw.num_proc and CC.DC_HBO = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
		WHERE 
			CC.Num_Proc_HBO = @Num_Proc and 
			CC.Cd_tp_tx = @Cd_tp_tx and
			CC.DC_HBO = @DC
		GROUP BY
			CC.Num_Proc_HBO,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HBO	
			,CC.Cd_Cred_Dev_HBO,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HBO,CC.Dt_Ins_HBO,CC.Dt_Prev_Pgto_HBO
			,CC.Num_DCN_HBO,CC.Org_Ins_HBO,CC.Num_NF_HBO,CC.Desp_Org_HBO,CC.CPMF_HBO,CC.Comp_RP_HBO,CC.Comp_DN_HBO,CC.Comp_CN_HBO
			,CC.Comp_CPA_HBO,CC.num_proc_HBO,CC.dc_HBO,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
			,		TDC.Descricao_TP_DC
				,CC.Dt_Ctb_CC_HBO,CC.Ref_Acesso_NF_HBO,CC.Vlr_Pgto_NF_HBO,CC.Par_NF_HBO,CC.Comp_Job_HBO,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
		ORDER BY
			1, 2 desc
	End




GO
