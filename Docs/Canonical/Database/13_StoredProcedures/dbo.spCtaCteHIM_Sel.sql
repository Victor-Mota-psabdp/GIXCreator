SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	PROCEDURE [dbo].[spCtaCteHIM_Sel]

	@Processo 	varchar(16)

AS
	SELECT
		TT.Nome_tp_tx 		TAXA,
		CC.DC_HIM 			DC,
		PS.apelido 			PESSOA,
		TM.nome_tp_moeda 	MOEDA,
		vlr_org_HIM 		VALOR,
		dt_prev_pgto_HIM 	PREVISTA,
		Dt_Ins_HIM 			INSERCAO,
		Comp_CPA_HIM 		CPA,
		Num_DCN_HIM 		INVOICE, 
		Org_Ins_HIM 		DEPART,
		CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,
		--CXA.Num_Lcto		NUM_LCTO,
		(case when CXA.Num_Lcto = 'REMESSA' then
			Num_Rcb_HIA
		else
			CXA.Num_Lcto end)	NUM_LCTO,	
		CC.Num_NF_HIM 		NF,
		Desp_Org_HIM		ORIGIN,
		CPMF_HIM			CPMF,
		Comp_RP_HIM			RP,
		Comp_DN_HIM			DN,
		Comp_CN_HIM			CN,
		Comp_CPA_HIM		CPA,
		Isnull(Vlr_Contab, Vlr_Contab_Ant)	Vlr_Contab,
		--(Select max(FatCod) from item_Fat FAT where FAT.Num_Proc = CC.num_proc_him and FAT.cd_tp_tx = CC.cd_tp_tx and FAT.DC = CC.dc_him and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')) UltimaFatura,
		dbo.[FBusca_UltimaFatura](CC.num_proc_him,CC.dc_him,CC.cd_tp_tx) UltimaFatura,
		-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
		--ID_AX	
		 max(ID_AX) as ID_AX,
		 --Alessandra 19/05/2021 - AX10
		 vw.FatVendorInvoiceNumber
	FROM
		Cta_Cte_Hou_Imp_Mar CC with(nolock) 
		left Join Tipo_Taxa TT with(nolock) 	on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_moeda TM with(nolock)  on CC.cd_tp_moeda = TM.cd_tp_moeda
		left join pessoa PS with(nolock) 	on CC.cd_cred_dev_HIM = PS.cd_pes
		left join vwCXAS CXA with(nolock)  on	CC.num_proc_him	= CXA.num_proc_hia and CC.cd_tp_tx	= CXA.cd_tp_tx and	CC.dc_him	= CXA.dc_hia
		Left join vwAXDocs AX with(nolock)  on CC.Num_proc_him = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_him = ax.dc
		--Alessandra 19/05/2021 - AX10
		left join vwFaturasValidas vw on CC.Num_Proc_HIM = vw.num_proc and CC.DC_HIM = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
	WHERE 
		CC.Num_Proc_HIM = @Processo
	-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
	GROUP BY
		TT.Nome_tp_tx
		,CC.DC_HIM
		,PS.apelido
		,TM.nome_tp_moeda
		,vlr_org_HIM
		,dt_prev_pgto_HIM
		,Dt_Ins_HIM
		,Comp_CPA_HIM
		,Num_DCN_HIM 
		,Org_Ins_HIM
		,CXA.Dt_Pgto_Rcto_HIA
		,(case when CXA.Num_Lcto = 'REMESSA' then
			Num_Rcb_HIA
		else
			CXA.Num_Lcto end)
		,CC.Num_NF_HIM
		,Desp_Org_HIM
		,CPMF_HIM
		,Comp_RP_HIM
		,Comp_DN_HIM
		,Comp_CN_HIM
		,Comp_CPA_HIM
		,Isnull(Vlr_Contab, Vlr_Contab_Ant)
		,dbo.[FBusca_UltimaFatura](CC.num_proc_him,CC.dc_him,CC.cd_tp_tx)
		,vw.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
	ORDER BY
		1, 2 desc





GO
