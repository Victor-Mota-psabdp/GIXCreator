SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE Procedure [dbo].[spMetricsKPI_BDP]-- '2009'
	@Ano Char(4),
	@SmartCode	Varchar(30)
as


select 
	distinct cd_tipo,num_po, Num_proc_lim Job,num_pedido, null OrderType,'Marítimo' Modal, 
	max(Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga)) Dispatch,nome_tp_carga,dbo.fBusca_TipoDocCliente('N',num_proc_lim,23) Numero_PO_HIM,dst.nome_local ,convert(varchar(10),ata_lim,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(ata_lim,dt_conclusao) Dias,Canal_lim,business_group_descr, Business_Descr, '' Planta,
	Nome_raz_soc Cliente,cast((Dt_Conclusao - ATA_Lim) as int) Dias_Corridos
	,dbo.quantidade_dias(ata_lim,Isnull(dbo.fbusca_tarefa(num_proc_lim,7),NF.Data_PO_HIM)) Doc_DU,
	cast((isnull(dbo.fBusca_Tarefa(num_proc_lim,7),NF.data_po_him)-ata_lim) as int) DOC_Transport_Corridos,
	Isnull(dbo.fbusca_tarefa(num_proc_lim,7),Isnull(NF.Data_PO_HIM,Dt_Conclusao)) DataDOC,
	Isnull(dbo.fbusca_tarefa(num_proc_lim,13),getdate()) Good_Receipt_DT, 
	dbo.quantidade_dias(ATA_LIM,dbo.fbusca_tarefa(num_proc_lim,13)) Biz_Days_GR,
	Cast((dbo.fbusca_tarefa(num_proc_lim,13)-ata_lim) as int) Run_Days_GR,
	dbo.fbusca_tarefa(num_proc_lim,15) Presenca_Carga,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lim,15),dt_conclusao) BIZ_Day_PresencaCarga,
	DI.Data_PO_Him Data_DI, dbo.quantidade_dias(isnull(dbo.fbusca_tarefa(num_proc_lim,56), dbo.fbusca_tarefa(num_proc_lim,15)),DI.Data_PO_Him) BIZ_Day_Presenca_DI,
	CAST(DI.Data_PO_HIM-dbo.fbusca_tarefa(num_proc_lim,15) as int) Dias_PC_DI, dbo.fbusca_tarefa(num_proc_lim,40) Prestacao,
	CAST(convert(datetime,Dt_Emis_Him,105)-dbo.fbusca_tarefa(num_proc_lim,47) as int) Run_Classificacao, dbo.fbusca_tarefa(num_proc_lim,47) DT_Classificacao,
	dbo.fbusca_tarefa(num_proc_lim,29) Desova,dbo.fbusca_tarefa(num_proc_lim,55) Terminal,
	dbo.fBusca_TipoDocCliente ('N',num_proc_lim,24) DrawBack, dbo.fbusca_tarefa(num_proc_lim,7) Doc_Transporte ,
	dbo.fbusca_tarefa(num_proc_lim,56) Autorizacao_DI,
	dbo.[fBusca_CampoCliente](num_proc_lim, 72) DTA ,
	org.nome_local Origem,ATD_LIM ATD,
	dbo.fbusca_tarefa(num_proc_lim,79)  Envio_Draft_Fat,
	dbo.fBusca_TipoDocCliente ('D',num_proc_lim,45) Registro_Dta,
	dbo.fbusca_tarefa(num_proc_lim,18)  Lib_DTA,
	dbo.fbusca_tarefa(num_proc_lim,20) Def_LI,
	[dbo].[fBusca_PRODUTO] (num_proc_lim) Produto,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lim,7),dbo.fbusca_tarefa(num_proc_lim,40)) Dias_PC_DOCT

from house_imp_mar HOU
	Join LLP_Imp_MAr LLP on LLP.num_proc_lim=hou.num_proc_him
	Join Localidade ORG on ORG.cd_local=cd_org_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Left Join Pedido_Ship PS on PS.num_proc=num_proc_lim
	Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos TP on TP.num_proc=num_proc_lim and ID_Task=4
	Join Tipo_Carga TC on TC.cd_tp_carga=LLP.cd_tp_carga
	Left Join Container_hou_imp_mar CH on num_proc_lim=CH.num_proc_him
	Left Join Container_mas_imp_mar CM on CH.num_proc_mim=CM.num_proc_mim and CH.item_cont_im=CM.item_cont_im
	Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	--Left Join PO_HIM LI on num_proc_lim=li.num_proc_him and LI.id_dc=23
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Left Join PO_HIM NF on num_proc_lim=NF.num_proc_him and NF.ID_DC=10
	Left Join PO_HIM DI on num_proc_lim=DI.num_proc_him and DI.ID_DC=5

Where dt_conclusao is not null
	and right(left(num_proc_lim,5),3) in (select grupo from grupo where smart_exp  like @SmartCode)
	and year(dt_conclusao)=@ano

Group by Cd_tipo,Num_PO,Num_Proc_Lim,Num_Pedido,Nome_Tp_Carga,org.Nome_Local,dst.Nome_Local,ata_lim,dt_conclusao,canal_lim,Business_Group_Descr,Business_Descr,Nome_Raz_Soc,NF.Data_PO_HIM,DI.Data_PO_HIM,Dt_Emis_HIM,ATD_lim
UNION

select 
	distinct cd_tipo,num_po,Num_proc_lio Job,num_pedido, null OrderType,'Rodoviário', 
	'Truck','LCL' ,dbo.fBusca_TipoDocCliente('N',num_proc_lio,23) Numero_PO_HIM,dst.nome_local,convert(varchar(10),ata_lio,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(ata_lio,dt_conclusao),Canal_lio,business_group_descr, Business_Descr, '' Planta,
	Nome_Raz_Soc Cliente, CAST((Dt_Conclusao - ATA_Lio) AS INT) Dias, 
	dbo.quantidade_dias(ata_lio,dt_conclusao) Doc_DU,
	cast((isnull(dt_conclusao,NF.data_po_hio)-ata_lio) as int) DOC_Transport_Corridos,
	Dt_Conclusao Data_DOC,
	Isnull(dbo.fbusca_tarefa(num_proc_lio,13),getdate()) Good_Receipt_DT, 
	dbo.quantidade_dias(ATA_LIo,dbo.fbusca_tarefa(num_proc_lio,13)) Biz_Days_GR,
	Cast((dbo.fbusca_tarefa(num_proc_lio,13)-ata_lio) as int) Run_Days_GR,
dbo.fbusca_tarefa(num_proc_lio,15) Presenca_Carga,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lio,15),dt_conclusao) BIZ_Day_PresencaCarga,
	DI.Data_PO_Hio Data_DI, dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lio,15),DI.Data_PO_Hio) BIZ_Day_Presenca_DI,
	CAST(DI.Data_PO_HIo-dbo.fbusca_tarefa(num_proc_lio,15) as int) Dias_PC_DI, dbo.fbusca_tarefa(num_proc_lio,40) Prestacao,
	CAST(convert(datetime,Dt_Emis_Hio,105)-dbo.fbusca_tarefa(num_proc_lio,47) as int) Run_Classificacao, dbo.fbusca_tarefa(num_proc_lio,47) DT_Classificacao,
	Null,Null, dbo.fBusca_TipoDocCliente ('N',num_proc_lio,24) DrawBack, dbo.fbusca_tarefa(num_proc_lio,7) Doc_Transporte,
	dbo.fbusca_tarefa(num_proc_lio,56) Autorizacao_DI,
	dbo.[fBusca_CampoCliente](num_proc_lio, 72) DTA , org.nome_local Origem,ATD_LIO,
	dbo.fbusca_tarefa(num_proc_lio,79)  Envio_Draft_Fat,
	dbo.fBusca_TipoDocCliente ('D',num_proc_lio,45) Registro_Dta,
	dbo.fbusca_tarefa(num_proc_lio,18)  Lib_DTA,
	dbo.fbusca_tarefa(num_proc_lio,20) Def_LI,
	[dbo].[fBusca_PRODUTO] (num_proc_lio) Produto,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lio,7),dbo.fbusca_tarefa(num_proc_lio,40)) Dias_PC_DOCT





from house_imp_out HOU
Join LLP_Imp_out LLP on LLP.num_proc_lio=hou.num_proc_hio
Join Localidade ORG on ORG.cd_local=cd_org_hio
Join Localidade DST on DST.cd_local=cd_dst_hio
Left Join Pedido_Ship PS on PS.num_proc=num_proc_lio
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_lio and ID_Task=4
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--Left Join PO_hio LI on num_proc_lio=li.num_proc_hio and id_dc=23
Join Pessoa PP on PP.cd_pes=cd_consig_hio
	Left Join PO_HIO NF on num_proc_lio=NF.num_proc_hio and NF.ID_DC=10
Left Join PO_HIO DI on num_proc_lio=DI.num_proc_hiO and DI.ID_DC=5
Where dt_conclusao is not null
and Tipo_Lio='T'
and right(left(num_proc_lio,5),3) in (select grupo from grupo where smart_exp  like @SmartCode)
and year(dt_conclusao)=@ano


UNION

select 
	distinct cd_tipo,num_po,Num_proc_lio Job,num_pedido, null OrderType,'Ferroviário', 
	'Rail','LCL' ,dbo.fBusca_TipoDocCliente('N',num_proc_lio,23) Numero_PO_HIM ,dst.nome_local,convert(varchar(10),ata_lio,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(ata_lio,dt_conclusao),Canal_lio,business_group_descr, Business_Descr, '' Planta,
	Nome_Raz_Soc Cliente, cast((Dt_Conclusao - ATA_Lio) as INT) Dias, 
	dbo.quantidade_dias(ata_lio,dt_conclusao) Doc_DU,
	cast((isnull(dt_conclusao,NF.data_po_hio)-ata_lio) as int) DOC_Transport_Corridos,
	DT_Conclusao,
	Isnull(dbo.fbusca_tarefa(num_proc_lio,13),getdate()) Good_Receipt_DT, 
	dbo.quantidade_dias(ATA_LIO,dbo.fbusca_tarefa(num_proc_lio,13)) Biz_Days_GR,
	Cast((dbo.fbusca_tarefa(num_proc_lio,13)-ata_lio) as int) Run_Days_GR,
	dbo.fbusca_tarefa(num_proc_lio,15) Presenca_Carga,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lio,15),dt_conclusao) BIZ_Day_PresencaCarga,
	DI.Data_PO_Hio Data_DI, dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lio,15),DI.Data_PO_Hio) BIZ_Day_Presenca_DI,
	CAST(DI.Data_PO_HIo-dbo.fbusca_tarefa(num_proc_lio,15) as int) Dias_PC_DI, dbo.fbusca_tarefa(num_proc_lio,40) Prestacao,
	CAST(convert(datetime,Dt_Emis_Hio,105)-dbo.fbusca_tarefa(num_proc_lio,47) as int) Run_Classificacao, dbo.fbusca_tarefa(num_proc_lio,47) DT_Classificacao,
	null,null,  dbo.fBusca_TipoDocCliente ('N',num_proc_lio,24) DrawBack, dbo.fbusca_tarefa(num_proc_lio,7) Doc_Transporte,
	dbo.fbusca_tarefa(num_proc_lio,56) Autorizacao_DI,
	dbo.[fBusca_CampoCliente](num_proc_lio, 72) DTA ,org.nome_local Origem,ATD_LIO,
	dbo.fbusca_tarefa(num_proc_lio,79)  Envio_Draft_Fat,
	dbo.fBusca_TipoDocCliente ('D',num_proc_lio,45) Registro_Dta,
	dbo.fbusca_tarefa(num_proc_lio,18)  Lib_DTA,
	dbo.fbusca_tarefa(num_proc_lio,20) Def_LI,
	[dbo].[fBusca_PRODUTO] (num_proc_lio) Produto,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lio,7),dbo.fbusca_tarefa(num_proc_lio,40)) Dias_PC_DOCT











from house_imp_out HOU
Join LLP_Imp_out LLP on LLP.num_proc_lio=hou.num_proc_hio
Join Localidade ORG on ORG.cd_local=cd_org_hio
Join Localidade DST on DST.cd_local=cd_dst_hio
Left Join Pedido_Ship PS on PS.num_proc=num_proc_lio
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_lio and ID_Task=4
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--Left Join PO_hio LI on num_proc_lio=li.num_proc_hio and id_dc=23
Join Pessoa PP on PP.cd_pes=cd_consig_hio
Left Join PO_HIO NF on num_proc_lio=NF.num_proc_hio and NF.ID_DC=10
Left Join PO_HIO DI on num_proc_lio=DI.num_proc_hio and DI.ID_DC=5
Where dt_conclusao is not null
and Tipo_Lio='R'
and right(left(num_proc_lio,5),3) in (select grupo from grupo where smart_exp  like @SmartCode)
and year(dt_conclusao)=@ano


union



select 
	distinct cd_tipo,num_po,Num_proc_lia Job,num_pedido, null OrderType,'Aéreo', 
	'Air','LCL' ,dbo.fBusca_TipoDocCliente('N',num_proc_lia,23) Numero_PO_HIA ,dst.nome_local,convert(varchar(10),ata_lia,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(ata_lia,dt_conclusao),Canal_lia,business_group_descr, Business_Descr , '' Planta,
	Nome_Raz_Soc Cliente, cast((Dt_Conclusao - ATA_Lia) as int) Dias,
	dbo.quantidade_dias(ata_lia,Isnull(dbo.fbusca_tarefa(num_proc_lia,7),NF.Data_PO_HIa)) Doc_DU,
	cast((isnull(dbo.fBusca_Tarefa(num_proc_lia,7),NF.data_po_hia)-ata_lia) as int) DOC_Transport_Corridos,
	Isnull(dbo.fbusca_tarefa(num_proc_lia,7),Isnull(NF.Data_PO_HIa,Dt_Conclusao)) DataDOC,
	Isnull(dbo.fbusca_tarefa(num_proc_lia,13),getdate()) Good_Receipt_DT, 
	dbo.quantidade_dias(ATA_LIA,dbo.fbusca_tarefa(num_proc_lia,13)) Biz_Days_GR,
	Cast((dbo.fbusca_tarefa(num_proc_lia,13)-ata_lia) as int) Run_Days_GR,
dbo.fbusca_tarefa(num_proc_lia,15) Presenca_Carga,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lia,15),dt_conclusao) BIZ_Day_PresencaCarga,
	DI.Data_PO_Hia Data_DI, dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lia,15),DI.Data_PO_Hia) BIZ_Day_Presenca_DI,

	CAST(DI.Data_PO_HIa-dbo.fbusca_tarefa(num_proc_lia,15) as int) Dias_PC_DI, dbo.fbusca_tarefa(num_proc_lia,40) Prestacao,
	CAST(convert(datetime,Dt_Emis_Hia,105)-dbo.fbusca_tarefa(num_proc_lia,47) as int) Run_Classificacao, dbo.fbusca_tarefa(num_proc_lia,47) DT_Classificacao,
	NULL,NULL,  dbo.fBusca_TipoDocCliente ('N',num_proc_lia,24) DrawBack, dbo.fbusca_tarefa(num_proc_lia,7) Doc_Transporte,
	dbo.fbusca_tarefa(num_proc_lia,56) Autorizacao_DI,
	dbo.[fBusca_CampoCliente](num_proc_lia, 72) DTA ,org.nome_local Origem,ATD_LIA,
	dbo.fbusca_tarefa(num_proc_liA,79)  Envio_Draft_Fat,
	dbo.fBusca_TipoDocCliente ('D',num_proc_lia,45) Registro_Dta ,
	dbo.fbusca_tarefa(num_proc_liA,18)  Lib_DTA,
	dbo.fbusca_tarefa(num_proc_lia,20) Def_LI,
	[dbo].[fBusca_PRODUTO] (num_proc_lia) Produto,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lia,7),dbo.fbusca_tarefa(num_proc_lia,40)) Dias_PC_DOCT











from house_imp_aer HOU
Join LLP_Imp_aer LLP on LLP.num_proc_lia=hou.num_proc_hia
Join Localidade ORG on ORG.cd_local=cd_org_hia
Join Localidade DST on DST.cd_local=cd_dst_hia
Left Join Pedido_Ship PS on PS.num_proc=num_proc_lia
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_lia and ID_Task=4
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--Left Join PO_hia LI on num_proc_lia=li.num_proc_hia and id_dc=23
Join Pessoa PP on PP.cd_pes=cd_consig_hia
Left Join PO_HIa NF on num_proc_lia=NF.num_proc_hia and NF.ID_DC=10
Left Join PO_HIA DI on num_proc_lia=DI.num_proc_hia and DI.ID_DC=5
Where dt_conclusao is not null
and right(left(num_proc_lia,5),3) in (select grupo from grupo where smart_exp  like @SmartCode)
and year(dt_conclusao)=@ano






























GO
