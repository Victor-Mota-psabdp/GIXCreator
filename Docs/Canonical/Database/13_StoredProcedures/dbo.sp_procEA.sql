SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  sp_procEA
				@datainicial	varchar(10),
				@datafinal	varchar(10)
AS
select NUM_PROC_MEA,cta_cte_hou_exp_aer.num_proc_hea AS PROCESSO, nome_tp_tx,cta_cte_hou_exp_aer.dc_hea, cta_cte_hou_exp_aer.cd_tp_moeda, cast(vlr_org_hea as money) as Valor, cast(sum(vlr_ref_hea) as money) as pgto from cta_cte_hou_exp_aer 
inner join tipo_taxa on tipo_taxa.cd_tp_tx=cta_cte_hou_exp_aer.cd_tp_tx
left join caixa_hou_exp_aer on (caixa_hou_exp_aer.num_proc_hea=cta_cte_hou_exp_aer.num_proc_hea and caixa_hou_exp_aer.cd_tp_tx=cta_cte_hou_exp_aer.cd_tp_tx and caixa_hou_exp_aer.dc_hea=cta_cte_hou_exp_aer.dc_hea AND NUM_LCTO <> 'PROVISÓRIO')
inner join master_exp_aer on (num_proc_MEA = left(cta_cte_hou_exp_aer.num_proc_hea,14))
WHERE DESP_DST_hea = 'N' and convert(datetime, dt_saida_MEA, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)
group by NUM_PROC_MEA,cta_cte_hou_exp_aer.num_proc_hea, nome_tp_tx,cta_cte_hou_exp_aer.dc_hea, cta_cte_hou_exp_aer.cd_tp_moeda, cast(vlr_org_hea as money) 
UNION
select MASTER_exp_AER.NUM_PROC_MEA,cta_cte_mas_exp_aer.num_proc_MEA as Processo, nome_tp_tx,cta_cte_mas_exp_aer.dc_MEA, cta_cte_mas_exp_aer.cd_tp_moeda, cast(vlr_org_MEA as money) as Valor, cast(sum(vlr_ref_MEA) as money) as pgto  from cta_cte_mas_exp_aer 
inner join tipo_taxa on tipo_taxa.cd_tp_tx=cta_cte_mas_exp_aer.cd_tp_tx
left join caixa_mas_exp_aer on (caixa_mas_exp_aer.num_proc_MEA=cta_cte_mas_exp_aer.num_proc_MEA and caixa_mas_exp_aer.cd_tp_tx=cta_cte_mas_exp_aer.cd_tp_tx and caixa_mas_exp_aer.dc_MEA=cta_cte_mas_exp_aer.dc_MEA AND NUM_LCTO <> 'PROVISÓRIO')
inner join master_exp_aer on (MASTER_exp_AER.num_proc_MEA = left(cta_cte_mas_exp_aer.num_proc_MEA,14))
WHERE DESP_DST_MEA = 'N' and convert(datetime, dt_saida_mea, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal ,105)
group by MASTER_exp_AER.NUM_PROC_MEA,cta_cte_mas_exp_aer.num_proc_MEA , nome_tp_tx,cta_cte_mas_exp_aer.dc_MEA, cta_cte_mas_exp_aer.cd_tp_moeda, cast(vlr_org_MEA as money) 



GO
