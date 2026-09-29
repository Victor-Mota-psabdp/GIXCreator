SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














CREATE procedure [dbo].[spContabilidadeCXANFPG_Sel] --'01-01-2011','01-31-2011'
			@DataInicial	DAtetime,
			@DataFinal		Datetime
as

--SOMENTE ITENS DE NOTA FISCAL


SELECT REF_aCESSO Filial,emissao Data_Mov,3228 Conta_Debito,514 Conta_Credito,VLR_PGTO_NF_hia Vlr_Pgto_Rcto_hia,458 codigo_historico,'"'+ NOTa_FISCAL +  '"' Hist_1,'"' + NOME_RAZ_SOC + '"' Hist_2,'"' + cta.NUM_PROC_hia + '"' Hist_3,cta.DC_hia DC FROM vwcta_cte CTA
JOIN BASE_NOTA_FISCAL NF ON NUM_NF_hia=NOTA_FISCAL AND REF_ACESSO_NF_hia=REF_ACESSO
jOIN PESSOA PP ON PP.CD_PES=NF.CD_PES
jOIN Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_Tp_Tx
Join vwcxas CXA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia and convert(Datetime,dt_pgto_rcto_hia,105)<@DataInicial
WHERE
	EMISSAO between @DataInicial and @DataFinal
	and cd_cta_ctb_atv is null

GO
