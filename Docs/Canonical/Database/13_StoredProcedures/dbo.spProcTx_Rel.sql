SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE      Procedure [dbo].[spProcTx_Rel]
			@apelido 	varchar(25),
			@Dt_Inicial 	varchar(10)
		
AS

select 
	'Importação Aérea' Modal, hou.num_proc_hia, convert(datetime,dt_cheg_mia,105) Data,apelido ,hawb_hia
from 
	house_imp_aer hou
	Left Join ctA_cte_hou_imp_aer cta on hou.num_proc_hia=cta.num_proc_hia and cd_tp_tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S') and cta.dc_hia='C'
	Join pessoa pp on pp.cd_pes=cd_import_hia
	Join master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia and mas.num_proc_mia <> 'JOB' and left(mas.num_proc_mia,5) <> 'IACLI'
	Left Join hist_geral hist on hou.num_proc_hia=hsgprocesso and cd_tp_ocor=38
where 
	apelido like @apelido --and cta.dc_hia='C'
	and (cta.num_proc_hia is null )
	and convert(datetime, dt_cheg_mia,105) >= convert(datetime, @Dt_Inicial,105)
	and hsgprocesso is null
Union


select 
	'Importação Marítima' Modal,hou.num_proc_him, convert(datetime,dt_atrac_mim,105) Data, apelido,hawb_him
from 
	house_imp_mar hou
	Left join ctA_cte_hou_imp_mar cta on hou.num_proc_him=cta.num_proc_him and cd_tp_tx in (select cd_tp_tx from tipo_Taxa where pft_mar='S') and cta.dc_him='C'
	Join pessoa pp on pp.cd_pes=cd_import_him
	Left Join hist_geral hist on hou.num_proc_him=hsgprocesso and cd_tp_ocor=38
	Join master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim and mas.num_proc_mim <> 'JOB' and left(mas.num_proc_mim,5) <> 'IMCLI'
where 
	apelido like @apelido --and cta.dc_him='C'
	and (cta.num_proc_him is null)
	and convert(datetime, dt_atrac_mim,105)>=convert(datetime,@dt_Inicial,105)
	and hsgprocesso is null
union



select 
	'Exportação Aérea' Modal,hou.num_proc_hea, convert(datetime,dt_saida_mea,105) Data,apelido , hawb_hea
from 
	house_exp_aer hou
	Left Join ctA_cte_hou_exp_aer cta on hou.num_proc_hea=cta.num_proc_hea and cd_tp_tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S') and cta.dc_hea='C'
	Join pessoa pp on pp.cd_pes=cd_export_hea
	Left Join hist_geral hist on hou.num_proc_hea=hsgprocesso and cd_tp_ocor=38
	Join master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea and mas.num_proc_mea <> 'JOB' and left(mas.num_proc_mea,5) <> 'EACLI'
where 
	apelido like @apelido
	and (cta.num_proc_hea is null )
	and convert(datetime, dt_saida_mea,105)>=convert(datetime, @dt_inicial,105)
	and hsgprocesso is null
Union


select 
	'Exportação Marítima' Modal,hou.num_proc_hem, convert(datetime,dt_saida_mem,105),apelido, hawb_hem
from 
	house_exp_mar hou
	Left join ctA_cte_hou_exp_mar cta on hou.num_proc_hem=cta.num_proc_hem and cd_tp_tx in (select cd_tp_tx from tipo_Taxa where pft_mar='S') and cta.dc_hem='C'
	Join pessoa pp on pp.cd_pes=cd_export_hem
	Join master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem and mas.num_proc_mem <> 'JOB' and left(mas.num_proc_mem,5) <> 'EMCLI'
	Left Join hist_geral hist on hou.num_proc_hem=hsgprocesso and cd_tp_ocor=38
where 
	apelido like @apelido
	and (cta.num_proc_hem is null )
	and convert(datetime, dt_saida_mem, 105) >=convert(datetime,@dt_inicial,105)
	and hsgprocesso is null








GO
