SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

Create   procedure spAuditorIM

as

select 
	convert(Datetime,dt_emis_him,105) Emissao, hou.num_proc_him JOB,po.numero_po_him Num_PO, customer_po.numero_po_him customer_po,NR_Reserva,
	ETD_Lim ETD, ATD_LIM ATD,ETA_LIM ETA, ATA_LIM ATA,Peso_bruto_him Peso_Bruto, Peso_Liquido_him Peso_Liquido,
	Navio_Him Navio,Viagem_him Viagem,Invoice.Numero_PO_HIM Invoice,SHP.NUM_Proc Doc_Anexos,DI.NUm_proc DI_Anexos,
	DI_Number.Numero_po_him DI_Number,Desemb.Dt_Conclusao Desemb,Canal_Lim Canal,Saida_Planta.DT_Conclusao Saida_Planta,
	Entrega_Planta.DT_Conclusao Entrega_Planta,nome_armador,Nome_Usuario,hou.mawb_him  MAWB,Chegada_Docs.Dt_Conclusao Chegada_docs


 from house_imp_mar hou
Left Join Po_HIM PO on PO.num_proc_him=hou.num_proc_Him and po.ID_DC=1
Left Join Po_HIM Customer_PO on customer_po.num_proc_him=hou.num_proc_Him and customer_po.ID_DC=9
join job_imp_mar job on job.num_proc_him=hou.num_proc_him
join llp_imp_mar on hou.num_proc_him=num_proc_lim
Left Join Po_HIM Invoice on Invoice.num_proc_him=hou.num_proc_Him and Invoice.ID_DC=1
Left Join Po_HIM DI_Number on DI_Number.num_proc_him=hou.num_proc_Him and DI_Number.ID_DC=5
LEft Join Doc_Anexos SHP on hou.num_proc_him=SHP.num_proc and SHP.id_dc=20
LEft Join Doc_Anexos DI on hou.num_proc_him=DI.num_proc and DI.id_dc=5
left join Tarefas_Processos Desemb on HOU.num_proc_him=Desemb.num_proc and Desemb.Id_Task=4
left join Tarefas_Processos Saida_Planta on HOU.num_proc_him=Saida_Planta.num_proc and Saida_Planta.Id_Task=10
left join Tarefas_Processos Entrega_Planta on HOU.num_proc_him=Entrega_Planta.num_proc and Entrega_Planta.Id_Task=13
left join armador arm on arm.cd_armador=job.cd_armador
left join usuario US on US.cd_usuario=job.cd_usuario
left join Tarefas_Processos Chegada_Docs on HOU.num_proc_him=Chegada_Docs.num_proc and Chegada_Docs.Id_Task=16

UNION

select 
	convert(Datetime,dt_emis_HIO,105) Emissao, hou.num_proc_HIO JOB,po.numero_po_HIO Num_PO, customer_po.numero_po_HIO customer_po,'N/A' NR_RESERVA,
	ETD_LIO ETD, ATD_LIO ATD,ETA_LIO ETA, ATA_LIO ATA,Peso_bruto_HIO Peso_Bruto, 1 Peso_Liquido,
	'N/A' Navio,'N/A' Viagem,Invoice.Numero_PO_HIO Invoice,SHP.NUM_Proc Doc_Anexos,DI.NUm_proc DI_Anexos,
	DI_Number.Numero_po_HIO DI_Number,Desemb.Dt_Conclusao Desemb,Canal_LIO Canal,Saida_Planta.DT_Conclusao Saida_Planta,
	Entrega_Planta.DT_Conclusao Entrega_Planta,APELIDO nome_armador,Nome_Usuario,hou.mawb_HIO  MAWB,Chegada_Docs.Dt_Conclusao Chegada_docs


 from house_imp_OUT hou
Left Join Po_HIO PO on PO.num_proc_HIO=hou.num_proc_HIO and po.ID_DC=1
Left Join Po_HIO Customer_PO on customer_po.num_proc_HIO=hou.num_proc_HIO and customer_po.ID_DC=9
join llp_imp_OUT LLP on hou.num_proc_HIO=num_proc_LIO
Left Join Po_HIO Invoice on Invoice.num_proc_HIO=hou.num_proc_HIO and Invoice.ID_DC=1
Left Join Po_HIO DI_Number on DI_Number.num_proc_HIO=hou.num_proc_HIO and DI_Number.ID_DC=5
LEft Join Doc_Anexos SHP on hou.num_proc_HIO=SHP.num_proc and SHP.id_dc=20
LEft Join Doc_Anexos DI on hou.num_proc_HIO=DI.num_proc and DI.id_dc=5
left join Tarefas_Processos Desemb on HOU.num_proc_HIO=Desemb.num_proc and Desemb.Id_Task=4
left join Tarefas_Processos Saida_Planta on HOU.num_proc_HIO=Saida_Planta.num_proc and Saida_Planta.Id_Task=10
left join Tarefas_Processos Entrega_Planta on HOU.num_proc_HIO=Entrega_Planta.num_proc and Entrega_Planta.Id_Task=13
left join PESSOA arm on ARM.CD_PES=CD_CARRIER
left join usuario US on US.cd_usuario=LLP.cd_usuario
left join Tarefas_Processos Chegada_Docs on HOU.num_proc_HIO=Chegada_Docs.num_proc and Chegada_Docs.Id_Task=16




GO
