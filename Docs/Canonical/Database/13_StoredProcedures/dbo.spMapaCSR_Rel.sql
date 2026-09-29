SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE           Procedure spMapaCSR_Rel 

		@Apelido varchar (30)

as

select 
	job_hea JOB_Number ,Numero_PO_HEA PO,inv_hea Invoice,
	seller.apelido Seller, buyer.apelido Buyer,Nome_tp_prod Produto,
	nome_tp_embal,	qtd_tot_vol_hea Qty,job.mawb_hea,'Exportação Aérea' Modal,
	voo_hea Voo,hawb_hea HAWB,etd.HSGDataFU ETD,convert(datetime,dt_saida_mea,105) Saida, 
	eta.HSGDataFU ETA,POD.HSGDataFU POD,org.nome_local Origem, dst.nome_local Destino,
	PCK.HSGDataFU PICKUP,BRO.HSGDataFU DESEM, obs_hea, Nome_Usuario

from 
	house_exp_aer hou

	inner join job_exp_aer job on job.num_proc_hea=hou.job_hea
	inner join usuario US on US.cd_usuario=JOB.cd_usuario
	inner join pessoa seller on seller.cd_pes=cd_export_hea
	inner join pessoa buyer on buyer.cd_pes=cd_consig_hea
	left join tipo_produto TP on hou.cd_tp_prod=TP.cd_tp_prod
	inner join tipo_embalagem TE on TE.cd_tp_embal=job.cd_tp_embal
	left join hist_geral ETD on etd.hsgprocesso=hou.job_hea and etd.cd_tp_ocor=15
	left join hist_geral ETA on eta.hsgprocesso=hou.job_hea and etA.cd_tp_ocor=16
	left join hist_geral POD on POD.hsgprocesso=hou.job_hea and POD.cd_tp_ocor=10
	inner join master_exp_aer mas on hou.num_proc_mea=mas.num_proc_mea
	inner join localidade org on org.cd_local=hou.cd_org_hea
	inner join localidade dst on dst.cd_local=hou.cd_dst_hea
	left join hist_geral PCK on PCK.hsgprocesso=hou.job_hea and PCK.cd_tp_ocor=17
	left join hist_geral BRO on BRO.hsgprocesso=hou.job_hea and BRO.cd_tp_ocor=18
	left join hist_geral FIM on FIM.hsgprocesso=hou.job_hea and FIM.cd_tp_ocor=11
	LEFT OUTER JOIN po_hea PO on HOU.job_hea=PO.num_proc_hea
where 
	left(job_hea,5)='EAJOB' and fim.hsgData is null
	and convert(datetime,hou.dt_emis_hea,105) >=convert(datetime,'11/05/2005',105)
	and seller.apelido like @APELIDO

UNION ALL

select 
	job_hem JOB_Number ,Numero_PO_Hem PO,inv_hem Invoice,
	seller.apelido Seller, buyer.apelido Buyer,Nome_tp_prod Produto,
	nome_tp_embal, qtd_tot_vol_hem Qty,job.Nr_Reserva,'Exportação Marítima' Modal,
	Viagem_hem Voo,hawb_hem HAWB,etd.HSGDataFU ETD,convert(datetime,dt_saida_mem,105) Saida, 
	eta.HSGDataFU ETA,POD.HSGDataFU POD,org.nome_local Origem, dst.nome_local Destino,
	PCK.HSGDataFU PICKUP, BRO.HSGDataFU DESEM,obs_hem , Nome_Usuario

from 
	house_exp_mar hou

	inner join job_exp_mar job on job.num_proc_hem=hou.job_hem
	Join usuario US on US.cd_usuario=JOB.cd_usuario
	inner join pessoa seller on seller.cd_pes=cd_export_hem
	inner join pessoa buyer on buyer.cd_pes=cd_consig_hem
	left join tipo_produto TP on hou.cd_tp_prod=TP.cd_tp_prod
	inner join tipo_embalagem TE on TE.cd_tp_embal=hou.cd_tp_embal
	left join hist_geral ETD on etd.hsgprocesso=hou.job_hem and etd.cd_tp_ocor=15
	left join hist_geral ETA on eta.hsgprocesso=hou.job_hem and etA.cd_tp_ocor=16
	left join hist_geral POD on POD.hsgprocesso=hou.job_hem and POD.cd_tp_ocor=10
	inner join master_exp_mar mas on hou.num_proc_mem=mas.num_proc_mem
	inner join localidade org on org.cd_local=hou.cd_org_hem
	inner join localidade dst on dst.cd_local=hou.cd_dst_hem
	left join hist_geral PCK on PCK.hsgprocesso=hou.job_hem and PCK.cd_tp_ocor=17
	left join hist_geral BRO on BRO.hsgprocesso=hou.job_hem and BRO.cd_tp_ocor=18
	left join hist_geral FIM on FIM.hsgprocesso=hou.job_hem and FIM.cd_tp_ocor=11
	LEFT OUTER JOIN po_hem PO on HOU.job_hem=PO.num_proc_hem

where 
	left(job_hem,5)='emjob' and fim.hsgData is null
	and convert(datetime,hou.dt_emis_hem,105) >=convert(datetime,'11/05/2005',105)
	and seller.apelido like @APELIDO

UNION ALL


SELECT

	JOB_HIM,Numero_PO_him PO, inv_him, SELLER.Apelido Seller, BUYER.Apelido Buyer,
	Nome_tp_prod Produto, nome_tp_embal, qtd_tot_vol_him Qty,job.mawb_him,'Importação Marítima' Modal,
	Viagem_him Voo,hawb_him HAWB, ETD.HSGDataFU ETD, Saida.HSGDataFU Saida, 
	ETA.HSGDataFU ETA,convert(datetime,dt_atrac_mim,105) POD,ORIGEM.nome_local Origem,
	DESTINO.nome_local Destino, PCK.HSGDataFU PICKUP,BRO.HSGDataFU Desem,obs_him, Nome_Usuario 

FROM
	house_imp_mar HOU
	
	INNER JOIN job_imp_mar JOB on job_him=JOB.num_proc_him
	JOIN usuario US on US.cd_usuario=JOB.cd_usuario
	INNER JOIN pessoa SELLER on SELLER.cd_pes=HOU.cd_export_him
	INNER JOIN pessoa BUYER on BUYER.cd_pes=HOU.cd_import_him
	LEFT OUTER JOIN tipo_produto TP on HOU.cd_tp_prod=TP.cd_tp_prod
	INNER JOIN  tipo_embalagem TE on TE.cd_tp_embal=HOU.cd_tp_embal
	LEFT OUTER JOIN hist_geral ETD on ETD.hsgprocesso=HOU.job_him and ETD.cd_tp_ocor=15
	LEFT OUTER JOIN hist_geral Saida on Saida.hsgprocesso=HOU.job_him and ETD.cd_tp_ocor=9
	LEFT OUTER JOIN hist_geral ETA on ETA.hsgprocesso=HOU.job_him and ETA.cd_tp_ocor=16
	INNER JOIN MASTER_IMP_MAR MAS on MAS.num_proc_mim=HOU.num_proc_mim
	INNER JOIN localidade ORIGEM on ORIGEM.cd_local=hou.cd_org_him
	INNER JOIN localidade DESTINO on DESTINO.cd_local=hou.cd_dst_him
	LEFT OUTER JOIN  hist_geral PCK on PCK.hsgprocesso=hou.job_him and PCK.cd_tp_ocor=31
	LEFT OUTER JOIN  hist_geral BRO on BRO.hsgprocesso=hou.job_him and BRO.cd_tp_ocor=18
	LEFT OUTER JOIN  hist_geral FIM on FIM.hsgprocesso=hou.job_him and FIM.cd_tp_ocor=11
	LEFT OUTER JOIN  po_him PO on HOU.job_him=PO.num_proc_him
where 
	left(job_him,5)='imjob' and fim.hsgData is null
	and convert(datetime,hou.dt_emis_him,105) >=convert(datetime,'11/05/2005',105)
	and buyer.apelido like @APELIDO

UNION ALL

SELECT

	JOB_hia,Numero_PO_Hia PO, inv_hia, SELLER.Apelido Seller, BUYER.Apelido Buyer,
	Nome_tp_prod Produto, nome_tp_embal,qtd_tot_vol_hia Qty,job.mawb_hia,
	'Importação Aérea' Modal,voo_hia Voo,hawb_hia HAWB, 
	ETD.HSGDataFU ETD, Saida.HSGDataFU Saida, 
	ETA.HSGDataFU ETA,convert(datetime,dt_cheg_mia,105) POD,ORIGEM.nome_local Origem,
	DESTINO.nome_local Destino, PCK.HSGDataFU PICKUP,BRO.HSGDataFU Desem,obs_hia, Nome_Usuario 

FROM
	house_imp_aer HOU
	
	INNER JOIN job_imp_aer JOB on job_hia=JOB.num_proc_hia
	JOIN usuario US on US.cd_usuario=JOB.cd_usuario
	INNER JOIN pessoa SELLER on SELLER.cd_pes=HOU.cd_export_hia
	INNER JOIN pessoa BUYER on BUYER.cd_pes=HOU.cd_import_hia
	LEFT OUTER JOIN tipo_produto TP on HOU.cd_tp_prod=TP.cd_tp_prod
	INNER JOIN  tipo_embalagem TE on TE.cd_tp_embal=JOB.cd_tp_embal
	LEFT OUTER JOIN hist_geral ETD on ETD.hsgprocesso=HOU.job_hia and ETD.cd_tp_ocor=15
	LEFT OUTER JOIN hist_geral Saida on Saida.hsgprocesso=HOU.job_hia and Saida.cd_tp_ocor=9
	LEFT OUTER JOIN hist_geral ETA on ETA.hsgprocesso=HOU.job_hia and ETA.cd_tp_ocor=16
	INNER JOIN MASTER_IMP_aer MAS on MAS.num_proc_mia=HOU.num_proc_mia
	INNER JOIN localidade ORIGEM on ORIGEM.cd_local=hou.cd_org_hia
	INNER JOIN localidade DESTINO on DESTINO.cd_local=hou.cd_dst_hia
	LEFT OUTER JOIN  hist_geral PCK on PCK.hsgprocesso=hou.job_hia and PCK.cd_tp_ocor=31
	LEFT OUTER JOIN  hist_geral BRO on BRO.hsgprocesso=hou.job_hia and BRO.cd_tp_ocor=18
	LEFT OUTER JOIN  hist_geral FIM on FIM.hsgprocesso=hou.job_hia and FIM.cd_tp_ocor=11
	LEFT OUTER JOIN  po_hia PO on hou.job_hia=PO.num_proc_hia
where 
	left(job_hia,5)='iajob' and fim.hsgData is null
	and convert(datetime,hou.dt_emis_hia,105) >=convert(datetime,'11/05/2005',105)
	and buyer.apelido like @APELIDO	










GO
