SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spCHBProcessosNegativos

AS


select 
	apelido,cta.num_proc_hia Processo,sum(dbo.valor(vlr_pgto_rcto_hia,cta.dc_hia)) Saldo,convert(varchar(10),max(dt_conclusao),103) ,
	(select max(data_pc) from fatura_chb where processo_pc=cta.num_proc_hia)
from vwcxas CXA 
Join vwcta_Cte CTA on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
LEft Join Tarefas_Processos TP on TP.num_proc=cta.num_proc_hia and id_task=4
Join Grupo GRP on substring(cxa.num_proc_hia,3,3) = GRupo
Join Pessoa PP on PP.cd_pes=cd_pes_grupo
where
	(cta.num_nf_hia is  null or cta.ref_acesso_nf_hia = 'P') and left(cta.num_proc_hia,5)<>'IAREM'
	and cta.cd_tp_tx not in ('BRO','CF1','C01','p01','PIS','IRR','IRF','SDA')
Group by cta.Num_Proc_Hia,apelido
Having sum(dbo.valor(vlr_pgto_rcto_hia,cta.dc_hia)) <-15
order by Saldo 



GO
