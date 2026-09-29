SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE    view Armador_pgto

as
select Nome_Armador,cta.cd_tp_moeda,sum(vlr_org_mem)Valor,month(convert(datetime,dt_saida_mem,105)) Mes from master_exp_maR MAS
Join Cta_cte_mas_exp_mar cta on cta.num_proC_mem=mas.num_proc_mem
Join Armador ARM on MAs.cd_armador=arm.cd_armador
where dc_mem='D' and cta.cd_tp_moeda='USD' and convert(Datetime,dt_saida_mem,105) between '01-01-2007' and '01-31-2007'
Group by nome_armador,cta.cd_tp_moeda, month(convert(datetime,dt_saida_mem,105))









GO
