SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[spReportManagerD1]
	
		@Processo Varchar(16)

 
as
select 
	hou.Num_Proc_HIM Processo,
	hou.MAWB_HIM MAWB,
	HAWB_HIM HAWB,
	ETA_LIM ETA,
	ATA_LIM ATA,
	ETD_LIM ETD,
	ATD_LIM ATD, 
	Nome_Armador Armador,
	Navio_HIM Navio, 
	Num_Pedido, 
	Isnull(PO.numero_po_him,Num_Po) Num_PO,
	isnull(Customer_PO.numero_PO_HIM,Customer_PO) Customer_PO,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,
	TP.Dt_Previsao,TP.Dt_Conclusao,
	Business_Group_Descr,
	null Tipo,
	Canal_Lim Canal,
	dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico,
	dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_him) Historico_Completo,
	dbo.FBusca_Adto(hou.num_proc_him) Adto, 
	dbo.FBusca_Caixa(hou.num_proc_him) Caixa, 
	DI.Numero_PO_Him DI, 
	DI.Data_PO_Him Data_DI,
	dbo.fBusca_Tarefa(hou.num_proc_him,3) Liberacao_BL,
	dbo.fBusca_Tarefa_Prev(hou.num_proc_him,13) Prev_Entrega,
	dbo.fBusca_Tarefa(hou.num_proc_him,13) Entrega_Planta,
	LI.Data_PO_HIM Data_LI,
	LI.Numero_PO_HIM Num_LI,
	dbo.fBusca_Tarefa(hou.num_proc_him,20) Def_LI,
	dbo.fBusca_Tarefa(hou.num_proc_him,23) Envio_Docs_Cambio,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_him,54),ETA_Lim +7)	Previsao,
	PO_GRP,
	dbo.fBusca_Tarefa(hou.num_proc_him,7) Entr_Docs_Transp,
	dbo.fBusca_Tarefa(hou.num_proc_him,26) Envio_Docs_Fat,
	dbo.fBusca_Tarefa(hou.num_proc_him,15) Presenca_Carga,
	dbo.fBusca_Tarefa(hou.num_proc_him,27) Digitacao_DI,
	dbo.fBusca_Tarefa(hou.num_proc_him,28) Entrada_Terminal,
	dbo.fBusca_Tarefa(hou.num_proc_him,29) Desova,
	dbo.fBusca_Tarefa(hou.num_proc_him,30) Receb_Insp_Madeira,
	GMID
from
	house_imp_mar HOU
	Join LLp_imp_mar LLP on LLP.num_proc_LIM=hou.num_proc_HIM
	left Join Job_imp_mar JOB on JOB.num_proc_him=hou.num_proc_him
	left Join Armador ARM on ARM.cd_armador=job.cd_armador
	left Join Pedido_Ship PS on PS.num_proc=hou.num_proc_HIM
	left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det PDET	on PDET.cd_pedido=PS.cd_pedido --and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente PC on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP on DP.gmid=cd_proc_cliente
	left Join Localidade Org on hou.cd_org_HIM=Org.cd_local
	left Join Localidade Dst on cd_dst_HIM=DSt.cd_local
	Left Join Tarefas_Processos TP on TP.num_proc=hou.num_proc_HIM and TP.ID_Task=4
	Left Join PO_HIM DI on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
	Left Join PO_HIM PO on PO.Num_Proc_Him=hou.num_proc_him and PO.id_dc=1
	Left Join PO_HIM Customer_PO on Customer_PO.Num_Proc_Him=hou.num_proc_him and Customer_PO.id_dc=9
	Left Join PO_HIM LI on LI.Num_Proc_Him=hou.num_proc_him and LI.id_dc=23
	Left Join Tarefas_Processos ENTREGA on ENTREGA.num_proc=hou.num_proc_HIM and ENTREGA.ID_Task=13
	Join Pessoa_LLP	PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo='1'
Where 
	HOU.num_proc_him=@processo
group by
	hou.Num_Proc_HIM ,hou.MAWB_HIM ,HAWB_HIM ,ETA_LIM ,ATA_LIM,
	ETD_LIM,ATD_LIM, Nome_Armador ,Navio_HIM, Num_Pedido, Num_Po,Customer_PO,Org.Nome_Local,
	Dst.Nome_Local ,TP.Dt_Previsao,TP.Dt_Conclusao,Business_Group_Descr, ATA_LIM ,Canal_Lim,
	dbo.FBusca_Adto(hou.num_proc_him) , dbo.FBusca_Caixa(hou.num_proc_him) ,DI.Numero_PO_Him, DI.Data_PO_Him,
	po.numero_po_him,customer_PO.numero_po_him,/*FCHB.Data_PC,*/LI.Data_PO_HIM,LI.Numero_PO_HIM,PO_GRP,
	GMID

UNION

select 
	hou.Num_Proc_HIA Processo,hou.MAWB_HIA MAWB,HAWB_HIA HAWB,ETA_LIA ETA,ATA_LIA ATA,
	ETD_LIA ETD,ATD_LIA ATD, Nome_Cia_Aer Armador,Voo_HIA Navio, Num_Pedido, 
	Isnull(po.numero_po_hia,Num_Po) num_po,
	Isnull(Customer_PO.numero_po_hia,Customer_PO) Customer_PO,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,TP.Dt_Previsao,TP.Dt_Conclusao,Business_Group_Descr,null,Canal_Lia Canal,dbo.fBusca_HistoricoDescr(hou.num_proc_hia,0,getdate()) Historico,
	dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hia) Historico_Completo,
	dbo.FBusca_Adto(hou.num_proc_hia) Adto, dbo.FBusca_Caixa(hou.num_proc_hia) Caixa, DI.Numero_PO_Hia DI, DI.Data_PO_Hia Data_DI,
	dbo.fBusca_Tarefa(hou.num_proc_hia,3) Liberacao_BL,
	dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,13) Prev_Entrega,
	dbo.fBusca_Tarefa(hou.num_proc_hia,13) Entrega_Planta,
	LI.Data_PO_HIA Data_LI,
	LI.Numero_PO_HIA Num_LI,
	dbo.fBusca_Tarefa(hou.num_proc_hia,20) Def_LI,
	dbo.fBusca_Tarefa(hou.num_proc_hia,23) Envio_Docs_Cambio,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_hia,54),ETA_Lia +7)	Previsao,
	PO_GRP,
	dbo.fBusca_Tarefa(hou.num_proc_hia,7) Entr_Docs_Transp,
	dbo.fBusca_Tarefa(hou.num_proc_hia,26) Envio_Docs_Fat,
	dbo.fBusca_Tarefa(hou.num_proc_hia,15) Presenca_Carga,
	dbo.fBusca_Tarefa(hou.num_proc_hia,27) Digitacao_DI,
	dbo.fBusca_Tarefa(hou.num_proc_hia,28) Entrada_Terminal,
	dbo.fBusca_Tarefa(hou.num_proc_hia,29) Desova,
	dbo.fBusca_Tarefa(hou.num_proc_hia,30) Receb_Insp_Madeira,
	GMID
from
	house_imp_AER HOU
	Join LLp_imp_AER LLP on LLP.num_proc_LIA=hou.num_proc_HIA
	left Join Job_imp_aer JOB on JOB.num_proc_hia=HOU.num_proc_hia
	left Join Cia_Aerea ARM on ARM.cd_cia_Aer=job.cd_cia_aer
	left Join Pedido_Ship PS on PS.num_proc=hou.num_proc_HIA
	left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det PDET on PDET.cd_pedido=PS.cd_pedido --and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente PC on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP on DP.gmid=cd_proc_cliente
	left Join Localidade Org on hou.cd_org_HIA=Org.cd_local
	left Join Localidade Dst on cd_dst_HIA=DSt.cd_local
	Left Join Tarefas_Processos TP on TP.num_proc=hou.num_proc_HIA and TP.ID_Task=4
	Left Join PO_HIA DI on DI.Num_Proc_Hia=hou.num_proc_hia and id_dc=5
	Left Join PO_HIA PO on PO.Num_Proc_Hia=hou.num_proc_hia and PO.id_dc=1
	Left Join PO_HIA Customer_PO on Customer_PO.Num_Proc_Hia=hou.num_proc_hia and Customer_PO.id_dc=9
	Left Join PO_HIA LI on LI.Num_Proc_Hia=hou.num_proc_hia and LI.id_dc=23
	Left Join Tarefas_Processos ENTREGA on ENTREGA.num_proc=hou.num_proc_HIA and ENTREGA.ID_Task=13
	Join Pessoa_LLP	PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo='1'
Where 
	HOU.num_proc_hia=@processo

group by
	hou.Num_Proc_HIA ,hou.MAWB_HIA ,HAWB_HIA ,ETA_LIA ,ATA_LIA ,
	ETD_LIA,ATD_LIA, Nome_Cia_Aer ,Voo_HIA, Num_Pedido, Num_Po,Customer_PO,Org.Nome_Local ,
	Dst.Nome_Local ,TP.Dt_Previsao,TP.Dt_Conclusao,Business_Group_Descr,Canal_Lia,
	dbo.FBusca_Adto(hou.num_proc_hia) , dbo.FBusca_Caixa(hou.num_proc_hia), DI.Numero_PO_Hia, DI.Data_PO_Hia,
	PO.Numero_PO_HIA,Customer_PO.Numero_PO_HIA,/*FCHB.Data_PC,*/LI.Data_PO_HIA,LI.Numero_PO_HIA,PO_GRP,
	GMID


UNION

select 
	hou.Num_Proc_HIO Processo,MAWB_HIO MAWB,HAWB_HIO HAWB,ETA_LIO ETA,ATA_LIO ATA,
	ETD_LIO ETD,ATD_LIO ATD, Nome_Raz_Soc Armador,Null Navio, Num_Pedido, 
	ISNULL(PO.NUMERO_PO_HIO,Num_Po) NUM_PO,
	ISNULL(CUSTOMER_PO.NUMERO_PO_HIO,Customer_PO) CUSTOMER_PO,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,TP.Dt_Previsao,TP.Dt_Conclusao,Business_Group_Descr,Tipo_LIO,Canal_Lio Canal,dbo.fBusca_HistoricoDescr(hou.num_proc_hio,0,getdate()),
	dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hio) Historico_Completo,
	dbo.FBusca_Adto(hou.num_proc_hio) , dbo.FBusca_Caixa(hou.num_proc_hio), DI.Numero_PO_Hio DI, DI.Data_PO_Hio Data_DI,
	dbo.fBusca_Tarefa(hou.num_proc_hio,3) Liberacao_BL,
	dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,13) Prev_Entrega,
	dbo.fBusca_Tarefa(hou.num_proc_hio,13) Entrega_Planta,
	LI.Data_PO_HIO Data_LI,
	LI.Numero_PO_HIO Num_LI,
	dbo.fBusca_Tarefa(hou.num_proc_hio,20) Def_LI,
	dbo.fBusca_Tarefa(hou.num_proc_hio,23) Envio_Docs_Cambio,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_hio,54),ETA_Lio +7)	Previsao,
	PO_GRP,
	dbo.fBusca_Tarefa(hou.num_proc_hio,7) Entr_Docs_Transp,
	dbo.fBusca_Tarefa(hou.num_proc_hio,26) Envio_Docs_Fat,
	dbo.fBusca_Tarefa(hou.num_proc_hio,15) Presenca_Carga,
	dbo.fBusca_Tarefa(hou.num_proc_hio,27) Digitacao_DI,
	dbo.fBusca_Tarefa(hou.num_proc_hio,28) Entrada_Terminal,
	dbo.fBusca_Tarefa(hou.num_proc_hio,29) Desova,
	dbo.fBusca_Tarefa(hou.num_proc_hio,30) Receb_Insp_Madeira,
	GMID
from
	house_imp_out HOU
	Join LLp_imp_out LLP on LLP.num_proc_LIO=hou.num_proc_HIO
	left Join Pessoa ARM on ARM.cd_pes=llp.cd_carrier
	left Join Pedido_Ship PS on PS.num_proc=hou.num_proc_HIO
	left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det PDET on PDET.cd_pedido=PS.cd_pedido --and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente PC on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP on DP.gmid=cd_proc_cliente
	left Join Localidade Org on hou.cd_org_HIO=Org.cd_local
	left Join Localidade Dst on cd_dst_HIO=DSt.cd_local
	Left Join Tarefas_Processos TP on TP.num_proc=hou.num_proc_HIO and TP.ID_Task=4
	Left Join PO_HIO DI on DI.Num_Proc_Hio=hou.num_proc_hio and id_dc=5
	Left Join PO_HIo PO on PO.Num_Proc_HiO=hou.num_proc_hiO and PO.id_dc=1
	Left Join PO_HIO Customer_PO on Customer_PO.Num_Proc_HiO=hou.num_proc_hiO and Customer_PO.id_dc=9
	Left Join PO_HIO LI on LI.Num_Proc_Hio=hou.num_proc_hio and LI.id_dc=23
	Left Join Tarefas_Processos ENTREGA on ENTREGA.num_proc=hou.num_proc_HIO and ENTREGA.ID_Task=13
	Join Pessoa_LLP	PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo='1'
Where 
	HOU.num_proc_hio=@processo

group by
	hou.Num_Proc_HIO ,MAWB_HIO ,HAWB_HIO ,ETA_LIO ,ATA_LIO ,
	ETD_LIO,ATD_LIO, Nome_Raz_Soc , Num_Pedido, Num_Po,Customer_PO,Org.Nome_Local ,
	Dst.Nome_Local ,TP.Dt_Previsao,TP.Dt_Conclusao,Business_Group_Descr,Tipo_LIO,Canal_LiO,
	dbo.FBusca_Adto(hou.num_proc_hio) , dbo.FBusca_Caixa(hou.num_proc_hio), DI.Numero_PO_Hio, DI.Data_PO_Hio,
	PO.Numero_PO_HIO,Customer_PO.Numero_PO_HIO,/*FCHB.Data_PC,*/LI.Data_PO_HIO,LI.Numero_PO_HIO,PO_GRP,
	GMID

order by Processo




GO
