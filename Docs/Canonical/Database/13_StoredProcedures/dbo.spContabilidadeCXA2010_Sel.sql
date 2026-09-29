SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















CREATE procedure [dbo].[spContabilidadeCXA2010_Sel] --'01-01-2012','01-05-2012'
			@DataInicial	DAtetime,
			@DataFinal		Datetime
as

--SOMENTE ITENS DE NOTA FISCAL

select Ref_Acesso_Nf_Hia Filial,'03-31-2012' Data_Mov, 514 Conta_Debito,3228 Conta_Credito,vlr_pgto_nf_hia Valor_Pgto_Rcto_Hia,458 Conta_Historico,'"'+ NOTa_FISCAL +  '"' Hist_1,'Transf. de Conta Contabil ' Hist_2,'"' + cta.NUM_PROC_HIA + '"' Hist_3,cta.DC_HIA DC    from vwcta_cte CTA
Join Base_Nota_Fiscal NF on num_nf_hia=nota_fiscal and ref_Acesso_nf_hia=ref_acesso
Left Join vwcxas cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_tx=cxa.cd_Tp_Tx and convert(Datetime,dt_pgto_Rcto_hia,105) <='03-31-2012'
where
	emissao between '01-01-2008' and '12-31-2010'
	and num_lcto is null



GO
