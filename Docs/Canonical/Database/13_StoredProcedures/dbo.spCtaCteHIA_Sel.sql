SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	PROCEDURE [dbo].[spCtaCteHIA_Sel]

	@Processo 	varchar(16)

AS
	SELECT
		TT.Nome_tp_tx 		TAXA,
		CC.DC_HIA 			DC,
		PS.apelido 			PESSOA,
		TM.nome_tp_moeda 	MOEDA,
		vlr_org_HIA 		VALOR,
		dt_prev_pgto_HIA 	PREVISTA,
		Dt_Ins_HIA 			INSERCAO,
		Comp_CPA_HIA 		CPA,
		Num_DCN_HIA 		INVOICE, 
		Org_Ins_HIA 		DEPART,
		CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,
		--CXA.Num_Lcto		NUM_LCTO,
		(case when CXA.Num_Lcto = 'REMESSA' then
			Num_Rcb_HIA
		else
			CXA.Num_Lcto end)	NUM_LCTO,	
		CC.Num_NF_HIA 		NF,
		Desp_Org_HIA		ORIGIN,
		CPMF_HIA			CPMF,
		Comp_RP_HIA			RP,
		Comp_DN_HIA			DN,
		Comp_CN_HIA			CN,
		Comp_CPA_HIA		CPA,
		Isnull(Vlr_Contab, Vlr_Contab_Ant)	Vlr_Contab,
		--(Select max(FatCod) from item_Fat FAT where FAT.Num_Proc = CC.num_proc_hia and FAT.cd_tp_tx = CC.cd_tp_tx and FAT.DC = CC.dc_hia and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')) UltimaFatura,
		dbo.[FBusca_UltimaFatura](CC.num_proc_hia,CC.dc_hia,CC.cd_tp_tx) UltimaFatura,
		-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
		--ID_AX	
		 max(ID_AX) as ID_AX
		 --Alessandra 19/05/2021 - AX10
		 ,vw.FatVendorInvoiceNumber
	FROM
		Cta_Cte_Hou_Imp_Aer CC	(nolock)
		left Join Tipo_Taxa TT	(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_moeda TM (nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left join pessoa PS		(nolock) on CC.cd_cred_dev_HIA = PS.cd_pes
		Left join vwCXAS CXA	(nolock) on	CC.num_proc_HIA	= CXA.num_proc_HIA and	CC.cd_tp_tx	= CXA.cd_tp_tx	and	CC.dc_HIA	= CXA.dc_HIA
		Left join vwAXDocs AX	(nolock) on CC.Num_proc_hia = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hia = ax.dc
		--Alessandra 19/05/2021 - AX10
		left join vwFaturasValidas vw on CC.Num_Proc_HIA = vw.num_proc and CC.DC_HIA = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx

	WHERE 
		CC.Num_Proc_HIA = @Processo
	-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
	GROUP BY
		TT.Nome_tp_tx 
		,CC.DC_HIA
		,PS.apelido
		,TM.nome_tp_moeda
		,vlr_org_HIA 
		,dt_prev_pgto_HIA
		,Dt_Ins_HIA 
		,Comp_CPA_HIA
		,Num_DCN_HIA
		,Org_Ins_HIA 
		,CXA.Dt_Pgto_Rcto_HIA
		,(case when CXA.Num_Lcto = 'REMESSA' then
			Num_Rcb_HIA
		else
			CXA.Num_Lcto end)
		,CC.Num_NF_HIA
		,Desp_Org_HIA
		,CPMF_HIA
		,Comp_RP_HIA	
		,Comp_DN_HIA
		,Comp_CN_HIA
		,Comp_CPA_HIA
		,Isnull(Vlr_Contab, Vlr_Contab_Ant)	
		,dbo.[FBusca_UltimaFatura](CC.num_proc_hia,CC.dc_hia,CC.cd_tp_tx)
		,vw.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
	ORDER BY
		1, 2 desc
		
	
GO
