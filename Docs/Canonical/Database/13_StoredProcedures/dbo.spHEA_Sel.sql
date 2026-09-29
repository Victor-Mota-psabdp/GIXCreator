SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	PROCEDURE [dbo].[spHEA_Sel] --'EAATL20100802001'
(
@Processo		VarChar(16)
)
AS
	Select  
--House_exp_Aer
		Dt_Emis_HEA,
		HOU.MAWB_HEA 			MAWB_HEA,
		HOU.HAWB_HEA 			HAWB_HEA,
		Ship.Apelido 			Shipper,
		Consig.Apelido 			Consignee,
		Export.Apelido 			Notify,
		Orig.Nome_Local 		Loading,
		Destin.Nome_Local 		Delivery,
		HOU.Voo_HEA 			Voo,
		CHB.Apelido CHB,
		Qtd_Tot_Vol_HEA,
		Peso_Bruto_HEA,
		Peso_Real_HEA,
		Vol_Tot_HEA, 
		Tp_Frete_HEA,
		TM.Nome_Tp_Moeda,
		Vlr_Frete_Tot_HEA,
		SAP_ShipNumber 			SAP,
		TP.NOMe_Tp_Oper 		Incoterm,
		TTime_d,
		HAN.Hand_Hea_1			Handling,
		HOU.Tx_Refer_HEA		Taxa_Ref,
		Obs_HEA,
--JOB_EXP_MAR
		Sales.Nome_Usuario		Vendedor,
		Emb.Nome_Tp_Embal		Embalagem,
		Agente.Apelido			Agente, 
		CSR.Nome_Usuario		Customer,
--LLP
		LLP.ETA_LEA 			ETA_LEA,
		LLP.ETD_LEA 			ETD_LEA,
		LLP.ATA_LEA 			ATA_LEA,
		LLP.ATD_LEA 			ATD_LEA,
		Planta.nome_local		Planta,
		DstFinal.Nome_Local 	DstFinal,
		Cia.Nome_Cia_Aer 		Cia_Aerea,
		Courier.Apelido 		Courier,
		LLP.Courier_Number_LEA	Courier_Number,
		Forwarder.Apelido		Forwarder,
		LLP.Intl_Ref_LEA		Intl_ref,
		LLP.Net_Rates_LEA		Net_Rates_LEA,
		LLP.Selling_Rates_LEA	Selling_Rates_LEA,
		LLP.Peso_Cubado_LEA		Peso_cubado_LEA,
		LLP.DL_Cargo_Lea		DL_Cargo,
		TERM.Nome_Terminal		Terminal,
		LLP.Canal_Lea			Canal_Lea,
		OD.Apelido				Order_Lea,
		LLP.Original_ETA_Lea	Original_ETA_Lea,
		Transp.Apelido			Transportadora,
		NTF.Apelido				Notify_2,
		MultiModal,
		Vlr_Invoice,
		TM_INV.Nome_Tp_Moeda	Moeda_INV,
		LLP.Comissao_Agente_Lea	Comissao_Agente_Lea,
		isnull(LLP.PO_Req_Date,LLP.ETA_LEA+10) PO_Req_Date,
--Nature_Gooods
		Descr.Descr				Descr,
		Num_Proc_MEA			Ref_Consolidada,
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status
	From  
		House_exp_Aer HOU
		Left Outer Join Pessoa		Export		on Cd_Notify_HEA = Export.Cd_Pes
		Left Outer Join Pessoa		Consig		on Cd_Consig_HEA = Consig.Cd_Pes 
		Left Outer Join Pessoa		Ship		on Cd_Export_HEA = Ship.Cd_Pes
		Left Outer Join Pessoa		CHB			on Cd_Dsp_HEA = CHB.Cd_Pes		
		Left Outer Join LLP_Exp_Aer	LLP			on HOU.Num_proc_HEA = LLP.Num_proc_LEA
		Left Outer Join Localidade	Planta		on LLP.cd_Planta_LEA = Planta.cd_local
		Left Outer Join Localidade	DstFinal	on LLP.cd_dstfinal_LEA = Dstfinal.cd_local
		Left Outer Join Cia_Aerea	Cia			on LLP.cd_CiaAerea_LEA = Cia.Cd_Cia_Aer
		Left Outer Join Pessoa		Courier		on LLP.Cd_Courier = Courier.Cd_Pes
		Left Outer Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Outer Join Job_Exp_Aer	JOB			on HOU.Num_proc_HEA = JOB.Num_Proc_HEA
		Left Outer Join Pessoa		Agente		on JOB.Cd_Agente = Agente.Cd_Pes
		Left Outer Join Usuario		Sales		on JOB.Cd_Vendedor = Sales.Cd_Usuario
		Left Outer Join Usuario		CSR			on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Nature_Goods Descr		on HOU.Num_proc_HEA = Descr.Num_Proc 
		Left Outer Join Localidade	Orig		on Cd_Org_HEA = Orig.Cd_Local 
		Left Outer Join Localidade	Destin		on Cd_Dst_HEA = Destin.Cd_Local 
		Left Outer Join Tipo_Moeda	TM			on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
		Left Outer Join Handling_HEa	HAN		on HOU.Num_Proc_Hea = HAN.Num_Proc_Hea
		Left Outer Join Tipo_Embalagem	Emb		on JOB.Cd_Tp_Embal = Emb.Cd_Tp_Embal
		Left Outer Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Terminal 	TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Pessoa		NTF			on LLP.Cd_Notify_2 = NTF.Cd_Pes
		Left Outer Join Tipo_Oper	TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Outer Join Tipo_Status_Processo Status on STatus.id_status=LLP.id_status
	Where
		HOU.Num_Proc_HEA= @Processo





























GO
