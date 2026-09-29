SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














CREATE               view cia_aerea_pgt

as
select Nome_Cia_Aer,cta.cd_tp_moeda,sum(vlr_org_mea)Valor,month(convert(datetime,dt_saida_mea,105)) Mes from master_exp_aeR MAS
Join Cta_cte_mas_exp_aeR cta on cta.num_proC_mea=mas.num_proc_mea
Join Cia_Aerea ARM on MAs.cd_cia_aer=arm.cd_cia_aer
where dc_mea='D' and cta.cd_tp_moeda='USD' and convert(Datetime,dt_saida_mea,105) between '07-01-2007' and '07-31-2007'
Group by nome_cia_aer,cta.cd_tp_moeda, month(convert(datetime,dt_saida_mea,105))



















GO
