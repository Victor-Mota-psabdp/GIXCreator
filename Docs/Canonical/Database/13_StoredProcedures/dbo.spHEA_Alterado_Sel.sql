SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	PROCEDURE [dbo].[spHEA_Alterado_Sel] --'EAATL20100802001'
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
		AGE.apelido		 		Notify,
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
		HOU.Num_Proc_MEA			Ref_Consolidada,
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status,
		
		
		HOU.Num_Proc_HEA,
		Ship.Apelido 			cmbShipper,
		Ship.Nome_Raz_Soc + Char(13) 
			+ 'CNPJ: ' + ISNULL(Ship.Num_CPF_CNPJ,'') + Char(13) 
			+ isnull(ShipED.Rua,'') + ',' + isnull(ShipED.Numero,'')
			+ isnull(ShipED.compl_end,'') + '  CEP:' + isnull(ShipED.cep,'') + ' '
			+ isnull(ShipED.cidade,'') txtShipper,
			
		Consig.Apelido 			cmbConsignee,
		Consig.Nome_Raz_Soc + Char(13) 
			+ 'CNPJ: ' + ISNULL(Consig.Num_CPF_CNPJ,'') + Char(13) 
			+ isnull(ConsigED.Rua,'') + ',' + isnull(ConsigED.Numero,'')
			+ isnull(ConsigED.compl_end,'') + '  CEP:' + isnull(ConsigED.cep,'') + ' '
			+ isnull(ConsigED.cidade,'') txtConsignee,
			
		AGE.apelido 			cmbNotify,
		AGE.Nome_Raz_Soc + Char(13) 
			+ 'CNPJ: ' + ISNULL(AGE.Num_CPF_CNPJ,'') + Char(13) 
			+ isnull(NotifyED.Rua,'') + ',' + isnull(NotifyED.Numero,'')
			+ isnull(NotifyED.compl_end,'') + '  CEP:' + isnull(NotifyED.cep,'') + ' '
			+ isnull(NotifyED.cidade,'') txtNotify,
			
		Planta.nome_local		cmbOrigin,
		Orig.Nome_Local 		cmbLoading,
		Destin.Nome_Local 		cmbDelivery,
		DstFinal.Nome_Local 	cmbFinalDestination,
		
		null cmbCarrier,
		null cmbVoyage,
		null txtVessel,
		--@cd_usuario cd_usuario,
		'1' [status],
		GETDATE() dt_ins,
		Cia.Nome_Cia_Aer 		cmbCiaAerea,
		HOU.Voo_HEA 			txtVoo,
		null txtVoyage,
		null cmbVessel,
		
		AGE.apelido 			cmbIssuing,
		AGE.Nome_Raz_Soc + Char(13) 
			+ 'CNPJ: ' + ISNULL(AGE.Num_CPF_CNPJ,'') + Char(13) 
			+ isnull(NotifyED.Rua,'') + ',' + isnull(NotifyED.Numero,'')
			+ isnull(NotifyED.compl_end,'') + '  CEP:' + isnull(NotifyED.cep,'') + ' '
			+ isnull(NotifyED.cidade,'') txtIssuing,
		'NVD'	txtCarriage,
		'NCV'	txtCustoms,
		null txtAmount,
		'BDP SOUTH AMERICA LTDA.' txtSignatureShipper,
		'A.VOELCKERS' txtSignatureCarrier,
		
		ShipED.CEP												txtShipperPostcodeCode,
		ShipED.RUA + ShipED.numero								txtShipperStreetName,
		ShipED.Cidade											txtShipperCityName,	
		ShipED.CD_pais											txtShipperCountryID,
		UPPER(ShipED.Pais)										txtShipperCountryName,
		
		ShipCOMS.contato											txtShipperPersonName,
		ShipCOMS.Depto_Ctt											txtShipperDepartmentName,
		(ShipCOMS.cd_int + ShipCOMS.cd_area_fone + ShipCOMS.prefixo + ShipCOMS.num_fone) txtShipperDirectTelephoneCommunication,	
		(ShipCOMFS.cd_int + ShipCOMFS.cd_area_fone + ShipCOMFS.prefixo + ShipCOMFS.num_fone) txtShipperFaxCommunication,
		ShipCOMS.Compl_Fone											txtShipperURIEmailCommunication,
		
		ConsigED.CEP												txtConsigneePostcodeCode,
		ConsigED.RUA + ConsigED.numero								txtConsigneeStreetName,
		ConsigED.Cidade											txtConsigneeCityName,	
		ConsigED.CD_pais											txtConsigneeCountryID,
		UPPER(ConsigED.Pais)										txtConsigneeCountryName,
		
		ConsigCOMS.contato											txtConsigneePersonName,
		ConsigCOMS.Depto_Ctt											txtConsigneeDepartmentName,
		(ConsigCOMS.cd_int + ConsigCOMS.cd_area_fone + ConsigCOMS.prefixo + ConsigCOMS.num_fone) txtConsigneeDirectTelephoneCommunication,	
		(ConsigCOMFS.cd_int + ConsigCOMFS.cd_area_fone + ConsigCOMFS.prefixo + ConsigCOMFS.num_fone) txtConsigneeFaxCommunication,
		ConsigCOMS.Compl_Fone											txtConsigneeURIEmailCommunication,
	
		NotifyED.CEP												txtNotifyPostcodeCode,
		NotifyED.RUA + NotifyED.numero								txtNotifyStreetName,
		NotifyED.Cidade											txtNotifyCityName,	
		NotifyED.CD_pais											txtNotifyCountryID,
		UPPER(NotifyED.Pais)										txtNotifyCountryName,
		
		NotifyCOMS.contato											txtNotifyPersonName,
		NotifyCOMS.Depto_Ctt											txtNotifyDepartmentName,
		(NotifyCOMS.cd_int + NotifyCOMS.cd_area_fone + NotifyCOMS.prefixo + NotifyCOMS.num_fone) txtNotifyDirectTelephoneCommunication,	
		(NotifyCOMFS.cd_int + NotifyCOMFS.cd_area_fone + NotifyCOMFS.prefixo + NotifyCOMFS.num_fone) txtNotifyFaxCommunication,
		NotifyCOMS.Compl_Fone											txtNotifyURIEmailCommunication,
			
		NotifyED.CEP												txtIssuingPostcodeCode,
		NotifyED.RUA + NotifyED.numero								txtIssuingStreetName,
		NotifyED.Cidade											txtIssuingCityName,	
		NotifyED.CD_pais											txtIssuingCountryID,
		UPPER(NotifyED.Pais)										txtIssuingCountryName,
		
		NotifyCOMS.contato											txtIssuingPersonName,
		NotifyCOMS.Depto_Ctt											txtIssuingDepartmentName,
		(NotifyCOMS.cd_int + NotifyCOMS.cd_area_fone + NotifyCOMS.prefixo + NotifyCOMS.num_fone) txtIssuingDirectTelephoneCommunication,	
		(NotifyCOMFS.cd_int + NotifyCOMFS.cd_area_fone + NotifyCOMFS.prefixo + NotifyCOMFS.num_fone) txtIssuingFaxCommunication,
		NotifyCOMS.Compl_Fone											txtIssuingURIEmailCommunication	
	From  
		House_exp_Aer HOU with(nolock)
		Left Outer Join Pessoa			Ship		with(nolock) on		Cd_Export_HEA = Ship.Cd_Pes
		Left Outer Join Pessoa		CHB				with(nolock) on Cd_Dsp_HEA = CHB.Cd_Pes
		Left Outer Join Endereco		ShipED		with(nolock) on		ShipED.cd_pes=Ship.cd_pes and ShipED.Cd_Tp_End='COM'
		left Outer join comunicacao		ShipCOMS	with(nolock) on		Ship.cd_pes = ShipCOMS.cd_pes AND ShipCOMS.cd_tp_com = 'TC1'
		left Outer join comunicacao		ShipCOMFS	with(nolock) on		Ship.cd_pes = ShipCOMFS.cd_pes AND ShipCOMFS.cd_tp_com = 'FC1'
		
		Left Outer Join Pessoa			Consig		with(nolock) on		Cd_Consig_HEA = Consig.Cd_Pes
		Left Outer Join Endereco		ConsigED	with(nolock) on		ConsigED.cd_pes=Consig.cd_pes and ConsigED.Cd_Tp_End='COM' 
		left Outer join comunicacao		ConsigCOMS	with(nolock) on		Consig.cd_pes = ConsigCOMS.cd_pes AND ConsigCOMS.cd_tp_com = 'TC1'
		left Outer join comunicacao		ConsigCOMFS	with(nolock) on		Consig.cd_pes = ConsigCOMFS.cd_pes AND ConsigCOMFS.cd_tp_com  = 'FC1'
		
		Left Outer Join	Master_exp_Aer	MIA			with(nolock) on		HOU.num_proc_mea = MIA.num_proc_mea
		Left Outer Join Pessoa			AGE			with(nolock) on		MIA.cd_export_mea = AGE.cd_pes
		Left Outer Join Endereco		NotifyED	with(nolock) on		NotifyED.cd_pes=AGE.cd_pes and NotifyED.Cd_Tp_End='COM' 
		left Outer join comunicacao		NotifyCOMS	with(nolock) on		AGE.cd_pes = NotifyCOMS.cd_pes AND NotifyCOMS.cd_tp_com = 'TC1'
		left Outer join comunicacao		NotifyCOMFS	with(nolock) on		AGE.cd_pes = NotifyCOMFS.cd_pes AND NotifyCOMFS.cd_tp_com  = 'FC1'	
		
		Left Outer Join LLP_Exp_Aer	LLP			with(nolock) on	 HOU.Num_proc_HEA = LLP.Num_proc_LEA
		Left Outer Join Localidade	Planta		with(nolock) on	 LLP.cd_Planta_LEA = Planta.cd_local
		Left Outer Join Localidade	DstFinal	with(nolock) on	 LLP.cd_dstfinal_LEA = Dstfinal.cd_local
		Left Outer Join Cia_Aerea	Cia			with(nolock) on	 LLP.cd_CiaAerea_LEA = Cia.Cd_Cia_Aer
		Left Outer Join Pessoa		Courier		with(nolock) on LLP.Cd_Courier = Courier.Cd_Pes
		Left Outer Join Pessoa		Forwarder	with(nolock) on LLP.Cd_Forwarder = Forwarder.Cd_Pes
		Left Outer Join Job_Exp_Aer	JOB			with(nolock) on HOU.Num_proc_HEA = JOB.Num_Proc_HEA
		Left Outer Join Pessoa		Agente		with(nolock) on JOB.Cd_Agente = Agente.Cd_Pes
		Left Outer Join Usuario		Sales		with(nolock) on JOB.Cd_Vendedor = Sales.Cd_Usuario
		Left Outer Join Usuario		CSR			with(nolock) on JOB.Cd_Usuario = CSR.Cd_Usuario
		Left Outer Join Nature_Goods Descr		with(nolock) on HOU.Num_proc_HEA = Descr.Num_Proc 					
		Left Outer Join Localidade	Orig		with(nolock) on	 Cd_Org_HEA = Orig.Cd_Local 
		Left Outer Join Localidade	Destin		with(nolock) on	 Cd_Dst_HEA = Destin.Cd_Local
		Left Outer Join Tipo_Moeda	TM			with(nolock) on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Left Outer Join Tipo_Moeda	TM_INV		with(nolock) on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
		Left Outer Join Handling_HEa	HAN		with(nolock) on HOU.Num_Proc_Hea = HAN.Num_Proc_Hea
		Left Outer Join Tipo_Embalagem	Emb		with(nolock) on JOB.Cd_Tp_Embal = Emb.Cd_Tp_Embal
		Left Outer Join Pessoa		OD			with(nolock) on LLP.Cd_Order = OD.Cd_Pes
		Left Outer Join Terminal 	TERM		with(nolock) on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Outer Join Pessoa		Transp		with(nolock) on LLP.Cd_Transportadora = Transp.Cd_Pes
		Left Outer Join Pessoa		NTF			with(nolock) on LLP.Cd_Notify_2 = NTF.Cd_Pes
		Left Outer Join Tipo_Oper	TP			with(nolock) on HOU.cd_tp_oper = TP.Cd_tp_oper
		Left Outer Join Tipo_Status_Processo Status with(nolock) on STatus.id_status=LLP.id_status						
	Where
		HOU.Num_Proc_HEA= @Processo	
		
		
	--From  
	--	House_exp_Aer HOU
	--	Left Outer Join	Master_exp_Aer MIA		on HOU.num_proc_mea = MIA.num_proc_mea
	--	Left Outer Join Pessoa		AGE			on MIA.cd_export_mea = AGE.cd_pes
	--	Left Outer Join Pessoa		Export		on Cd_Notify_HEA = Export.Cd_Pes
	--	Left Outer Join Pessoa		Consig		on Cd_Consig_HEA = Consig.Cd_Pes 
	--	Left Outer Join Pessoa		Ship		on Cd_Export_HEA = Ship.Cd_Pes
	--	Left Outer Join Pessoa		CHB			on Cd_Dsp_HEA = CHB.Cd_Pes		
	--	Left Outer Join LLP_Exp_Aer	LLP			on HOU.Num_proc_HEA = LLP.Num_proc_LEA
	--	Left Outer Join Localidade	Planta		on LLP.cd_Planta_LEA = Planta.cd_local
	--	Left Outer Join Localidade	DstFinal	on LLP.cd_dstfinal_LEA = Dstfinal.cd_local
	--	Left Outer Join Cia_Aerea	Cia			on LLP.cd_CiaAerea_LEA = Cia.Cd_Cia_Aer
	--	Left Outer Join Pessoa		Courier		on LLP.Cd_Courier = Courier.Cd_Pes
	--	Left Outer Join Pessoa		Forwarder	on LLP.Cd_Forwarder = Forwarder.Cd_Pes
	--	Left Outer Join Job_Exp_Aer	JOB			on HOU.Num_proc_HEA = JOB.Num_Proc_HEA
	--	Left Outer Join Pessoa		Agente		on JOB.Cd_Agente = Agente.Cd_Pes
	--	Left Outer Join Usuario		Sales		on JOB.Cd_Vendedor = Sales.Cd_Usuario
	--	Left Outer Join Usuario		CSR			on JOB.Cd_Usuario = CSR.Cd_Usuario
	--	Left Outer Join Nature_Goods Descr		on HOU.Num_proc_HEA = Descr.Num_Proc 
	--	Left Outer Join Localidade	Orig		on Cd_Org_HEA = Orig.Cd_Local 
	--	Left Outer Join Localidade	Destin		on Cd_Dst_HEA = Destin.Cd_Local 
	--	Left Outer Join Tipo_Moeda	TM			on HOU.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
	--	Left Outer Join Tipo_Moeda	TM_INV		on LLP.Cd_Moeda_Invoice = TM_INV.Cd_Tp_Moeda
	--	Left Outer Join Handling_HEa	HAN		on HOU.Num_Proc_Hea = HAN.Num_Proc_Hea
	--	Left Outer Join Tipo_Embalagem	Emb		on JOB.Cd_Tp_Embal = Emb.Cd_Tp_Embal
	--	Left Outer Join Pessoa		OD			on LLP.Cd_Order = OD.Cd_Pes
	--	Left Outer Join Terminal 	TERM		on LLP.Cd_Terminal = TERM.Cd_Terminal
	--	Left Outer Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
	--	Left Outer Join Pessoa		NTF			on LLP.Cd_Notify_2 = NTF.Cd_Pes
	--	Left Outer Join Tipo_Oper	TP			on HOU.cd_tp_oper = TP.Cd_tp_oper
	--	Left Outer Join Tipo_Status_Processo Status on STatus.id_status=LLP.id_status
	--Where
	--	HOU.Num_Proc_HEA= @Processo

GO
