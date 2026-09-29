SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create  PROCEDURE  sp_procIA
				@datainicial	varchar(10),
				@datafinal	varchar(10)
AS
select NUM_PROC_MIA,cta_cte_hou_imp_aer.num_proc_hia AS PROCESSO, nome_tp_tx,cta_cte_hou_imp_aer.dc_hia, cta_cte_hou_imp_aer.cd_tp_moeda, cast(vlr_org_hia as money) as Valor, cast(sum(vlr_ref_hia) as money) as pgto from cta_cte_hou_imp_aer 
inner join tipo_taxa on tipo_taxa.cd_tp_tx=cta_cte_hou_imp_aer.cd_tp_tx
left join caixa_hou_imp_aer on (caixa_hou_imp_aer.num_proc_hia=cta_cte_hou_imp_aer.num_proc_hia and caixa_hou_imp_aer.cd_tp_tx=cta_cte_hou_imp_aer.cd_tp_tx and caixa_hou_imp_aer.dc_hia=cta_cte_hou_imp_aer.dc_hia AND NUM_LCTO <> 'PROVISÓRIO')
inner join master_imp_aer on (num_proc_mia = left(cta_cte_hou_imp_aer.num_proc_hia,14))
WHERE DESP_ORG_HIA = 'N' and convert(datetime, dt_cheg_mia, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)
group by NUM_PROC_MIA,cta_cte_hou_imp_aer.num_proc_hia, nome_tp_tx,cta_cte_hou_imp_aer.dc_hia, cta_cte_hou_imp_aer.cd_tp_moeda, cast(vlr_org_hia as money) 
UNION
select MASTER_IMP_AER.NUM_PROC_MIA,cta_cte_mas_imp_aer.num_proc_MIA as Processo, nome_tp_tx,cta_cte_mas_imp_aer.dc_MIA, cta_cte_mas_imp_aer.cd_tp_moeda, cast(vlr_org_MIA as money) as Valor, cast(sum(vlr_ref_MIA) as money) as pgto  from cta_cte_mas_imp_aer 
inner join tipo_taxa on tipo_taxa.cd_tp_tx=cta_cte_mas_imp_aer.cd_tp_tx
left join caixa_mas_imp_aer on (caixa_mas_imp_aer.num_proc_MIA=cta_cte_mas_imp_aer.num_proc_MIA and caixa_mas_imp_aer.cd_tp_tx=cta_cte_mas_imp_aer.cd_tp_tx and caixa_mas_imp_aer.dc_MIA=cta_cte_mas_imp_aer.dc_MIA AND NUM_LCTO <> 'PROVISÓRIO')
inner join master_imp_aer on (MASTER_IMP_AER.num_proc_mia = left(cta_cte_mas_imp_aer.num_proc_MIA,14))
WHERE DESP_ORG_MIA = 'N' and convert(datetime, dt_cheg_mia, 105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal ,105)
group by MASTER_IMP_AER.NUM_PROC_MIA,cta_cte_mas_imp_aer.num_proc_MIA , nome_tp_tx,cta_cte_mas_imp_aer.dc_MIA, cta_cte_mas_imp_aer.cd_tp_moeda, cast(vlr_org_MIA as money) 



GO
