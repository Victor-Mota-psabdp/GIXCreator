SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Cta_Cte_Hou_Exp_Aer
--select * from Cta_Cte_Hou_Exp_Aer where convert(datetime, Dt_Ins_HEA,103) > '2019-01-01'

--select * from Cta_Cte_Hou_Exp_Aer where num_proc_HEA = 'EAATL201902022BR'
--[spATL_Cta_Cte_HEA_Sel]'EAATL201902022BR','','','A'
CREATE PROCEDURE [dbo].[spATL_Cta_Cte_HEA_Sel]--'EAATL201902022BR','','','A'
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
		CC.Num_Proc_HEA						[JOB],
		CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
		(case when CXA.Num_Lcto = 'REMESSA' then
			CXA.Num_Rcb_HIA
		else
			isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
		CC.Cd_Tp_Tx							[Charge Type Code],
		TT.Nome_Tp_Tx						[Charge Type Name],			
		CC.DC_HEA							[D/C Code],
		TDC.Descricao_TP_DC					[D/C Name],
		CC.Cd_Cred_Dev_HEA					[Creditor/Debitor Code],
		PS.Apelido							[Creditor/Debitor Name],
		CC.Cd_Tp_Moeda						[Currency Code],
		TM.Nome_Tp_moeda					[Currency Name],
		CC.Vlr_Org_HEA						[Value],
		convert(datetime, CC.Dt_Ins_HEA,103) [Register Date],					
		convert(datetime, CC.Dt_Prev_Pgto_HEA,103) [Prevision Date],
		CC.Num_DCN_HEA						[Invoice],
		CC.Org_Ins_HEA						[Departament],
		CC.Num_NF_HEA						[Nota Fiscal],
		CC.Desp_Dst_HEA						[Origin],
		CC.CPMF_HEA							[CPMF],
		CC.Comp_RP_HEA						[Comp_RP],
		CC.Comp_DN_HEA						[Comp_DN],
		CC.Comp_CN_HEA						[Comp_CN],
		CC.Comp_CPA_HEA						[Comp_CPA],
		dbo.[FBusca_UltimaFatura](CC.num_proc_HEA,CC.dc_HEA,CC.cd_tp_tx) [Invoice Number],		
		max(AX.ID_AX)						[ID_AX],
		vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
		,CC.Dt_Ctb_CC_HEA					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HEA				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HEA					[Vlr_Pgto_NF],
		CC.Par_NF_HEA						[Par_NF],
		CC.Comp_Job_HEA						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC	
	FROM Cta_Cte_Hou_Exp_Aer	CC with(nolock) 
		left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left join Tipo_dc		TDC with(nolock) on CC.DC_HEA = TDC.Cd_Tp_DC 
		left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HEA = PS.cd_pes
		left join vwCXAS CXA with(nolock)  on	CC.num_proc_HEA	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HEA	= CXA.dc_HIA
		Left join vwAXDocs AX with(nolock)  on CC.Num_proc_HEA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HEA = ax.dc
		left join vwFaturasValidas vw on CC.Num_Proc_HEA = vw.num_proc and CC.DC_HEA = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
	WHERE 
		CC.Num_Proc_HEA = @Num_Proc
	GROUP BY
		CC.Num_Proc_HEA,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HEA	
		,CC.Cd_Cred_Dev_HEA,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HEA,CC.Dt_Ins_HEA,CC.Dt_Prev_Pgto_HEA
		,CC.Num_DCN_HEA,CC.Org_Ins_HEA,CC.Num_NF_HEA,CC.Desp_Dst_HEA,CC.CPMF_HEA,CC.Comp_RP_HEA,CC.Comp_DN_HEA,CC.Comp_CN_HEA
		,CC.Comp_CPA_HEA,CC.num_proc_HEA,CC.dc_HEA,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
		,TDC.Descricao_TP_DC
			,CC.Dt_Ctb_CC_HEA,CC.Ref_Acesso_NF_HEA,CC.Vlr_Pgto_NF_HEA,CC.Par_NF_HEA,CC.Comp_Job_HEA,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
	ORDER BY
		1, 2 desc
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_HEA						[JOB],
			CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
			(case when CXA.Num_Lcto = 'REMESSA' then
				CXA.Num_Rcb_HIA
			else
				isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_HEA							[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev_HEA					[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org_HEA						[Value],
			convert(datetime, CC.Dt_Ins_HEA,103) [Register Date],
			convert(datetime, CC.Dt_Prev_Pgto_HEA,103) [Prevision Date],
			CC.Num_DCN_HEA						[Invoice],
			CC.Org_Ins_HEA						[Departament],
			CC.Num_NF_HEA						[Nota Fiscal],
			CC.Desp_Dst_HEA						[Origin],
			CC.CPMF_HEA							[CPMF],
			CC.Comp_RP_HEA						[Comp_RP],
			CC.Comp_DN_HEA						[Comp_DN],
			CC.Comp_CN_HEA						[Comp_CN],
			CC.Comp_CPA_HEA						[Comp_CPA],
			dbo.[FBusca_UltimaFatura](CC.num_proc_HEA,CC.dc_HEA,CC.cd_tp_tx) [Invoice Number],		
			max(AX.ID_AX)						[ID_AX],
			vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
			,CC.Dt_Ctb_CC_HEA					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HEA				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HEA					[Vlr_Pgto_NF],
		CC.Par_NF_HEA						[Par_NF],
		CC.Comp_Job_HEA						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC	
		FROM Cta_Cte_Hou_Exp_Aer	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_HEA = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HEA = PS.cd_pes
				left join vwCXAS CXA with(nolock)  on	CC.num_proc_HEA	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HEA	= CXA.dc_HIA
			Left join vwAXDocs AX with(nolock)  on CC.Num_proc_HEA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HEA = ax.dc
			left join vwFaturasValidas vw on CC.Num_Proc_HEA = vw.num_proc and CC.DC_HEA = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
		WHERE 
			CC.Num_Proc_HEA = @Num_Proc and 
			CC.Cd_tp_tx = @Cd_tp_tx and
			CC.DC_HEA = @DC
		GROUP BY
			CC.Num_Proc_HEA,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HEA	
			,CC.Cd_Cred_Dev_HEA,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HEA,CC.Dt_Ins_HEA,CC.Dt_Prev_Pgto_HEA
			,CC.Num_DCN_HEA,CC.Org_Ins_HEA,CC.Num_NF_HEA,CC.Desp_Dst_HEA,CC.CPMF_HEA,CC.Comp_RP_HEA,CC.Comp_DN_HEA,CC.Comp_CN_HEA
			,CC.Comp_CPA_HEA,CC.num_proc_HEA,CC.dc_HEA,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
			,TDC.Descricao_TP_DC
				,CC.Dt_Ctb_CC_HEA,CC.Ref_Acesso_NF_HEA,CC.Vlr_Pgto_NF_HEA,CC.Par_NF_HEA,CC.Comp_Job_HEA,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
		ORDER BY
			1, 2 desc
	End




GO
