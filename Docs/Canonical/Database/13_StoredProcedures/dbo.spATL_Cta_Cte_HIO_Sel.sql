SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Cta_Cte_Hou_Imp_Out
--select * from Cta_Cte_Hou_Imp_Out where convert(datetime, Dt_Ins_HIO,103) > getdate() -120

--select * from Cta_Cte_Hou_Imp_Out where num_proc_HIO = 'IAATL201909003BR'
--[spATL_Cta_Cte_HIO_Sel]'IAATL201909003BR','','','A'
CREATE PROCEDURE [dbo].[spATL_Cta_Cte_HIO_Sel]--'IAATL201909003BR','','','A'
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
		CC.Num_Proc_HIO						[JOB],
		CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
		(case when CXA.Num_Lcto = 'REMESSA' then
			CXA.Num_Rcb_HIA
		else
			isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
		CC.Cd_Tp_Tx							[Charge Type Code],
		TT.Nome_Tp_Tx						[Charge Type Name],			
		CC.DC_HIO							[D/C Code],
		TDC.Descricao_TP_DC					[D/C Name],
		CC.Cd_Cred_Dev_HIO					[Creditor/Debitor Code],
		PS.Apelido							[Creditor/Debitor Name],
		CC.Cd_Tp_Moeda						[Currency Code],
		TM.Nome_Tp_moeda					[Currency Name],
		CC.Vlr_Org_HIO						[Value],
		convert(datetime, CC.Dt_Ins_HIO,103) [Register Date],					
		convert(datetime, CC.Dt_Prev_Pgto_HIO,103) [Prevision Date],
		CC.Num_DCN_HIO						[Invoice],
		CC.Org_Ins_HIO						[Departament],
		CC.Num_NF_HIO						[Nota Fiscal],
		CC.Desp_Org_HIO						[Origin],
		CC.CPMF_HIO							[CPMF],
		CC.Comp_RP_HIO						[Comp_RP],
		CC.Comp_DN_HIO						[Comp_DN],
		CC.Comp_CN_HIO						[Comp_CN],
		CC.Comp_CPA_HIO						[Comp_CPA],
		dbo.[FBusca_UltimaFatura](CC.num_proc_HIO,CC.dc_HIO,CC.cd_tp_tx) [Invoice Number],		
		max(AX.ID_AX)						[ID_AX],
		vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
		,CC.Dt_Ctb_CC_HIO					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HIO				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HIO					[Vlr_Pgto_NF],
		CC.Par_NF_HIO						[Par_NF],
		CC.Comp_Job_HIO						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC			
	FROM Cta_Cte_Hou_Imp_Out	CC with(nolock) 
		left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_HIO = TDC.Cd_Tp_DC 
		left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HIO = PS.cd_pes
		left join vwCXAS CXA with(nolock)  on	CC.num_proc_HIO	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HIO	= CXA.dc_HIA
		Left join vwAXDocs AX with(nolock)  on CC.Num_proc_HIO = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HIO = ax.dc
		left join vwFaturasValidas vw on CC.Num_Proc_HIO = vw.num_proc and CC.DC_HIO = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
	WHERE 
		CC.Num_Proc_HIO = @Num_Proc
	GROUP BY
		CC.Num_Proc_HIO,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HIO	
		,CC.Cd_Cred_Dev_HIO,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HIO,CC.Dt_Ins_HIO,CC.Dt_Prev_Pgto_HIO
		,CC.Num_DCN_HIO,CC.Org_Ins_HIO,CC.Num_NF_HIO,CC.Desp_Org_HIO,CC.CPMF_HIO,CC.Comp_RP_HIO,CC.Comp_DN_HIO,CC.Comp_CN_HIO
		,CC.Comp_CPA_HIO,CC.num_proc_HIO,CC.dc_HIO,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
		,TDC.Descricao_TP_DC
		,CC.Dt_Ctb_CC_HIO,CC.Ref_Acesso_NF_HIO,CC.Vlr_Pgto_NF_HIO,CC.Par_NF_HIO,CC.Comp_Job_HIO,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
	ORDER BY
		1, 2 desc
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			CC.Num_Proc_HIO						[JOB],
			CXA.Dt_Pgto_Rcto_HIA				[Accounting Status],
			(case when CXA.Num_Lcto = 'REMESSA' then
				CXA.Num_Rcb_HIA
			else
				isnull(CXA.Num_Lcto,'Open') end) [Financial Status],		
			CC.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			CC.DC_HIO							[D/C Code],
		TDC.Descricao_TP_DC					[D/C Name],
			CC.Cd_Cred_Dev_HIO					[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			CC.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			CC.Vlr_Org_HIO						[Value],
			convert(datetime, CC.Dt_Ins_HIO,103) [Register Date],
			convert(datetime, CC.Dt_Prev_Pgto_HIO,103) [Prevision Date],
			CC.Num_DCN_HIO						[Invoice],
			CC.Org_Ins_HIO						[Departament],
			CC.Num_NF_HIO						[Nota Fiscal],
			CC.Desp_Org_HIO						[Origin],
			CC.CPMF_HIO							[CPMF],
			CC.Comp_RP_HIO						[Comp_RP],
			CC.Comp_DN_HIO						[Comp_DN],
			CC.Comp_CN_HIO						[Comp_CN],
			CC.Comp_CPA_HIO						[Comp_CPA],
			dbo.[FBusca_UltimaFatura](CC.num_proc_HIO,CC.dc_HIO,CC.cd_tp_tx) [Invoice Number],		
			max(AX.ID_AX)						[ID_AX],
			vw.FatVendorInvoiceNumber			[Vendor/Agent Invoice]
				
			,CC.Dt_Ctb_CC_HIO					[Dt_Ctb_CC],
		CC.Ref_Acesso_NF_HIO				[Ref_Acesso_NF],
		CC.Vlr_Pgto_NF_HIO					[Vlr_Pgto_NF],
		CC.Par_NF_HIO						[Par_NF],
		CC.Comp_Job_HIO						[Comp_Job],
		CC.Contab							[Contab],
		CC.Vlr_Contab						[Vlr_Contab],
		CC.Contab_Ant						[Contab_Ant],
		CC.Vlr_Contab_Ant					[Vlr_Contab_Ant],
		CC.Contab_Mes_Ano					[Contab_Mes_Ano],
		CC.Val_Con_Comp						[Val_Con_Comp]
		--CC.IC		
		FROM Cta_Cte_Hou_Imp_Out	CC with(nolock) 
			left Join Tipo_Taxa		TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_dc		TDC with(nolock) on CC.DC_HIO = TDC.Cd_Tp_DC 
			left join Pessoa		PS with(nolock) on CC.cd_cred_dev_HIO = PS.cd_pes
				left join vwCXAS CXA with(nolock)  on	CC.num_proc_HIO	= CXA.num_proc_HIA and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HIO	= CXA.dc_HIA
			Left join vwAXDocs AX with(nolock)  on CC.Num_proc_HIO = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HIO = ax.dc
			left join vwFaturasValidas vw on CC.Num_Proc_HIO = vw.num_proc and CC.DC_HIO = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
		WHERE 
			CC.Num_Proc_HIO = @Num_Proc and 
			CC.Cd_tp_tx = @Cd_tp_tx and
			CC.DC_HIO = @DC
		GROUP BY
			CC.Num_Proc_HIO,CXA.Dt_Pgto_Rcto_HIA,CXA.Num_Lcto,CXA.Num_Rcb_HIA,CXA.Num_Lcto,CC.Cd_Tp_Tx,TT.Nome_Tp_Tx,CC.DC_HIO	
			,CC.Cd_Cred_Dev_HIO,PS.Apelido,CC.Cd_Tp_Moeda,TM.Nome_Tp_moeda,CC.Vlr_Org_HIO,CC.Dt_Ins_HIO,CC.Dt_Prev_Pgto_HIO
			,CC.Num_DCN_HIO,CC.Org_Ins_HIO,CC.Num_NF_HIO,CC.Desp_Org_HIO,CC.CPMF_HIO,CC.Comp_RP_HIO,CC.Comp_DN_HIO,CC.Comp_CN_HIO
			,CC.Comp_CPA_HIO,CC.num_proc_HIO,CC.dc_HIO,CC.cd_tp_tx,vw.FatVendorInvoiceNumber
			,TDC.Descricao_TP_DC
			,CC.Dt_Ctb_CC_HIO,CC.Ref_Acesso_NF_HIO,CC.Vlr_Pgto_NF_HIO,CC.Par_NF_HIO,CC.Comp_Job_HIO,
		CC.Contab,CC.Vlr_Contab,CC.Contab_Ant,CC.Vlr_Contab_Ant,CC.Contab_Mes_Ano,CC.Val_Con_Comp
		ORDER BY
			1, 2 desc
	End




GO
