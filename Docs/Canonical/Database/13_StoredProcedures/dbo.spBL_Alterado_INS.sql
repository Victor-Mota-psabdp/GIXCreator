SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from altera_bl where num_proc = 'EAATL201507008BR'

--[spBL_Alterado_INS]'EAVCP201507003','Carlos Eduardo'
CREATE PROCEDURE [dbo].[spBL_Alterado_INS]--'EAATL201507008BR','Carlos Eduardo'
(
	@Processo		VarChar(16),
	@Usuario		varchar(50)
)
AS

declare @cd_usuario as varchar(6)
set @cd_usuario = (select cd_usuario from Usuario with(nolock)where Nome_Usuario = @Usuario)
	
	if not exists(select txtShipper from Altera_BL with(nolock) where num_proc = @Processo)
		if len(@Processo) = 16
			BEGIN		 	
				insert into Altera_BL							
					Select 
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
						@cd_usuario cd_usuario,
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
						House_exp_Aer HOU
						Left Outer Join Pessoa			Ship		with(nolock) on		Cd_Export_HEA = Ship.Cd_Pes
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
						Left Outer Join Localidade	Orig		with(nolock) on	 Cd_Org_HEA = Orig.Cd_Local 
						Left Outer Join Localidade	Destin		with(nolock) on	 Cd_Dst_HEA = Destin.Cd_Local						
					Where
						HOU.Num_Proc_HEA= @Processo
			END
		else if len(@Processo) = 14
			BEGIN
				insert into Altera_BL
					Select
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
						@cd_usuario cd_usuario,
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
						
					Where
						MAS.Num_Proc_MEA = @Processo and (LLP.Status is null or LLP.Status <> 'C') -- Cancelado
				
				END
			
GO
