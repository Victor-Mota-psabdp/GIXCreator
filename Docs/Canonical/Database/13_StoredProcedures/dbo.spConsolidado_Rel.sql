SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--05-06-2008
--Week 23
--inclusão Join com Pessoa_LLP - Claudio


CREATE     Procedure	[dbo].[spConsolidado_Rel]

As

select
	HOU.Num_Proc_HIM						Ref_BDP,
	P.Num_Pedido							SAP,
	P.Num_PO								PU,
	CONS.Apelido							Consignee,
	dbo.fBusca_GMID(HOU.Num_Proc_HIM)		GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)	Produtos,
	sum(isnull(PD.Peso_Liquido_TOT,0))/1000	TON,
	'Marine'								Modo,
	HOU.HAWB_HIM							House,
	HOU.MAWB_HIM							Master,
	HOU.Navio_HIM							Navio,
	ARM.Nome_Armador						Transportador,
	AGT.Nome_Raz_Soc						Agente,
	ORG.Pais_Local							Origem,
	P.Incoterm								Incoterms,
	dbo.fBusca_InvoiceNum (HOU.Num_Proc_HIM) Invoices,
	max(FCHB.Data_PC)						Data_Fatura,
	TaskPC.Dt_Conclusao						Envio_Fatura,
	DEST.Nome_Local							Local_Entrada,
	DI.Data_PO_HIM							DataDI,
	DI.Numero_PO_HIM						NroDI,
	isnull(Paridade,1.7)					TxDolar,
	LLP.Canal_LIM							Canal,
	LLP.ATA_LIM								Chegada,
	dbo.fBusca_Historico(hou.num_proc_him,53,GETDATE()) SaidaNavio,
	dbo.fBusca_Tarefa(hou.num_proc_him,15)	PresencaCarga,
	dbo.fBusca_Tarefa(hou.num_proc_him,4)	Desembaraco,
	CI.Data_PO_HIM							DataCI,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_him,54),ETA_Lim +7)	Previsao,
	dbo.fBusca_Historico(hou.num_proc_him,57,getdate()) Data_Entrega_Transporte,
	dbo.fBusca_Historico(hou.num_proc_him,56,getdate()) DepositoDataReal,
	dbo.fBusca_Containers (hou.num_proc_him) Containers,
	dbo.fBusca_Volumes (hou.num_proc_him)	 Volumes,
	dbo.qty_container(hou.num_proc_him)		 QtdContainers,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Posicionamento%') Posicionamento,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Desova%') Desova,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Pesagem%') Pesagem,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Armazenagem%') Armazenagem,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Consertadores%') Consertadores,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Vistoria%') Vistoria,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%MediaContainer%') MediaContainer,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%THC%') THC,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%fee%') BLFee,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%adiantamento%') Adiantamento,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%CPMF%') CPMF,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%AFRM%') AFRM,

	dbo.FBusca_FOB(hou.num_proc_him,'I')/Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_him,'31'),1.7)	FobUSD,
	Vlr_Frete_efet_him /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_him,'31'),1.7)	FreteUSD,
--	VB: FobUSD + FreteUSD						ValorCFUSD
	dbo.FBusca_FOB(hou.num_proc_him,'S')/Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_him,'31'),1.7)	SeguroUSD,
--	VB: FobUSD + FreteUSD + SeguroUSD				CIFUSD
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Impos% Impor%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_him,'31'),1.7) IIUSD,
--	VB: FobUSD + FreteUSD + SeguroUSD + IIUSD			CIFeIIUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'IPI%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_him,'31'),1.7) IPIUSD,
	Isnull(Paridade,1.7)						TxExtratoDIUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%ICMS%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_him,'31'),1.7) ICMSUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%PIS%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_him,'31'),1.7) PISUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Cofins%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_him,'31'),1.7) CofinsUSD,
--	VB: FobUSD + FreteUSD + SeguroUSD + IIUSD + IPIUSD + TxExtratoDIUSD + ICMSUSD + PISUSD	+ CofinsUSD = TotalUSD,

	dbo.FBusca_FOB(hou.num_proc_him,'I')				FobReais,
	Vlr_Frete_efet_him						FreteReais,
--	VB: FobReais + FreteReais					ValorCFReais,
	dbo.FBusca_FOB(hou.num_proc_him,'S')				SeguroReais,
--	VB: FobReais + FreteReais + SeguroReais				CIFReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Impos% Impor%') IIReais,
--	VB: FobReais + FreteReais + SeguroReais + IIReais		CIFeIIReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Impos% Prod% Ind%') IPIReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%SISCOMEX%') TxExtratoDIReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%ICMS%') ICMSReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%PIS%') PISReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_him,'%Cofins%') CofinsReais,
--	VB: FobReais + FreteReais + SeguroReais + IIReais + IPIReais + TxExtratoDIReais + ICMSReais + PISReais + CofinsReais = TotalReais
	dbo.fBusca_HistoricoDescr(hou.num_proc_him,54,getdate())	Motivo_Atraso,
	Right(Left(P.Planta,5),2)								Company_ID,
	P.Planta
from LLP_Imp_Mar LLP with(nolock)
	Join House_Imp_Mar			HOU	with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM --and right(left(LLP.Num_Proc_LIM,9),4) = '2009'
	Left Join Job_Imp_Mar		JIM	with(nolock) on HOU.Num_Proc_HIM = JIM.Num_Proc_HIM
	Left Join Pessoa			CONS with(nolock) on HOU.Cd_Consig_HIM = CONS.Cd_Pes
	Join Pedido_Ship 			PS	with(nolock) on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido					P	with(nolock)  on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det 			PD	with(nolock)  on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto --and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join Localidade		ORG	with(nolock) on HOU.Cd_Org_Him = ORG.Cd_Local
	left Join Fatura_CHB		FCHB with(nolock) on HOU.Num_Proc_HIM = FCHB.Processo_PC
	Left Join tarefas_processos	TaskPC with(nolock) on HOU.Num_Proc_HIM = TaskPC.num_proc AND id_task=14
	Left Join Localidade		DEST with(nolock) on HOU.Cd_Dst_HIM = DEST.Cd_Local
	Join Nota_Cliente			NOTA with(nolock) on HOU.Num_Proc_HIM = NOTA.Num_Proc --and DI.Numero_PO_HIM = NOTA.DI
	Left Join PO_HIM			CI	with(nolock) on HOU.Num_Proc_HIM = CI.Num_Proc_HIM and CI.ID_PO_HIM = 6
--	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
--	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Join Armador			ARM	with(nolock) on JIM.Cd_Armador   = ARM.Cd_Armador
	Left Join Pessoa 			AGT	with(nolock) on JIM.cd_agente=AGT.cd_pes
	Left Join PO_HIM			DI	with(nolock) on HOU.Num_Proc_HIM = DI.Num_Proc_HIM and DI.ID_PO_HIM = 5
	Join Pessoa_LLP				PLL with(nolock) on PLL.Cd_Pes=CONS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
where
	NOTA.Nota_Fiscal  like '%' and PO_GRP IN ('041','431','620') 
	--year(ATA_Lim) = 2011
	and ata_lim >= getdate()-180
--	and dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,'4') <= '2009-12-31'
Group by
	HOU.Num_Proc_HIM,
	P.Num_Pedido,
	P.Num_PO,
	CONS.Apelido,
	PD.Peso_Liquido_TOT,
	HOU.HAWB_HIM,
	HOU.MAWB_HIM,
	HOU.Navio_HIM,
	ARM.Nome_Armador,
	AGT.Nome_Raz_Soc,
	ORG.Pais_Local,
	P.Incoterm,
	TaskPC.Dt_Conclusao,
	DEST.Nome_Local,
	DI.Data_PO_HIM,
	DI.Numero_PO_HIM,
	LLP.Canal_LIM,
	LLP.ATA_LIM,
	CI.Data_PO_HIM,
	Vlr_Frete_efet_him,
	ETA_Lim,
--	PS.cd_produto,
--	PS.cd_pedido,
	NOTA.Paridade,
	Right(Left(P.Planta,5),2),
	P.Planta

Union all
select
	HOU.Num_Proc_HIA						Ref_BDP,
	P.Num_Pedido							SAP,
	P.Num_PO								PU,
	CONS.Apelido							Consignee,
	dbo.fBusca_GMID(HOU.Num_Proc_HIA)		GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)	Produtos,
	sum(isnull(PD.Peso_Liquido_TOT,0))/1000	TON,
	'Air'									Modo,
	HOU.HAWB_HIA							House,
	HOU.MAWB_HIA							Master,
	Null									Navio,
	CIA.Nome_Cia_Aer						Transportador,
	AGT.Nome_Raz_Soc						Agente,
	ORG.Pais_Local							Origem,
	P.Incoterm							Incoterms,
	dbo.fBusca_InvoiceNum (HOU.Num_Proc_HIA)			Invoices,
	max(FCHB.Data_PC)						Data_Fatura,
	TaskPC.Dt_Conclusao						Envio_Fatura,
	DEST.Nome_Local							Local_Entrada,
	DI.Data_PO_HIA							DataDI,
	DI.Numero_PO_HIA						NroDI,
	isnull(Paridade,1.7)						TxDolar,
	LLP.Canal_LIA							Canal,
	LLP.ATA_LIA							Chegada,
	dbo.fBusca_Historico(hou.num_proc_HIA,53,GETDATE()) 		SaidaNavio,
	dbo.fBusca_Tarefa(hou.num_proc_HIA,15)				PresencaCarga,
	dbo.fBusca_Tarefa(hou.num_proc_HIA,4)				Desembaraco,
	CI.Data_PO_HIA							DataCI,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_HIA,54),ETA_LIA +7)	Previsao,
	dbo.fBusca_Historico(hou.num_proc_hia,57,getdate()) Data_Entrega_Transporte,
	dbo.fBusca_Historico(hou.num_proc_hia,56,getdate()) DepositoDataReal,
	dbo.fBusca_Containers (hou.num_proc_HIA)			Containers,
	dbo.fBusca_Volumes (hou.num_proc_HIA)				Volumes,
	dbo.qty_container(hou.num_proc_HIA)				QtdContainers,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%Posicionamento%') Posicionamento,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%Desova%') Desova,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%Pesagem%') Pesagem,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%Armazenagem%') Armazenagem,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%Consertadores%') Consertadores,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%Vistoria%') Vistoria,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%MediaContainer%') MediaContainer,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%THC%') THC,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%fee%') BLFee,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%adiantamento%') Adiantamento,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%CPMF%') CPMF,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%AFRM%') AFRM,

	dbo.FBusca_FOB(hou.num_proc_HIA,'I')/Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hia,'31'),1.7)	FobUSD,
	Vlr_Frete_efet_HIA /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hia,'31'),1.7)			FreteUSD,
--	VB: FobUSD + FreteUSD						ValorCFUSD
	dbo.FBusca_FOB(hou.num_proc_HIA,'S')/Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hia,'31'),1.7)	SeguroUSD,
--	VB: FobUSD + FreteUSD + SeguroUSD				CIFUSD
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%Impos% Impor%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hia,'31'),1.7) IIUSD,
--	VB: FobUSD + FreteUSD + SeguroUSD + IIUSD			CIFeIIUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'IPI%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hia,'31'),1.7) IPIUSD,
	Isnull(Paridade,1.7)						TxExtratoDIUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%ICMS%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hia,'31'),1.7) ICMSUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%PIS%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hia,'31'),1.7) PISUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%Cofins%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hia,'31'),1.7) CofinsUSD,
--	VB: FobUSD + FreteUSD + SeguroUSD + IIUSD + IPIUSD + TxExtratoDIUSD + ICMSUSD + PISUSD	+ CofinsUSD = TotalUSD,

	dbo.FBusca_FOB(hou.num_proc_HIA,'I')				FobReais,
	Vlr_Frete_efet_HIA						FreteReais,
--	VB: FobReais + FreteReais					ValorCFReais,
	dbo.FBusca_FOB(hou.num_proc_HIA,'S')				SeguroReais,
--	VB: FobReais + FreteReais + SeguroReais				CIFReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%Impos% Impor%') IIReais,
--	VB: FobReais + FreteReais + SeguroReais + IIReais		CIFeIIReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'IPI%') IPIReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%SISCOMEX%') TxExtratoDIReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%ICMS%') ICMSReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%PIS%') PISReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIA,'%Cofins%') CofinsReais,
--	VB: FobReais + FreteReais + SeguroReais + IIReais + IPIReais + TxExtratoDIReais + ICMSReais + PISReais + CofinsReais = TotalReais
	dbo.fBusca_HistoricoDescr(hou.num_proc_HIA,54,getdate())	Motivo_Atraso,
	Right(Left(P.Planta,5),2)								Company_ID,
	P.Planta
from LLP_Imp_Aer	LLP
	Join House_Imp_Aer			HOU	with(nolock) on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA --and right(left(LLP.Num_Proc_LIA,9),4) = '2009'
	Left Join Job_Imp_Aer		JIA	with(nolock) on HOU.Num_Proc_HIA = JIA.Num_Proc_HIA
	Left Join Pessoa			CONS with(nolock) on HOU.Cd_Consig_HIA = CONS.Cd_Pes
	Join Pedido_Ship 			PS	with(nolock) on HOU.Num_Proc_HIA = PS.Num_Proc
	Join Pedido					P	with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det 			PD	with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto --and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join Localidade		ORG	with(nolock) on HOU.Cd_Org_HIA = ORG.Cd_Local
	left Join Fatura_CHB		FCHB with(nolock) on HOU.Num_Proc_HIA = FCHB.Processo_PC
	Left Join tarefas_processos	TaskPC with(nolock) on HOU.Num_Proc_HIA = TaskPC.num_proc AND id_task=14
	Left Join Localidade		DEST with(nolock) on HOU.Cd_Dst_HIA = DEST.Cd_Local
	Join Nota_Cliente			NOTA with(nolock) on HOU.Num_Proc_HIA = NOTA.Num_Proc --and DI.Numero_PO_HIA = NOTA.DI
	Left Join PO_HIA			CI	with(nolock) on HOU.Num_Proc_HIA = CI.Num_Proc_HIA and CI.ID_PO_HIA = 6
--	Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
--	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Join Cia_Aerea			CIA	with(nolock) on JIA.Cd_Cia_Aer   = CIA.Cd_Cia_Aer
	Left Join Pessoa 			AGT	with(nolock) on JIA.cd_agente=AGT.cd_pes
	Left Join PO_HIA			DI	with(nolock) on HOU.Num_Proc_HIA = DI.Num_Proc_HIA and DI.ID_PO_HIA = 5
	Join Pessoa_LLP				PLL with(nolock) on PLL.Cd_Pes=CONS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
where
	NOTA.Nota_Fiscal  like '%' and PO_GRP IN ('041','431','620') 
	--and year(ATA_Lia) = 2011
	and ata_lia >= getdate()-180
--	and dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,'4') <= '2009-12-31'
Group by
	HOU.Num_Proc_HIA,
	P.Num_Pedido,
	P.Num_PO,
	CONS.Apelido,
	PD.Peso_Liquido_TOT,
	HOU.HAWB_HIA,
	HOU.MAWB_HIA,
--	HOU.Navio_HIA,
	CIA.Nome_Cia_Aer,
	AGT.Nome_Raz_Soc,
	ORG.Pais_Local,
	P.Incoterm,
	TaskPC.Dt_Conclusao,
	DEST.Nome_Local,
	DI.Data_PO_HIA,
	DI.Numero_PO_HIA,
	LLP.Canal_LIA,
	LLP.ATA_LIA,
	CI.Data_PO_HIA,
	Vlr_Frete_efet_HIA,
	ETA_LIA,
--	PS.cd_produto,
--	PS.cd_pedido,
	NOTA.Paridade,
	Right(Left(P.Planta,5),2),
	P.Planta

Union all
select
	HOU.Num_Proc_HIO						Ref_BDP,
	P.Num_Pedido							SAP,
	P.Num_PO								PU,
	CONS.Apelido							Consignee,
	dbo.fBusca_GMID(HOU.Num_Proc_HIO)		GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO)	Produtos,
	sum(isnull(PD.Peso_Liquido_TOT,0))/1000	TON,
	LLP.Tipo_LIO							Modo,
	HOU.HAWB_HIO							House,
	HOU.MAWB_HIO							Master,
	Null									Navio,
	CAR.Nome_Raz_Soc						Transportador,
	AGT.Nome_Raz_Soc						Agente,
	ORG.Pais_Local							Origem,
	P.Incoterm								Incoterms,
	dbo.fBusca_InvoiceNum (HOU.Num_Proc_HIO) Invoices,
	MAX(FCHB.Data_PC)						Data_Fatura,
	TaskPC.Dt_Conclusao						Envio_Fatura,
	DEST.Nome_Local							Local_Entrada,
	DI.Data_PO_HIO							DataDI,
	DI.Numero_PO_HIO						NroDI,
	isnull(Paridade,1.7)					TxDolar,
	LLP.Canal_LIO							Canal,
	LLP.ATA_LIO								Chegada,
	dbo.fBusca_Historico(hou.num_proc_HIO,53,GETDATE()) 		SaidaNavio,
	dbo.fBusca_Tarefa(hou.num_proc_HIO,15)				PresencaCarga,
	dbo.fBusca_Tarefa(hou.num_proc_HIO,4)				Desembaraco,
	CI.Data_PO_HIO							DataCI,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_HIO,54),ETA_LIO +7)	Previsao,
	dbo.fBusca_Historico(hou.num_proc_hio,57,getdate()) Data_Entrega_Transporte,
	dbo.fBusca_Historico(hou.num_proc_hio,56,getdate()) DepositoDataReal,
	dbo.fBusca_Containers (hou.num_proc_HIO)			Containers,
	dbo.fBusca_Volumes (hou.num_proc_HIO)				Volumes,
	dbo.qty_container(hou.num_proc_HIO)				QtdContainers,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%Posicionamento%') Posicionamento,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%Desova%') Desova,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%Pesagem%') Pesagem,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%Armazenagem%') Armazenagem,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%Consertadores%') Consertadores,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%Vistoria%') Vistoria,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%MediaContainer%') MediaContainer,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%THC%') THC,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%fee%') BLFee,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%adiantamento%') Adiantamento,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%CPMF%') CPMF,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%AFRM%') AFRM,

	dbo.FBusca_FOB(hou.num_proc_HIO,'I')/Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hio,'31'),1.7)	FobUSD,
	Vlr_Frete_efet_HIO /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hio,'31'),1.7)			FreteUSD,
--	VB: FobUSD + FreteUSD						ValorCFUSD
	dbo.FBusca_FOB(hou.num_proc_HIO,'S')/Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hio,'31'),1.7)	SeguroUSD,
--	VB: FobUSD + FreteUSD + SeguroUSD				CIFUSD
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%Impos% Impor%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hio,'31'),1.7) IIUSD,
--	VB: FobUSD + FreteUSD + SeguroUSD + IIUSD			CIFeIIUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'IPI%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hio,'31'),1.7) IPIUSD,
	Isnull(Paridade,1.7)						TxExtratoDIUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%ICMS%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hio,'31'),1.7) ICMSUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%PIS%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hio,'31'),1.7) PISUSD,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%Cofins%') /Isnull(dbo.fBusca_CampoCliente(HOU.num_proc_hio,'31'),1.7) CofinsUSD,
--	VB: FobUSD + FreteUSD + SeguroUSD + IIUSD + IPIUSD + TxExtratoDIUSD + ICMSUSD + PISUSD	+ CofinsUSD = TotalUSD,

	dbo.FBusca_FOB(hou.num_proc_HIO,'I')				FobReais,
	Vlr_Frete_efet_HIO						FreteReais,
--	VB: FobReais + FreteReais					ValorCFReais,
	dbo.FBusca_FOB(hou.num_proc_HIO,'S')				SeguroReais,
--	VB: FobReais + FreteReais + SeguroReais				CIFReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%Impos% Impor%') IIReais,
--	VB: FobReais + FreteReais + SeguroReais + IIReais		CIFeIIReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'IPI%') IPIReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%SISCOMEX%') TxExtratoDIReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%ICMS%') ICMSReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%PIS%') PISReais,
	dbo.fBusca_Custo_Processo(HOU.num_proc_HIO,'%Cofins%') CofinsReais,
--	VB: FobReais + FreteReais + SeguroReais + IIReais + IPIReais + TxExtratoDIReais + ICMSReais + PISReais + CofinsReais = TotalReais
	dbo.fBusca_HistoricoDescr(hou.num_proc_HIO,54,getdate())	Motivo_Atraso,
	Right(Left(P.Planta,5),2)								Company_ID,
	P.Planta
from LLP_Imp_Out				LLP 
	Join House_Imp_Out			HOU	with(nolock) on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO --and right(left(LLP.Num_Proc_LIO,9),4) = '2009'
	Left Join Pessoa			CONS with(nolock) on HOU.Cd_Consig_HIO = CONS.Cd_Pes
	Join Pedido_Ship 			PS	with(nolock) on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido					P	with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det 			PD	with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto --and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join Localidade		ORG	with(nolock) on HOU.Cd_Org_HIO = ORG.Cd_Local
	left Join Fatura_CHB		FCHB with(nolock) on HOU.Num_Proc_HIO = FCHB.Processo_PC
	Left Join tarefas_processos	TaskPC with(nolock) on HOU.Num_Proc_HIO = TaskPC.num_proc AND id_task=14
	Left Join Localidade		DEST with(nolock) on HOU.Cd_Dst_HIO = DEST.Cd_Local
	Join Nota_Cliente			NOTA with(nolock) on HOU.Num_Proc_HIO = NOTA.Num_Proc --and DI.Numero_PO_HIO = NOTA.DI
	Left Join PO_HIO			CI	with(nolock) on HOU.Num_Proc_HIO = CI.Num_Proc_HIO and CI.ID_PO_HIO = 6
	Join Produto_Cliente		PC	with(nolock) on PS.Cd_Produto =PC.Cd_Prod
--	Join De_Para_Produto 		DPP	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa		CAR	with(nolock) on LLP.Cd_carrier   = CAR.Cd_Pes
	Left Join Pessoa 			AGT	with(nolock) on LLP.cd_agente=AGT.cd_pes
	Left Join PO_HIO			DI	with(nolock) on HOU.Num_Proc_HIO = DI.Num_Proc_HIO and DI.ID_PO_HIO = 5
	Join Pessoa_LLP				PLL with(nolock) on PLL.Cd_Pes=CONS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
where
	NOTA.Nota_Fiscal  like '%' and PO_GRP IN ('041','431','620') 
	and	year(ATA_Lio) = 2011
	and ata_lio >= getdate()-180
--	and dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,'4') <= '2009-12-31'
Group by
	HOU.Num_Proc_HIO,
	P.Num_Pedido,
	P.Num_PO,
	CONS.Apelido,
	PD.Peso_Liquido_TOT,
	HOU.HAWB_HIO,
	HOU.MAWB_HIO,
--	HOU.Navio_HIO,
	CAR.Nome_Raz_Soc,
	AGT.Nome_Raz_Soc,
	ORG.Pais_Local,
	P.Incoterm,
	TaskPC.Dt_Conclusao,
	DEST.Nome_Local,
	DI.Data_PO_HIO,
	DI.Numero_PO_HIO,
	LLP.Canal_LIO,
	LLP.ATA_LIO,
	CI.Data_PO_HIO,
	Vlr_Frete_efet_HIO,
	ETA_LIO,
--	PS.cd_produto,
--	PS.cd_pedido,
	NOTA.Paridade,
	LLP.Tipo_Lio,
	Right(Left(P.Planta,5),2),
	P.Planta

















GO
