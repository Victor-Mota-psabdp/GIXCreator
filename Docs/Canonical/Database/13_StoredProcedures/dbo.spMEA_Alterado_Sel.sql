SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMEA_Alterado_Sel] --'IMGIG200901029'
(
@Num_Proc	VarChar(14)
)
AS
	Select
		MAS.Dt_Emis_MEA,
		MAS.MAWB_MEA,
		MAS.Qtd_HAWB_MEA		Qtd_HOUs,
		Ship.Apelido 			Shipper,
		Consig.Apelido 			Consignee,
		NTF.Apelido 			Notify,
		Orig.Nome_Local 		Origem,
		Destin.Nome_Local 		Destino,
		CAR.Nome_Cia_Aer		Carrier,
		MAS.Voo_MEA 			Viagem,
		LLP.ETD_Master			ETD,
		LLP.ATD_Master			ATD,
		LLP.ETA_Master			ETA,
		LLP.ATA_Master			ATA,
		TC.Nome_Tp_Carga		Tipo_Carga,
		LLP.Peso_Liquido		PesoLiquido,
		MAS.Peso_Bruto_MEA		PesoBruto,
		LLP.Peso_Cubado			PesoCubado,
		MAS.Vol_Tot_MEA			Volume,
		MAS.Qtd_Tot_Vol_MEA		Qtd,
		TM.Nome_Tp_Moeda		Moeda,
		MAS.Vlr_Frete_MEA		Frete,
		MAS.Tp_Frete_MEA		TipoFrete,
		LLP.Original_ETA_Master	Original_ETA,
		MAS.Obs_MEA				OBS,
		LLP.Tipo,
		NG.Descr				Descr_Goods,
		--Incluso 31-08-2012 - Status do Processo
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status,
		
				
		MAS.Num_Proc_MEA,
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
			
			
		NTF.apelido 			cmbNotify,
		NTF.Nome_Raz_Soc + Char(13) 
			+ 'CNPJ: ' + ISNULL(NTF.Num_CPF_CNPJ,'') + Char(13) 
			+ isnull(NotifyED.Rua,'') + ',' + isnull(NotifyED.Numero,'')
			+ isnull(NotifyED.compl_end,'') + '  CEP:' + isnull(NotifyED.cep,'') + ' '
			+ isnull(NotifyED.cidade,'') txtNotify,
		
		NULL					cmbOrigin,
		Orig.Nome_Local 		cmbLoading,
		Destin.Nome_Local 		cmbDelivery,
		NULL 					cmbFinalDestination,

		null cmbCarrier,
		null cmbVoyage,
		null txtVessel,
		--@cd_usuario cd_usuario,
		'1' [status],
		GETDATE() dt_ins,
		
		CAR.Nome_Cia_Aer 		cmbCiaAerea,
		MAS.Voo_MEA  			txtVoo,
		null txtVoyage,
		null cmbVessel,
		
		NTF.apelido 			cmbIssuing,
		NTF.Nome_Raz_Soc + Char(13) 
			+ 'CNPJ: ' + ISNULL(NTF.Num_CPF_CNPJ,'') + Char(13) 
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
		Master_Exp_Aer  MAS with(nolock)
		Left Join LLP_Master		LLP				with(nolock) on MAS.Num_Proc_MEA	= LLP.Num_Proc_Master
		
		Left Outer Join Pessoa			Ship		with(nolock) on		Cd_Export_MEA 	= Ship.Cd_Pes
		Left Outer Join Endereco		ShipED		with(nolock) on		ShipED.cd_pes=Ship.cd_pes and ShipED.Cd_Tp_End='COM'
		left Outer join comunicacao		ShipCOMS	with(nolock) on		Ship.cd_pes = ShipCOMS.cd_pes AND ShipCOMS.cd_tp_com = 'TC1'
		left Outer join comunicacao		ShipCOMFS	with(nolock) on		Ship.cd_pes = ShipCOMFS.cd_pes AND ShipCOMFS.cd_tp_com = 'FC1'
		
		Left Join Pessoa				Consig		with(nolock) on		Cd_Consig_MEA 	= Consig.Cd_Pes
		Left Outer Join Endereco		ConsigED	with(nolock) on		ConsigED.cd_pes=Consig.cd_pes and ConsigED.Cd_Tp_End='COM' 
		left Outer join comunicacao		ConsigCOMS	with(nolock) on		Consig.cd_pes = ConsigCOMS.cd_pes AND ConsigCOMS.cd_tp_com = 'TC1'
		left Outer join comunicacao		ConsigCOMFS	with(nolock) on		Consig.cd_pes = ConsigCOMFS.cd_pes AND ConsigCOMFS.cd_tp_com  = 'FC1'
				
		Left Join Pessoa				NTF			with(nolock) on		LLP.Cd_Notify 	= NTF.Cd_Pes
		Left Outer Join Endereco		NotifyED	with(nolock) on		NotifyED.cd_pes=NTF.cd_pes and NotifyED.Cd_Tp_End='COM' 
		left Outer join comunicacao		NotifyCOMS	with(nolock) on		NTF.cd_pes = NotifyCOMS.cd_pes AND NotifyCOMS.cd_tp_com = 'TC1'
		left Outer join comunicacao		NotifyCOMFS	with(nolock) on		NTF.cd_pes = NotifyCOMFS.cd_pes AND NotifyCOMFS.cd_tp_com  = 'FC1'	
				
		Left Join Localidade		Orig	with(nolock) on	 Cd_Org_MEA 		= Orig.Cd_Local
		Left Join Localidade		Destin	with(nolock) on	 Cd_Dst_MEA 		= Destin.Cd_Local
		Left Join Cia_Aerea			CAR		with(nolock) on	 MAS.Cd_Cia_Aer	= CAR.Cd_Cia_Aer
		Left Join Tipo_Moeda		TM		with(nolock) on MAS.Cd_Tp_Moeda 	= TM.Cd_Tp_Moeda
		Left Join Tipo_Carga		TC		with(nolock) on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
		Left Join Nature_Goods		NG		with(nolock) on NG.Num_Proc		= MAS.Num_Proc_MEA
		Left Outer Join Tipo_Status_Processo Status with(nolock) on STatus.id_status=LLP.id_status
		
	Where
		MAS.Num_Proc_MEA = @Num_Proc and (LLP.Status is null or LLP.Status <> 'C') -- Cancelado	
	




GO
