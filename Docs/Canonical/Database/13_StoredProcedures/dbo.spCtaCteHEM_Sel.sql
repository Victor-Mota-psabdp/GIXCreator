SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	PROCEDURE [dbo].[spCtaCteHEM_Sel]

	@Processo 	varchar(16)

AS
	SELECT
		TT.Nome_tp_tx 		TAXA,
		CC.DC_HEM 			DC,
		PS.apelido 			PESSOA,
		TM.nome_tp_moeda 	MOEDA,
		vlr_org_HEM 		VALOR,
		dt_prev_pgto_HEM 	PREVISTA,
		Dt_Ins_HEM 			INSERCAO,
		Comp_CPA_HEM 		CPA,
		Num_DCN_HEM 		INVOICE, 
		Org_Ins_HEM 		DEPART,
		CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,
		--CXA.Num_Lcto		NUM_LCTO,
		(case when CXA.Num_Lcto = 'REMESSA' then
			Num_Rcb_HIA
		else
			CXA.Num_Lcto end)	NUM_LCTO,	
		CC.Num_NF_HEM 		NF,
		Desp_Dst_HEM		ORIGIN,
		CPMF_HEM			CPMF,
		Comp_RP_HEM			RP,
		Comp_DN_HEM			DN,
		Comp_CN_HEM			CN,
		Comp_CPA_HEM		CPA,
		Isnull(Vlr_Contab, Vlr_Contab_Ant)	Vlr_Contab,
		--(Select max(FatCod) from item_Fat FAT where FAT.Num_Proc = CC.num_proc_hem and FAT.cd_tp_tx = CC.cd_tp_tx and FAT.DC = CC.dc_hem and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')) UltimaFatura,
		dbo.[FBusca_UltimaFatura](CC.num_proc_hem,CC.dc_hem,CC.cd_tp_tx) UltimaFatura,
		-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
		--ID_AX	
		 max(ID_AX) as ID_AX
		 --Alessandra 19/05/2021 - AX10
		 ,vw.FatVendorInvoiceNumber
	FROM
		Cta_Cte_Hou_Exp_Mar CC
		left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left join pessoa PS	on CC.cd_cred_dev_HEM = PS.cd_pes
		Left join vwCXAS CXA on	CC.num_proc_HEM	= CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEM = CXA.dc_HIA
		Left join vwAXDocs AX on CC.Num_proc_hem = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hem = ax.dc
		--Alessandra 19/05/2021 - AX10
		left join vwFaturasValidas vw on CC.Num_Proc_HEM = vw.num_proc and CC.DC_HEM = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
	WHERE 
		CC.Num_Proc_HEM = @Processo
	-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
	GROUP BY 
		TT.Nome_tp_tx
		,CC.DC_HEM
		,PS.apelido
		,TM.nome_tp_moeda
		,vlr_org_HEM
		,dt_prev_pgto_HEM
		,Dt_Ins_HEM
		,Comp_CPA_HEM
		,Num_DCN_HEM 
		,Org_Ins_HEM
		,CXA.Dt_Pgto_Rcto_HIA
		,(case when CXA.Num_Lcto = 'REMESSA' then
			Num_Rcb_HIA
		else
			CXA.Num_Lcto end)	
		,CC.Num_NF_HEM
		,Desp_Dst_HEM
		,CPMF_HEM
		,Comp_RP_HEM
		,Comp_DN_HEM
		,Comp_CN_HEM
		,Comp_CPA_HEM
		,Isnull(Vlr_Contab, Vlr_Contab_Ant)
		,dbo.[FBusca_UltimaFatura](CC.num_proc_hem,CC.dc_hem,CC.cd_tp_tx)
		,vw.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
	ORDER BY
		1, 2 desc


GO
