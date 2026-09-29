SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spMetricsKPI_BDPWAL]  --'2009'
	@Ano Char(4)
as


select 
	 Distinct convert(datetime,Dt_Emis_Him,105) Data_Abertura, dbo.fbusca_tarefa(num_proc_lim,16	)Chegada_Docs,ATD_LIM ATD,ETD_LIM ETD,dbo.fbusca_tarefa(num_proc_lim,20	)Def_LI, dbo.fbusca_tarefa(num_proc_lim,46)Sol_LI,dbo.fbusca_tarefa(num_proc_lim,58)Sol_Booking,dbo.fbusca_tarefa(num_proc_lim,5)Booking, dbo.fbusca_tarefa(num_proc_lim,45)Shipping, dbo.fbusca_tarefa(num_proc_lim,44)Etiqueta, dbo.fbusca_tarefa(num_proc_lim,43) Envio_Custo,dbo.fbusca_tarefa(num_proc_lim,47) Envio_Capa,cd_tipo,num_po, Num_proc_lim Job,num_pedido, null OrderType,'Marítimo' Modal, 
	Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) Dispatch,nome_tp_carga,LI.Numero_PO_HIM,dst.nome_local,convert(varchar(10),ata_lim,103) ATA, 
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
	CAST(DI.Data_PO_HIM-dbo.fbusca_tarefa(num_proc_lim,15) as int) Dias_PC_DI, dbo.FBusca_Prestacao(num_proc_lim) Prestacao,
	CAST(convert(datetime,Dt_Emis_Him,105)-dbo.fbusca_tarefa(num_proc_lim,47) as int) Run_Classificacao, dbo.fbusca_tarefa(num_proc_lim,47) DT_Classificacao,
	dbo.fbusca_tarefa(num_proc_lim,29) Desova,dbo.fbusca_tarefa(num_proc_lim,28) Terminal,
	dbo.fBusca_TipoDocCliente ('N',num_proc_lim,24) DrawBack, dbo.fbusca_tarefa(num_proc_lim,7) Doc_Transporte ,
	dbo.fbusca_tarefa(num_proc_lim,56) Autorizacao_DI,PRO.data_PO_HIM data_proforma,
	dbo.fbusca_tarefa(num_proc_lim,50) Recebimento_Processo, DataFinal Data_Janela,
	dbo.fbusca_tarefa(num_proc_lim,69) Custo_Revisado

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
	Left Join PO_HIM LI on num_proc_lim=li.num_proc_him and LI.id_dc=23
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	Left Join PO_HIM NF on num_proc_lim=NF.num_proc_him and NF.ID_DC=10
	Left Join PO_HIM DI on num_proc_lim=DI.num_proc_him and DI.ID_DC=5
	Left Join PO_HIM PRO on num_proc_lim=PRO.num_proc_him and PRO.ID_DC=38
	Join Janela_Processos JP on jp.num_proc=hou.num_proc_him and id_janela=1
Where --dt_conclusao is not null
	--and 
	right(left(num_proc_lim,5),3) in (select grupo from grupo where smart_exp='WAL')
--	and year(dt_conclusao)=@ano









GO
