SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spEfreight_HouseWaybill_Rel]--'EACSR201601004BR'
		
		@Processo 	VarChar(16)
AS

		Declare @Vlr_Agt_HEA	float
		Declare @Vlr_Crr_HEA 	float		
		Declare @Vlr_Tx_Tot_HEA float
		Declare @Vlr_frete		float
		
		Declare @Vlr_AgtPP_HEA	float
		Declare @Vlr_CrrPP_HEA 	float		

		Set @Vlr_Agt_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer where num_proc_HEA = @Processo and Comp_Job_HEA = 'A' and contab_mes_ano = 'C'),0)
		Set @Vlr_Crr_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer where num_proc_HEA = @Processo and Comp_Job_HEA = 'C' and contab_mes_ano = 'C'),0)
		
		Set @Vlr_AgtPP_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer where num_proc_HEA = @Processo and Comp_Job_HEA = 'A' and contab_mes_ano = 'P'),0)
		Set @Vlr_CrrPP_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer where num_proc_HEA = @Processo and Comp_Job_HEA = 'C' and contab_mes_ano = 'P'),0)
		
		set @Vlr_frete = isnull((select vlr_frete_tot_hea from house_exp_Aer where num_proc_hea = @Processo),0)

		Set @Vlr_Tx_Tot_HEA = (@Vlr_Agt_HEA + @Vlr_Crr_HEA + @Vlr_frete)
		--Declare @New_ID bigInt
		--set @New_ID = (select isnull(max(ID),0)+1 from ATL_INT.dbo.Efreight where Num_Proc = @Processo and Tipo_Envio = 'C' and Tipo_XML = 'XFZB')
		--insert into ATL_INT.dbo.Efreight values(@New_ID,@Processo,'C','XFZB',NULL,NULL)

--Insert into ATL_INT.dbo.XFZB_House
select 
	--@New_ID,
	HAWB_HEA									[BusinessHeaderDocument_ID],
	left(US.nome_usuario,20)					[SignatoryConsignorAuthentication_Signatory],
	llp.dt_impres_lea							[SignatoryCarrierAuthentication_ActualDateTime],
	left(AG.Nome_raz_soc,20)					[SignatoryCarrierAuthentication_Signatory],
	[dbo].[FRemoveAcentuacao](ENDA.Cidade)		[IssueAuthenticationLocation_Name],
	
	Convert(decimal(18,1),Peso_Bruto_hea)		[IncludedTareGrossWeightMeasure],
	Convert(int,Qtd_Tot_Vol_hea)				[TotalPieceQuantity],		
	HOU.MAWB_HEA								[TransportContractDocument_ID],
	
	UPPER(LCO.IATACODE)							[OriginLocation_ID],
	UPPER(LCO.Nome_Local)						[OriginLocation_Name],			
	UPPER(LCD.IATACODE)							[FinalDestinationLocation_ID],
	UPPER(LCD.Nome_Local)						[FinalDestinationLocation_Name],	
	
	(case when tp_frete_hea	= 'C' 
			then 'false' else 'true' end)		[TotalChargePrepaidIndicator],
	(case when tp_frete_hea	= 'C'
			then 'false' else 'true' end)		[TotalDisbursementPrepaidIndicator],
			
	convert(decimal(18,2),vlr_frete_tot_hea	)			[WeightTotalChargeAmount],
		
	(case when tp_frete_hea	= 'C' 
		then convert(decimal(18,2),@Vlr_AgtPP_HEA) 
		else convert(decimal(18,2),@Vlr_Agt_HEA) end)	[AgentTotalDisbursementAmount],		
	(case when tp_frete_hea	= 'C' 
		then convert(decimal(18,2),@Vlr_CrrPP_HEA) 
		else convert(decimal(18,2),@Vlr_Crr_HEA) end)	[CarrierTotalDisbursementAmount],
	
	
	(case when tp_frete_hea	= 'P' 
		then convert(decimal(18,2),@Vlr_AgtPP_HEA + @Vlr_CrrPP_HEA + vlr_frete_tot_hea)
		 else convert(decimal(18,2),@Vlr_AgtPP_HEA + @Vlr_CrrPP_HEA) end)	[TotalPrepaidChargeAmount],
		 
	(case when tp_frete_hea	= 'C' 
		then convert(decimal(18,2),@Vlr_Agt_HEA + @Vlr_Crr_HEA + vlr_frete_tot_hea)
		else convert(decimal(18,2),@Vlr_Agt_HEA + @Vlr_Crr_HEA) end)		[TotalCollectChargeAmount],
		
	Convert(decimal(18,1),Peso_Bruto_hea)		[IncludedTareGrossWeightMeasure_House],
	
	--convert(decimal(18,1),LLP.Peso_Cubado_Lea)	[GrossVolumeMeasure_House],
	convert(decimal(18,1),Vol_Tot_HEA)	[GrossVolumeMeasure_House],
	
	Convert(int,Qtd_Tot_Vol_hea)				[TotalPieceQuantity_House],	
	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[SummaryDescription],
		
	Sh.Cd_Pes [ConsignorParty_AccountID],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](Sh.Nome_raz_soc)),20)[ConsignorParty_Name],
	replace(ENDS.CEP COLLATE Latin1_General_BIN, char(32),'') [ConsignorParty_PostcodeCode],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDS.Rua + ' ' + ends.numero)) ,35)[ConsignorParty_StreetName],
	left([dbo].[FRemoveAcentuacao](ENDS.Cidade),17)					[ConsignorParty_CityName],	
	ENDS.CD_pais											[ConsignorParty_CountryID],
	
	cs.Cd_Pes [ConsigneeParty_AccountID],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](cs.Nome_raz_soc)),20)[ConsigneeParty_Name],
	replace(ENDC.CEP COLLATE Latin1_General_BIN, char(32),'') [ConsigneeParty_PostcodeCode],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDC.Rua + ' ' + ENDC.numero)) ,35)[ConsigneeParty_StreetName],
	left([dbo].[FRemoveAcentuacao](ENDC.Cidade),17)					[ConsigneeParty_CityName],	
	ENDC.CD_pais											[ConsigneeParty_CountryID],
			
	AG.Cd_Pes [FreightForwarderParty_AccountID],
	'5715014/0014' [FreightForwarderParty_CargoAgentID],
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](AG.Nome_raz_soc)),20)[FreightForwarderParty_Name],
	replace(ENDA.CEP COLLATE Latin1_General_BIN, char(32),'') [FreightForwarderParty_PostcodeCode],	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]((ENDA.Rua + ' ' + ENDA.numero)) ,35)[FreightForwarderParty_StreetName],
	left([dbo].[FRemoveAcentuacao](ENDA.Cidade),17)					[FreightForwarderParty_CityName],	
	ENDA.CD_pais											[FreightForwarderParty_CountryID],
		
	--Origin Destination
	
	'Main-Carriage'											[SpecifiedLogisticsTransportMovement_StageCode],
	'4'														[SpecifiedLogisticsTransportMovement_ModeCode],
	'Air'													[SpecifiedLogisticsTransportMovement_Mode],	
	HOU.Voo_HEA												[SpecifiedLogisticsTransportMovement_ID],
	'1'														[SpecifiedLogisticsTransportMovement_SequenceNumeric],
	--CA.Nome_cia_aer											[UsedLogisticsTransportMeans_Name],
	CA.SCAC													[UsedLogisticsTransportMeans_Name],
	
	LLP.ATD_Lea												[ArrivalEvent_ScheduledOccurrenceDateTime],
	--Origin
	'Airport'												[ArrivalEvent_TypeCode],
	
	LLP.ATA_Lea												[DepartureEvent_ScheduledOccurrenceDateTime],
	--Destination
	'Airport'												[DepartureEvent_TypeCode],
	
	[dbo].[FRemoveAcentuacao](HN.Hand_HEA_1)				[HandlingSPHInstructions],
	
	convert(decimal(18,1),Peso_Bruto_hea)					[GrossWeightMeasure_HouseItem],
	convert(decimal(18,1),LLP.Peso_Cubado_Lea)				[GrossVolumeMeasure_HouseItem],
	Convert(int,Qtd_Tot_Vol_hea)							[TotalPieceQuantity_HouseItem],	
	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[Information],
	
	isnull([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Qtd_Vol_EA'),0)					[TransportLogisticsPackage_ItemQuantity],
	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Altura_EA')) * 100,0)	[TransportLogisticsPackage_HeightMeasure],
	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Compr_EA'))* 100,0)	 [TransportLogisticsPackage_LengthMeasure],
	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Largura_EA'))* 100,0)	[TransportLogisticsPackage_WidthMeasure],	
	
	convert(decimal(6,1),Peso_Bruto_hea)		[ChargeableWeightMeasure]

from 
	house_exp_Aer HOU
	Left Join Master_Exp_Aer MEA on HOU.num_proc_mea = MEA.num_proc_mea
	Left Outer Join LLP_Exp_Aer LLP on HOU.Num_Proc_Hea = LLP.Num_Proc_Lea
	
	Left Join Pessoa AG on MEA.cd_export_mea = AG.cd_pes
	Left Join Endereco ENDA on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
	left join comunicacao COMA on AG.cd_pes = COMA.cd_pes and COMA.cd_tp_com = 'TC1'
	left join comunicacao COMFA on AG.cd_pes = COMFA.cd_pes AND COMFA.cd_tp_com = 'FC1'
	
	Left Join Pessoa CS on CS.cd_pes=cd_consig_hea
	Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	left join comunicacao COMC on CS.cd_pes = COMC.cd_pes and comc.cd_tp_com = 'TC1'
	left join comunicacao COMFC on CS.cd_pes = COMFC.cd_pes AND COMFC.cd_tp_com = 'FC1'
	
	Left Join Pessoa Sh on SH.cd_pes=cd_export_hea
	Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
	left join comunicacao COMS on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
	left join comunicacao COMFS on SH.cd_pes = COMFS.cd_pes AND COMFS.cd_tp_com = 'FC1'
	
	Join Cia_Aerea CA on LLP.cd_ciaAerea_lea = CA.cd_cia_aer
	Left Join Localidade LCO on HOU.cd_org_hea = LCO.cd_local
	Left Join Localidade LCD on Hou.cd_dst_hea = LCD.cd_local
	left join Usuario US on US.cd_usuario = LLP.cd_User_Impres_Lea
	
	Left Join Pessoa NF on NF.cd_pes=cd_export_hea	
	
	Left Join nature_goods NG on HOU.num_proc_hea=NG.Num_Proc
	Left Join Handling_HEA HN on Hou.num_proc_hea = HN.Num_proc_hea 
	Left Join PESSOA DSP on cd_dsp_hea=DSP.cd_pes
Where
	hou.Num_Proc_hea=@Processo
	--and LLP.cd_ciaAerea_lea in ('AA','BA','LH','AF','CV','TKU')
	and isnull(CA.EfreightDescartes,0) = 1
		
--AA - AMERICAN AIRLINES
--BA - BRITISH AIRWAYS
--AF - AIR FRANCE
--LH - LUFTHANSA
--TKU	TURKISH AIRLINES INC cadu 02/06/2023
--select * from Cia_Aerea where Nome_Cia_Aer like '%SWISS%'
--select * from Cia_Aerea where EfreightDescartes =1

--update Cia_Aerea set EfreightDescartes = 1 where cd_Cia_Aer in ('AA','BA','LH','AF','CV','TKU')
--update Cia_Aerea set EfreightDescartes = 1 where cd_Cia_Aer in ('SW')

--alter table [dbo].[Cia_Aerea] add EfreightDescartes bit NULL
GO
