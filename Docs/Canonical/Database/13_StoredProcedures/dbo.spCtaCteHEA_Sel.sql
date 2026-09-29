SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	PROCEDURE [dbo].[spCtaCteHEA_Sel] --'EACSR20080100101'

	@Processo 	varchar(16)

AS
	SELECT
		TT.Nome_tp_tx 		TAXA,
		CC.DC_HEA 			DC,
		PS.apelido 			PESSOA,
		TM.nome_tp_moeda 	MOEDA,
		vlr_org_HEA 		VALOR,
		dt_prev_pgto_HEA 	PREVISTA,
		Dt_Ins_HEA 			INSERCAO,
		Comp_CPA_HEA 		CPA,
		Num_DCN_HEA 		INVOICE, 
		Org_Ins_HEA 		DEPART,
		CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,
		--CXA.Num_Lcto		NUM_LCTO,
		(case when CXA.Num_Lcto = 'REMESSA' then
			Num_Rcb_HIA
		else
			CXA.Num_Lcto end)	NUM_LCTO,	
		CC.Num_NF_HEA 		NF,
		Desp_Dst_HEA		ORIGIN,
		CPMF_HEA			CPMF,
		Comp_RP_HEA			RP,
		Comp_DN_HEA			DN,
		Comp_CN_HEA			CN,
		Comp_CPA_HEA		CPA,
		isnull(Vlr_Contab, Vlr_Contab_ant)	Vlr_Contab,
		--(Select max(FatCod) from item_Fat FAT where FAT.Num_Proc = CC.num_proc_hea and FAT.cd_tp_tx = CC.cd_tp_tx and FAT.DC = CC.dc_hea and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')) UltimaFatura,
		dbo.[FBusca_UltimaFatura](CC.num_proc_hea,CC.dc_hea,CC.cd_tp_tx) UltimaFatura,
		-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
		--ID_AX	
		 max(ID_AX) as ID_AX
		 --Alessandra 19/05/2021 - AX10
		 ,vw.FatVendorInvoiceNumber
	FROM
		Cta_Cte_Hou_Exp_AER CC
		left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left join pessoa PS	on CC.cd_cred_dev_HEA = PS.cd_pes
		Left join vwCXAS CXA on	CC.num_proc_HEA	= CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEA = CXA.dc_HIA
		Left join vwAXDocs AX on CC.Num_proc_hea = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hea = ax.dc
		--Alessandra 19/05/2021 - AX10
		left join vwFaturasValidas vw on CC.num_proc_hea = vw.num_proc and CC.dc_hea = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx

	WHERE 
		CC.Num_Proc_HEA = @Processo
	-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
	GROUP BY 
		TT.Nome_tp_tx
		,CC.DC_HEA
		,PS.apelido
		,TM.nome_tp_moeda
		,vlr_org_HEA
		,dt_prev_pgto_HEA
		,Dt_Ins_HEA
		,Comp_CPA_HEA
		,Num_DCN_HEA
		,Org_Ins_HEA
		,CXA.Dt_Pgto_Rcto_HIA
		,(case when CXA.Num_Lcto = 'REMESSA' then
			Num_Rcb_HIA
		else
			CXA.Num_Lcto end)	
		,CC.Num_NF_HEA
		,Desp_Dst_HEA
		,CPMF_HEA
		,Comp_RP_HEA
		,Comp_DN_HEA
		,Comp_CN_HEA
		,Comp_CPA_HEA	
		,isnull(Vlr_Contab, Vlr_Contab_ant)	
		,dbo.[FBusca_UltimaFatura](CC.num_proc_hea,CC.dc_hea,CC.cd_tp_tx)
		,vw.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
	ORDER BY
		1, 2 desc












GO
