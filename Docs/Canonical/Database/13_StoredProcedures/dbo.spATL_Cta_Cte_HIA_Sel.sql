SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Cta_Cte_Hou_Imp_Aer
--select * from Cta_Cte_Hou_Imp_Aer where convert(datetime, Dt_Ins_HIA,103) > getdate() -120

--select * from Cta_Cte_Hou_Imp_Aer where num_proc_hia = 'IAATL201909003BR'
CREATE PROCEDURE [dbo].[spATL_Cta_Cte_HIA_Sel]--'IAATL201909003BR','','','A'
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
		CC.Num_Proc_HIA						[JOB],
		CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
		(case when CXA.Num_Lcto = 'REMESSA' then
			CXA.Num_Rcb_HIA
		else
			isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
		CC.Cd_Tp_Tx							[Charge Type Code],
		TT.Nome_Tp_Tx						[Charge Type Name],			
		CC.DC_HIA							[D/C Code],
		TDC.Descricao_TP_DC					[D/C Name],
		CC.Cd_Cred_Dev_HIA					[Creditor/Debitor Code],
		PS.Apelido							[Creditor/Debitor Name],
		CC.Cd_Tp_Moeda						[Currency Code],
		TM.Nome_Tp_moeda					[Currency Name],
		CC.Vlr_Org_HIA						[Value],
		convert(datetime, CC.Dt_Ins_HIA,103) [Register Date],					
		convert(datetime, CC.Dt_Prev_Pgto_HIA,103) [Prevision Date],
		CC.Num_DCN_HIA						[Invoice],
		CC.Org_Ins_HIA						[Departament],
		CC.Num_NF_HIA						[Nota Fiscal],
		CC.Desp_Org_HIA						[Origin],
		CC.CPMF_HIA							[CPMF],
		CC.Comp_RP_HIA						[Comp_RP],
		CC.Comp_DN_HIA						[Comp_DN],
		CC.Comp_CN_HIA						[Comp_CN],
		CC.Comp_CPA_HIA						[Comp_CPA],
		dbo.[FBusca_UltimaFatura](CC.num_proc_HIA,CC.dc_HIA,CC.cd_tp_tx) [Invoice Number],		
		max(AX.ID_AX)						[ID_AX],
		vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
		,CC.Dt_Ctb_CC_HIA					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HIA				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HIA					[Vlr_Pgto_NF],
		CC.Par_NF_HIA						[Par_NF],
		CC.Comp_Job_HIA						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC			
	FROM Cta_Cte_Hou_Imp_Aer	CC with(nolock) 
		left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left join Tipo_dc		TDC with(nolock) on CC.DC_HIA = TDC.Cd_Tp_DC
		left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HIA = PS.cd_pes
		left join vwCXAS CXA with(nolock)  on	CC.num_proc_HIA	= CXA.num_proc_hia and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HIA	= CXA.dc_hia
		Left join vwAXDocs AX with(nolock)  on CC.Num_proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HIA = ax.dc
		left join vwFaturasValidas vw on CC.Num_Proc_HIA = vw.num_proc and CC.DC_HIA = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
	WHERE 
		CC.Num_Proc_HIA = @Num_Proc
	GROUP BY
		CC.Num_Proc_HIA,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HIA	
		,CC.Cd_Cred_Dev_HIA,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HIA,CC.Dt_Ins_HIA,CC.Dt_Prev_Pgto_HIA
		,CC.Num_DCN_HIA,CC.Org_Ins_HIA,CC.Num_NF_HIA,CC.Desp_Org_HIA,CC.CPMF_HIA,CC.Comp_RP_HIA,CC.Comp_DN_HIA,CC.Comp_CN_HIA
		,CC.Comp_CPA_HIA,CC.num_proc_HIA,CC.dc_HIA,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
		,TDC.Descricao_TP_DC
		,CC.Dt_Ctb_CC_HIA,CC.Ref_Acesso_NF_HIA,CC.Vlr_Pgto_NF_HIA,CC.Par_NF_HIA,CC.Comp_Job_HIA,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
	ORDER BY
		1, 2 desc
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_HIA						[JOB],
			CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
			(case when CXA.Num_Lcto = 'REMESSA' then
				CXA.Num_Rcb_HIA
			else
				isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_HIA							[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev_HIA					[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org_HIA						[Value],
			convert(datetime, CC.Dt_Ins_HIA,103) [Register Date],
			convert(datetime, CC.Dt_Prev_Pgto_HIA,103) [Prevision Date],
			CC.Num_DCN_HIA						[Invoice],
			CC.Org_Ins_HIA						[Departament],
			CC.Num_NF_HIA						[Nota Fiscal],
			CC.Desp_Org_HIA						[Origin],
			CC.CPMF_HIA							[CPMF],
			CC.Comp_RP_HIA						[Comp_RP],
			CC.Comp_DN_HIA						[Comp_DN],
			CC.Comp_CN_HIA						[Comp_CN],
			CC.Comp_CPA_HIA						[Comp_CPA],
			dbo.[FBusca_UltimaFatura](CC.num_proc_HIA,CC.dc_HIA,CC.cd_tp_tx) [Invoice Number],		
			max(AX.ID_AX)						[ID_AX],
			vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
			,CC.Dt_Ctb_CC_HIA					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HIA				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HIA					[Vlr_Pgto_NF],
		CC.Par_NF_HIA						[Par_NF],
		CC.Comp_Job_HIA						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC		
		FROM Cta_Cte_Hou_Imp_Aer	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_HIA = TDC.Cd_Tp_DC
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HIA = PS.cd_pes
			left join vwCXAS CXA with(nolock)  on	CC.num_proc_HIA	= CXA.num_proc_hia and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HIA	= CXA.dc_hia
			Left join vwAXDocs AX with(nolock)  on CC.Num_proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HIA = ax.dc
			left join vwFaturasValidas vw on CC.Num_Proc_HIA = vw.num_proc and CC.DC_HIA = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
		WHERE 
			CC.Num_Proc_HIA = @Num_Proc and 
			CC.Cd_tp_tx = @Cd_tp_tx and
			CC.DC_HIA = @DC
		GROUP BY
			CC.Num_Proc_HIA,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HIA	
			,CC.Cd_Cred_Dev_HIA,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HIA,CC.Dt_Ins_HIA,CC.Dt_Prev_Pgto_HIA
			,CC.Num_DCN_HIA,CC.Org_Ins_HIA,CC.Num_NF_HIA,CC.Desp_Org_HIA,CC.CPMF_HIA,CC.Comp_RP_HIA,CC.Comp_DN_HIA,CC.Comp_CN_HIA
			,CC.Comp_CPA_HIA,CC.num_proc_HIA,CC.dc_HIA,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
			,TDC.Descricao_TP_DC
			,CC.Dt_Ctb_CC_HIA,CC.Ref_Acesso_NF_HIA,CC.Vlr_Pgto_NF_HIA,CC.Par_NF_HIA,CC.Comp_Job_HIA,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
		ORDER BY
			1, 2 desc
	End




GO
