SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from altera_bl

CREATE	PROCEDURE [dbo].[spHEM_Alterado_Sel] 
(
@Processo		VarChar(16)
)
AS
	Select  
--House_exp_mar
		Dt_Emis_HEM,
		HOU.MAWB_HEM 			MAWB_HEM,
		HOU.HAWB_HEM 			HAWB_HEM,
		Ship.Apelido 			Shipper,
		Consig.Apelido 			Consignee,
		Export.Apelido 			Notify,
		Orig.Nome_Local 		Loading,
		Destin.Nome_Local 		Delivery,
		Viagem_HEM Voyage,
		Navio_HEM Vessel,
		CHB.Apelido CHB,
		--Dt_Saida_HEM,
		--Dt_Cheg_HEM,
		Qtd_Tot_Vol_HEM,
		Peso_Bruto_HEM,
		Peso_Liquido_HEM,
		Vol_Tot_HEM, 
		Tp_Frete_HEM,
		TM.Nome_Tp_Moeda,
		Vlr_Frete_Tot_HEM,
		SAP_ShipNumber 			SAP,
		TP.NOME_Tp_Oper 		Incoterm,
		TTime_d,
		Obs_HEM,
--JOB_EXP_MAR
		JOB.Nr_Reserva 			Booking,
		Sales.Nome_Usuario		Vendedor,
		Agente.Apelido			Agente, 
		CSR.Nome_Usuario		Customer,
--LLP
		LLP.ETA_LEM 			ETA_LEM,
		LLP.ETD_LEM 			ETD_LEM,
		LLP.ATA_LEM 			ATA_LEM,
		LLP.ATD_LEM 			ATD_LEM,
		Planta.nome_local 		Planta,
		DstFinal.Nome_Local 	DstFinal,
		Armador.Nome_Armador 	Armador,
		Carga.Nome_tp_Carga 	Carga,
		Courier.Apelido 		Courier,
		LLP.Courier_Number_Lem  Courier_Number,
		Forwarder.Apelido 		Forwarder,
		LLP.Intl_Ref_Lem		Intl_ref,
		LLP.Net_Rates_Lem		Net_Rates_Lem,
		LLP.Canal_Lem			Canal_Lem,
		TERM.Nome_Terminal		Terminal,
		OD.Apelido				Order_Lem,
		LLP.Selling_Rates_Lem	Selling_Rates_Lem,
		LLP.Original_ETA_Lem	Original_ETA_Lem,
		Transp.Apelido			Transportadora,
		NTF.Apelido				Notify_2,
		LLP.Dt_BL_Lem			Dt_BL,
		MultiModal,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Comissao_Agente_Lem	Comissao_Agente_Lem,
		isnull(LLP.PO_Req_Date,LLP.ETA_LEM+10) PO_Req_Date,
--Nature_Gooods
		Descr.Descr				Descr,
		Num_Proc_MEM			Ref_Consolidada,
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status
	From  
		House_exp_Mar HOU
		Left Outer Join Pessoa		Export		on Cd_Notify_HEM = Export.Cd_Pes
		Left Outer Join Pessoa		Consig		on Cd_Consig_HEM = Consig.Cd_Pes 
		Left Outer Join Pessoa		Ship		on Cd_Export_HEM = Ship.Cd_Pes
		Left Outer Join Pessoa		CHB			on Cd_Dsp_HEM = CHB.Cd_Pes		
		Left Outer Join LLP_Exp_mar	LLP			on HOU.Num_proc_hem = LLP.Num_proc_LEM
		Left Outer Join Localidade	Planta		on LLP.cd_Planta_Lem = Planta.cd_local
		Left Outer Join Localidade	DstFinal	on LLP.cd_dstfinal_lem = Dstfinal.cd_local
		Left Outer Join Armador		Armador		on LLP.cd_armador_lem = Armador.cd_Armador
		Left Outer Join Tipo_Carga	Carga		on LLP.cd_tp_carga = Carga.cd_tp_Carga 
		Left Outer Join Pessoa		Courier		on LLP.Cd_Courier = Courier.Cd_Pes
		Left Outer Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Outer Join Job_Exp_Mar	JOB			on HOU.Num_proc_hem = JOB.Num_Proc_HEM
		Left Outer Join Pessoa		Agente		on JOB.Cd_Agente = Agente.Cd_Pes
		Left Outer Join Usuario		Sales		on JOB.Cd_Vendedor = Sales.Cd_Usuario
		Left Outer Join Usuario		CSR			on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Nature_Goods Descr		on HOU.Num_proc_hem = Descr.Num_Proc 
		Left Outer Join Localidade	Orig		on Cd_Org_HEM = Orig.Cd_Local 
		Left Outer Join Localidade	Destin		on Cd_Dst_HEM = Destin.Cd_Local 
		Left Outer Join Tipo_Moeda	TM			on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice	= TM_INV.Cd_Tp_Moeda
		Left Outer Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Terminal	TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Tipo_Oper	TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Outer Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Pessoa		NTF			on LLP.Cd_Notify_2 = NTF.Cd_Pes
		Left Outer Join Tipo_Status_Processo Status on STatus.id_status=LLP.id_status
	Where
		HOU.Num_Proc_HEM= @Processo
GO
