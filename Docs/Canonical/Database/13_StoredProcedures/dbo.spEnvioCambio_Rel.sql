SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE        Procedure	 [dbo].[spEnvioCambio_Rel]-- 'IMCSR20080100401'
(
@Processo varchar (16)
)
As
select 
	getdate()				Data_Envio_BDP_Corretora,
	SHP.Nome_Raz_Soc		Shipper,
	IMP.Nome_raz_soc		Companhia,
	DI.Numero_PO_HIM		DI,
	INV.Numero_PO_HIM		Invoice,
	P.Num_PO				Ref_PO,
	0						Valor_Fatura,
	HOU.Num_Proc_HIM		JOB
from
	House_Imp_Mar			HOU with(nolock)
	Left Join LLP_Imp_Mar		LLP with(nolock)	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Left Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Left Join PO_HIM			DI with(nolock)	on HOU.Num_Proc_HIM=DI.Num_Proc_HIM and Id_DC = 5
	Left Join Pessoa			IMP with(nolock)	on HOU.Cd_consig_him = IMP.cd_pes
	Left Join Pessoa			SHP with(nolock)	on HOU.Cd_Export_him = SHP.cd_pes
	Left Outer Join PO_HIM INV with(nolock) on LLP.Num_proc_LIM = INV.Num_Proc_HIM and INV.ID_DC = 2
where 
	HOU.Num_Proc_HIM	= @Processo
Group by
	IMP.Nome_raz_soc,
	SHP.Nome_Raz_Soc,
	DI.Numero_PO_HIM,
	INV.Numero_PO_HIM,
	P.Num_PO,
	HOU.Num_Proc_HIM

UNION

select 
	getdate()				Data_Envio_BDP_Corretora,
	SHP.Nome_Raz_Soc		Shipper,
	IMP.Nome_raz_soc		Companhia,
	DI.Numero_PO_HIA		DI,
	INV.Numero_PO_HIA		Invoice,
	P.Num_PO				Ref_PO,
	0						Valor_Fatura,
	HOU.Num_Proc_HIA		JOB
from
	House_Imp_AER			HOU with(nolock)
	Left Join LLP_Imp_AER		LLP with(nolock)	on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
	Left Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIA = PS.Num_Proc
	Left Join Pedido		P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Left Join PO_HIA		DI with(nolock)	on HOU.Num_Proc_HIA=DI.Num_Proc_HIA and Id_DC = 5
	Left Join Pessoa			IMP with(nolock)	on HOU.Cd_consig_hia = IMP.cd_pes
	Left Join Pessoa			SHP with(nolock)	on HOU.Cd_Export_hia = SHP.cd_pes
	Left Outer Join PO_HIA INV with(nolock) on LLP.Num_proc_LIA = INV.Num_Proc_HIA and INV.ID_DC = 2
where 
	HOU.Num_Proc_HIA	= @Processo
Group by
	IMP.Nome_raz_soc,
	SHP.Nome_Raz_Soc,
	DI.Numero_PO_HIA,
	INV.Numero_PO_HIA,
	P.Num_PO,
	HOU.Num_Proc_HIA

UNION

select 
	getdate()				Data_Envio_BDP_Corretora,
	SHP.Nome_Raz_Soc		Shipper,
	IMP.Nome_raz_soc		Companhia,
	DI.Numero_PO_HIO		DI,
	INV.Numero_PO_HIO		Invoice,
	P.Num_PO				Ref_PO,
	0						Valor_Fatura,
	HOU.Num_Proc_HIO		JOB
from
	House_Imp_OUT			HOU with(nolock)
	Left Join LLP_Imp_OUT		LLP with(nolock)	on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
	Left Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIO = PS.Num_Proc
	Left Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Left Join PO_HIO			DI with(nolock)	on HOU.Num_Proc_HIO=DI.Num_Proc_HIO and Id_DC = 5
	Left Join Pessoa			IMP with(nolock)	on HOU.Cd_consig_hio = IMP.cd_pes
	Left Join Pessoa			SHP with(nolock)	on HOU.Cd_Export_hio = SHP.cd_pes
	Left Outer Join PO_HIO INV with(nolock) on LLP.Num_proc_LIO = INV.Num_Proc_HIO and INV.ID_DC = 2
where 
	HOU.Num_Proc_HIO	= @Processo
Group by
	IMP.Nome_raz_soc,
	SHP.Nome_Raz_Soc,
	DI.Numero_PO_HIO,
	INV.Numero_PO_HIO,
	P.Num_PO,
	HOU.Num_Proc_HIO

--UNION
--
--select 
--	HOU.Num_Proc_HIA		JOB,
--convert(datetime,HOU.Dt_Emis_HIA,105)	Data,
--	P.Num_PO			PO,
--	P.Num_Pedido			Order_Number,
--	isnull(OC.Apelido,Consig.Apelido) Ordering_Customer,
--	Ship.Apelido 			Shipper,
--	Consig.Apelido 			Consignee,
--	ORG.Pais_Local			Pais_Origem,
--	dbo.fBusca_GMID(HOU.Num_Proc_HIA)	GMIDs,
--	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA) Produtos,
--	dbo.fNCM(HOU.Num_Proc_HIA) NCM,
--	HOU.Voo_HIA			Navio_Voo,
--	Null				Booking,
--	ORG.Nome_Local			Origem,
--	DEST.Nome_Local			Destino,
--	LLP.ETD_LIA			ETD,
--	LLP.ATD_LIA			ATD,
--	LLP.ETA_LIA			ETA,
--	LLP.ATA_LIA			ATA,
--	TRF.Dt_Previsao		Prev_PreAlert,
--	TRF.Dt_Conclusao		PreAlert,
--	AGT.Nome_Raz_Soc		Agente,
--	CIA.Nome_Cia_Aer		Transportador,
--	SHIPN.Numero_PO_HIA		Shipment_Number
--from
--	House_Imp_Aer			HOU
--	Left Join LLP_Imp_Aer		LLP	on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
--	Left Outer Join Job_Imp_Aer	JIA	on HOU.Num_Proc_HIA = JIA.Num_Proc_HIA
--	Left Join Pedido_Ship 		PS	on HOU.Num_Proc_HIA = PS.Num_Proc
--	Left Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
----	Join Pedido_Det			PD 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
--	Left Outer Join Localidade	DEST	on Hou.Cd_Dst_HIA = DEST.Cd_Local
--	Left Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
--	Left Join De_Para_Produto 	DPP	on PC.Cd_Proc_Cliente = DPP.GMID
--	Left Outer Join Cia_Aerea	CIA	on JIA.Cd_Cia_Aer   = CIA.Cd_Cia_Aer
--	Left Outer Join Pessoa		OC	on LLP.Cd_Order = OC.Cd_Pes
--	Left Outer Join Pessoa		Ship	on HOU.Cd_Export_HIA = Ship.Cd_Pes
--	Left Outer Join Pessoa		Consig	on HOU.Cd_Consig_HIA = Consig.Cd_Pes
--	Left Outer Join Localidade	ORG	on HOU.Cd_Org_HIA = ORG.Cd_Local
--	Left Join Pessoa 		AGT	on JIA.cd_agente=AGT.cd_pes
--	Left Join tarefas_processos	TRF	on HOU.Num_Proc_HIA=TRF.Num_proc and Id_Task='1'
--	Left Join PO_HIA		SHIPN	on HOU.Num_Proc_HIA=SHIPN.Num_Proc_HIA and Id_DC='8'
--where 
--	convert(datetime,Dt_Emis_HIA,105) > @Data and  HOU.Num_Proc_HIA	like 'IACSR%'
--Group by
--	HOU.Num_Proc_HIA,
--	HOU.Dt_Emis_HIA,
--	P.Num_PO,
--	P.Num_Pedido,
--	OC.Apelido,Consig.Apelido,
--	Ship.Apelido,
--	Consig.Apelido,
--	ORG.Pais_Local,
--	HOU.Voo_HIA,
--	ORG.Nome_Local,
--	DEST.Nome_Local,
--	LLP.ETD_LIA,
--	LLP.ATD_LIA,
--	LLP.ETA_LIA,
--	LLP.ATA_LIA,
--	TRF.Dt_Previsao,
--	TRF.Dt_Conclusao,
--	AGT.Nome_Raz_Soc,
--	CIA.Nome_Cia_Aer,
--	SHIPN.Numero_PO_HIA
--
--UNION
--select 
--	HOU.Num_Proc_HIO		JOB,
--convert(datetime,HOU.Dt_Emis_HIO,105)	Data,
--	P.Num_PO			PO,
--	P.Num_Pedido			Order_Number,
--	isnull(OC.Apelido,Consig.Apelido) Ordering_Customer,
--	Ship.Apelido 			Shipper,
--	Consig.Apelido 			Consignee,
--	ORG.Pais_Local			Pais_Origem,
--	dbo.fBusca_GMID(HOU.Num_Proc_HIO)	GMIDs,
--	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO) Produtos,
--	dbo.fNCM(HOU.Num_Proc_HIO) NCM,
--	Null				Navio_Voo,
--	Null				Booking,
--	ORG.Nome_Local			Origem,
--	DEST.Nome_Local			Destino,
--	LLP.ETD_LIO			ETD,
--	LLP.ATD_LIO			ATD,
--	LLP.ETA_LIO			ETA,
--	LLP.ATA_LIO			ATA,
--	TRF.Dt_Previsao,
--	TRF.Dt_Conclusao		PreAlert,
--	AGT.Nome_Raz_Soc		Agente,
--	CAR.Nome_Raz_Soc		Transportador,
--	SHIPN.Numero_PO_HIO		Shipment_Number
--from
--	House_Imp_Out			HOU
--	Left Join LLP_Imp_Out		LLP	on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
--	Left Join Pedido_Ship 		PS	on HOU.Num_Proc_HIO = PS.Num_Proc
--	Left Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
--	Left Join Localidade		DEST	on Hou.Cd_Dst_HIO = DEST.Cd_Local
--	Left Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
--	Left Join De_Para_Produto 	DPP	on PC.Cd_Proc_Cliente = DPP.GMID
--	Left Join Pessoa		OC	on LLP.Cd_Order = OC.Cd_Pes
--	Left Join Pessoa		Ship	on HOU.Cd_Export_HIO = Ship.Cd_Pes
--	Left Join Pessoa		Consig	on HOU.Cd_Consig_HIO = Consig.Cd_Pes
--	Left Join Localidade		ORG	on HOU.Cd_Org_HIO = ORG.Cd_Local
--	Left Join Pessoa 		AGT	on LLP.cd_agente=AGT.cd_pes
--	Left Join Pessoa		CAR	on LLP.Cd_carrier   = CAR.Cd_Pes
--	Left Join tarefas_processos	TRF	on HOU.Num_Proc_HIO = TRF.Num_proc and Id_Task='1'
--	Left Join PO_HIO		SHIPN	on HOU.Num_Proc_HIO=SHIPN.Num_Proc_HIO and Id_DC='8'
--where
--	convert(datetime,Dt_Emis_HIO,105) > @Data and  HOU.Num_Proc_HIO	like 'IACSR%'
--Group by
--	HOU.Num_Proc_HIO,
--	HOU.Dt_Emis_HIO,
--	P.Num_PO,
--	P.Num_Pedido,
--	OC.Apelido,Consig.Apelido,
--	Ship.Apelido,
--	Consig.Apelido,
--	ORG.Pais_Local,
--	ORG.Nome_Local,
--	DEST.Nome_Local,
--	LLP.ETD_LIO,
--	LLP.ATD_LIO,
--	LLP.ETA_LIO,
--	LLP.ATA_LIO,
--	TRF.Dt_Previsao,
--	TRF.Dt_Conclusao,
--	AGT.Nome_Raz_Soc,
--	CAR.Nome_Raz_Soc,
--	SHIPN.Numero_PO_HIO




Order by
	JOB









GO
