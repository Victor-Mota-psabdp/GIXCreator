SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_HouseWaybill_Sel]'IAAPB202102001BR',''
--spHIA_HouseWaybill_Rel 'IAAPB202102001BR'
--IAATL202307002BR
--BDP NEW YOR - 1992C
--30119908792
--020-29975901

--select * from AirlineStock where Proc_Num is null and Number like '020-%'
--select * from ATL_INT.dbo.Iata_HouseWaybill
--[spATL_INT_Iata_Palas_HouseWaybill_Sel]'IAATL202306015BR',''
CREATE Procedure [dbo].[spATL_INT_Iata_Palas_HouseWaybill_Sel]--'IAATL202306015BR',''
(		
	@Num_Proc 	VarChar(16),
	@Tipo		char(1)
)	
AS
	Declare @Vlr_Agt_HIA	float
	Declare @Vlr_Crr_HIA 	float		
	Declare @Vlr_Tx_Tot_HIA float
	Declare @Vlr_frete		float
		
	Declare @Vlr_AgtPP_HIA	float
	Declare @Vlr_CrrPP_HIA 	float		

	Set @Vlr_Agt_HIA=isnull((select sum(vlr_org_HIA)from cta_cte_HOU_IMP_aer with(nolock) where num_proc_HIA = @Num_Proc and Comp_Job_HIA = 'A' and contab_mes_ano = 'C'),0)
	Set @Vlr_Crr_HIA=isnull((select sum(vlr_org_HIA)from cta_cte_HOU_IMP_aer with(nolock) where num_proc_HIA = @Num_Proc and Comp_Job_HIA = 'C' and contab_mes_ano = 'C'),0)
		
	Set @Vlr_AgtPP_HIA=isnull((select sum(vlr_org_HIA)from cta_cte_HOU_IMP_aer with(nolock)  where num_proc_HIA = @Num_Proc and Comp_Job_HIA = 'A' and contab_mes_ano = 'P'),0)
	Set @Vlr_CrrPP_HIA=isnull((select sum(vlr_org_HIA)from cta_cte_HOU_IMP_aer with(nolock) where num_proc_HIA = @Num_Proc and Comp_Job_HIA = 'C' and contab_mes_ano = 'P'),0)
		
	set @Vlr_frete = isnull((select Vlr_Frete_Efet_HIA from house_IMP_Aer with(nolock) where num_proc_HIA = @Num_Proc),0)

	Set @Vlr_Tx_Tot_HIA = (@Vlr_Agt_HIA + @Vlr_Crr_HIA + @Vlr_frete)

IF	not exists(select Num_Proc from ATL_INT.dbo.Iata_HouseWaybill where Num_Proc = @Num_Proc)
	BEGIN
		select 
		NULL ID,
		hou.Num_Proc_HIA [Num_Proc],
	-- string strJunta = i["BusinessHeaderDocument_ID"].ToString() + "_" + i["TransportContractDocument_ID"].ToString();
	--MessageHeaderDocument(writer, "703", "House Waybill", "3.00", i["Iata_Code"].ToString(), strJunta);
		HAWB_HIA + '_' + HOU.MAWB_HIA				[MessageHeaderDocument_ID],
		'House Waybill'								[MessageHeaderDocument_Name],
		'703'										[MessageHeaderDocument_TypeCode],
		NULL										[MessageHeaderDocument_IssueDateTime],
		'Creation'									[MessageHeaderDocument_PurposeCode],--Creation, Update e Deletion
		'3.00'										[MessageHeaderDocument_VersionID],		
		'C'											[MessageHeaderDocument_SenderParty_schemeID],
		'RUSAGT82BDPI/ATL01'						[MessageHeaderDocument_SenderParty_Value],	
		'C'											[MessageHeaderDocument_RecipientParty_schemeID],
		'DSGUNXA'									[MessageHeaderDocument_RecipientParty_Value],
	--BusinessHeaderDocument(writer, "703", "HouseWaybill", strHouseJOB);
		HAWB_HIA									[BusinessHeaderDocument_ID],
		left(US.nome_usuario,20)					[SignatoryConsignorAuthentication_Signatory],
		--dt_impres_lia								[SignatoryCarrierAuthentication_ActualDateTime], --llp.dt_impres_LIA
		LLP.Original_ETA_LIA								[SignatoryCarrierAuthentication_ActualDateTime], --Eliene ETA Original
		left(AG.Nome_raz_soc,20)					[SignatoryCarrierAuthentication_Signatory],
		[dbo].[FRemoveAcentuacao](ENDA.Cidade)		[IssueAuthenticationLocation_Name],
	-- MasterConsignment
		'KGM'										[MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode],
		Convert(decimal(18,1),Peso_Bruto_HIA)		[MasterConsignment_IncludedTareGrossWeightMeasure_Value],
		Convert(int,Qtd_Tot_Vol_HIA)				[MasterConsignment_TotalPieceQuantity],		
		HOU.MAWB_HIA								[MasterConsignment_TransportContractDocument_ID],
		UPPER(LCO.IATACODE)							[MasterConsignment_OriginLocation_ID],
		UPPER(LCO.Nome_Local)						[MasterConsignment_OriginLocation_Name],			
		UPPER(LCD.IATACODE)							[MasterConsignment_FinalDestinationLocation_ID],
		UPPER(LCD.Nome_Local)						[MasterConsignment_FinalDestinationLocation_Name],
		--IncludedHouseConsignment
		'true'										[MasterConsignment_IncludedHouseConsignment_NilCarriageValueIndicator],
		'true'										[MasterConsignment_IncludedHouseConsignment_NilCustomsValueIndicator],
		'true'										[MasterConsignment_IncludedHouseConsignment_NilInsuranceValueIndicator],
		(case when tp_frete_HIA	= 'C' then 'false' else 'true' end) [MasterConsignment_IncludedHouseConsignment_TotalChargePrepaidIndicator],
		HOU.cd_tp_moeda								[MasterConsignment_IncludedHouseConsignment_WeightTotalChargeAmount_currencyID],
		convert(decimal(18,2),Vlr_Frete_Efet_HIA)	[MasterConsignment_IncludedHouseConsignment_WeightTotalChargeAmount_Value],
		(case when tp_frete_HIA	= 'C' then 'false' else 'true' end)	[MasterConsignment_IncludedHouseConsignment_TotalDisbursementPrepaidIndicator],

		HOU.cd_tp_moeda								[MasterConsignment_IncludedHouseConsignment_AgentTotalDisbursementAmount_currencyID],
		(case when tp_frete_hIA	= 'P' 
			then convert(decimal(18,2),@Vlr_AgtPP_HIA) 
			else convert(decimal(18,2),@Vlr_Agt_HIA) end)	[MasterConsignment_IncludedHouseConsignment_AgentTotalDisbursementAmount_Value],	

		HOU.cd_tp_moeda								[MasterConsignment_IncludedHouseConsignment_CarrierTotalDisbursementAmount_currencyID],
		(case when tp_frete_hIA	= 'P' 
			then convert(decimal(18,2),@Vlr_CrrPP_HIA) 
			else convert(decimal(18,2),@Vlr_Crr_HIA) end)	[MasterConsignment_IncludedHouseConsignment_CarrierTotalDisbursementAmount_Value], 


		HOU.cd_tp_moeda								 [MasterConsignment_IncludedHouseConsignment_TotalPrepaidChargeAmount_currencyID],
		(case when tp_frete_HIA	= 'P' then
			convert(decimal(18,2),@Vlr_AgtPP_HIA + @Vlr_CrrPP_HIA + Vlr_Frete_Efet_HIA)
			else convert(decimal(18,2),@Vlr_AgtPP_HIA + @Vlr_CrrPP_HIA) end) [MasterConsignment_IncludedHouseConsignment_TotalPrepaidChargeAmount_Value],
	
		HOU.cd_tp_moeda								 [MasterConsignment_IncludedHouseConsignment_TotalCollectChargeAmount_currencyID],
		(case when tp_frete_HIA	= 'C' then 
			convert(decimal(18,2),@Vlr_Agt_HIA + @Vlr_Crr_HIA + Vlr_Frete_Efet_HIA)
			else convert(decimal(18,2),@Vlr_Agt_HIA + @Vlr_Crr_HIA) end) [MasterConsignment_IncludedHouseConsignment_TotalCollectChargeAmount_Value],


		'KGM'										[MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_UnitCode],
		Convert(decimal(18,1),Peso_Bruto_HIA)		[MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_Value],


		'MTQ'										[MasterConsignment_IncludedHouseConsignment_GrossVolumeMeasure_UnitCode],
		convert(decimal(18,2),LLP.Peso_Cubado_LIA)	[MasterConsignment_IncludedHouseConsignment_GrossVolumeMeasure_Value],

		Convert(int,Qtd_Tot_Vol_HIA)				[MasterConsignment_IncludedHouseConsignment_ConsignmentItemQuantity],	
		Convert(int,Qtd_Tot_Vol_HIA)				[MasterConsignment_IncludedHouseConsignment_PackageQuantity],	
		Convert(int,Qtd_Tot_Vol_HIA)				[MasterConsignment_IncludedHouseConsignment_TotalPieceQuantity],	

		left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[MasterConsignment_IncludedHouseConsignment_SummaryDescription],

		--Party("", "ConsignorParty", writer, i["cd_Consignor"].ToString());
		left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](Sh.Nome_raz_soc)),20)	[ConsignorParty_Name],
		sh.Cd_Pes																							[ConsignorParty_AccountID],	
		replace(ENDS.CEP COLLATE Latin1_General_BIN, char(32),'')											[ConsignorParty_PostcodeCode],	
		left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDS.Rua + ' ' + ends.numero)) ,35)				[ConsignorParty_StreetName],
		left([dbo].[FRemoveAcentuacao](ENDS.Cidade),17)														[ConsignorParty_CityName],	
		--City name exceeds 17 character limit.
		ENDS.CD_pais																						[ConsignorParty_CountryID],
		ENDS.Pais																							[ConsignorParty_CountryName],
	
	 --   Party("", "ConsigneeParty", writer, i["cd_Consignee"].ToString()); 	
		left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](cs.Nome_raz_soc)),20)	[ConsigneeParty_Name],
		cs.Cd_Pes																							[ConsigneeParty_AccountID],	
		replace(ENDC.CEP COLLATE Latin1_General_BIN, char(32),'')											[ConsigneeParty_PostcodeCode],	
		left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDC.Rua + ' ' + ENDC.numero)) ,35)				[ConsigneeParty_StreetName],
		left([dbo].[FRemoveAcentuacao](ENDC.Cidade),17)														[ConsigneeParty_CityName],	
		ENDC.CD_pais																						[ConsigneeParty_CountryID],
		ENDC.Pais																							[ConsigneeParty_CountryName],

	 --   Party("", "FreightForwarderParty", writer, i["cd_FreightForwarder"].ToString());
 		left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](AG.Nome_raz_soc)),20)	[FreightForwarderParty_Name],
		AG.Cd_Pes																							[FreightForwarderParty_AccountID],	
		replace(ENDA.CEP COLLATE Latin1_General_BIN, char(32),'')											[FreightForwarderParty_PostcodeCode],	
		left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDA.Rua + ' ' + ENDA.numero)) ,35)				[FreightForwarderParty_StreetName],
		left([dbo].[FRemoveAcentuacao](ENDA.Cidade),17)														[FreightForwarderParty_CityName],	
		ENDA.CD_pais																						[FreightForwarderParty_CountryID],
		ENDC.Pais																							[FreightForwarderParty_CountryName],

		HOU.cd_tp_moeda																						[ApplicableOriginCurrencyExchange_SourceCurrencyCode],
		--nao criado
		--UPPER(LCO.cd_local)															[MasterConsignment_IncludedHouseConsignment_OriginLocation_ID],
		--UPPER(LCO.Nome_Local)															[MasterConsignment_IncludedHouseConsignment_OriginLocation_Name],			
		--UPPER(LCD.cd_local)															[MasterConsignment_IncludedHouseConsignment_FinalDestinationLocation_ID],
		--UPPER(LCD.Nome_Local)															[MasterConsignment_IncludedHouseConsignment_FinalDestinationLocation_Name],

 		'Main-Carriage'											[SpecifiedLogisticsTransportMovement_StageCode],
		'4'														[SpecifiedLogisticsTransportMovement_ModeCode],
		'Air'													[SpecifiedLogisticsTransportMovement_Mode],	
		(case when len(HOU.Voo_HIA) < 3 then 
			'00' + HOU.Voo_HIA	else HOU.Voo_HIA end)			[SpecifiedLogisticsTransportMovement_ID],
		'1'														[SpecifiedLogisticsTransportMovement_SequenceNumeric],
		CA.SCAC													[UsedLogisticsTransportMeans_Name],
		LLP.ATA_LIA												[ArrivalEvent_ScheduledOccurrenceDateTime],
		'Airport'												[ArrivalEvent_TypeCode],
		UPPER(LCD.IATACODE)										[ArrivalEvent_OriginLocation_ID],
		UPPER(LCD.Nome_Local)									[ArrivalEvent_OriginLocation_Name],

		LLP.ATD_LIA 											[DepartureEvent_ScheduledOccurrenceDateTime],
		'Airport'												[DepartureEvent_TypeCode],	
		UPPER(LCO.IATACODE)										[DepartureEvent_FinalDestinationLocation_ID],
		UPPER(LCO.Nome_Local)									[DepartureEvent_FinalDestinationLocation_Name],

		[dbo].[FRemoveAcentuacao](HN.Hand_HIA_1)				[HandlingSPHInstructions],
		'1'														[IncludedHouseConsignmentItem_SequenceNumeric],
		NC.NCM													[IncludedHouseConsignmentItem_TypeCode],
		'KGM'													[IncludedHouseConsignmentItem_GrossWeightMeasure_UnitCode],
		convert(decimal(18,1),Peso_Bruto_HIA)					[IncludedHouseConsignmentItem_GrossWeightMeasure_Value],

		'MTQ'													[IncludedHouseConsignmentItem_GrossVolumeMeasure_UnitCode],
		convert(decimal(18,2),LLP.Peso_Cubado_LIA)				[IncludedHouseConsignmentItem_GrossVolumeMeasure_Value],


		convert(int,Qtd_Tot_Vol_HIA)							[IncludedHouseConsignmentItem_PieceQuantity],
		'NDA'													[IncludedHouseConsignmentItem_Information],
		left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[NatureIdentificationTransportCargo_Information],
		'KGM'													[ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_UnitCode],
		convert(decimal(6,1),Peso_Bruto_HIA)					[ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_Value],

		ENDC.CD_pais											[IncludedHouseConsignmentItem_OriginCountry],

		(case when tp_frete_HIA	= 'P' then
			convert(decimal(18,2),@Vlr_AgtPP_HIA + @Vlr_CrrPP_HIA + Vlr_Frete_Efet_HIA)
			else convert(decimal(18,2),@Vlr_AgtPP_HIA + @Vlr_CrrPP_HIA) end) [ApplicableFreightRateServiceCharge_AppliedAmount_Value],
	
		HOU.cd_tp_moeda								 [ApplicableFreightRateServiceCharge_AppliedAmount_UnitCode]


		,PLLP.Cd_Pes_grupo 		[Group Code],
		PG.Apelido				[Group Name],
		''						[User Code],
		''						[User Name],
		''						[Notes]
	from 
		house_IMP_Aer HOU with(nolock)
		Left Join Master_IMP_Aer MEA with(nolock) on HOU.num_proc_MIA = MEA.num_proc_MIA
		Left Join LLP_IMP_Aer LLP with(nolock) on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
		Left Join JOB_IMP_Aer JOB on HOU.Num_Proc_Hia = JOB.Num_Proc_hia
	
		Left Join Pessoa AG with(nolock) on MEA.Cd_Consig_MIA = AG.cd_pes
		Left Join Endereco ENDA with(nolock) on MEA.Cd_Consig_MIA = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
		--left join comunicacao COMA with(nolock) on AG.cd_pes = COMA.cd_pes and COMA.cd_tp_com = 'TC1'
		--left join comunicacao COMFA with(nolock) on AG.cd_pes = COMFA.cd_pes AND COMFA.cd_tp_com = 'FC1'
		--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
	
		Left Join Pessoa CS with(nolock) on CS.cd_pes=cd_consig_HIA
		Left Join Endereco ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
		Left Join Pessoa_llp	PLLP with(nolock)		on HOU.cd_consig_HIA	= PLLP.Cd_Pes
		Left Join Pessoa		PG with(nolock)			on PG.Cd_Pes			= PLLP.Cd_Pes_grupo
		--left join comunicacao COMC with(nolock) on CS.cd_pes = COMC.cd_pes and comc.cd_tp_com = 'TC1'
		--left join comunicacao COMFC with(nolock) on CS.cd_pes = COMFC.cd_pes AND COMFC.cd_tp_com = 'FC1'
	
		Left Join Pessoa Sh with(nolock) on SH.cd_pes=cd_export_HIA
		Left Join Endereco ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
		--left join comunicacao COMS with(nolock) on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
		--left join comunicacao COMFS with(nolock) on SH.cd_pes = COMFS.cd_pes AND COMFS.cd_tp_com = 'FC1'
	
		Left Join Cia_Aerea CA with(nolock) on job.cd_cia_aer = CA.cd_cia_aer
		Left Join Localidade LCO with(nolock) on HOU.cd_org_HIA = LCO.cd_local
		Left Join Localidade LCD with(nolock) on Hou.cd_dst_HIA = LCD.cd_local
		left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
		left join Usuario US with(nolock) on US.cd_usuario = job.CD_USUARIO --LLP.cd_User_Impres_LIA
	
		Left Join Pessoa NF with(nolock) on NF.cd_pes=cd_export_HIA	

		Left Join nature_goods NG with(nolock) on HOU.num_proc_HIA=NG.Num_Proc
		Left Join Handling_HIA HN with(nolock) on Hou.num_proc_HIA = HN.Num_proc_HIA 
		Left Join PESSOA DSP with(nolock) on cd_dsp_HIA=DSP.cd_pes
		Left Join PROC_NCM PNC with(nolock) on Hou.num_proc_HIA = PNC.Num_proc 
		Left Join NCM NC with(nolock) on NC.Id_NCM = PNC.Id_NCM 
	
	Where
		hou.Num_Proc_HIA=@Num_Proc
	END
ELSE
	BEGIN
		select distinct
			HOU.ID,
			HOU.Num_Proc,	
			--MessageHeaderDocument_
			HOU.MessageHeaderDocument_ID,
			HOU.MessageHeaderDocument_Name,
			HOU.MessageHeaderDocument_TypeCode,
			HOU.MessageHeaderDocument_IssueDateTime,
			--(case when IRL.Status = 'Processed' then 'Update' else HOU.MessageHeaderDocument_PurposeCode end) 	MessageHeaderDocument_PurposeCode,
			HOU.MessageHeaderDocument_PurposeCode MessageHeaderDocument_PurposeCode,--Creation, Update e Deletion
			HOU.MessageHeaderDocument_VersionID,			
			HOU.MessageHeaderDocument_SenderParty_schemeID,
			HOU.MessageHeaderDocument_SenderParty_Value,
			HOU.MessageHeaderDocument_RecipientParty_schemeID,
			HOU.MessageHeaderDocument_RecipientParty_Value,

			--BusinessHeaderDocument
			HOU.BusinessHeaderDocument_ID,
			HOU.SignatoryConsignorAuthentication_Signatory,
			HOU.SignatoryCarrierAuthentication_ActualDateTime ,
			HOU.SignatoryCarrierAuthentication_Signatory,
			HOU.IssueAuthenticationLocation_Name,

			--MasterConsignment
			HOU.MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode,
			HOU.MasterConsignment_IncludedTareGrossWeightMeasure_Value,

			HOU.MasterConsignment_TotalPieceQuantity	[MasterConsignment_IncludedHouseConsignment_ConsignmentItemQuantity],	
			HOU.MasterConsignment_TotalPieceQuantity	[MasterConsignment_IncludedHouseConsignment_PackageQuantity],

			HOU.MasterConsignment_TotalPieceQuantity,
			HOU.MasterConsignment_TransportContractDocument_ID,
			HOU.MasterConsignment_OriginLocation_ID,
			HOU.MasterConsignment_OriginLocation_Name,
			HOU.MasterConsignment_FinalDestinationLocation_ID,
			HOU.MasterConsignment_FinalDestinationLocation_Name,

			--HOU.IncludedHouseConsignmentItem_SequenceNumeric,

			--IncludedHouseConsigment
			HOU.MasterConsignment_NilCarriageValueIndicator						[MasterConsignment_IncludedHouseConsignment_NilCarriageValueIndicator],
			HOU.MasterConsignment_NilCustomsValueIndicator						[MasterConsignment_IncludedHouseConsignment_NilCustomsValueIndicator],
			HOU.MasterConsignment_NilInsuranceValueIndicator					[MasterConsignment_IncludedHouseConsignment_NilInsuranceValueIndicator],
			HOU.MasterConsignment_TotalChargePrepaidIndicator					[MasterConsignment_IncludedHouseConsignment_TotalChargePrepaidIndicator],
			HOU.MasterConsignment_WeightTotalChargeAmount_currencyID			[MasterConsignment_IncludedHouseConsignment_WeightTotalChargeAmount_currencyID],
			HOU.MasterConsignment_WeightTotalChargeAmount_Value					[MasterConsignment_IncludedHouseConsignment_WeightTotalChargeAmount_Value],
			HOU.MasterConsignment_TotalDisbursementPrepaidIndicator				[MasterConsignment_IncludedHouseConsignment_TotalDisbursementPrepaidIndicator],
			HOU.MasterConsignment_AgentTotalDisbursementAmount_currencyID		[MasterConsignment_IncludedHouseConsignment_AgentTotalDisbursementAmount_currencyID],
			HOU.MasterConsignment_AgentTotalDisbursementAmount_Value			[MasterConsignment_IncludedHouseConsignment_AgentTotalDisbursementAmount_Value],
			HOU.MasterConsignment_CarrierTotalDisbursementAmount_currencyID		[MasterConsignment_IncludedHouseConsignment_CarrierTotalDisbursementAmount_currencyID],
			HOU.MasterConsignment_CarrierTotalDisbursementAmount_Value			[MasterConsignment_IncludedHouseConsignment_CarrierTotalDisbursementAmount_Value], 
			HOU.MasterConsignment_TotalPrepaidChargeAmount_currencyID			[MasterConsignment_IncludedHouseConsignment_TotalPrepaidChargeAmount_currencyID],
			HOU.MasterConsignment_TotalPrepaidChargeAmount_Value				[MasterConsignment_IncludedHouseConsignment_TotalPrepaidChargeAmount_Value],
			HOU.MasterConsignment_TotalCollectChargeAmount_currencyID			[MasterConsignment_IncludedHouseConsignment_TotalCollectChargeAmount_currencyID],
			HOU.MasterConsignment_TotalCollectChargeAmount_Value				[MasterConsignment_IncludedHouseConsignment_TotalCollectChargeAmount_Value],
			HOU.MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_UnitCode,
			HOU.MasterConsignment_IncludedHouseConsignment_IncludedTareGrossWeightMeasure_Value,
			HOU.MasterConsignment_GrossVolumeMeasure_UnitCode					[MasterConsignment_IncludedHouseConsignment_GrossVolumeMeasure_UnitCode],
			HOU.MasterConsignment_GrossVolumeMeasure_Value						[MasterConsignment_IncludedHouseConsignment_GrossVolumeMeasure_Value],
			HOU.MasterConsignment_IncludedHouseConsignment_TotalPieceQuantity,
			HOU.SummaryDescription												[MasterConsignment_IncludedHouseConsignment_SummaryDescription],
		
			
			--ConsignorParty
			HOU.ConsignorParty_Name,
			HOU.ConsignorParty_AccountID,
			HOU.ConsignorParty_PostcodeCode,
			HOU.ConsignorParty_StreetName,
			HOU.ConsignorParty_CityName,
			HOU.ConsignorParty_CountryID,

			ConsignorParty.Nome_Pais ConsignorParty_CountryName,

			--ConsigneeParty
			HOU.ConsigneeParty_Name,
			HOU.ConsigneeParty_AccountID,
			HOU.ConsigneeParty_PostcodeCode,
			HOU.ConsigneeParty_StreetName,
			HOU.ConsigneeParty_CityName,
			HOU.ConsigneeParty_CountryID,

			ConsigneeParty.Nome_Pais ConsigneeParty_CountryName,

			--FreightForwarderParty
			HOU.FreightForwarderParty_Name,
			HOU.FreightForwarderParty_AccountID,
			HOU.FreightForwarderParty_PostcodeCode,
			HOU.FreightForwarderParty_StreetName,
			HOU.FreightForwarderParty_CityName,
			HOU.FreightForwarderParty_CountryID,

			FreightForwarderParty.Nome_Pais FreightForwarderParty_CountryName,


			HOU.MasterConsignment_WeightTotalChargeAmount_currencyID [ApplicableOriginCurrencyExchange_SourceCurrencyCode],
			'NDA'	[IncludedHouseConsignmentItem_Information],

			HOU.ConsigneeParty_CountryID					[IncludedHouseConsignmentItem_OriginCountry],

			HOU.MasterConsignment_WeightTotalChargeAmount_currencyID [ApplicableFreightRateServiceCharge_AppliedAmount_UnitCode],
			HOU.MasterConsignment_WeightTotalChargeAmount_Value	 [ApplicableFreightRateServiceCharge_AppliedAmount_Value],

			--nao criado
			--HOU.MasterConsignment_IncludedHouseConsignment_OriginLocation_ID,
			--HOU.MasterConsignment_IncludedHouseConsignment_OriginLocation_Name,
			--HOU.MasterConsignment_IncludedHouseConsignment_FinalDestinationLocation_ID,
			--HOU.MasterConsignment_IncludedHouseConsignment_FinalDestinationLocation_Name,


			HOU.SpecifiedLogisticsTransportMovement_StageCode,
			HOU.SpecifiedLogisticsTransportMovement_ModeCode,
			HOU.SpecifiedLogisticsTransportMovement_Mode,
			HOU.SpecifiedLogisticsTransportMovement_ID,
			HOU.SpecifiedLogisticsTransportMovement_SequenceNumeric,
			HOU.UsedLogisticsTransportMeans_Name,

			HOU.ArrivalEvent_ScheduledOccurrenceDateTime,
			HOU.ArrivalEvent_TypeCode,
			HOU.ArrivalEvent_OriginLocation_ID,
			HOU.ArrivalEvent_OriginLocation_Name,

			HOU.DepartureEvent_ScheduledOccurrenceDateTime,
			HOU.DepartureEvent_TypeCode,
			HOU.DepartureEvent_FinalDestinationLocation_ID,
			HOU.DepartureEvent_FinalDestinationLocation_Name,

			HOU.HandlingSPHInstructions,
			HOU.IncludedHouseConsignmentItem_SequenceNumeric,
			HOU.IncludedHouseConsignmentItem_TypeCode,
			HOU.IncludedHouseConsignmentItem_GrossWeightMeasure_UnitCode,
			HOU.IncludedHouseConsignmentItem_GrossWeightMeasure_Value,

			HOU.IncludedHouseConsignmentItem_GrossVolumeMeasure_UnitCode,
			HOU.IncludedHouseConsignmentItem_GrossVolumeMeasure_Value,

			HOU.IncludedHouseConsignmentItem_PieceQuantity,
			HOU.NatureIdentificationTransportCargo_Information,
			HOU.ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_UnitCode,
			HOU.ApplicableFreightRateServiceCharge_ChargeableWeightMeasure_Value
			
			,HOU.Cd_Pes_grupo 		[Group Code],
			PG.Apelido				[Group Name],
			HOU.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name],
			HOU.Notes				[Notes]
			--, *
		from 
			ATL_INT.dbo.Iata_HouseWaybill HOU with(nolock)	
			Left Join Atlantis.dbo.Pessoa		PG with(nolock)	on PG.Cd_Pes= HOU.Cd_Pes_grupo
			Left Join Atlantis.dbo.Usuario		US with(nolock)	on US.Cd_Usuario= HOU.Cd_Usuario

			Left Join Atlantis.dbo.exchange_GTNEXUS	E with(nolock)	on E.Num_proc = HOU.Num_proc and Tipo_Envio = 9 and E.type = 'HW'
			left join Atlantis.dbo.GTNEXUS_XML		G with(nolock) on E.ID = G.ID_GTNEXUS and G.type = 'HW'
			left join [ATL_INT].[dbo].Iata_Response IA with(nolock) on IA.Num_proc = G.Num_proc and IA.ID_GTNEXUS = G.ID_GTNEXUS
			left join [ATL_INT].[dbo].Iata_Response_Status IRS with(nolock) on IA.Id = IRS.ID_Response
			left join [ATL_INT].[dbo].Iata_Received_List IRL with(nolock) on IRL.protocolNumber = IRS.Reason
			left join [ATL_INT].[dbo].Iata_Received_List_Errorlist IRLE  with(nolock) on IRL.ID = IRLE.ID_Received

			Left Join Atlantis.dbo.Pais  ConsignorParty with(nolock)	on ConsignorParty.Cd_Pais= HOU.ConsignorParty_CountryID
			Left Join Atlantis.dbo.Pais  ConsigneeParty with(nolock)	on ConsigneeParty.Cd_Pais= HOU.ConsigneeParty_CountryID
			Left Join Atlantis.dbo.Pais  FreightForwarderParty with(nolock)	on FreightForwarderParty.Cd_Pais= HOU.FreightForwarderParty_CountryID

		Where
			hou.Num_Proc=@Num_Proc
	END

GO
