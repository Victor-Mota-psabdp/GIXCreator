SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create   PROCEDURE  sp_procIM
				@datainicial	varchar(10),
				@datafinal	varchar(10)
AS
select NUM_PROC_MIM,cta_cte_hou_imp_mar.num_proc_HIM AS PROCESSO, nome_tp_tx,cta_cte_hou_imp_mar.dc_HIM, cta_cte_hou_imp_mar.cd_tp_moeda, cast(vlr_org_HIM as money) as Valor, cast(sum(vlr_ref_HIM) as money) as pgto from cta_cte_hou_imp_mar 
inner join tipo_taxa on tipo_taxa.cd_tp_tx=cta_cte_hou_imp_mar.cd_tp_tx
left join caixa_hou_imp_mar on (caixa_hou_imp_mar.num_proc_HIM=cta_cte_hou_imp_mar.num_proc_HIM and caixa_hou_imp_mar.cd_tp_tx=cta_cte_hou_imp_mar.cd_tp_tx and caixa_hou_imp_mar.dc_HIM=cta_cte_hou_imp_mar.dc_HIM AND NUM_LCTO <> 'PROVISÓRIO')
inner join master_imp_mar on (num_proc_MIM = left(cta_cte_hou_imp_mar.num_proc_HIM,14))
WHERE DESP_ORG_HIM = 'N' and convert(datetime, dt_atrac_MIM, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)
group by NUM_PROC_MIM,cta_cte_hou_imp_mar.num_proc_HIM, nome_tp_tx,cta_cte_hou_imp_mar.dc_HIM, cta_cte_hou_imp_mar.cd_tp_moeda, cast(vlr_org_HIM as money) 
UNION
select master_imp_mar.NUM_PROC_MIM,cta_cte_mas_imp_mar.num_proc_MIM as Processo, nome_tp_tx,cta_cte_mas_imp_mar.dc_MIM, cta_cte_mas_imp_mar.cd_tp_moeda, cast(vlr_org_MIM as money) as Valor, cast(sum(vlr_ref_MIM) as money) as pgto  from cta_cte_mas_imp_mar 
inner join tipo_taxa on tipo_taxa.cd_tp_tx=cta_cte_mas_imp_mar.cd_tp_tx
left join caixa_mas_imp_mar on (caixa_mas_imp_mar.num_proc_MIM=cta_cte_mas_imp_mar.num_proc_MIM and caixa_mas_imp_mar.cd_tp_tx=cta_cte_mas_imp_mar.cd_tp_tx and caixa_mas_imp_mar.dc_MIM=cta_cte_mas_imp_mar.dc_MIM AND NUM_LCTO <> 'PROVISÓRIO')
inner join master_imp_mar on (master_imp_mar.num_proc_MIM = left(cta_cte_mas_imp_mar.num_proc_MIM,14))
WHERE DESP_ORG_MIM = 'N' and convert(datetime, dt_atrac_mim, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal ,105)
group by master_imp_mar.NUM_PROC_MIM,cta_cte_mas_imp_mar.num_proc_MIM , nome_tp_tx,cta_cte_mas_imp_mar.dc_MIM, cta_cte_mas_imp_mar.cd_tp_moeda, cast(vlr_org_MIM as money) 



GO
