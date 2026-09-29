SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCtaCteHBO_Sel] --'EACSR20080100101'

	@Processo 	varchar(16)

AS
--"Saved" & vbTab & RsTemp!Dt_Lcto & vbTab & IIf(IsNull(RsTemp!Num_Lcto) = True, "Open", RsTemp!Num_Lcto) 
--& vbTab & RsTemp!Taxa & vbTab & RsTemp!DC & vbTab & RsTemp!Pessoa & vbTab & RsTemp!moeda & vbTab & Format(RsTemp!Valor, "#,##0.00") 
--& vbTab & RsTemp!INSERCAO & vbTab & RsTemp!PREVISTA & vbTab & RsTemp!invoice & vbTab & RsTemp!DEPART 
--& vbTab & IIf(IsNull(RsTemp!NF) = True, "", RsTemp!NF) & vbTab & RsTemp!Origin & vbTab & RsTemp!CPMF & vbTab & RsTemp!RP
-- & vbTab & RsTemp!DN 
--& vbTab & RsTemp!CN & vbTab & RsTemp!CPA & vbTab & RsTemp!UltimaFatura & vbTab & RsTemp!id_ax
	SELECT
		'Saved'			[Status],
		CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,
		(case when CXA.Num_Lcto = 'REMESSA' then
			Num_Rcb_HIA
		else
			isnull(CXA.Num_Lcto,'Open') end)	NUM_LCTO,
		CC.cd_tp_tx,
		TT.Nome_tp_tx 		TAXA,
		CC.DC_HBO 			DC,
		CC.cd_cred_dev_HBO,
		PS.apelido 			PESSOA,
		CC.cd_tp_moeda,
		TM.nome_tp_moeda 	MOEDA,
		vlr_org_HBO 		VALOR,
		Dt_Ins_HBO 			INSERCAO,
		dt_prev_pgto_HBO 	PREVISTA,
		Num_DCN_HBO 		INVOICE, 
		Org_Ins_HBO 		DEPART,
		CC.Num_NF_HBO 		NF,
		Desp_Org_HBO		ORIGIN,
		CPMF_HBO			CPMF,
		Comp_RP_HBO			RP,
		Comp_DN_HBO			DN,
		Comp_CN_HBO			CN,
		Comp_CPA_HBO		CPA,
		dbo.[FBusca_UltimaFatura](CC.num_proc_HBO,CC.dc_HBO,CC.cd_tp_tx) UltimaFatura,
		ID_AX,
		PS.Nome_Raz_Soc + '|'+ isnull(PS.Num_CPF_CNPJ,'')
		
	FROM
		Cta_Cte_HOU_BDP_OUT CC
		left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
		left join Tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left join pessoa PS	on CC.cd_cred_dev_HBO = PS.cd_pes
		Left join vwCXAS CXA on	CC.num_proc_HBO	= CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HBO = CXA.dc_HIA
		Left join vwAXDocs AX on CC.Num_proc_HBO = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_HBO = ax.dc
	WHERE 
		CC.Num_Proc_HBO = @Processo
	ORDER BY
		1, 2 desc

GO
