SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE  sp_procEM
				@datainicial	varchar(10),
				@datafinal	varchar(10)
AS
select NUM_PROC_MEM,cta_cte_hou_exp_mar.num_proc_HEM AS PROCESSO, nome_tp_tx,cta_cte_hou_exp_mar.dc_HEM, cta_cte_hou_exp_mar.cd_tp_moeda, cast(vlr_org_HEM as money) as Valor, cast(sum(vlr_ref_HEM) as money) as pgto from cta_cte_hou_exp_mar 
inner join tipo_taxa on tipo_taxa.cd_tp_tx=cta_cte_hou_exp_mar.cd_tp_tx
left join caixa_hou_exp_mar on (caixa_hou_exp_mar.num_proc_HEM=cta_cte_hou_exp_mar.num_proc_HEM and caixa_hou_exp_mar.cd_tp_tx=cta_cte_hou_exp_mar.cd_tp_tx and caixa_hou_exp_mar.dc_HEM=cta_cte_hou_exp_mar.dc_HEM AND NUM_LCTO <> 'PROVISÓRIO')
inner join master_exp_mar on (num_proc_MEM = left(cta_cte_hou_exp_mar.num_proc_HEM,14))
WHERE DESP_DST_HEM = 'N' and convert(datetime, dt_saida_MEM, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)
group by NUM_PROC_MEM,cta_cte_hou_exp_mar.num_proc_HEM, nome_tp_tx,cta_cte_hou_exp_mar.dc_HEM, cta_cte_hou_exp_mar.cd_tp_moeda, cast(vlr_org_HEM as money) 
UNION
select MASTER_exp_mar.NUM_PROC_MEM,cta_cte_mas_exp_mar.num_proc_MEM as Processo, nome_tp_tx,cta_cte_mas_exp_mar.dc_MEM, cta_cte_mas_exp_mar.cd_tp_moeda, cast(vlr_org_MEM as money) as Valor, cast(sum(vlr_ref_MEM) as money) as pgto  from cta_cte_mas_exp_mar 
inner join tipo_taxa on tipo_taxa.cd_tp_tx=cta_cte_mas_exp_mar.cd_tp_tx
left join caixa_mas_exp_mar on (caixa_mas_exp_mar.num_proc_MEM=cta_cte_mas_exp_mar.num_proc_MEM and caixa_mas_exp_mar.cd_tp_tx=cta_cte_mas_exp_mar.cd_tp_tx and caixa_mas_exp_mar.dc_MEM=cta_cte_mas_exp_mar.dc_MEM AND NUM_LCTO <> 'PROVISÓRIO')
inner join master_exp_mar on (MASTER_exp_mar.num_proc_MEM = left(cta_cte_mas_exp_mar.num_proc_MEM,14))
WHERE DESP_DST_MEM = 'N' and convert(datetime, dt_saida_MEM, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal ,105)
group by MASTER_exp_mar.NUM_PROC_MEM,cta_cte_mas_exp_mar.num_proc_MEM , nome_tp_tx,cta_cte_mas_exp_mar.dc_MEM, cta_cte_mas_exp_mar.cd_tp_moeda, cast(vlr_org_MEM as money) 



GO
