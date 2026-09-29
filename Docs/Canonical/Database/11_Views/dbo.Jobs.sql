SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE           View Jobs

		
AS

select 
	apelido,hawb_hea,job_hea,max(PSaida.HSGDataFU) PSaida,convert(datetime,dt_saida_mea,105) Saida,
	max(PChegada.HSGDataFU) PChegada,max(POD.HSGDataFU)  POD,nome_usuario , '' Reserva

from  
	house_exp_Aer Hou
	Inner Join pessoa pp on pp.cd_pes=cd_export_hea
	Inner Join Master_exp_Aer Mas on MAS.num_proc_mea=HOU.num_proc_mea
	Inner Join Job_Exp_aer JOB on JOB.num_proc_hea=HOU.job_hea
	Inner Join usuario US on US.cd_usuario=JOB.cd_usuario
	Left Outer Join hist_geral PSaida on HOU.job_hea=Psaida.HSGProcesso and Psaida.cd_tp_ocor=15
	Left Outer Join hist_geral PChegada on HOU.job_hea=PChegada.HSGProcesso and PChegada.cd_tp_ocor=16
	Left Outer Join hist_geral POD on HOU.job_hea=POD.HSGProcesso and POD.cd_tp_ocor=10
	Left Outer Join hist_geral FIM on FIM.HSGProcesso in (HOU.job_hea,hou.num_proc_hea) and FIM.cd_tp_ocor=11
	
where left(job_hea,2)='EA' and FIM.HSGData is null
	and convert(datetime,dt_emis_hea,105)>=convert(datetime,'01/06/2006',105)

GROUP BY
	apelido,hawb_hea,job_hea,convert(datetime,dt_saida_mea,105),
	nome_usuario 
	

UNION

select 
	apelido,hawb_hem,job_hem,max(PSaida.HSGDataFU) PSaida,convert(datetime,dt_saida_mem,105) Saida,
	max(PChegada.HSGDataFU) PChegada,max(POD.HSGDataFU) POD , nome_usuario, nr_reserva Reserva

from  
	house_exp_mar Hou
	Inner Join pessoa pp on pp.cd_pes=cd_export_hem
	Inner Join Master_exp_mar Mas on MAS.num_proc_mem=HOU.num_proc_mem
	Inner Join Job_Exp_mar JOB on JOB.num_proc_hem=HOU.job_hem
	Inner Join usuario US on US.cd_usuario=JOB.cd_usuario
	Left Outer Join hist_geral PSaida on (HOU.job_hem=PSaida.HSGProcesso OR HOU.num_proc_hem=PSaida.HSGProcesso) and Psaida.cd_tp_ocor=15
	Left Outer Join hist_geral PChegada on (HOU.job_hem=PChegada.HSGProcesso OR HOU.num_proc_hem=PChegada.HSGProcesso) and PChegada.cd_tp_ocor=16
	Left Outer Join hist_geral POD on (HOU.job_hem=POD.HSGProcesso OR HOU.num_proc_hem=POD.HSGProcesso) and POD.cd_tp_ocor=10
	Left Outer Join hist_geral FIM on (HOU.job_hem=FIM.HSGProcesso OR HOU.num_proc_hem=FIM.HSGProcesso) and FIM.cd_tp_ocor=11
	
where left(job_hem,2)='EM' and FIM.HSGData is null
	and convert(datetime,dt_emis_hem,105)>=convert(datetime,'01/06/2006',105)

GROUP by
	apelido,hawb_hem,job_hem,convert(datetime,dt_saida_mem,105), nome_usuario, nr_reserva


UNION



select 
	apelido,hawb_hia,job_hia,max(PSaida.HSGDataFU) PSaida,max(Saida.HSGDataFU) Saida,
	max(PChegada.HSGDataFU) PChegada,convert(datetime,dt_cheg_mia,105) POD, nome_usuario, '' Reserva

from  
	house_imp_Aer Hou
	Inner Join pessoa pp on pp.cd_pes=cd_import_hia
	Inner Join Master_imp_Aer Mas on MAS.num_proc_mia=HOU.num_proc_mia
	Inner Join Job_imp_aer JOB on JOB.num_proc_hia=HOU.job_hia
	Inner Join usuario US on US.cd_usuario=JOB.cd_usuario
	Left Outer Join hist_geral PSaida on Psaida.HSGProcesso in (HOU.job_hia,hou.num_proc_hia) and Psaida.cd_tp_ocor=15
	Left Outer Join hist_geral PChegada on PChegada.HSGProcesso in (HOU.job_hia,hou.num_proc_hia) and PChegada.cd_tp_ocor=16
	Left Outer Join hist_geral Saida on Saida.HSGProcesso in (HOU.job_hia,hou.num_proc_hia) and Saida.cd_tp_ocor=9
	Left Outer Join hist_geral FIM on FIM.HSGProcesso in (HOU.job_hia,hou.num_proc_hia) and FIM.cd_tp_ocor=11
	
where left(job_hia,2)='IA' and FIM.HSGData is null
	and convert(datetime,dt_emis_hia,105)>=convert(datetime,'01/06/2006',105)

	
GROUP BY
	apelido,hawb_hia,job_hia,convert(datetime,dt_cheg_mia,105), nome_usuario

UNION

select 
	apelido,hawb_him,job_him,max(PSaida.HSGDataFU) PSaida,max(Saida.HSGDataFU) Saida,
	max(Patracada.HSGDataFU) Patracada,convert(datetime,dt_atrac_mim,105) POD , nome_usuario, '' Reserva

from  
	house_imp_mar Hou
	Inner Join pessoa pp on pp.cd_pes=cd_import_him
	Inner Join Master_imp_mar Mas on MAS.num_proc_mim=HOU.num_proc_mim
	Inner Join Job_imp_mar JOB on JOB.num_proc_him=HOU.job_him
	Inner Join usuario US on US.cd_usuario=JOB.cd_usuario
	Left Outer Join hist_geral PSaida on HOU.job_him=Psaida.HSGProcesso and Psaida.cd_tp_ocor=15
	Left Outer Join hist_geral Patracada on HOU.job_him=Patracada.HSGProcesso and Patracada.cd_tp_ocor=16
	Left Outer Join hist_geral Saida on HOU.job_him=Saida.HSGProcesso and Saida.cd_tp_ocor=9
	Left Outer Join hist_geral FIM on HOU.job_him=FIM.HSGProcesso and FIM.cd_tp_ocor=11
	
where left(job_him,2)='IM' and FIM.HSGData is null
	and convert(datetime,dt_emis_him,105)>=convert(datetime,'01/06/2006',105)

GROUP BY
	apelido,hawb_him,job_him,convert(datetime,dt_atrac_mim,105) , nome_usuario













GO
