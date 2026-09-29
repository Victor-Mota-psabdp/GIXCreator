SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE	PROCEDURE [dbo].[spCtaCteHEO_Sel]

	@Processo 	varchar(16),
	@Tipo		char(1)

AS
	
	SELECT
		TT.Nome_tp_tx 		TAXA,
		CC.DC_HEO 			DC,
		PS.apelido 			PESSOA,
		TM.nome_tp_moeda 	MOEDA,
		vlr_org_HEO 		VALOR,
		dt_prev_pgto_HEO 	PREVISTA,
		Dt_Ins_HEO 			INSERCAO,
		Comp_CPA_HEO 		CPA,
		Num_DCN_HEO 		INVOICE, 
		Org_Ins_HEO 		DEPART,
		CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,
		CXA.Num_Lcto		NUM_LCTO,
		CC.Num_NF_HEO 		NF,
		Desp_Org_HEO		ORIGIN,
		CPMF_HEO			CPMF,
		Comp_RP_HEO			RP,
		Comp_DN_HEO			DN,
		Comp_CN_HEO			CN,
		Comp_CPA_HEO		CPA,
		Isnull(Vlr_Contab, Vlr_Contab_Ant)	Vlr_Contab,
		--(Select max(FatCod) from item_Fat FAT where FAT.Num_Proc = CC.num_proc_heo and FAT.cd_tp_tx = CC.cd_tp_tx and FAT.DC = CC.dc_heo and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')) UltimaFatura,
		dbo.[FBusca_UltimaFatura](CC.num_proc_heo,CC.dc_heo,CC.cd_tp_tx) UltimaFatura,
		-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
		--ID_AX	
		 max(ID_AX) as ID_AX
		 --Alessandra 19/05/2021 - AX10
		 ,vw.FatVendorInvoiceNumber
	FROM
		Cta_Cte_Hou_EXP_OUT CC with(nolock)
		Left Outer Join LLP_EXP_OUT LLP with(nolock)	on @Processo = LLP.Num_Proc_LEO 
		Left Outer Join Tipo_Taxa TT with(nolock)	on CC.cd_tp_tx = TT.cd_tp_tx
		Left Outer join Tipo_moeda TM with(nolock) 	on CC.cd_tp_moeda = TM.cd_tp_moeda
		Left Outer join pessoa PS with(nolock)	on CC.cd_cred_dev_HEO = PS.cd_pes
		Left Outer join vwCXAS CXA with(nolock) on CC.num_proc_HEO = CXA.num_proc_HIA	and	CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_HEO = CXA.dc_HIA
		Left join vwAXDocs AX with(nolock) on CC.Num_proc_heo = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_heo = ax.dc
		--Alessandra 19/05/2021 - AX10
		left join vwFaturasValidas vw on CC.Num_Proc_HEO = vw.num_proc and CC.DC_HEO = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
	WHERE
		CC.Num_Proc_HEO = @Processo and LLP.Tipo_Leo=@Tipo
	-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
GROUP BY 
		TT.Nome_tp_tx 
		,CC.DC_HEO 
		,PS.apelido 
		,TM.nome_tp_moeda 
		,vlr_org_HEO
		,dt_prev_pgto_HEO
		,Dt_Ins_HEO
		,Comp_CPA_HEO
		,Num_DCN_HEO
		,Org_Ins_HEO
		,CXA.Dt_Pgto_Rcto_HIA
		,CXA.Num_Lcto
		,CC.Num_NF_HEO
		,Desp_Org_HEO
		,CPMF_HEO	
		,Comp_RP_HEO
		,Comp_DN_HEO
		,Comp_CN_HEO	
		,Comp_CPA_HEO
		,Isnull(Vlr_Contab, Vlr_Contab_Ant)	
		,dbo.[FBusca_UltimaFatura](CC.num_proc_heo,CC.dc_heo,CC.cd_tp_tx) 
		,vw.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
	ORDER BY
		1, 2 desc





GO
