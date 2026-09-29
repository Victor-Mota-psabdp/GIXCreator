SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spMetricsKPI_DOW] --'2010','I%csr'
	@Ano Char(4),
	@Referencia Char(6)
as

select 
	distinct cd_tipo,num_po, Num_proc_lim Job,num_pedido, null OrderType,'Marítimo' Modal, 
	Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) Dispatch,nome_tp_carga,LI.Numero_PO_HIM,dst.nome_local,convert(varchar(10),ata_lim,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(ata_lim,dt_conclusao) Dias,Canal_lim,business_group_descr, Business_Descr, '' Planta,
	Nome_raz_soc Cliente,cast((Dt_Conclusao - ATA_Lim) as int) Dias_Corridos
	,dbo.quantidade_dias(ata_lim,Isnull(dbo.fbusca_tarefa(num_proc_lim,7),NF.Data_PO_HIM)) Doc_DU,
	cast((isnull(dbo.fBusca_Tarefa(num_proc_lim,7),NF.data_po_him)-ata_lim) as int) DOC_Transport_Corridos,
	Isnull(dbo.fbusca_tarefa(num_proc_lim,7),Isnull(NF.Data_PO_HIM,Dt_Conclusao)) DataDOC,
	Isnull(dbo.fbusca_tarefa(num_proc_lim,13),getdate()) Good_Receipt_DT, 
	dbo.quantidade_dias(ATA_LIM,dbo.fbusca_tarefa(num_proc_lim,13)) Biz_Days_GR,
	Cast((dbo.fbusca_tarefa(num_proc_lim,13)-ata_lim) as int) Run_Days_GR	
	,dbo.fbusca_tarefa(num_proc_lim,10) GI, dbo.fbusca_tarefa_prev(num_proc_lim,10) PGI
	,org.nome_local Origem, ETD_LIM ETD, ATD_LIM ATD, ETA_LIM ETA,substring(planta,4,2) Planta,
	dbo.fbusca_tarefa(num_proc_lim,15) Presenca,planta PlantID


	
from house_imp_mar HOU
	Join LLP_Imp_MAr LLP With(nolock) on LLP.num_proc_lim=hou.num_proc_him
	Join Localidade ORG With(nolock)  on ORG.cd_local=cd_org_him
	Join Localidade DST With(nolock)  on DST.cd_local=cd_dst_him
	Left Join Pedido_Ship PS With(nolock)  on PS.num_proc=num_proc_lim
	Left Join Produto_Cliente PC With(nolock)  on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP With(nolock)  on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos TP With(nolock)  on TP.num_proc=num_proc_lim and ID_Task=4
	Join Tipo_Carga TC With(nolock)  on TC.cd_tp_carga=LLP.cd_tp_carga
	Left Join Container_hou_imp_mar CH With(nolock)  on num_proc_lim=CH.num_proc_him
	Left Join Container_mas_imp_mar CM With(nolock)  on CH.num_proc_mim=CM.num_proc_mim and CH.item_cont_im=CM.item_cont_im
	Left Join Pedido PD With(nolock)  on PD.cd_pedido=PS.cd_pedido
	Left Join PO_HIM LI With(nolock)  on num_proc_lim=li.num_proc_him and LI.id_dc=23
	Join Pessoa PP With(nolock)  on PP.cd_pes=cd_consig_him
	Left Join PO_HIM NF With(nolock)  on num_proc_lim=NF.num_proc_him and NF.ID_DC=10
Where dt_conclusao is not null
	and substring(num_proc_lim,3,3) in ('CSR','ROB','STB') 	and year(dt_conclusao)=@ano





UNION ALL

select 
	distinct cd_tipo,num_po,Num_proc_lio Job,num_pedido, null OrderType,'Rodoviário', 
	'Truck','LCL' ,LI.Numero_PO_HIO,dst.nome_local,convert(varchar(10),ata_lio,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(ata_lio,dt_conclusao),Canal_lio,business_group_descr, Business_Descr, '' Planta,
	Nome_Raz_Soc Cliente, CAST((Dt_Conclusao - ATA_Lio) AS INT) Dias, 
	dbo.quantidade_dias(ata_lio,dt_conclusao) Doc_DU,
	cast((isnull(dt_conclusao,NF.data_po_hio)-ata_lio) as int) DOC_Transport_Corridos,
	Dt_Conclusao Data_DOC,
	Isnull(dbo.fbusca_tarefa(num_proc_lio,13),getdate()) Good_Receipt_DT, 
	dbo.quantidade_dias(ATA_LIo,dbo.fbusca_tarefa(num_proc_lio,13)) Biz_Days_GR,
	Cast((dbo.fbusca_tarefa(num_proc_lio,13)-ata_lio) as int) Run_Days_GR
	,dbo.fbusca_tarefa(num_proc_lio,10) GI, dbo.fbusca_tarefa_prev(num_proc_lio,10) PGI
	,org.nome_local Origem, ETD_LIO ETD, ATD_LIO ATD, ETA_LIO ETA,substring(planta,4,2) Planta,
	dbo.fbusca_tarefa(num_proc_lio,15) Presenca,planta




from house_imp_out HOU
	Join LLP_Imp_out LLP with (nolock) on LLP.num_proc_lio=hou.num_proc_hio
	Join Localidade ORG with (nolock)  on ORG.cd_local=cd_org_hio
	Join Localidade DST with (nolock)  on DST.cd_local=cd_dst_hio
	Left Join Pedido_Ship PS with (nolock)  on PS.num_proc=num_proc_lio
	Left Join Produto_Cliente PC with (nolock)  on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP with (nolock)  on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos TP with (nolock)  on TP.num_proc=num_proc_lio and ID_Task=4
	Left Join Pedido PD with (nolock)  on PD.cd_pedido=PS.cd_pedido
	Left Join PO_hio LI with (nolock)  on num_proc_lio=li.num_proc_hio and id_dc=23
	Join Pessoa PP with (nolock)  on PP.cd_pes=cd_consig_hio
	Left Join PO_HIO NF on num_proc_lio=NF.num_proc_hio and NF.ID_DC=10

Where	dt_conclusao is not null
		and Tipo_Lio='T' and
		substring(num_proc_lio,3,3) in ('CSR','ROB','STB')
		and year(dt_conclusao)=@ano


UNION

select 
	distinct cd_tipo,num_po,Num_proc_lio Job,num_pedido, null OrderType,'Ferroviário', 
	'Rail','LCL' ,LI.Numero_PO_HIO,dst.nome_local,convert(varchar(10),ata_lio,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(ata_lio,dt_conclusao),Canal_lio,business_group_descr, Business_Descr, '' Planta,
	Nome_Raz_Soc Cliente, cast((Dt_Conclusao - ATA_Lio) as INT) Dias, 
	dbo.quantidade_dias(ata_lio,dt_conclusao) Doc_DU,
	cast((isnull(dt_conclusao,NF.data_po_hio)-ata_lio) as int) DOC_Transport_Corridos,
	DT_Conclusao,
	Isnull(dbo.fbusca_tarefa(num_proc_lio,13),getdate()) Good_Receipt_DT, 
	dbo.quantidade_dias(ATA_LIO,dbo.fbusca_tarefa(num_proc_lio,13)) Biz_Days_GR,
	Cast((dbo.fbusca_tarefa(num_proc_lio,13)-ata_lio) as int) Run_Days_GR
	,dbo.fbusca_tarefa(num_proc_lio,10) GI, dbo.fbusca_tarefa_prev(num_proc_lio,10) PGI
	,org.nome_local Origem, ETD_LIO ETD, ATD_LIO ATD, ETA_LIO ETA,substring(planta,4,2) Planta,
	dbo.fbusca_tarefa(num_proc_lio,15) Presenca,planta




from house_imp_out HOU
	Join LLP_Imp_out LLP with (nolock)  on LLP.num_proc_lio=hou.num_proc_hio
	Join Localidade ORG with (nolock)  on ORG.cd_local=cd_org_hio
	Join Localidade DST with (nolock)  on DST.cd_local=cd_dst_hio
	Left Join Pedido_Ship PS with (nolock)  on PS.num_proc=num_proc_lio
	Left Join Produto_Cliente PC with (nolock)  on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP with (nolock)  on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos TP with (nolock)  on TP.num_proc=num_proc_lio and ID_Task=4
	Left Join Pedido PD with (nolock)  on PD.cd_pedido=PS.cd_pedido
	Left Join PO_hio LI with (nolock) on num_proc_lio=li.num_proc_hio and id_dc=23
	Join Pessoa PP  with (nolock)  on PP.cd_pes=cd_consig_hio
	Left Join PO_HIO NF with (nolock)  on num_proc_lio=NF.num_proc_hio and NF.ID_DC=10

Where	
		Tipo_Lio='R' and
		(substring(num_proc_lio,3,3) in ('CSR','ROB','STB'))
		and year(dt_conclusao)=@ano

union



select 
	distinct cd_tipo,num_po,Num_proc_lia Job,num_pedido, null OrderType,'Aéreo', 
	'Air','LCL' ,LI.Numero_PO_HIA,dst.nome_local,convert(varchar(10),ata_lia,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(ata_lia,dt_conclusao),Canal_lia,business_group_descr, Business_Descr , '' Planta,
	Nome_Raz_Soc Cliente, cast((Dt_Conclusao - ATA_Lia) as int) Dias,
	dbo.quantidade_dias(ata_lia,Isnull(dbo.fbusca_tarefa(num_proc_lia,7),NF.Data_PO_HIa)) Doc_DU,
	cast((isnull(dbo.fBusca_Tarefa(num_proc_lia,7),NF.data_po_hia)-ata_lia) as int) DOC_Transport_Corridos,
	Isnull(dbo.fbusca_tarefa(num_proc_lia,7),Isnull(NF.Data_PO_HIa,Dt_Conclusao)) DataDOC,
	Isnull(dbo.fbusca_tarefa(num_proc_lia,13),getdate()) Good_Receipt_DT, 
	dbo.quantidade_dias(ATA_LIA,dbo.fbusca_tarefa(num_proc_lia,13)) Biz_Days_GR,
	Cast((dbo.fbusca_tarefa(num_proc_lia,13)-ata_lia) as int) Run_Days_GR
	,dbo.fbusca_tarefa(num_proc_lia,10) GI, dbo.fbusca_tarefa_prev(num_proc_lia,10) PGI
	,org.nome_local Origem, ETD_LIA ETD, ATD_LIA ATD, ETA_LIA ETA, substring(planta,3,2) Planta,
	dbo.fbusca_tarefa(num_proc_liA,15) Presenca,planta




from house_imp_aer HOU
Join LLP_Imp_aer LLP with (nolock)  on LLP.num_proc_lia=hou.num_proc_hia
Join Localidade ORG with (nolock)  on ORG.cd_local=cd_org_hia
Join Localidade DST with (nolock)  on DST.cd_local=cd_dst_hia
Left Join Pedido_Ship PS with (nolock)  on PS.num_proc=num_proc_lia
Left Join Produto_Cliente PC with (nolock)  on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP with (nolock)  on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP with (nolock)  on TP.num_proc=num_proc_lia and ID_Task=4
Left Join Pedido PD with (nolock)  on PD.cd_pedido=PS.cd_pedido
Left Join PO_hia LI with (nolock)  on num_proc_lia=li.num_proc_hia and id_dc=23
Join Pessoa PP with (nolock)  on PP.cd_pes=cd_consig_hia
Left Join PO_HIa NF with (nolock)  on num_proc_lia=NF.num_proc_hia and NF.ID_DC=10

Where 
			substring(num_proc_lia,3,3) in ('CSR','ROB','STB')	
			and year(dt_conclusao)=@ano





















GO
