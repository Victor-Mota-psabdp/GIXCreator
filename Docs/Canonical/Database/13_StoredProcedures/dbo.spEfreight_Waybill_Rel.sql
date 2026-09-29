SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEfreight_Waybill_Rel]--'EAGIG201805001'

		@Processo 	VarChar(14)

AS

		Declare @Vlr_Agt_MEA	float
		Declare @Vlr_Crr_MEA 	float
		Declare @Vlr_Tx_Tot_MEA float
		Declare @Vlr_frete		float
		
		Declare @Vlr_AgtPP_MEA	float
		Declare @Vlr_CrrPP_MEA 	float	
		
		Set @Vlr_Agt_MEA=isnull((select sum(vlr_org_MEA)from cta_cte_MAS_exp_aer where num_proc_MEA = @Processo and Comp_MBL_MEA = 'A' and contab_mes_ano = 'C'),0)
		Set @Vlr_Crr_MEA=isnull((select sum(vlr_org_MEA)from cta_cte_MAS_exp_aer where num_proc_MEA = @Processo and Comp_MBL_MEA = 'C' and contab_mes_ano = 'C'),0)
		
		Set @Vlr_AgtPP_MEA=isnull((select sum(vlr_org_mEA)from cta_cte_MAS_exp_aer where Num_Proc_MEA = @Processo and Comp_MBL_MEA = 'A' and contab_mes_ano = 'P'),0)
		Set @Vlr_CrrPP_MEA=isnull((select sum(vlr_org_mEA)from cta_cte_MAS_exp_aer where Num_Proc_MEA = @Processo and Comp_MBL_MEA = 'C' and contab_mes_ano = 'P'),0)
				
		set @Vlr_frete = isnull((select vlr_frete_mea from master_exp_Aer where num_proc_mea = @Processo),0)
		
		Set @Vlr_Tx_Tot_MEA= (@Vlr_Agt_MEA + @Vlr_Crr_MEA + @Vlr_frete)
		

select 
	--CA.IATA_CODE							ID,
	
	MAWB_MEA								[BusinessHeaderDocument_ID],
	left(US.nome_usuario,20)				[SignatoryConsignorAuthentication_Signatory],
	MEA.Dt_Impres_MEA						[SignatoryCarrierAuthentication_ActualDateTime],
	left(AG.Nome_raz_soc,20)				[SignatoryCarrierAuthentication_Signatory],
	[dbo].[FRemoveAcentuacao](ENDA.Cidade)	[IssueAuthenticationLocation_Name],
	
	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end) [TotalChargePrepaidIndicator],
	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end)	[TotalDisbursementPrepaidIndicator],
	
	Convert(decimal(18,1),Peso_Bruto_MEA)	[IncludedTareGrossWeightMeasure],
	convert(decimal(18,3),MEA.Vol_Tot_MEA)	[GrossVolumeMeasure],
	Convert(int,Qtd_Tot_Vol_MEA)			[TotalPieceQuantity],
		
	Sh.Cd_Pes [ConsignorParty_AccountID],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](Sh.Nome_raz_soc)),20)[ConsignorParty_Name],
	replace(ENDS.CEP COLLATE Latin1_General_BIN, char(32),'') [ConsignorParty_PostcodeCode],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDS.Rua + ' ' + ends.numero)) ,35)[ConsignorParty_StreetName],
	left([dbo].[FRemoveAcentuacao](ENDS.Cidade),17)					[ConsignorParty_CityName],	
	ENDS.CD_pais											[ConsignorParty_CountryID],
	--TC1	Telefone Comercial1
	--COMS.cd_int + COMS.cd_area_fone + COMS.prefixo + COMS.num_fone [ConsignorParty_Telephone],
	

	cs.Cd_Pes [ConsigneeParty_AccountID],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](cs.Nome_raz_soc)),20)[ConsigneeParty_Name],
	replace(ENDC.CEP COLLATE Latin1_General_BIN, char(32),'') [ConsigneeParty_PostcodeCode],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDC.Rua + ' ' + ENDC.numero)) ,35)[ConsigneeParty_StreetName],
	left([dbo].[FRemoveAcentuacao](ENDC.Cidade),17)					[ConsigneeParty_CityName],	
	ENDC.CD_pais													[ConsigneeParty_CountryID],
	--CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone [ConsigneeParty_Telephone],
	--HBL	Contato H/MAWB
			
	AG.Cd_Pes [FreightForwarderParty_AccountID],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](AG.Nome_raz_soc)),20)[FreightForwarderParty_Name],
	replace(ENDA.CEP COLLATE Latin1_General_BIN, char(32),'') [FreightForwarderParty_PostcodeCode],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDA.Rua + ' ' + ENDA.numero)) ,35)[FreightForwarderParty_StreetName],
	left([dbo].[FRemoveAcentuacao](ENDA.Cidade),17)					[FreightForwarderParty_CityName],	
	ENDA.CD_pais											[FreightForwarderParty_CountryID],
	'5715014/0014'											[FreightForwarderParty_CargoAgentID],
	CMA.cd_int + CMA.cd_area_fone + CMA.prefixo + CMA.num_fone  [FreightForwarderParty_Telephone],
	--HBL	Contato H/MAWB
	
	UPPER(LCO.IATACODE)				[OriginLocation_ID],
	UPPER(LCO.Nome_Local)			[OriginLocation_Name],			
	
	UPPER(LCD.IATACODE)				[FinalDestinationLocation_ID],
	UPPER(LCD.Nome_Local)			[FinalDestinationLocation_Name],
	
	mea.Voo_MEA												[SpecifiedLogisticsTransportMovement_ID],
	'Main-Carriage'											[SpecifiedLogisticsTransportMovement_StageCode],
	'4'														[SpecifiedLogisticsTransportMovement_ModeCode],
	'Air'													[SpecifiedLogisticsTransportMovement_Mode],	
	
	'1'														[SpecifiedLogisticsTransportMovement_SequenceNumeric],
	
	CA.Cd_Cia_Aer											[UsedLogisticsTransportMeans_Name],
	
	LLP.ATD_Master											[ArrivalEvent_ScheduledOccurrenceDateTime],
	'Airport'												[ArrivalEvent_TypeCode],
	LLP.ATA_Master											[DepartureEvent_ScheduledOccurrenceDateTime],
	'Airport'												[DepartureEvent_TypeCode],

	isnull([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](MEA.Obs_MEA)),	'Field Mandatory') [HandlingSPHInstructions],
	--[dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](MEA.Obs_MEA))		[HandlingSPHInstructions],
	
	'F' [ApplicableRating_TypeCode],
	
	convert(decimal(18,1),mEA.Peso_Bruto_MEA) [ApplicableRating_GrossWeightMeasure],
	Convert(int,Qtd_Tot_Vol_MEA)			[ApplicableRating_PieceQuantity],
	
	(case when isnull(dbo.fBusca_CampoCliente(MEA.Num_Proc_MEA,89),'2') = '1' then 'M'
		else 'K' end) [CategoryCode],
	convert(decimal(18,1),Peso_Bruto_MEA)		[ChargeableWeightMeasure],
	convert(decimal(18,2),(convert(decimal(18,2),MEA.Vlr_Frete_MEA)/convert(decimal(18,2),LLP.Peso_Cubado))) [AppliedRate],
	convert(decimal(18,2),MEA.Vlr_Frete_MEA)  [AppliedAmount],
	convert(decimal(18,2),MEA.Vol_Tot_MEA)	[ApplicableRating_GrossVolumeMeasure],
	
	'F' [ApplicableTotalRating_TypeCode],	
	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end)		[ApplicableTotalRating_PrepaidIndicator],
	convert(decimal(18,2),MEA.Vlr_Frete_MEA)		[ApplicableTotalRating_WeightChargeTotalAmount],
	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Agt_MEA) + convert(decimal(18,2),@Vlr_Crr_MEA)+ convert(decimal(18,2),MEA.Vlr_Frete_MEA)
	else convert(decimal(18,2),@Vlr_AgtPP_MEA) + convert(decimal(18,2),@Vlr_CrrPP_MEA) + convert(decimal(18,2),MEA.Vlr_Frete_MEA) 
	end)	[ApplicableTotalRating_GrandTotalAmount],
	
	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	--	isnull(Arm.nome_armador,'Field Mandatory')
	--ELSE
	--	null
	--end) CarrierMAWB,
	
	(case when P.HTS = 1 THEN
		isnull(Arm.nome_armador,'Field Mandatory')
	ELSE
		null
	end) CarrierMAWB,
	
	----(case when UPPER(ENDC.CD_pais) = 'CN' THEN
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	--	(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
	--		'EIN23-1878776'
	--	ELSE
	--		'EIN20-8141384'	
	--	end) 
	--ELSE
	--	'' end)	EIN_Number,
	
	(case when P.HTS = 1 THEN
		(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,62),'BDP') = 'BDP' then 
			'EIN23-1878776'
		ELSE
			'EIN20-8141384'	
		end) 
	ELSE
		'' end)	EIN_Number,
		
	----(case when UPPER(ENDC.CD_pais) = 'CN' THEN
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	--	isnull(CP18.Campo_Dados,'Field Mandatory') ELSE
	--	null END) USCI,
	
	(case when P.HTS = 1 THEN
		isnull(CP18.Campo_Dados,'Field Mandatory') ELSE
		null END) USCI,
		
	----(case when UPPER(ENDC.CD_pais) = 'CN' THEN
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	--	isnull(COMS.cd_int + COMS.cd_area_fone + COMS.prefixo + COMS.num_fone,'Field Mandatory') ELSE
	--	null END) [ConsignorParty_Telephone],
	
	(case when P.HTS = 1 THEN
		isnull(COMS.cd_int + COMS.cd_area_fone + COMS.prefixo + COMS.num_fone,'Field Mandatory') ELSE
		null END) [ConsignorParty_Telephone],
		
	----(case when UPPER(ENDC.CD_pais) = 'CN' THEN
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	--	isnull(CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone,'Field Mandatory') ELSE
	--	null END) [ConsigneeParty_Telephone],
	
	(case when P.HTS = 1 THEN
		isnull(CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone,'Field Mandatory') ELSE
		null END) [ConsigneeParty_Telephone],
		
	UPPER(LCO.Pais_Local)			[OriginCountry_Name],
	UPPER(LCD.Pais_Local)			[FinalDestinationCountry_Name]
	
from 
	Master_Exp_Aer MEA
	Left Outer Join LLP_Master LLP on MEA.num_proc_mea = LLP.Num_Proc_master
	
	Left Join Pessoa AG on MEA.cd_export_mea = AG.cd_pes
	Left Join Endereco ENDA on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
	Left Join Comunicacao CMA on CMA.cd_pes=AG.cd_pes and CMA.Cd_Tp_Com='TC1'
		
	Left Join Cia_Aerea CA on MEA.cd_cia_aer = CA.cd_cia_aer
	--Left Join Pessoa NF on NF.cd_pes=cd_export_mea
	
	Left Join Pessoa CS on CS.cd_pes=cd_consig_mea
	Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Join Endereco ENDI on CS.cd_pes=ENDI.cd_pes and ENDC.cd_tp_end = 'INT'
	Left Join Comunicacao CM on CM.cd_pes=cs.cd_pes and CM.Cd_Tp_Com='HBL'
	--HBL	Contato H/MAWB
	
	Left Join Pessoa Sh on SH.cd_pes=cd_export_mea
	Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'	
	left join comunicacao COMS on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
	left join comunicacao COMFS on SH.cd_pes = COMFS.cd_pes AND COMFS.cd_tp_com = 'FC1'
	
	--Join Tipo_Moeda TM on TM.cd_tp_moeda=mea.cd_tp_moeda
	
	Left Join nature_goods NG on MEA.num_proc_mea =NG.Num_Proc
	Left Join Handling_MEA HN on MEA.num_proc_mea = HN.Num_proc_mea 
	Left Join Localidade LCO on MEA.cd_org_mea = LCO.cd_local
	Left Join Localidade LCD on MEA.cd_dst_mea = LCD.cd_local
	left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
	
	left join Usuario US on US.cd_usuario = MEA.cd_User_Impres_mea
	
		
	left join Campo_Pessoa CP18 on CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
	left join Campo_Processo CP178 on CP178.Num_Proc = MEA.num_proc_mea and CP178.Id_Campo = '178'
	left join Armador Arm on Arm.Cd_Armador = CP178.Campo_Dados
Where
	MEA.Num_Proc_mea=@Processo	
	--and MEA.cd_cia_aer in ('AA','BA','LH','AF','CV','TKU')
	and isnull(CA.EfreightDescartes,0) = 1
	
--AA - AMERICAN AIRLINES
--BA - BRITISH AIRWAYS
--AF - AIR FRANCE
--LH - LUFTHANSA
--TKU	TURKISH AIRLINES INC cadu 02/06/2023
--select * from Cia_Aerea 





--ALTER PROCEDURE [dbo].[spEfreight_Waybill_Rel]--'EAGIG201805001'

--		@Processo 	VarChar(14)

--AS

--		Declare @Vlr_Agt_MEA	float
--		Declare @Vlr_Crr_MEA 	float
--		Declare @Vlr_Tx_Tot_MEA float
--		Declare @Vlr_frete		float
		
--		Declare @Vlr_AgtPP_MEA	float
--		Declare @Vlr_CrrPP_MEA 	float	
		
--		Set @Vlr_Agt_MEA=isnull((select sum(vlr_org_MEA)from cta_cte_MAS_exp_aer where num_proc_MEA = @Processo and Comp_MBL_MEA = 'A' and contab_mes_ano = 'C'),0)
--		Set @Vlr_Crr_MEA=isnull((select sum(vlr_org_MEA)from cta_cte_MAS_exp_aer where num_proc_MEA = @Processo and Comp_MBL_MEA = 'C' and contab_mes_ano = 'C'),0)
		
--		Set @Vlr_AgtPP_MEA=isnull((select sum(vlr_org_mEA)from cta_cte_MAS_exp_aer where Num_Proc_MEA = @Processo and Comp_MBL_MEA = 'A' and contab_mes_ano = 'P'),0)
--		Set @Vlr_CrrPP_MEA=isnull((select sum(vlr_org_mEA)from cta_cte_MAS_exp_aer where Num_Proc_MEA = @Processo and Comp_MBL_MEA = 'C' and contab_mes_ano = 'P'),0)
				
--		set @Vlr_frete = isnull((select vlr_frete_mea from master_exp_Aer where num_proc_mea = @Processo),0)
		
--		Set @Vlr_Tx_Tot_MEA= (@Vlr_Agt_MEA + @Vlr_Crr_MEA + @Vlr_frete)
		

--select 
--	--CA.IATA_CODE							ID,
	
--	MAWB_MEA								[BusinessHeaderDocument_ID],
--	left(US.nome_usuario,20)				[SignatoryConsignorAuthentication_Signatory],
--	MEA.Dt_Impres_MEA						[SignatoryCarrierAuthentication_ActualDateTime],
--	left(AG.Nome_raz_soc,20)				[SignatoryCarrierAuthentication_Signatory],
--	[dbo].[FRemoveAcentuacao](ENDA.Cidade)	[IssueAuthenticationLocation_Name],
	
--	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end) [TotalChargePrepaidIndicator],
--	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end)	[TotalDisbursementPrepaidIndicator],
	
--	Convert(decimal(18,1),Peso_Bruto_MEA)	[IncludedTareGrossWeightMeasure],
--	convert(decimal(18,3),MEA.Vol_Tot_MEA)	[GrossVolumeMeasure],
--	Convert(int,Qtd_Tot_Vol_MEA)			[TotalPieceQuantity],
		
--	Sh.Cd_Pes [ConsignorParty_AccountID],	
--	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](Sh.Nome_raz_soc)),20)[ConsignorParty_Name],
--	replace(ENDS.CEP COLLATE Latin1_General_BIN, char(32),'') [ConsignorParty_PostcodeCode],	
--	left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDS.Rua + ' ' + ends.numero)) ,35)[ConsignorParty_StreetName],
--	left([dbo].[FRemoveAcentuacao](ENDS.Cidade),17)					[ConsignorParty_CityName],	
--	ENDS.CD_pais											[ConsignorParty_CountryID],
--	--TC1	Telefone Comercial1
--	COMS.cd_int + COMS.cd_area_fone + COMS.prefixo + COMS.num_fone [ConsignorParty_Telephone],	

--	cs.Cd_Pes [ConsigneeParty_AccountID],	
--	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](cs.Nome_raz_soc)),20)[ConsigneeParty_Name],
--	replace(ENDC.CEP COLLATE Latin1_General_BIN, char(32),'') [ConsigneeParty_PostcodeCode],	
--	left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDC.Rua + ' ' + ENDC.numero)) ,35)[ConsigneeParty_StreetName],
--	left([dbo].[FRemoveAcentuacao](ENDC.Cidade),17)					[ConsigneeParty_CityName],	
--	ENDC.CD_pais													[ConsigneeParty_CountryID],
--	CM.cd_int + CM.cd_area_fone + CM.prefixo + CM.num_fone [ConsigneeParty_Telephone],
--	--HBL	Contato H/MAWB
			
--	AG.Cd_Pes [FreightForwarderParty_AccountID],	
--	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](AG.Nome_raz_soc)),20)[FreightForwarderParty_Name],
--	replace(ENDA.CEP COLLATE Latin1_General_BIN, char(32),'') [FreightForwarderParty_PostcodeCode],	
--	left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDA.Rua + ' ' + ENDA.numero)) ,35)[FreightForwarderParty_StreetName],
--	left([dbo].[FRemoveAcentuacao](ENDA.Cidade),17)					[FreightForwarderParty_CityName],	
--	ENDA.CD_pais											[FreightForwarderParty_CountryID],
--	'5715014/0014'											[FreightForwarderParty_CargoAgentID],
--	CMA.cd_int + CMA.cd_area_fone + CMA.prefixo + CMA.num_fone  [FreightForwarderParty_Telephone],
--	--HBL	Contato H/MAWB
	
--	UPPER(LCO.cd_local)				[OriginLocation_ID],
--	UPPER(LCO.Nome_Local)			[OriginLocation_Name],			
	
--	UPPER(LCD.iatacode)				[FinalDestinationLocation_ID],
--	UPPER(LCD.Nome_Local)			[FinalDestinationLocation_Name],
	
--	mea.Voo_MEA												[SpecifiedLogisticsTransportMovement_ID],
--	'Main-Carriage'											[SpecifiedLogisticsTransportMovement_StageCode],
--	'4'														[SpecifiedLogisticsTransportMovement_ModeCode],
--	'Air'													[SpecifiedLogisticsTransportMovement_Mode],	
	
--	'1'														[SpecifiedLogisticsTransportMovement_SequenceNumeric],
	
--	CA.Cd_Cia_Aer											[UsedLogisticsTransportMeans_Name],
	
--	LLP.ATD_Master											[ArrivalEvent_ScheduledOccurrenceDateTime],
--	'Airport'												[ArrivalEvent_TypeCode],
--	LLP.ATA_Master											[DepartureEvent_ScheduledOccurrenceDateTime],
--	'Airport'												[DepartureEvent_TypeCode],
	
--	[dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](MEA.Obs_MEA))		[HandlingSPHInstructions],
	
--	'F' [ApplicableRating_TypeCode],
	
--	convert(decimal(18,1),mEA.Peso_Bruto_MEA) [ApplicableRating_GrossWeightMeasure],
--	Convert(int,Qtd_Tot_Vol_MEA)			[ApplicableRating_PieceQuantity],
	
--	(case when isnull(dbo.fBusca_CampoCliente(MEA.Num_Proc_MEA,89),'2') = '1' then 'M'
--		else 'K' end) [CategoryCode],
--	convert(decimal(18,1),Peso_Bruto_MEA)		[ChargeableWeightMeasure],
--	convert(decimal(18,2),(convert(decimal(18,2),MEA.Vlr_Frete_MEA)/convert(decimal(18,2),LLP.Peso_Cubado))) [AppliedRate],
--	convert(decimal(18,2),MEA.Vlr_Frete_MEA)  [AppliedAmount],
--	convert(decimal(18,2),MEA.Vol_Tot_MEA)	[ApplicableRating_GrossVolumeMeasure],
	
--	'F' [ApplicableTotalRating_TypeCode],	
--	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end)		[ApplicableTotalRating_PrepaidIndicator],
--	convert(decimal(18,2),MEA.Vlr_Frete_MEA)		[ApplicableTotalRating_WeightChargeTotalAmount],
--	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Agt_MEA) + convert(decimal(18,2),@Vlr_Crr_MEA)+ convert(decimal(18,2),MEA.Vlr_Frete_MEA)
--	else convert(decimal(18,2),@Vlr_AgtPP_MEA) + convert(decimal(18,2),@Vlr_CrrPP_MEA) + convert(decimal(18,2),MEA.Vlr_Frete_MEA) 
--	end)	[ApplicableTotalRating_GrandTotalAmount],
	
--	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--		Arm.nome_armador
--	ELSE
--		null
--	end) CarrierMAWB,
	
--	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--		(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
--			'EIN23-1878776'
--		ELSE
--			'EIN20-8141384'	
--		end) 
--	ELSE
--		'' end)	EIN_Number,
		
--	(case when UPPER(ENDC.CD_pais) = 'CN' THEN
--		CP18.Campo_Dados ELSE
--		null END) USCI
	
	
--from 
--	Master_Exp_Aer MEA
--	Left Outer Join LLP_Master LLP on MEA.num_proc_mea = LLP.Num_Proc_master
	
--	Left Join Pessoa AG on MEA.cd_export_mea = AG.cd_pes
--	Left Join Endereco ENDA on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
--	Left Join Comunicacao CMA on CMA.cd_pes=AG.cd_pes and CMA.Cd_Tp_Com='TC1'
		
--	Left Join Cia_Aerea CA on MEA.cd_cia_aer = CA.cd_cia_aer
--	--Left Join Pessoa NF on NF.cd_pes=cd_export_mea
	
--	Left Join Pessoa CS on CS.cd_pes=cd_consig_mea
--	Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Join Endereco ENDI on CS.cd_pes=ENDI.cd_pes and ENDC.cd_tp_end = 'INT'
--	Left Join Comunicacao CM on CM.cd_pes=cs.cd_pes and CM.Cd_Tp_Com='HBL'
--	--HBL	Contato H/MAWB
	
--	Left Join Pessoa Sh on SH.cd_pes=cd_export_mea
--	Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'	
--	left join comunicacao COMS on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
--	left join comunicacao COMFS on SH.cd_pes = COMFS.cd_pes AND COMFS.cd_tp_com = 'FC1'
	
--	--Join Tipo_Moeda TM on TM.cd_tp_moeda=mea.cd_tp_moeda
	
--	Left Join nature_goods NG on MEA.num_proc_mea =NG.Num_Proc
--	Left Join Handling_MEA HN on MEA.num_proc_mea = HN.Num_proc_mea 
--	Left Join Localidade LCO on MEA.cd_org_mea = LCO.cd_local
--	Left Join Localidade LCD on MEA.cd_dst_mea = LCD.cd_local
	
--	left join Usuario US on US.cd_usuario = MEA.cd_User_Impres_mea
	
		
--	left join Campo_Pessoa CP18 on CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
--	left join Campo_Processo CP178 on CP178.Num_Proc = MEA.num_proc_mea and CP178.Id_Campo = '178'
--	left join Armador Arm on Arm.Cd_Armador = CP178.Campo_Dados
--Where
--	MEA.Num_Proc_mea=@Processo	
--	and MEA.cd_cia_aer in ('AA','BA','LH','AF')
	
----AA - AMERICAN AIRLINES
----BA - BRITISH AIRWAYS
----AF - AIR FRANCE
----LH - LUFTHANSA
----select * from Cia_Aerea 





GO
