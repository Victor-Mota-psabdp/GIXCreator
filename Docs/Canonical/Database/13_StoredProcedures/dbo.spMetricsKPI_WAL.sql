SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











--[spMetricsKPI_WAL] '2009','I%WAL%'

CREATE Procedure [dbo].[spMetricsKPI_WAL]
	@Ano Char(4),
	@Referencia Char(5)
as

select 
	distinct cd_tipo,num_po, Num_proc_lim Job,num_pedido, null OrderType,'Marítimo' Modal, 
	Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) Dispatch,nome_tp_carga,
	--LI.Numero_PO_HIM,
	dst.nome_local,convert(varchar(10),ata_lim,103) ATA, 
	convert(varchar(10),dt_conclusao,103) Desembaraco, dbo.quantidade_dias(ata_lim,dt_conclusao) Dias,Canal_lim,business_group_descr, Business_Descr, '' Planta,
	Nome_raz_soc Cliente,cast((Dt_Conclusao - ATA_Lim) as int) Dias_Corridos
	,dbo.quantidade_dias(ata_lim,Isnull(dbo.fbusca_tarefa(num_proc_lim,7),NF.Data_PO_HIM)) Doc_DU,
	cast((isnull(dbo.fBusca_Tarefa(num_proc_lim,7),NF.data_po_him)-ata_lim) as int) DOC_Transport_Corridos,
	Isnull(dbo.fbusca_tarefa(num_proc_lim,7),Isnull(NF.Data_PO_HIM,Dt_Conclusao)) DataDOC,
	Isnull(dbo.fbusca_tarefa(num_proc_lim,13),getdate()) Good_Receipt_DT, 
	dbo.quantidade_dias(ATA_LIM,dbo.fbusca_tarefa(num_proc_lim,13)) Biz_Days_GR,
	Cast((dbo.fbusca_tarefa(num_proc_lim,13)-ata_lim) as int) Run_Days_GR,
	dbo.fbusca_tarefa(num_proc_lim,50) Recebimento_Processo,
	convert(datetime,dt_emis_him,105) Register_Date, 
	dbo.fbusca_tarefa(num_proc_lim,47) Data_Classificacao,cast(dbo.fbusca_tarefa(num_proc_lim,47)-dbo.fbusca_tarefa(num_proc_lim,50) as int) Dias_Classificao_Corridos, dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lim,50),dbo.fbusca_tarefa(num_proc_lim,47)) Dias_Classificacao_Uteis,
	dbo.fbusca_tarefa(num_proc_lim,43) Custo_Estimado, cast(dbo.fbusca_tarefa(num_proc_lim,43)-dbo.fbusca_tarefa(num_proc_lim,47) as int) Dias_CustoEstimado_Corridos, dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lim,47),dbo.fbusca_tarefa(num_proc_lim,43)) Dias_CustoEstimado_Uteis
	,dbo.fBusca_tarefa(num_proc_lim,69) Custo_Revisado,cast(dbo.fBusca_tarefa(num_proc_lim,69)-dbo.fBusca_TipoDocCliente('D',num_proc_lim,5) as int) Dias_CustoRevisado_Corridos
	, dbo.quantidade_dias(dbo.fbusca_tipodoccliente('D',num_proc_lim,5),dbo.fbusca_tarefa(num_proc_lim,69)) Dias_CustoRevisados_Uteis
	,dbo.fBusca_tarefa(num_proc_lim,44) Envio_Label,cast(dbo.fbusca_tarefa(num_proc_lim,44)-dbo.fbusca_tarefa(num_proc_lim,50) as int) Dias_Label_Corridos, dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lim,50),dbo.fbusca_tarefa(num_proc_lim,44)) Dias_Label_Uteis
	,dbo.fBusca_tarefa(num_proc_lim,45) Envio_SI,cast(dbo.fbusca_tarefa(num_proc_lim,45)-dbo.fbusca_tarefa(num_proc_lim,50) as int) Dias_SI,dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lim,50),dbo.fbusca_tarefa(num_proc_lim,45)) Dias_SI_Uteis
	,dbo.fbusca_tarefa(num_proc_lim,46) Solicitacao_LI,
	dbo.fbusca_tarefa(num_proc_lim,20) Def_LI
	,isnull(JN.DataFinal,JP.DataFinal)DataFinal, (cast(Etd_lim-isnull(jn.datafinal,jp.DataFinal) as int)) Dias_Corridos_Janelas
	,cast(ATD_LIM-ETD_LIM as int) Dias_Corridos_ATD,dbo.quantidade_dias(ETD_LIM,ATD_LIM) Dias_ATD_Uteis
	,cast(dbo.fbusca_tarefa(num_proc_lim,15)-ATA_LIM as int) Dias_Presencao_Corridos, dbo.quantidade_dias(ata_lim,dbo.fbusca_tarefa(num_proc_lim,15)) Dias_Presenca_Uteis
	,cast(dbo.fBusca_TipoDocCliente('D',num_proc_lim,5)-dbo.fbusca_tarefa(num_proc_lim,15) as int) Dias_Corridos_RegistroDI, dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lim,15),dbo.fBusca_TipoDocCliente('D',num_proc_lim,5)) Dias_Uteis_Registro_DI,
	org.nome_local Origem,
	cast(dbo.fbusca_tarefa(num_proc_lim,4)-dbo.fBusca_TipoDocCliente('D',num_proc_lim,5) as int) Liberacao_Corridos,
	dbo.quantidade_dias(dbo.fBusca_TipoDocCliente('D',num_proc_lim,5),dbo.fbusca_tarefa(num_proc_lim,4)) Liberacao_Uteis,
	left((datename(month,dbo.fbusca_tarefa(num_proc_lim,43))),3) Custo_Estimado_MES_Int,
	dbo.fbusca_tarefa(num_proc_lim,72) Rec_Item,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lim,74),dbo.fbusca_tipodoccliente('D',num_proc_lim,10)) Dias_Corridos_NF,
	cast(dbo.fbusca_tipodoccliente('D',num_proc_lim,10)-dbo.fbusca_tarefa(num_proc_lim,74) as int) Dias_Uteis_NF,
	dbo.[fBusca_CampoCliente](num_proc_lim,19) Evento,

	/*
	left(datename(month,dbo.fbusca_tarefa(num_proc_lim,13)),3) GR_Mes,
	left(datename(month,dbo.fbusca_tarefa(num_proc_lim,47)),3) Class_Mes,
	left(datename(month,dbo.fBusca_tarefa(num_proc_lim,69)),3) CustoRevisado_Mes
	,left(datename(month,dbo.fBusca_tarefa(num_proc_lim,44)),3) Label_Mes,
	left(datename(month,dbo.fBusca_tarefa(num_proc_lim,45)),3) EnvioSI_Mes,
	left(Datename(month,dbo.fbusca_tarefa(num_proc_lim,20)),3) LI_Mes	,
	left(datename(month,atd_lim),3) ATD_Mes,
	left(datename(month,dbo.fbusca_tarefa(num_proc_lim,15)),3) Presenca_Mes,
	left(datename(month,dbo.fBusca_TipoDocCliente('D',num_proc_lim,5)),3) Registro_Mes,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lim,46),dbo.fbusca_tarefa(num_proc_lim,20)) DIAS_LI,
	cast(dbo.fbusca_tarefa(num_proc_lim,20)-dbo.fbusca_tarefa(num_proc_lim,46) as int) DIAS_LI_Corridos,
	datename(month,dbo.fbusca_tarefa(num_proc_lim,20)) LI_MEs
	*/
	dbo.fbusca_tarefa(num_proc_lim,13) GR_Mes,
	dbo.fbusca_tarefa(num_proc_lim,47) Class_Mes,
	dbo.fBusca_tarefa(num_proc_lim,69) CustoRevisado_Mes,
	dbo.fBusca_tarefa(num_proc_lim,44) Label_Mes,
	dbo.fBusca_tarefa(num_proc_lim,45) EnvioSI_Mes,
	dbo.fbusca_tarefa(num_proc_lim,20)  LI_Mes	,
	atd_lim  ATD_Mes,
	dbo.fbusca_tarefa(num_proc_lim,15)  Presenca_Mes,
	cast(dbo.fBusca_TipoDocCliente('D',num_proc_lim,5) as datetime) Registro_Mes,
	dbo.quantidade_dias(dbo.fbusca_tarefa(num_proc_lim,46),dbo.fbusca_tarefa(num_proc_lim,20)) DIAS_LI,
	cast(dbo.fbusca_tarefa(num_proc_lim,20)-dbo.fbusca_tarefa(num_proc_lim,46) as int) DIAS_LI_Corridos,
	dbo.fbusca_tarefa(num_proc_lim,20) LI_MEs
	



	
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
--	Left Join PO_HIM LI on num_proc_lim=li.num_proc_him and LI.id_dc=23
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Left Join PO_HIM NF on num_proc_lim=NF.num_proc_him and NF.ID_DC=10
	Join Janela_Processos JP on JP.num_proc=num_proc_lim and JP.id_janela=1
	Left Join Janela_Processos JN on JN.num_proc=num_proc_lim and JN.id_janela=2

Where left(num_proc_lim,5) like @Referencia and cd_dst_him <>'SAP'
--	and 
--	(year(dt_conclusao)=@ano or year(dbo.fbusca_tarefa(num_proc_lim,43))=@Ano)
--	and year(convert(datetime,dt_emis_him,105))=@Ano
/**


UNION

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



from house_imp_out HOU
Join LLP_Imp_out LLP on LLP.num_proc_lio=hou.num_proc_hio
Join Localidade ORG on ORG.cd_local=cd_org_hio
Join Localidade DST on DST.cd_local=cd_dst_hio
Left Join Pedido_Ship PS on PS.num_proc=num_proc_lio
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_lio and ID_Task=4
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_hio LI on num_proc_lio=li.num_proc_hio and id_dc=23
Join Pessoa PP on PP.cd_pes=cd_consig_hio
	Left Join PO_HIO NF on num_proc_lio=NF.num_proc_hio and NF.ID_DC=10

Where dt_conclusao is not null
and Tipo_Lio='T'
and left(num_proc_lio,5) like @Referencia
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



from house_imp_out HOU
Join LLP_Imp_out LLP on LLP.num_proc_lio=hou.num_proc_hio
Join Localidade ORG on ORG.cd_local=cd_org_hio
Join Localidade DST on DST.cd_local=cd_dst_hio
Left Join Pedido_Ship PS on PS.num_proc=num_proc_lio
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_lio and ID_Task=4
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_hio LI on num_proc_lio=li.num_proc_hio and id_dc=23
Join Pessoa PP on PP.cd_pes=cd_consig_hio
Left Join PO_HIO NF on num_proc_lio=NF.num_proc_hio and NF.ID_DC=10

Where dt_conclusao is not null
and Tipo_Lio='R'
and left(num_proc_lio,5) like @Referencia
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



from house_imp_aer HOU
Join LLP_Imp_aer LLP on LLP.num_proc_lia=hou.num_proc_hia
Join Localidade ORG on ORG.cd_local=cd_org_hia
Join Localidade DST on DST.cd_local=cd_dst_hia
Left Join Pedido_Ship PS on PS.num_proc=num_proc_lia
Left Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Left Join De_ParA_PRoduto DPP on DPP.gmid=cd_proc_cliente
Left Join tarefas_processos TP on TP.num_proc=num_proc_lia and ID_Task=4
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Left Join PO_hia LI on num_proc_lia=li.num_proc_hia and id_dc=23
Join Pessoa PP on PP.cd_pes=cd_consig_hia
Left Join PO_HIa NF on num_proc_lia=NF.num_proc_hia and NF.ID_DC=10

Where dt_conclusao is not null
and left(num_proc_liA,5) like @Referencia
and year(dt_conclusao)=@ano










**/











GO
