SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--02-06-2008
--Week 23
--inclusão "NATOP" - Claudio

--06-06-2008
--Week 23
--inclusão Join com Pessoa_LLP - Claudio

--01-07-2008
--Week 27
--Pegando a Qtd da Invoice_Det - Claudio

CREATE    Procedure	[dbo].[spDAS_FU_Exp_Rel] --'01-01-2008'
(
@Data datetime
)
As

select
	HOU.Num_Proc_HEM					Ref_BDP,
	P.Num_Pedido						SAP,
	P.Customer_PO						Customer_PO,
	P.Dt_Pedido							Data_Ordem,
	DN.Numero_PO_HEM					Delivery_Note,
	DN.Data_PO_HEM						DN_Date,
	SHPM.Numero_PO_HEM					Shipment_No,
	SHPM.Data_PO_HEM					Shipment_Date,
	SAIDA.Dt_Conclusao					Saida_Planta,
	CONS.Nome_Raz_Soc					Cliente,
	'44'								Company_Code,
	PLA.Planta_Nome						Planta,
	DEST.Pais_Local 					PaisDestino,
--	INVDET.Quantidade					Qty,
	(case when INVDET.Tipo_Unid = 'L' then (INVDET.Quantidade * Capacidade) else INVDET.Peso_Liquido end) Qty,
	INVDET.Tipo_Unid					Peso_UOM,
	DPP.GMID_Descr_Curta				Produto,
	HOU.Navio_HEM						Navio,
	ARM.Nome_Armador					Transportador,
	isnull(LLP.DL_Cargo_LEM, ETD_LEM -3) DeadLine,
	LLP.ATA_LEM							ATA,
	LLP.ETD_LEM							ETD,
	LLP.ATD_LEM							ATD,
	dbo.fBusca_HistoricoDescr(hou.num_proc_HEM,0,getdate()) Status,
	RE.Numero_PO_HEM					RE,
	INVDET.Preco_Unit					Preco_Item,
	INVDET.Preco_Unit*INVDET.Peso_Liquido FOB,
--	(HOU.Vlr_Frete_Tot_HEM / sum(INVDET.Peso_Liquido)) * INVDET.Peso_Liquido Frete,
	HOU.Vlr_Frete_Tot_HEM				Frete,
--	(INVCLI.Vlr_Seguro / sum(INVDET.Peso_Liquido)) * INVDET.Peso_Liquido Seguro,
	INVCLI.Vlr_Seguro					Seguro,
--	VB: FOB + Frete + Seguro
	right('000' + convert(varchar(4),TP.Cd_Termo),4) + ' - ' + Descricao_Termo Cond_Pagamento,
	dbo.qty_container(hou.num_proc_hem)	QtdContainers,
	DDE.Numero_PO_HEM					Num_SD,
	isnull(HOU.HAWB_HEM,HOU.MAWB_HEM)	Num_BL,
	AVER.Dt_Conclusao					StatusRE,
	NF.Numero_PO_HEM					Nota_Fiscal,
	DRAW.Numero_PO_HEM					Drawback,
	DOCS.Dt_Conclusao					Envio_Docs,
	LLP.Courier_Number_LEM				Num_AWB,
	CIA.Apelido							Cia,
	LLP.Canal_LEM						Canal,
	dbo.FNATOP(HOU.Num_Proc_HEM)		NATOP,
	'O'									Modal
from
	House_Exp_Mar HOU with(nolock)
	Join LLP_Exp_Mar			LLP	with(nolock) on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
	Left Join Pedido_Ship	 	PS with(nolock)	on HOU.Num_Proc_HEM = PS.Num_Proc
	Left Join Pedido			P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
	Left Join Pedido_Det		PD with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto --and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join PO_HEM			DN with(nolock) on HOU.Num_Proc_HEM = DN.Num_Proc_HEM and DN.ID_DC = '7'
	Left Join PO_HEM			SHPM with(nolock) on HOU.Num_Proc_HEM = SHPM.Num_Proc_HEM and SHPM.ID_DC = '8'
	Left Join PO_HEM			RE with(nolock) on HOU.Num_Proc_HEM = RE.Num_Proc_HEM and RE.ID_DC = '4'
	Left Join tarefas_processos	SAIDA with(nolock) on HOU.Num_Proc_HEM = SAIDA.num_proc and SAIDA.id_task = '10'
	Left Join Pessoa			CONS with(nolock) on CONS.cd_pes = HOU.cd_consig_HEM
	Left Join Localidade		PLANTA with(nolock) on P.Planta = PLANTA.Cd_Local
	Left Join Localidade		DEST with(nolock) on HOU.Cd_Dst_HEM = DEST.Cd_Local
--	Left Join tarefas_processos	ENTR	on HOU.Num_Proc_HEM = ENTR.num_proc and ENTR.id_task = '13'
	LEFT Join Produto_Cliente	PC with(nolock) on PS.Cd_Produto =PC.Cd_Prod
	LEFT Join De_Para_Produto 	DPP with(nolock) on PC.Cd_Proc_Cliente = DPP.GMID
	Left Join Armador 			ARM	 with(nolock) on LLP.Cd_Armador_LEM=ARM.cd_armador
	Left Join Pessoa			EXPO with(nolock) on HOU.cd_export_hem = EXPO.cd_pes
	Left Join Pessoa_LLP		PLA with(nolock) on HOU.cd_export_HEM = PLA.cd_pes
	Left Join Invoice_Cliente	INVCLI with(nolock) on HOU.Num_Proc_HEM = INVCLI.Num_Proc
	Left Join Invoice_Det		INVDET with(nolock) on INVCLI.ID_INV = INVDET.ID_INV
	Left Join tarefas_processos	AVER with(nolock) on HOU.Num_Proc_HEM = AVER.num_proc and AVER.id_task = '15'
	Left Join PO_HEM			NF with(nolock) on HOU.Num_Proc_HEM = NF.Num_Proc_HEM and NF.ID_DC = '10'
	Left Join tarefas_processos	DOCS with(nolock) on HOU.Num_Proc_HEM = DOCS.num_proc and DOCS.id_task = '12'
	Left Join Pessoa			CIA with(nolock) on CIA.cd_pes = LLP.cd_courier
	Left Join PO_HEM			DDE	with(nolock) on HOU.Num_Proc_HEM = DDE.Num_Proc_HEM and DDE.ID_DC = '12'
	Left Join PO_HEM			DRAW with(nolock) on HOU.Num_Proc_HEM = DRAW.Num_Proc_HEM and DRAW.ID_DC = '24'
	Join Pessoa_LLP				PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEM and PLL.Cd_Pes_Grupo='1'
	Left Join Termo_Pagamento	TP with(nolock) on TP.Cd_Termo=INVCLI.Cd_Termo
where 
	convert(datetime,Dt_Emis_HEM,105) > @Data and 
	EXPO.nome_raz_soc like '%DOW%AGRO%'
Group By
	HOU.Num_Proc_HEM,
	P.Num_Pedido,
	P.Customer_PO,
	P.Dt_Pedido,
	DN.Numero_PO_HEM,
	DN.Data_PO_HEM,
	SHPM.Numero_PO_HEM,
	SHPM.Data_PO_HEM,
	SAIDA.Dt_Conclusao,
	CONS.Nome_Raz_Soc,
	PLA.Planta_Nome,
	DEST.Pais_Local,
	INVDET.Quantidade,
	INVDET.Tipo_Unid,
	DPP.GMID_Descr_Curta,
	HOU.Navio_HEM,
	ARM.Nome_Armador,
	LLP.ETA_LEM,
	LLP.ATA_LEM,
	LLP.ETD_LEM, PO_GRP,
	LLP.ATD_LEM,
	RE.Numero_PO_HEM,
	INVDET.Preco_Unit,
	INVDET.Peso_Liquido,
	HOU.Vlr_Frete_Tot_HEM,
	INVCLI.Vlr_Seguro,
	TP.Cd_Termo, Descricao_Termo,
	HOU.HAWB_HEM,HOU.MAWB_HEM,
	AVER.Dt_Conclusao,
	NF.Numero_PO_HEM,
	DOCS.Dt_Conclusao,
	LLP.Courier_Number_LEM,
	CIA.Apelido,
	LLP.Canal_LEM,
	DDE.Numero_PO_HEM,
	DRAW.Numero_PO_HEM,
	LLP.DL_Cargo_LEM,
	Capacidade,
	INVDET.Peso_Liquido


Union all

select
	HOU.Num_Proc_HEA					Ref_BDP,
	P.Num_Pedido						SAP,
	P.Customer_PO						Customer_PO,
	P.Dt_Pedido							Data_Ordem,
	DN.Numero_PO_HEA					Delivery_Note,
	DN.Data_PO_HEA						DN_Date,
	SHPM.Numero_PO_HEA					Shipment_No,
	SHPM.Data_PO_HEA					Shipment_Date,
	SAIDA.Dt_Conclusao					Saida_Planta,
	CONS.Nome_Raz_Soc					Cliente,
	'44'								Company_Code,
	PLA.Planta_Nome						Planta,
	DEST.Pais_Local 					PaisDestino,
--	INVDET.Quantidade					Qty,
	(case when INVDET.Tipo_Unid = 'L' then (INVDET.Quantidade * Capacidade) else INVDET.Peso_Liquido end) Qty,
	INVDET.Tipo_Unid					Peso_UOM,
	DPP.GMID_Descr_Curta				Produto,
	null								Navio,
	Nome_Cia_Aer						Transportador,
	null								DeadLine,
	LLP.ATA_LEA							ATA,
	LLP.ETD_LEA							ETD,
	LLP.ATD_LEA							ATD,
	dbo.fBusca_HistoricoDescr(hou.num_proc_HEA,0,getdate()) Status,
	RE.Numero_PO_HEA					RE,
	INVDET.Preco_Unit					Preco_Item,
	INVDET.Preco_Unit*INVDET.Peso_Liquido	FOB,
--	(HOU.Vlr_Frete_Tot_HEA / sum(INVDET.Peso_Liquido)) * INVDET.Peso_Liquido Frete,
	HOU.Vlr_Frete_Tot_HEA				Frete,
--	(INVCLI.Vlr_Seguro / sum(INVDET.Peso_Liquido)) * INVDET.Peso_Liquido Seguro,
	INVCLI.Vlr_Seguro					Seguro,
--	VB: FOB + Frete + Seguro
	right('000' + convert(varchar(4),TP.Cd_Termo),4) + ' - ' + Descricao_Termo Cond_Pagamento,
	dbo.qty_container(hou.num_proc_hea)	QtdContainers,
	DDE.Numero_PO_HEA					Num_SD,
	isnull(HOU.HAWB_HEA,HOU.MAWB_HEA)	Num_BL,
	AVER.Dt_Conclusao					StatusRE,
	NF.Numero_PO_HEA					Nota_Fiscal,
	DRAW.Numero_PO_HEA					Drawback,
	DOCS.Dt_Conclusao					Envio_Docs,
	LLP.Courier_Number_LEA				Num_AWB,
	CIA.Apelido							Cia,
	LLP.Canal_LEA						Canal,
	dbo.FNATOP(HOU.Num_Proc_HEA)		NATOP,
	'A'									Modal
from
	House_Exp_Aer HOU with(nolock)
	Join LLP_Exp_Aer		LLP with(nolock) on HOU.Num_Proc_HEA = LLP.Num_Proc_LEA
	Left Join Pedido_Ship 	PS with(nolock) on HOU.Num_Proc_HEA = PS.Num_Proc
	Left Join Pedido		P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
	Left Join Pedido_Det 	PD with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto --and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join PO_HEA		DN with(nolock) on HOU.Num_Proc_HEA = DN.Num_Proc_HEA and DN.ID_DC = '7'
	Left Join PO_HEA		SHPM with(nolock) on HOU.Num_Proc_HEA = SHPM.Num_Proc_HEA and SHPM.ID_DC = '8'
	Left Join PO_HEA		RE with(nolock) on HOU.Num_Proc_HEA = RE.Num_Proc_HEA and RE.ID_DC = '4'
	Left Join tarefas_processos	SAIDA with(nolock) on HOU.Num_Proc_HEA = SAIDA.num_proc and SAIDA.id_task = '10'
	Left Join Pessoa		CONS with(nolock) on CONS.cd_pes = HOU.cd_consig_HEA
	Left Join Localidade	PLANTA with(nolock) on P.Planta = PLANTA.Cd_Local
	Left Join Localidade	DEST with(nolock) on HOU.Cd_Dst_HEA = DEST.Cd_Local
	LEFT Join Produto_Cliente PC with(nolock) on PS.Cd_Produto =PC.Cd_Prod
	LEFT Join De_Para_Produto DPP with(nolock) on PC.Cd_Proc_Cliente = DPP.GMID
	Left Join Pessoa		EXPO with(nolock) on HOU.cd_export_HEA = EXPO.cd_pes
	Left Join Cia_Aerea 	AER with(nolock) on AER.cd_cia_Aer=LLP.cd_ciaaerea_lea
	Left Join Pessoa_LLP	PLA with(nolock) on HOU.cd_export_HEA = PLA.cd_pes
	Left Join Invoice_Cliente INVCLI with(nolock) on HOU.Num_Proc_HEA = INVCLI.Num_Proc
	Left Join Invoice_Det	INVDET with(nolock) on INVCLI.ID_INV = INVDET.ID_INV
	Left Join tarefas_processos	AVER with(nolock) on HOU.Num_Proc_HEA = AVER.num_proc and AVER.id_task = '15'
	Left Join PO_HEA		NF with(nolock) on HOU.Num_Proc_HEA = NF.Num_Proc_HEA and NF.ID_DC = '10'
	Left Join tarefas_processos	DOCS with(nolock) on HOU.Num_Proc_HEA = DOCS.num_proc and DOCS.id_task = '12'
	Left Join Pessoa		CIA with(nolock) on CIA.cd_pes = LLP.cd_courier
	Left Join PO_HEA		DDE with(nolock) on HOU.Num_Proc_HEA = DDE.Num_Proc_HEA and DDE.ID_DC = '12'
	Left Join PO_HEA		DRAW with(nolock) on HOU.Num_Proc_HEA = DRAW.Num_Proc_HEA and DRAW.ID_DC = '24'
	Join Pessoa_LLP			PLL	with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEA and PLL.Cd_Pes_Grupo='1'
	Left Join Termo_Pagamento TP with(nolock) on TP.Cd_Termo=INVCLI.Cd_Termo
where
	convert(datetime,Dt_Emis_HEA,105) > @Data 
	and EXPO.nome_raz_soc like '%DOW%AGRO%'
Group By
	HOU.Num_Proc_HEA,
	P.Num_Pedido,
	P.Customer_PO,
	P.Dt_Pedido,
	DN.Numero_PO_HEA,
	DN.Data_PO_HEA,
	SHPM.Numero_PO_HEA,
	SHPM.Data_PO_HEA,
	SAIDA.Dt_Conclusao,
	CONS.Nome_Raz_Soc,
	PLA.Planta_Nome,
	DEST.Pais_Local,
	INVDET.Quantidade,
	INVDET.Tipo_Unid,
	DPP.GMID_Descr_Curta,
	Nome_Cia_Aer,
	LLP.ETA_LEA,
	LLP.ATA_LEA,
	LLP.ETD_LEA, PO_GRP,
	LLP.ATD_LEA,
	RE.Numero_PO_HEA,
	INVDET.Preco_Unit,
	INVDET.Peso_Liquido,
	HOU.Vlr_Frete_Tot_HEA,
	INVCLI.Vlr_Seguro,
	TP.Cd_Termo, Descricao_Termo,
	HOU.HAWB_HEA,HOU.MAWB_HEA,
	AVER.Dt_Conclusao,
	NF.Numero_PO_HEA,
	DOCS.Dt_Conclusao,
	LLP.Courier_Number_LEA,
	CIA.Apelido,
	LLP.Canal_LEA,
	DDE.Numero_PO_HEA,
	DRAW.Numero_PO_HEA,
	Capacidade,
	INVDET.Peso_Liquido

Union All

select
	HOU.Num_Proc_HEO					Ref_BDP,
	P.Num_Pedido						SAP,
	P.Customer_PO						Customer_PO,
	P.Dt_Pedido							Data_Ordem,
	DN.Numero_PO_HEO					Delivery_Note,
	DN.Data_PO_HEO						DN_Date,
	SHPM.Numero_PO_HEO					Shipment_No,
	SHPM.Data_PO_HEO					Shipment_Date,
	SAIDA.Dt_Conclusao					Saida_Planta,
	CONS.Nome_Raz_Soc					Cliente,
	'44'								Company_Code,
	PLA.Planta_Nome						Planta,
	DEST.Pais_Local 					PaisDestino,
--	INVDET.Quantidade					Qty,
	(case when INVDET.Tipo_Unid = 'L' then (INVDET.Quantidade * Capacidade) else INVDET.Peso_Liquido end) Qty,
	INVDET.Tipo_Unid					Peso_UOM,
	DPP.GMID_Descr_Curta				Produto,
	null								Navio,
	CARR.Nome_Raz_Soc					Transportador,
	null								DeadLine,
	LLP.ATA_LEO							ATA,
	LLP.ETD_LEO							ETD,
	LLP.ATD_LEO							ATD,
	dbo.fBusca_HistoricoDescr(hou.num_proc_HEO,0,getdate()) Status,
	RE.Numero_PO_HEO					RE,
	INVDET.Preco_Unit					Preco_Item,
	INVDET.Preco_Unit*INVDET.Peso_Liquido	FOB,
--	(HOU.Vlr_Frete_Efet_HEO / sum(INVDET.Peso_Liquido)) * INVDET.Peso_Liquido Frete,
	HOU.Vlr_Frete_Efet_HEO				Frete,
--	(INVCLI.Vlr_Seguro / sum(INVDET.Peso_Liquido)) * INVDET.Peso_Liquido Seguro,
	INVCLI.Vlr_Seguro					Seguro,
--	VB: FOB + Frete + Seguro
	right('000' + convert(varchar(4),TP.Cd_Termo),4) + ' - ' + Descricao_Termo Cond_Pagamento,
	dbo.qty_container(hou.num_proc_heo)	QtdContainers,
	DDE.Numero_PO_HEO					Num_SD,
	isnull(HOU.HAWB_HEO,HOU.MAWB_HEO)	Num_BL,
	AVER.Dt_Conclusao					StatusRE,
	NF.Numero_PO_HEO					Nota_Fiscal,
	DRAW.Numero_PO_HEO					Drawback,
	DOCS.Dt_Conclusao					Envio_Docs,
	LLP.Courier_Number_LEO				Num_AWB,
	CIA.Apelido							Cia,
	LLP.Canal_LEO						Canal,
	dbo.FNATOP(HOU.Num_Proc_HEO)		NATOP,
	LLP.Tipo_LEO						Modal
from
	House_Exp_Out HOU
	Join LLP_Exp_Out			LLP with(nolock) on HOU.Num_Proc_HEO = LLP.Num_Proc_LEO
	Left Join Pedido_Ship 		PS with(nolock) on HOU.Num_Proc_HEO = PS.Num_Proc
	Left Join Pedido			P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
	Left Join Pedido_Det		PD with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto --and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join PO_HEO			DN with(nolock) on HOU.Num_Proc_HEO = DN.Num_Proc_HEO and DN.ID_DC = '7'
	Left Join PO_HEO			SHPM with(nolock) on HOU.Num_Proc_HEO = SHPM.Num_Proc_HEO and SHPM.ID_DC = '8'
	Left Join PO_HEO			RE with(nolock) on HOU.Num_Proc_HEO = RE.Num_Proc_HEO and RE.ID_DC = '4'
	Left Join tarefas_processos	SAIDA with(nolock) on HOU.Num_Proc_HEO = SAIDA.num_proc and SAIDA.id_task = '10'
	Left Join Pessoa			CONS with(nolock) on CONS.cd_pes = HOU.cd_consig_HEO
	Left Join Localidade		PLANTA with(nolock) on P.Planta = PLANTA.Cd_Local
	Left Join Localidade		DEST with(nolock) on HOU.Cd_Dst_HEO = DEST.Cd_Local
--	Left Join tarefas_processos	ENTR	on HOU.Num_Proc_HEO = ENTR.num_proc and ENTR.id_task = '13'
	LEFT Join Produto_Cliente	PC with(nolock) on PS.Cd_Produto =PC.Cd_Prod
	LEFT Join De_Para_Produto 	DPP with(nolock) on PC.Cd_Proc_Cliente = DPP.GMID
	Left Join Pessoa			EXPO with(nolock) on HOU.cd_export_HEO = EXPO.cd_pes
	Left Join Pessoa			CARR with(nolock) on LLP.cd_carrier = CARR.cd_pes
	Left Join Pessoa_LLP		PLA with(nolock) on HOU.cd_export_HEO = PLA.cd_pes
	Left Join Invoice_Cliente	INVCLI with(nolock) on HOU.Num_Proc_HEO = INVCLI.Num_Proc
	Left Join Invoice_Det		INVDET with(nolock) on INVCLI.ID_INV = INVDET.ID_INV
	Left Join tarefas_processos	AVER with(nolock) on HOU.Num_Proc_HEO = AVER.num_proc and AVER.id_task = '15'
	Left Join PO_HEO			NF with(nolock) on HOU.Num_Proc_HEO = NF.Num_Proc_HEO and NF.ID_DC = '10'
	Left Join tarefas_processos	DOCS with(nolock) on HOU.Num_Proc_HEO = DOCS.num_proc and DOCS.id_task = '12'
	Left Join Pessoa			CIA with(nolock) on CIA.cd_pes = LLP.cd_courier
	Left Join PO_HEO			DDE with(nolock) on HOU.Num_Proc_HEO = DDE.Num_Proc_HEO and DDE.ID_DC = '12'
	Left Join PO_HEO			DRAW with(nolock) on HOU.Num_Proc_HEO = DRAW.Num_Proc_HEO and DRAW.ID_DC = '24'
	Join Pessoa_LLP				PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEO and PLL.Cd_Pes_Grupo='1'
	Left Join Termo_Pagamento	TP with(nolock) on TP.Cd_Termo=INVCLI.Cd_Termo
where 
	convert(datetime,Dt_Emis_HEO,105) > @Data 
	and EXPO.nome_raz_soc like '%DOW%AGRO%'
Group By
	HOU.Num_Proc_HEO,
	P.Num_Pedido,
	P.Customer_PO,
	P.Dt_Pedido,
	DN.Numero_PO_HEO,
	DN.Data_PO_HEO,
	SHPM.Numero_PO_HEO,
	SHPM.Data_PO_HEO,
	SAIDA.Dt_Conclusao,
	CONS.Nome_Raz_Soc,
	PLA.Planta_Nome,
	DEST.Pais_Local,
	INVDET.Quantidade,
	INVDET.Tipo_Unid,
	DPP.GMID_Descr_Curta,
	CARR.Nome_Raz_Soc,
	LLP.ETA_LEO,
	LLP.ATA_LEO,
	LLP.ETD_LEO, PO_GRP,
	LLP.ATD_LEO,
	RE.Numero_PO_HEO,
	INVDET.Preco_Unit,
	INVDET.Peso_Liquido,
	HOU.Vlr_Frete_Efet_HEO,
	INVCLI.Vlr_Seguro,
	TP.Cd_Termo, Descricao_Termo,
	HOU.HAWB_HEO,HOU.MAWB_HEO,
	AVER.Dt_Conclusao,
	NF.Numero_PO_HEO,
	DOCS.Dt_Conclusao,
	LLP.Courier_Number_LEO,
	CIA.Apelido,
	LLP.Canal_LEO,
	DDE.Numero_PO_HEO,
	DRAW.Numero_PO_HEO,
	LLP.Tipo_LEO,
	Capacidade,
	INVDET.Peso_Liquido

order by
	Ref_BDP














GO
