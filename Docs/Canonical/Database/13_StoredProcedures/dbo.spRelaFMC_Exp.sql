SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	Procedure [dbo].[spRelaFMC_Exp]

as

select Distinct
	HOU.Num_Proc_HEM Ref_BDP,
	Isnull(dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hem, 1),Num_Pedido)  Num_Order,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,1)		Customer_PO,
--	dbo.fBusca_PRODUTO(HOU.Num_Proc_Hem) 
	PC.Produto_Descr									Produto_Descr,
	CONS.Apelido										Consignee,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,10)		Nota_Fiscal,
	TP.NOME_Tp_Oper										Incoterm,
	dbo.fNCM(HOU.Num_Proc_HEM)							NCM,
	'Ocean'												Modal,
	Org.Nome_Local										Origem,
	Dst.Nome_Local										Destino,
	ETD_LEM												ETD,
	ATD_LEM												ATD,
	ETA_LEM												ETA,
	null												ATA_Fronteira,
	DDE.Data_PO_HEM										Averbacao,
	ATA_LEM												ATA,
	Nome_Armador										Carrier,
	Navio_Hem											Navio_Voo,
	isnull(LLP.Vlr_Invoice,0)							Vlr_Invoice,
	HOU.Vlr_Frete_Tot_HEM Frete,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HEM,'%Seguro%') Seguro,
	MAWB_HEM											Master,
	HAWB_HEM											House,
	RE.Numero_PO_HEM									RE,
	DDE.Numero_PO_HEM									DDE,
	LLP.Canal_LEM										Canal,
	dbo.fBusca_Tarefa(hou.num_proc_hem,4)				Desembaraco,
	LLP.Courier_Number_LEM								Courier_Nr,
	dbo.fBusca_Tarefa(hou.num_proc_hem,26)				Envio_Docs_Fat,
	dbo.fBusca_HistoricoDescr(hou.num_proc_hem,0,getdate()) Historico,
	max(FCHB.Data_PC)									Prest_Contas,
	RE.Data_PO_HEM										RE_DATA,
	DDE.Data_PO_HEM										DDE_DATA,
	SOR.Numero_PO_HEM									SALES,
	PCB.concentracao,
	PDET.UoM,
	PDET.Qty,
	INV.Numero_PO_HEM									Invoice,
	PS.Item

from house_exp_mar HOU With(nolock)
	Join LLp_Exp_mar LLP With(nolock) on LLP.num_proc_lem=hou.num_proc_hem
	Left Join Pessoa CONS With(nolock) on HOU.Cd_Consig_HEM = CONS.Cd_Pes
	Left Join Tipo_Oper TP With(nolock) on HOU.cd_tp_oper = TP.Cd_tp_oper
	left Join Pedido_Ship PS With(nolock) on PS.num_proc=hou.num_proc_hem
	left Join Pedido P With(nolock) on P.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det PDET With(nolock) on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item --and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente PC With(nolock) on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP With(nolock) on DP.gmid=cd_proc_cliente
	left Join Armador ARM With(nolock) on ARM.cd_armador=llp.cd_armador_lem
	left Join Localidade Org With(nolock) on hou.cd_org_hem=Org.cd_local
	left Join Localidade Dst With(nolock) on cd_dst_hem=DSt.cd_local
	Left Join PO_HEM RE With(nolock) on RE.num_proc_hem = HOU.num_proc_hem and RE.id_dc=4
	Left Join PO_HEM SOR With(nolock) on HOU.num_proc_hem = SOR.num_proc_hem and SOR.Id_DC=3
	Left Join PO_HEM DDE With(nolock) on HOU.num_proc_hem = DDE.num_proc_hem and DDE.Id_DC=12
	left join po_hem INV With(nolock) on INV.Num_proc_hem = HOU.num_proc_hem and INV.id_dc=2
	left Join Fatura_CHB FCHB With(nolock) on HOU.Num_Proc_HEM = FCHB.Processo_PC
	Join Pessoa_LLP	PLL With(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEM and PLL.Cd_Pes_Grupo='362'
	left join Produto_chb PCB With(nolock) on PCB.cd_prod = PS.cd_produto and PCB.concentracao is not null
Where
	ETD_LEM>=getdate()-180

group by
	HOU.Num_Proc_HEM,
	Customer_PO,
	Produto_Descr,
	CONS.Apelido ,
	TP.NOME_Tp_Oper	,
	Org.Nome_Local ,
	Dst.Nome_Local ,
	ETD_LEM ,
	ATD_LEM ,
	ETA_LEM ,
	DDE.Data_PO_HEM,
	ATA_LEM,
	Nome_Armador,
	Navio_Hem,
	LLP.Vlr_Invoice,
	HOU.Vlr_Frete_Tot_HEM,
	MAWB_HEM,
	HAWB_HEM,
	RE.Numero_PO_HEM,
	DDE.Numero_PO_HEM,
	LLP.Canal_LEM,
	LLP.Courier_Number_LEM,
	RE.Data_PO_HEM,
	DDE.Data_PO_HEM,
	SOR.Numero_PO_HEM,
	PCB.concentracao,
	PDET.UoM,
	PDET.Qty,
	INV.Numero_PO_HEM,
	PS.Item,
	Num_Pedido

UNION ALL
select Distinct
	HOU.Num_Proc_HEA Ref_BDP,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,1) Customer_PO,
	Isnull(dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hea, 1),Num_Pedido)  Num_Order,
--	dbo.fBusca_PRODUTO(HOU.Num_Proc_Hea)
	PC.Produto_Descr Produto_Descr,
	CONS.Apelido Consignee,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,10) Nota_Fiscal,
	TP.NOME_Tp_Oper	Incoterm,
	dbo.fNCM(HOU.Num_Proc_HEA) NCM,
	'Air'	Modal,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,
	ETD_LEA ETD,
	ATD_LEA ATD,
	ETA_LEA ETA,
	null	ATA_Fronteira,
	DDE.Data_PO_HEA Averbacao,
	ATA_LEA ATA,
	Nome_Cia_Aer Carrier,
	Voo_HEA Navio_Voo,
	isnull(LLP.Vlr_Invoice,0) Vlr_Invoice,
	HOU.Vlr_Frete_Tot_HEA Frete,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HEA,'%Seguro%') Seguro,
	MAWB_HEA Master,
	HAWB_HEA House,
	RE.Numero_PO_HEA RE,
	DDE.Numero_PO_HEA DDE,
	LLP.Canal_LEA Canal,
	dbo.fBusca_Tarefa(hou.num_proc_HEA,4) Desembaraco,
	LLP.Courier_Number_LEA Courier_Nr,
	dbo.fBusca_Tarefa(hou.num_proc_HEA,26) Envio_Docs_Fat,
	dbo.fBusca_HistoricoDescr(hou.num_proc_HEA,0,getdate()) Historico,
	max(FCHB.Data_PC) Prest_Contas,
	RE.Data_PO_HEA RE_DATA,
	DDE.Data_PO_HEA DDE_DATA,
	SOR.Numero_PO_HEA SALES,
	PCB.concentracao Concentracao,
	PDET.UoM,
--	HOU.Peso_Real_HEA
	PDET.Qty,
	INV.Numero_PO_HEA Invoice,
	PS.Item

from house_exp_Aer HOU With(nolock)
	Join LLp_Exp_Aer LLP With(nolock) on LLP.num_proc_LEA=hou.num_proc_HEA
	Left Join Pessoa CONS With(nolock) on HOU.Cd_Consig_HEA = CONS.Cd_Pes
	Left Join Tipo_Oper TP With(nolock) on HOU.cd_tp_oper = TP.Cd_tp_oper
	left Join Pedido_Ship PS With(nolock) on PS.num_proc=hou.num_proc_HEA
	left Join Pedido P With(nolock) on P.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det PDET With(nolock) on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item and PDET.cd_produto=PS.cd_produto --and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente PC With(nolock) on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP With(nolock) on DP.gmid=cd_proc_cliente
	left Join Cia_Aerea CIA With(nolock) on CIA.cd_cia_Aer=llp.cd_ciaaerea_lea
	left Join Localidade Org With(nolock) on hou.cd_org_HEA=Org.cd_local
	left Join Localidade Dst With(nolock) on cd_dst_HEA=DSt.cd_local
	Left Join PO_HEA RE With(nolock) on RE.num_proc_HEA = HOU.num_proc_HEA and RE.id_dc=4
	Left Join PO_HEA SOR With(nolock) on HOU.num_proc_HEA = SOR.num_proc_HEA and SOR.Id_DC=3
	Left Join PO_HEA DDE With(nolock) on HOU.num_proc_HEA = DDE.num_proc_HEA and DDE.Id_DC=12
	left join po_hea INV With(nolock) on INV.Num_proc_hea = HOU.num_proc_hea and INV.id_dc=2
	left Join Fatura_CHB  FCHB With(nolock) on HOU.Num_Proc_HEA = FCHB.Processo_PC
	Join Pessoa_LLP	PLL With(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEA and PLL.Cd_Pes_Grupo='362'
	left join Produto_chb PCB With(nolock) on PCB.cd_prod = PS.cd_produto and PCB.concentracao is not null

Where ETD_LEA>=getdate()-180
group by
	HOU.Num_Proc_HEA,
	Customer_PO,
	Produto_Descr,
	CONS.Apelido ,
	TP.NOME_Tp_Oper	,
	Org.Nome_Local ,
	Dst.Nome_Local ,
	ETD_LEA ,
	ATD_LEA ,
	ETA_LEA ,
	DDE.Data_PO_HEA,
	ATA_LEA,
	Nome_Cia_Aer,
	Voo_HEA,
	LLP.Vlr_Invoice,
	HOU.Vlr_Frete_Tot_HEA,
	MAWB_HEA,
	HAWB_HEA,
	RE.Numero_PO_HEA,
	DDE.Numero_PO_HEA,
	LLP.Canal_LEA,
	LLP.Courier_Number_LEA,
	RE.Data_PO_HEA,
	DDE.Data_PO_HEA,
	SOR.Numero_PO_HEA,
	PCB.concentracao,
	PDET.UoM,
--	HOU.Peso_Real_HEA,
	PDET.Qty,
	INV.Numero_PO_HEA,
	PS.Item,
	Num_Pedido

UNION ALL

select
	Distinct 
	HOU.Num_Proc_HEO Ref_BDP,
	Isnull(dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Heo, 1),Num_Pedido) Num_Order,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEO,1) Customer_PO,
--	dbo.fBusca_PRODUTO(HOU.Num_Proc_Heo)
	PC.Produto_Descr Produto_Descr,
	CONS.Apelido Consignee,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEO,10) Nota_Fiscal,
	TP.NOME_Tp_Oper	Incoterm,
	dbo.fNCM(HOU.Num_Proc_HEO) NCM,
	(case when LLP.Tipo_LEO = 'T' then 'Truck' else 'Rail' end) Modal,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,
	ETD_LEO ETD,
	ATD_LEO ATD,
	ETA_LEO ETA,
	dbo.fBusca_Tarefa(hou.num_proc_HEO,16) ATA_Fronteira,
	DDE.Data_PO_HEO Averbacao,
	ATA_LEO ATA,
	ARM.Apelido Carrier,
	Voo_HEO Navio_Voo,
	isnull(LLP.Vlr_Invoice,0) Vlr_Invoice,
	HOU.Vlr_Frete_Efet_HEO Frete,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HEO,'%Seguro%') Seguro,
	MAWB_HEO Master,
	HAWB_HEO House,
	RE.Numero_PO_HEO RE,
	DDE.Numero_PO_HEO DDE,
	LLP.Canal_LEO Canal,
	dbo.fBusca_Tarefa(hou.num_proc_HEO,4) Desembaraco,
	LLP.Courier_Number_LEO Courier_Nr,
	dbo.fBusca_Tarefa(hou.num_proc_HEO,26) Envio_Docs_Fat,
	dbo.fBusca_HistoricoDescr(hou.num_proc_HEO,0,getdate()) Historico,
	max(FCHB.Data_PC) Prest_Contas,
	RE.Data_PO_HEO RE_DATA,
	DDE.Data_PO_HEO DDE_DATA,
	SOR.Numero_PO_HEO SALES,
	PCB.concentracao Concentracao,
	PDET.UoM,
	PDET.Qty,
	INV.Numero_PO_HEO Invoice,
	PS.Item

from house_exp_Out HOU With(nolock)
	Join LLp_Exp_Out LLP With(nolock) on LLP.num_proc_LEO=hou.num_proc_HEO
	Left Join Pessoa CONS With(nolock) on HOU.Cd_Consig_HEO = CONS.Cd_Pes
	Left Join Tipo_Oper TP With(nolock) on HOU.cd_tp_oper = TP.Cd_tp_oper
	left Join Pedido_Ship PS With(nolock) on PS.num_proc=hou.num_proc_HEO
	left Join Pedido P With(nolock) on P.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det PDET With(nolock) on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item --and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente PC With(nolock) on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto DP With(nolock) on DP.gmid=cd_proc_cliente
	left Join Pessoa ARM With(nolock) on ARM.cd_pes=llp.cd_carrier
	left Join Localidade Org With(nolock) on hou.cd_org_HEO=Org.cd_local
	left Join Localidade Dst With(nolock) on cd_dst_HEO=DSt.cd_local
	Left Join PO_HEO RE With(nolock) on RE.num_proc_HEO = HOU.num_proc_HEO and RE.id_dc=4
	Left Join PO_HEO SOR With(nolock) on HOU.num_proc_HEO = SOR.num_proc_HEO and SOR.Id_DC=3
	Left Join PO_HEO DDE With(nolock) on HOU.num_proc_HEO = DDE.num_proc_HEO and DDE.Id_DC=12
	left join po_heo INV With(nolock) on INV.Num_proc_heo = HOU.num_proc_heo and INV.id_dc=2
	left Join Fatura_CHB FCHB With(nolock) on HOU.Num_Proc_HEO = FCHB.Processo_PC
	Join Pessoa_LLP	PLL With(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEO and PLL.Cd_Pes_Grupo='362'
	left join Produto_chb PCB With(nolock) on PCB.cd_prod = PS.cd_produto and PCB.concentracao is not null
Where
	ETD_LEO >=getdate()-180
group by
	HOU.Num_Proc_HEO,
	Customer_PO,
	Produto_Descr,
	CONS.Apelido ,
	TP.NOME_Tp_Oper	,
	LLP.Tipo_LEO,
	Org.Nome_Local ,
	Dst.Nome_Local ,
	ETD_LEO ,
	ATD_LEO ,
	ETA_LEO ,
	DDE.Data_PO_HEO,
	ATA_LEO,
	ARM.Apelido,
	Voo_HEO,
	LLP.Vlr_Invoice,
	HOU.Vlr_Frete_Efet_HEO,
	MAWB_HEO,
	HAWB_HEO,
	RE.Numero_PO_HEO,
	DDE.Numero_PO_HEO,
	LLP.Canal_LEO,
	LLP.Courier_Number_LEO,
	RE.Data_PO_HEO,
	DDE.Data_PO_HEO,
	SOR.Numero_PO_HEO,
	PCB.concentracao,
	PDET.UoM,
	PDET.Qty,
	INV.Numero_PO_HEO,
	PS.Item,
	Num_Pedido


















GO
