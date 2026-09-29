SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spLancamentoContabil_Int --spLancamentoContabil_Int '01-01-2009','03-31-2009'
		@DataInicial	Varchar(10),
		@DataFinal		Varchar(10)

as
select cta.dc_hem DC, dt_ins_hem Data,Conta_Debito,Conta_Credito,vlr_org_hem*isnull(par_moeda,1) Valor,cta.num_proc_hem Processo,nome_tp_tx  from cta_Cte_hou_exp_mar CTA
Left Join Caixa_hou_exp_Mar CXA on CTa.num_proc_hem=CXA.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hem=CXa.dc_hem and num_lcto <> 'PROVISÓRIO'  AND CONVERT(DATETIME,DT_PGTO_RCTO_HEM,105) <=@DataFinal
Left Join Regras_Contabeis RC on RC.cd_tp_tx=cta.cd_tp_tx and cta.dc_hem=DC and left(cta.num_proc_hem,2)=modal and tipo='P'
Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and dt_par='30/03/2009'
Where cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.dc_hem='C' and left(cta.cd_tp_tx,1) <> 'X'
and convert(datetime,dt_ins_hem,105) between @DataInicial and @DataFinal


GO
