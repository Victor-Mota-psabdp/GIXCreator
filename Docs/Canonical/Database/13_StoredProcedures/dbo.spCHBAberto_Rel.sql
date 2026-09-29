SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    Procedure spCHBAberto_Rel

as

select 
	Org.Nome_Local Origem, Dst.Nome_Local Destino, Imp.Apelido Importador,EP.Apelido Exportador,ETd_LIM ETD,
	ATD_LIM ATD, ETA_LIM ETA, ATA_LIM,Navio_him,Nome_Armador,Viagem_him, hou.num_proc_him JOB,po.numero_po_him PO,
	Invoice.numero_po_him Invoice_Imp,Sales_order.numero_po_him SAP_Order, Dt_Conclusao, Dt_Previsao 

 from house_imp_mar HOU
Join Pessoa IMP on IMP.cd_pes=cd_consig_him
Join Pessoa EP on EP.cd_pes=cd_export_him
Join Localidade Org on Org.cd_local=cd_org_him
Join Localidade Dst on Dst.cd_local=cd_dst_him
Join pedido_ship PS on PS.num_proc=hou.num_proc_him
Join Job_imp_mar Job on job.num_proc_him=hou.num_proc_him
Left Join Armador ARM on ARm.cd_armador=job.cd_armador
Join Produto_Cliente PC on PC.cd_prod=ps.cd_produto
Join LLP_imp_mar LLP on LLP.num_proc_lim=hou.num_proC_him
Left Join PO_HIM PO on hou.num_proc_him=po.num_proc_him and PO.id_dc=1
Left Join PO_HIM Invoice on hou.num_proc_him=invoice.num_proc_him and invoice.id_dc=2
Left Join PO_HIM Sales_Order on hou.num_proc_him=Sales_Order.num_proc_him and sales_order.id_dc=3
Left join tarefas_Processos TP on TP.num_proc=hou.num_proc_him and id_task in (select ID_TAsK from tipo_tarefas where smart_conclusao='CustomsReleaseDate')


group by 

Org.Nome_Local , Dst.Nome_Local, Imp.Apelido ,EP.Apelido ,ETd_LIM ,
	ATD_LIM, ETA_LIM, ATA_LIM,Navio_him,Nome_Armador,Viagem_him, hou.num_proc_him ,po.numero_po_him,
	Invoice.numero_po_him ,Sales_order.numero_po_him , Dt_Conclusao, Dt_Previsao 








GO
