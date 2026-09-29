SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Cta_Cte_Hou_Imp_Aer
--select * from Cta_Cte_Hou_Imp_Mar where convert(datetime, Dt_Ins_HIM,103) > getdate() -30
--[spATL_Cta_Cte_HIM_Sel]'IMATL202109003BR','','','A'
CREATE PROCEDURE [dbo].[spATL_Cta_Cte_HIM_Sel]--'IMATL202109003BR','','','A'
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
		CC.Num_Proc_HIM						[JOB],
		CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
		(case when CXA.Num_Lcto = 'REMESSA' then
			CXA.Num_Rcb_HIA
		else
			isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
		CC.Cd_Tp_Tx							[Charge Type Code],
		TT.Nome_Tp_Tx						[Charge Type Name],			
		CC.DC_HIM							[D/C Code],
		TDC.Descricao_TP_DC					[D/C Name],
		CC.Cd_Cred_Dev_HIM					[Creditor/Debitor Code],
		PS.Apelido							[Creditor/Debitor Name],
		CC.Cd_Tp_Moeda						[Currency Code],
		TM.Nome_Tp_moeda					[Currency Name],
		CC.Vlr_Org_HIM						[Value],
		convert(datetime, CC.Dt_Ins_HIM,103) [Register Date],					
		convert(datetime, CC.Dt_Prev_Pgto_HIM,103) [Prevision Date],
		CC.Num_DCN_HIM						[Invoice],
		CC.Org_Ins_HIM						[Departament],
		CC.Num_NF_HIM						[Nota Fiscal],
		CC.Desp_Org_HIM						[Origin],
		CC.CPMF_HIM							[CPMF],
		CC.Comp_RP_HIM						[Comp_RP],
		CC.Comp_DN_HIM						[Comp_DN],
		CC.Comp_CN_HIM						[Comp_CN],
		CC.Comp_CPA_HIM						[Comp_CPA],
		dbo.[FBusca_UltimaFatura](CC.num_proc_him,CC.dc_him,CC.cd_tp_tx) [Invoice Number],		
		max(AX.ID_AX)						[ID_AX],
		vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
		,CC.Dt_Ctb_CC_HIM					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HIM				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HIM					[Vlr_Pgto_NF],
		CC.Par_NF_HIM						[Par_NF],
		CC.Comp_Job_HIM						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC		
	FROM Cta_Cte_Hou_Imp_Mar	CC with(nolock) 
		left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left join Tipo_dc		TDC with(nolock) on CC.DC_HIM = TDC.Cd_Tp_DC 
		left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HIM = PS.cd_pes
		left join vwCXAS CXA with(nolock)  on	CC.num_proc_him	= CXA.num_proc_hia and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_him	= CXA.dc_hia
		Left join vwAXDocs AX with(nolock)  on CC.Num_proc_him = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_him = ax.dc
		left join vwFaturasValidas vw on CC.Num_Proc_HIM = vw.num_proc and CC.DC_HIM = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
	WHERE 
		CC.Num_Proc_HIM = @Num_Proc
	GROUP BY
		CC.Num_Proc_HIM,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HIM	
		,CC.Cd_Cred_Dev_HIM,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HIM,CC.Dt_Ins_HIM,CC.Dt_Prev_Pgto_HIM
		,CC.Num_DCN_HIM,CC.Org_Ins_HIM,CC.Num_NF_HIM,CC.Desp_Org_HIM,CC.CPMF_HIM,CC.Comp_RP_HIM,CC.Comp_DN_HIM,CC.Comp_CN_HIM
		,CC.Comp_CPA_HIM,CC.num_proc_him,CC.dc_him,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
		,TDC.Descricao_TP_DC	
		,CC.Dt_Ctb_CC_HIM,CC.Ref_Acesso_NF_HIM,CC.Vlr_Pgto_NF_HIM,CC.Par_NF_HIM,CC.Comp_Job_HIM,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
	ORDER BY
		1, 2 desc
End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_HIM						[JOB],
			CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
			(case when CXA.Num_Lcto = 'REMESSA' then
				CXA.Num_Rcb_HIA
			else
				isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_HIM							[D/C Code],
		TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev_HIM					[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org_HIM						[Value],
			convert(datetime, CC.Dt_Ins_HIM,103) [Register Date],
			convert(datetime, CC.Dt_Prev_Pgto_HIM,103) [Prevision Date],
			CC.Num_DCN_HIM						[Invoice],
			CC.Org_Ins_HIM						[Departament],
			CC.Num_NF_HIM						[Nota Fiscal],
			CC.Desp_Org_HIM						[Origin],
			CC.CPMF_HIM							[CPMF],
			CC.Comp_RP_HIM						[Comp_RP],
			CC.Comp_DN_HIM						[Comp_DN],
			CC.Comp_CN_HIM						[Comp_CN],
			CC.Comp_CPA_HIM						[Comp_CPA],
			dbo.[FBusca_UltimaFatura](CC.num_proc_him,CC.dc_him,CC.cd_tp_tx) [Invoice Number],		
			max(AX.ID_AX)						[ID_AX],
			vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
			,CC.Dt_Ctb_CC_HIM					[Dt_Ctb_CC],
			CC.Ref_Acesso_NF_HIM				[Ref_Acesso_NF],
			CC.Vlr_Pgto_NF_HIM					[Vlr_Pgto_NF],
			CC.Par_NF_HIM						[Par_NF],
			CC.Comp_Job_HIM						[Comp_Job],
			CC.Contab							[Contab],
			CC.Vlr_Contab						[Vlr_Contab],
			CC.Contab_Ant						[Contab_Ant],
			CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
			CC.Contab_Mes_Ano					[Contab_Mes_Ano],
			CC.Val_Con_Comp						[Val_Con_Comp]
			--CC.IC		
		FROM Cta_Cte_Hou_Imp_Mar	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_HIM = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HIM = PS.cd_pes
			left join vwCXAS CXA with(nolock)  on	CC.num_proc_him	= CXA.num_proc_hia and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_him	= CXA.dc_hia
			Left join vwAXDocs AX with(nolock)  on CC.Num_proc_him = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_him = ax.dc
			left join vwFaturasValidas vw on CC.Num_Proc_HIM = vw.num_proc and CC.DC_HIM = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
		WHERE 
			CC.Num_Proc_HIM = @Num_Proc and 
			CC.Cd_tp_tx = @Cd_tp_tx and
			CC.DC_HIM = @DC
		GROUP BY
			CC.Num_Proc_HIM,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HIM	
			,CC.Cd_Cred_Dev_HIM,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HIM,CC.Dt_Ins_HIM,CC.Dt_Prev_Pgto_HIM
			,CC.Num_DCN_HIM,CC.Org_Ins_HIM,CC.Num_NF_HIM,CC.Desp_Org_HIM,CC.CPMF_HIM,CC.Comp_RP_HIM,CC.Comp_DN_HIM,CC.Comp_CN_HIM
			,CC.Comp_CPA_HIM,CC.num_proc_him,CC.dc_him,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
			,TDC.Descricao_TP_DC
			,CC.Dt_Ctb_CC_HIM,CC.Ref_Acesso_NF_HIM,CC.Vlr_Pgto_NF_HIM,CC.Par_NF_HIM,CC.Comp_Job_HIM,
			CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
		ORDER BY
			1, 2 desc
	End




GO
