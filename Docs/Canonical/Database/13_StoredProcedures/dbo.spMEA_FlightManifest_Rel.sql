SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMEA_FlightManifest_Rel]--'EAVCP21507003'

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
	MAWB_MEA								[BusinessHeaderDocument_ID],
	'Main-Carriage'							[SpecifiedLogisticsTransportMovement_StageCode],
	'4'										[SpecifiedLogisticsTransportMovement_ModeCode],
	'Air'									[SpecifiedLogisticsTransportMovement_Mode],	
	mea.Voo_MEA								[SpecifiedLogisticsTransportMovement_ID],
	'1'										[SpecifiedLogisticsTransportMovement_SequenceNumeric],
	convert(decimal(18,2),LLP.Peso_Cubado)		[TotalGrossVolumeMeasure],
	convert(decimal(18,2),mEA.Peso_Bruto_MEA)	[TotalGrossWeightMeasure],
	convert(int,Qtd_Tot_Vol_MEA)			[TotalPackageQuantity],
	Convert(int,Qtd_Tot_Vol_MEA)			[TotalPieceQuantity],	
	
	CA.Nome_cia_aer							[UsedLogisticsTransportMeans_Name],
	MEA.MAWB_MEA							[TransportContractDocument_ID],

	ENDA.Cidade								[IssueAuthenticationLocation_Name],
	Convert(decimal(18,2),Peso_Bruto_MEA)	[IncludedTareGrossWeightMeasure],
	convert(decimal(18,2),LLP.Peso_Cubado)	[GrossVolumeMeasure],
	convert(decimal(18,2),mEA.Peso_Bruto_MEA)	[GrossWeightMeasure],

	convert(decimal(18,2),MEA.Vlr_Frete_MEA)	[TotalChargeAmount],
	
	Sh.Cd_Pes	[cd_Consignor],
	cs.Cd_Pes	[cd_Consignee],
	AG.Cd_Pes	[cd_FreightForwarder],
		
	UPPER(LCO.cd_local)				[OriginLocation_ID],
	UPPER(LCO.Nome_Local)			[OriginLocation_Name],			
	UPPER(LCD.iatacode)				[FinalDestinationLocation_ID],
	UPPER(LCD.Nome_Local)			[FinalDestinationLocation_Name],
	
	

	LLP.ATD_Master											[ArrivalEvent_ScheduledOccurrenceDateTime],
	'Airport'												[ArrivalEvent_TypeCode],
	LLP.ATA_Master											[DepartureEvent_ScheduledOccurrenceDateTime],
	'Airport'												[DepartureEvent_TypeCode],
	MEA.Obs_MEA								[SummaryDescription],
	HN.Hand_mEA_1							[HandlingSPHInstructions],
	--HN.Hand_mEA_1,
	--HN.Hand_MEA_2,
	--HN.Hand_MEA_3,	
	''										[HandlingSSRInstructions],
	''										[HandlingOSIInstructions],
	'PX'									[TransportPaymentMethodCode], --não sei
	
	convert(decimal(18,2),isnull(V.Altura_EA,0))					[TransportLogisticsPackage_HeightMeasure],
	convert(decimal(18,2),isnull(V.Compr_EA,0))					[TransportLogisticsPackage_LengthMeasure],
	convert(decimal(18,2),isnull(V.Largura_EA,0))					[TransportLogisticsPackage_WidthMeasure],		
	isnull(V.Qtd_Vol_EA,0)					[TransportLogisticsPackage_ItemQuantity],
	isnull(V.Peso_Bruto_EA,0)				[TransportLogisticsPackage_GrossWeightMeasure],
	
	convert(decimal(18,2),Peso_Bruto_hea)		[ChargeableWeightMeasure],
	
	
	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end)		[PrepaidIndicator],
	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_AgtPP_MEA) 
				else convert(decimal(18,2),@Vlr_Agt_MEA) end)	[AgentTotalDuePayableAmount],
				
	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_CrrPP_MEA) 
			else convert(decimal(18,2),@Vlr_Crr_MEA) end)	[CarrierTotalDuePayableAmount],
	
	(case when MEA.Tp_Frete_MEA= 'P' then convert(decimal(18,2),@Vlr_AgtPP_MEA + @Vlr_CrrPP_MEA + vlr_frete_tot_hea)
		 else convert(decimal(18,2),@Vlr_AgtPP_MEA + @Vlr_CrrPP_MEA) end)	[TotalPrepaidChargeAmount],
		 
	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Agt_MEA + @Vlr_Crr_MEA + vlr_frete_tot_hea)
		 else convert(decimal(18,2),@Vlr_Agt_MEA + @Vlr_Crr_MEA) end)		[TotalCollectChargeAmount],
		
	ISNULL(Dbo.fBusca_CampoCliente (@processo, 47),'0.00')	AppliedRate,
	
	convert(decimal(18,2),MEA.Vlr_Frete_MEA)  AppliedAmount
		
		
	--upper(lcd.iatacode)		cd_cia_aer,	
	--MEA.cd_tp_moeda,
	--dbo.fBusca_CampoCliente (@processo, 47) exchangeRate,
	--dbo.fBusca_CampoCliente (@processo, 39) ref_accountinginfo,
	--'0'						selling_rates,
	--NG.Descr				NATURES_GOODS,
	--left(MEA.MAWB_mEA,3)	COMECO,
	--right(MEA.MAWB_mEA,8)	FIM,
	--@Vlr_Agt_MEA			Valor_Agente,
	--@Vlr_Crr_MEA			Valor_Carrier,
	--@Vlr_Tx_Tot_MEA			Total_Taxa,
	--dbo.spTaxasMasterEA(@Processo) Taxas,
	--dbo.spHouseEA(@Processo)Houses,
	--Obs_mea,
	--isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') FreteMinimo,
	--ENDI.Rua				Rua_CiaAer,
	--ENDI.Numero				Numero_CiaAer,
	--ENDI.Compl_End			Compl_CiaAer,
	--ENDI.Bairro				Bairro_CiaAer,
	--ENDI.Cidade				Ciade_CiaAer,
	--ENDI.Pais				Pais_CiaAer,	
	--@Vlr_AgtPP_MEA Valor_AgentePP,
	--@Vlr_CrrPP_MEA Valor_CarrierPP,	
	--'+' + Cd_Int + ' ' + cd_area_fone + ' '+ prefixo +'-'+num_fone Telefone,
	--MEA.dt_ImpressDraft_mea dt_draft
	
from 
	Master_Exp_Aer MEA
	Join house_exp_Aer HOU on MEA.num_proc_mea = HOU.num_proc_mea
	Left Outer Join LLP_Master LLP on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Join Pessoa AG on MEA.cd_export_mea = AG.cd_pes
	Left Join Endereco ENDA on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
	--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
	Left Join Cia_Aerea CA on MEA.cd_cia_aer = CA.cd_cia_aer
	Left Join Pessoa NF on NF.cd_pes=cd_export_mea
	Left Join Pessoa CS on CS.cd_pes=cd_consig_mea
	Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Join Endereco ENDI on CS.cd_pes=ENDI.cd_pes and ENDC.cd_tp_end = 'INT'
	--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
	Left Join Pessoa Sh on SH.cd_pes=cd_export_mea
	Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
	--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
	Join Tipo_Moeda TM on TM.cd_tp_moeda=mea.cd_tp_moeda
	Left Join nature_goods NG on MEA.num_proc_mea =NG.Num_Proc
	Left Join Handling_MEA HN on MEA.num_proc_mea = HN.Num_proc_mea 
	Left Join PESSOA DSP on cd_dsp_hea=DSP.cd_pes
	Left Join Localidade LCO on MEA.cd_org_mea = LCO.cd_local
	Left Join Localidade LCD on MEA.cd_dst_mea = LCD.cd_local
	Left Join Comunicacao CM on CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
	
	left join Usuario US on US.cd_usuario = MEA.cd_User_Impres_mea
	
	left join Volume_Exp_Aer V on V.Num_Proc_HEA = HOU.Num_Proc_HEA
Where
	MEA.Num_Proc_mea=@Processo





GO
