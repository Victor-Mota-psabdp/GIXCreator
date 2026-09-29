SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE	Procedure [dbo].[spTracking_Imp_EXO_Rel] 

as

select
	hou.Num_Proc_HIM Processo,
	dbo.fBusca_GMID(HOU.Num_Proc_HIM)	GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM) Produtos,
	Num_Pedido,
	Isnull(Num_Po,PO.numero_po_him) Num_PO,
	isnull(Customer_PO,Customer_PO.numero_PO_HIm) Customer_PO,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,
	Nome_Armador Armador,
	Navio_HIM Navio,
	sum(isnull(PDET.Peso_Liquido_TOT,0)) Peso_Liquido,
	sum(isnull(PDET.Peso_Bruto_TOT,0)) Peso_Bruto_TOT,
	ETA_LIM ETA,
	ATA_LIM ATA,
	ETD_LIM ETD,
	ATD_LIM ATD, 
	TP.Dt_Conclusao,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_him,54),ETA_Lim +7) Dt_Previsao,
	Business_Group_Descr,
	null Tipo,
	dbo.FBusca_Adto(hou.num_proc_him) Adto, 
	dbo.FBusca_Caixa(hou.num_proc_him) Caixa, 
	dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico,
	DI.Numero_PO_Him DI, 
	DI.Data_PO_Him Data_DI,
	Canal_Lim Canal,
	PO_GRP
from house_imp_mar HOU with(nolock)
	Join LLp_imp_mar LLP with(nolock) on LLP.num_proc_LIM=hou.num_proc_HIM
	left Join Job_imp_mar  JOB with(nolock) on JOB.num_proc_him=hou.num_proc_him
	left Join Armador ARM with(nolock) on ARM.cd_armador=job.cd_armador
	left Join Pedido_Ship PS with(nolock) on PS.num_proc=hou.num_proc_HIM
	left Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det PDET	with(nolock) on PDET.cd_pedido=PS.cd_pedido and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente PC with(nolock) on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP with(nolock) on DP.gmid=cd_proc_cliente
	left Join Localidade Org with(nolock) on hou.cd_org_HIM=Org.cd_local
	left Join Localidade Dst with(nolock) on cd_dst_HIM=DSt.cd_local
	Left Join Tarefas_Processos TP on TP.num_proc=hou.num_proc_HIM and TP.ID_Task=4
	Left Join PO_HIM DI with(nolock) on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
	Left Join PO_HIM PO with(nolock) on PO.Num_Proc_Him=hou.num_proc_him and PO.id_dc=1
	Left Join PO_HIM Customer_PO with(nolock) on Customer_PO.Num_Proc_Him=hou.num_proc_him and Customer_PO.id_dc=9
	Join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo='1'
where
	(PO_GRP = '041' Or PO_GRP = '431') and ETA_LIM >=getdate()-90
group by
	hou.Num_Proc_HIM ,
	Num_Pedido,
	Num_Po,PO.numero_po_him,
	Customer_PO,Customer_PO.numero_PO_HIm,
	Org.Nome_Local,
	Dst.Nome_Local,
	Nome_Armador,
	Navio_HIM,
	PDET.Peso_Liquido_TOT,
	PDET.Peso_Bruto_TOT,
	ETA_LIM,
	ATA_LIM,
	ETD_LIM,
	ATD_LIM, 
	TP.Dt_Conclusao,
--	TP.Dt_Previsao,
	Business_Group_Descr,
	DI.Numero_PO_Him, 
	DI.Data_PO_Him,
	Canal_Lim,
	PO_GRP
UNION

select 
	hou.Num_Proc_HIA Processo,
	dbo.fBusca_GMID(HOU.Num_Proc_HIA)	GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA) Produtos,
	Num_Pedido,
	Isnull(Num_Po,PO.numero_po_hia) Num_PO,
	isnull(Customer_PO,Customer_PO.numero_PO_HIA) Customer_PO,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,
	Nome_Cia_aer Armador,
	Voo_HIA Navio,
	sum(isnull(PDET.Peso_Liquido_TOT,0)) Peso_Liquido,
	sum(isnull(PDET.Peso_Bruto_TOT,0)) Peso_Bruto_TOT,
	ETA_LIA ETA,
	ATA_LIA ATA,
	ETD_LIA ETD,
	ATD_LIA ATD, 
	TP.Dt_Conclusao,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_hia,54),ETA_Lia +7) Dt_Previsao,
	Business_Group_Descr,
	null Tipo,
	dbo.FBusca_Adto(hou.num_proc_hia) Adto, 
	dbo.FBusca_Caixa(hou.num_proc_hia) Caixa, 
	dbo.fBusca_HistoricoDescr(hou.num_proc_hia,0,getdate()) Historico,
	DI.Numero_PO_HiA DI, 
	DI.Data_PO_HiA Data_DI,
	Canal_Lia Canal,
	PO_GRP
from 
	house_imp_AER HOU with(nolock)
	Join LLp_imp_AER LLP with(nolock)  on LLP.num_proc_LIA=hou.num_proc_HIA
	left Join Job_imp_aer JOB with(nolock)   on JOB.num_proc_hia=HOU.num_proc_hia
	left Join Cia_Aerea ARM with(nolock)   on ARM.cd_cia_Aer=job.cd_cia_aer
	left Join Pedido_Ship PS with(nolock)   on PS.num_proc=hou.num_proc_HIA
	left Join Pedido PD with(nolock)  on  PD.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det PDET with(nolock)   on PDET.cd_pedido=PS.cd_pedido and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente PC with(nolock)    on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP with(nolock)   on DP.gmid=cd_proc_cliente
	left Join Localidade Org with(nolock)    on hou.cd_org_HIA=Org.cd_local
	left Join Localidade Dst with(nolock)   on cd_dst_HIA=DSt.cd_local
	Left Join Tarefas_Processos TP with(nolock)  on TP.num_proc=hou.num_proc_HIA and TP.ID_Task=4
	Left Join PO_HIA DI with(nolock)   on DI.Num_Proc_Hia=hou.num_proc_hia and id_dc=5
	Left Join PO_HIA PO with(nolock)   on PO.Num_Proc_Hia=hou.num_proc_hia and PO.id_dc=1
	Left Join PO_HIA Customer_PO with(nolock)   on Customer_PO.Num_Proc_Hia=hou.num_proc_hia and Customer_PO.id_dc=9
	Join Pessoa_LLP	PLL with(nolock)   on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo='1'
where
	(PO_GRP = '041' Or PO_GRP = '431') and ETA_LIA >=getdate()-90
group by
	hou.Num_Proc_HIA,
	Num_Pedido,
	Num_Po,PO.numero_po_hia,
	Customer_PO,Customer_PO.numero_PO_HIA,
	Org.Nome_Local,
	Dst.Nome_Local,
	Nome_Cia_aer,
	Voo_HIA,
	PDET.Peso_Liquido_TOT,
	PDET.Peso_Bruto_TOT,
	ETA_LIA ,
	ATA_LIA ,
	ETD_LIA ,
	ATD_LIA , 
	TP.Dt_Conclusao,
--	TP.Dt_Previsao,
	Business_Group_Descr,
	DI.Numero_PO_HiA, 
	DI.Data_PO_HiA,
	Canal_Lia,
	PO_GRP

UNION

select 
	hou.Num_Proc_HIO Processo,
	dbo.fBusca_GMID(HOU.Num_Proc_HIO)	GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO) Produtos,
	Num_Pedido,
	Isnull(Num_Po,PO.numero_po_hio) Num_PO,
	isnull(Customer_PO,Customer_PO.numero_PO_HIO) Customer_PO,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,
	Nome_Raz_Soc Armador,
	null Navio,
	sum(isnull(PDET.Peso_Liquido_TOT,0)) Peso_Liquido,
	sum(isnull(PDET.Peso_Bruto_TOT,0)) Peso_Bruto_TOT,
	ETA_LIO ETA,
	ATA_LIO ATA,
	ETD_LIO ETD,
	ATD_LIO ATD, 
	TP.Dt_Conclusao,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_hio,54),ETA_Lio +7) Dt_Previsao,
	Business_Group_Descr,
	Tipo_LIO Tipo,
	dbo.FBusca_Adto(hou.num_proc_hio) Adto, 
	dbo.FBusca_Caixa(hou.num_proc_hio) Caixa, 
	dbo.fBusca_HistoricoDescr(hou.num_proc_hio,0,getdate()) Historico,
	DI.Numero_PO_Hio DI, 
	DI.Data_PO_Hio Data_DI,
	Canal_Lio Canal,
	PO_GRP
from 
	house_imp_out HOU with(nolock)   
	Join LLp_imp_out LLP with(nolock)   on LLP.num_proc_LIO=hou.num_proc_HIO
	left Join Pessoa ARM with(nolock)   on ARM.cd_pes=llp.cd_carrier
	left Join Pedido_Ship PS with(nolock)   on PS.num_proc=hou.num_proc_HIO
	left Join Pedido PD with(nolock) on    PD.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det    PDET with(nolock)on PDET.cd_pedido=PS.cd_pedido and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente PC with(nolock)   on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP with(nolock)   on DP.gmid=cd_proc_cliente
	left Join Localidade Org with(nolock)   on hou.cd_org_HIO=Org.cd_local
	left Join Localidade Dst with(nolock)   on cd_dst_HIO=DSt.cd_local
	Left Join Tarefas_Processos TP with(nolock)   on TP.num_proc=hou.num_proc_HIO and TP.ID_Task=4
	Left Join PO_HIO DI with(nolock)   on DI.Num_Proc_Hio=hou.num_proc_hio and id_dc=5
	Left Join PO_HIo PO with(nolock)   on PO.Num_Proc_HiO=hou.num_proc_hiO and PO.id_dc=1
	Left Join PO_HIO Customer_PO with(nolock)   on Customer_PO.Num_Proc_HiO=hou.num_proc_hiO and Customer_PO.id_dc=9
	Join Pessoa_LLP	PLL with(nolock)   on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo='1'
where
	(PO_GRP = '041' Or PO_GRP = '431') and ETA_LIO >=getdate()-90
group by
	hou.Num_Proc_HIO,
	Num_Pedido,
	Num_Po,PO.numero_po_hio,
	Customer_PO,Customer_PO.numero_PO_HIO,
	Org.Nome_Local,
	Dst.Nome_Local,
	Nome_Raz_Soc,
	PDET.Peso_Liquido_TOT,
	PDET.Peso_Bruto_TOT,
	ETA_LIO,
	ATA_LIO ,
	ETD_LIO ,
	ATD_LIO , 
	TP.Dt_Conclusao,
--	TP.Dt_Previsao,
	Business_Group_Descr,
	Tipo_Lio,
	DI.Numero_PO_Hio, 
	DI.Data_PO_Hio,
	Canal_Lio,
	PO_GRP

order by 
	Processo




GO
