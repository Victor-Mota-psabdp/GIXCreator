SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE     Procedure [dbo].[spRelaDow_CSP_Exp]
	as
select 
	HOU.Num_Proc_HEM Processo,MAWB_HEM MAWB,HAWB_HEM HAWB,ETA_LEM ETA,ATA_LEM ATA, LLP.Canal_LEM Canal,
	ETD_LEM ETD,ATD_LEM ATD, Nome_Armador Armador,Navio_Hem Navio, 
	Isnull(SO.numero_po_hem,Num_Pedido) Num_pedido,
	isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,1),Num_Po) Num_PO,
	isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,9),Customer_PO) Customer_PO,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,Dt_Previsao,Dt_Conclusao,Business_Group_Descr,null Tipo,
	dbo.fBusca_HistoricoDescr(hou.num_proc_hem,0,getdate()) Historico, RE.Numero_PO_HEM RE, ARK.Numero_PO_HEM Arktec,dbo.fBusca_Tarefa(hou.num_proc_hem,26) Envio_Docs_Fat,
	dbo.fNCM(HOU.Num_Proc_HEM) NCM
from house_exp_mar HOU
	Join LLp_Exp_mar LLP on LLP.num_proc_lem=hou.num_proc_hem
	left Join Armador ARM on ARM.cd_armador=llp.cd_armador_lem
	left Join Pedido_Ship PS on PS.num_proc=hou.num_proc_hem
	left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	left Join Produto_cliente PC on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP on DP.gmid=cd_proc_cliente
	left Join Localidade Org on hou.cd_org_hem=Org.cd_local
	left Join Localidade Dst on cd_dst_hem=DSt.cd_local
	Left Join Tarefas_Processos TP on TP.num_proc=hou.num_proc_hem and ID_Task=4
	Left Join PO_HEM RE on RE.num_proc_hem = HOU.num_proc_hem and RE.id_dc=4
	Left Join PO_HEM ARK on ARK.num_proc_hem = HOU.num_proc_hem and ARK.id_dc=30
	Left Join PO_HEM SO on HOU.num_proc_hem = SO.num_proc_hem and SO.Id_DC=3
	Join Pessoa_LLP	PLL on PLL.Cd_Pes=HOU.Cd_Export_HEM and PLL.Cd_Pes_Grupo='P17842'
group by
	HOU.Num_Proc_HEM ,MAWB_HEM ,HAWB_HEM ,ETA_LEM ,ATA_LEM, Canal_LEM,
	ETD_LEM,ATD_LEM, Nome_Armador ,Navio_Hem, Num_Pedido, Num_Po,Customer_PO,Org.Nome_Local ,
	Dst.Nome_Local ,Dt_Previsao,Dt_Conclusao,Business_Group_Descr, RE.Numero_PO_HEM, ARK.Numero_PO_HEM,
	SO.numero_po_hem

UNION

select 
	HOU.Num_Proc_HEA Processo,MAWB_HEA MAWB,HAWB_HEA HAWB,ETA_lea ETA,ATA_lea ATA, Canal_LEA Canal,
	ETD_lea ETD,ATD_lea ATD, Nome_Cia_Aer Armador,Voo_Hea Navio, 
	Isnull(SO.numero_po_hea,Num_Pedido) Num_Pedido, 
	isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,1),Num_Po) Num_PO,
	isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,9),Customer_PO) Customer_PO,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,Dt_Previsao,Dt_Conclusao,Business_Group_Descr,null,
	dbo.fBusca_HistoricoDescr(hou.num_proc_hea,0,getdate()) Historico, RE.Numero_PO_HEA RE, ARK.Numero_PO_HEA Arktec,dbo.fBusca_Tarefa(hou.num_proc_hea,26) Envio_Docs_Fat,
	dbo.fNCM(HOU.Num_Proc_HEA) NCM
from house_exp_AER HOU
	Join LLp_Exp_AER LLP on LLP.num_proc_lea=hou.num_proc_HEA
	Join Cia_Aerea ARM on ARM.cd_cia_Aer=llp.cd_ciaaerea_lea
	left Join Pedido_Ship PS on PS.num_proc=hou.num_proc_HEA
	left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	left Join Produto_cliente PC on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP on DP.gmid=cd_proc_cliente
	left Join Localidade Org on hou.cd_org_HEA=Org.cd_local
	left Join Localidade Dst on cd_dst_HEA=DSt.cd_local
	Left Join Tarefas_Processos TP on TP.num_proc=hou.num_proc_HEA and ID_Task=4
	Left Join PO_HEA RE on RE.num_proc_hea = HOU.num_proc_hea and RE.id_dc=4
	Left Join PO_HEA ARK on ARK.num_proc_hea = HOU.num_proc_hea and ARK.id_dc=30
	Left Join PO_HEA SO on HOU.num_proc_hea=SO.num_proc_hea and SO.id_dc=3
	Join Pessoa_LLP	PLL on PLL.Cd_Pes=HOU.Cd_Export_HEA and PLL.Cd_Pes_Grupo='P17842'
group by
	HOU.Num_Proc_HEA ,MAWB_HEA ,HAWB_HEA ,ETA_lea ,ATA_lea , Canal_LEA,
	ETD_lea,ATD_lea, Nome_Cia_Aer ,Voo_HEA, Num_Pedido, Num_Po,Customer_PO,Org.Nome_Local ,
	Dst.Nome_Local ,Dt_Previsao,Dt_Conclusao,Business_Group_Descr, RE.Numero_PO_HEA, ARK.Numero_PO_HEA,
	SO.numero_po_hea


UNION

select 
	HOU.Num_Proc_heo Processo,MAWB_heo MAWB,HAWB_heo HAWB,ETA_leo ETA,ATA_leo ATA, Canal_LEO Canal,
	ETD_leo ETD,ATD_leo ATD, Nome_Raz_Soc Armador,Null Navio, 
	Isnull(SO.numero_po_heO,Num_Pedido) Num_pedido, 
	isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEO,1),Num_Po) Num_PO,
	isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEO,9),Customer_PO) Customer_PO,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,Dt_Previsao,Dt_Conclusao,Business_Group_Descr,Tipo_Leo,
	dbo.fBusca_HistoricoDescr(hou.num_proc_heO,0,getdate()) Historico, RE.Numero_PO_HEO RE, ARK.Numero_PO_HEO Arktec,dbo.fBusca_Tarefa(hou.num_proc_heo,26) Envio_Docs_Fat,
	dbo.fNCM(HOU.Num_Proc_HEO) NCM
from house_exp_out HOU
	Join LLp_Exp_out LLP on LLP.num_proc_leo=hou.num_proc_heo
	left Join Pessoa ARM on ARM.cd_pes=llp.cd_carrier
	left Join Pedido_Ship PS on PS.num_proc=hou.num_proc_heo
	left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	left Join Produto_cliente PC on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP on DP.gmid=cd_proc_cliente
	left Join Localidade Org on hou.cd_org_heo=Org.cd_local
	left Join Localidade Dst on cd_dst_heo=DSt.cd_local
	Left Join Tarefas_Processos TP on TP.num_proc=hou.num_proc_heo and ID_Task=4
	Left Join PO_HEO RE on RE.num_proc_heo = HOU.num_proc_heo and RE.id_dc=4
	Left Join PO_HEO ARK on ARK.num_proc_heo = HOU.num_proc_heo and ARK.id_dc=30
	Left Join PO_HEO SO on HOU.num_proc_heo = SO.num_proc_heo and SO.ID_DC=3
	Join Pessoa_LLP	PLL on PLL.Cd_Pes=HOU.Cd_Export_HEO and PLL.Cd_Pes_Grupo='P17842'
group by
	HOU.Num_Proc_heo ,MAWB_heo ,HAWB_heo ,ETA_leo ,ATA_leo , Canal_LEO,
	ETD_leo,ATD_leo, Nome_Raz_Soc , Num_Pedido, Num_Po,Customer_PO,Org.Nome_Local ,
	Dst.Nome_Local ,Dt_Previsao,Dt_Conclusao,Business_Group_Descr,Tipo_Leo, RE.Numero_PO_HEO, ARK.Numero_PO_HEO,
	SO.numero_po_heo 







GO
