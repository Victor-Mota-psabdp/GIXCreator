SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE	PROCEDURE [dbo].[spCtaCteHIO_Sel]

	@Processo 	varchar(16),
	@Tipo		char(1)

AS
	
	SELECT
		TT.Nome_tp_tx 		TAXA,
		CC.DC_HIO 			DC,
		PS.apelido 			PESSOA,
		TM.nome_tp_moeda 	MOEDA,
		vlr_org_HIO 		VALOR,
		dt_prev_pgto_HIO 	PREVISTA,
		Dt_Ins_HIO 			INSERCAO,
		Comp_CPA_HIO 		CPA,
		Num_DCN_HIO 		INVOICE, 
		Org_Ins_HIO 		DEPART,
		CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,
		CXA.Num_Lcto		NUM_LCTO,
		CC.Num_NF_HIO 		NF,
		Desp_Org_HIO		ORIGIN,
		CPMF_HIO			CPMF,
		Comp_RP_HIO			RP,
		Comp_DN_HIO			DN,
		Comp_CN_HIO			CN,
		Comp_CPA_HIO		CPA,
		Isnull(Vlr_Contab, Vlr_Contab_Ant) Vlr_Contab,
		--(Select max(FatCod) from item_Fat FAT where FAT.Num_Proc = CC.num_proc_hio and FAT.cd_tp_tx = CC.cd_tp_tx and FAT.DC = CC.dc_hio and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')) UltimaFatura,
		dbo.[FBusca_UltimaFatura](CC.num_proc_hio,CC.dc_hio,CC.cd_tp_tx) UltimaFatura,
		-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
		--ID_AX	
		 max(ID_AX) as ID_AX
		 --Alessandra 19/05/2021 - AX10
		 ,vw.FatVendorInvoiceNumber
	FROM
		Cta_Cte_Hou_Imp_OUT CC
		Left Outer Join LLP_IMP_OUT LLP	on @Processo = LLP.Num_Proc_LIO 
		Left Outer Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
		Left Outer join Tipo_moeda TM 	on CC.cd_tp_moeda = TM.cd_tp_moeda
		Left Outer join pessoa PS	on CC.cd_cred_dev_HIO = PS.cd_pes
		Left Outer join vwCXAS CXA on	CC.num_proc_HIO	= CXA.num_proc_HIA and	CC.cd_tp_tx	= CXA.cd_tp_tx	and	CC.dc_HIO	= CXA.dc_HIA
		Left join vwAXDocs AX on CC.Num_proc_hio = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hio = ax.dc
		--Alessandra 19/05/2021 - AX10
		left join vwFaturasValidas vw on CC.Num_Proc_HIO = vw.num_proc and CC.DC_HIO = vw.dc and CC.cd_tp_tx = vw.cd_tp_tx
	WHERE 
		CC.Num_Proc_HIO = @Processo and LLP.Tipo_Lio=@Tipo 
	-- Alessandra 27/04/2020 - Conforme alinhado com o anderson, colocado para retirar duplicidade
	GROUP BY 
		TT.Nome_tp_tx
		,CC.DC_HIO
		,PS.apelido
		,TM.nome_tp_moeda
		,vlr_org_HIO
		,dt_prev_pgto_HIO
		,Dt_Ins_HIO
		,Comp_CPA_HIO
		,Num_DCN_HIO
		,Org_Ins_HIO
		,CXA.Dt_Pgto_Rcto_HIA 
		,CXA.Num_Lcto
		,CC.Num_NF_HIO
		,Desp_Org_HIO
		,CPMF_HIO
		,Comp_RP_HIO
		,Comp_DN_HIO
		,Comp_CN_HIO
		,Comp_CPA_HIO
		,Isnull(Vlr_Contab, Vlr_Contab_Ant)
		,dbo.[FBusca_UltimaFatura](CC.num_proc_hio,CC.dc_hio,CC.cd_tp_tx)
		,vw.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
	ORDER BY
		1, 2 desc




GO
