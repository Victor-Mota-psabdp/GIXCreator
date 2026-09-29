SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Cadu - alterado 21/07/2016 - para o DSGUNXA, conforme solicitação do Bill Connors
--[spHEA_HouseWaybill_Rel]'EAFMC202312001BR'
CREATE Procedure [dbo].[spHEA_HouseWaybill_Rel]--'EAKRY201511002BR'
		
		@Processo 	VarChar(16)
		--@User		varchar(50),
		--@Tipo		char(1)
AS


--declare @Processo as varchar(16)
--set @Processo = 'EAATL201408007BR'

		Declare @Vlr_Agt_HEA	float
		Declare @Vlr_Crr_HEA 	float		
		Declare @Vlr_Tx_Tot_HEA float
		Declare @Vlr_frete		float
		
		Declare @Vlr_AgtPP_HEA	float
		Declare @Vlr_CrrPP_HEA 	float		

		Set @Vlr_Agt_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer with(nolock) where num_proc_HEA = @Processo and Comp_Job_HEA = 'A' and contab_mes_ano = 'C'),0)
		Set @Vlr_Crr_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer with(nolock) where num_proc_HEA = @Processo and Comp_Job_HEA = 'C' and contab_mes_ano = 'C'),0)
		
		Set @Vlr_AgtPP_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer with(nolock)  where num_proc_HEA = @Processo and Comp_Job_HEA = 'A' and contab_mes_ano = 'P'),0)
		Set @Vlr_CrrPP_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer with(nolock) where num_proc_HEA = @Processo and Comp_Job_HEA = 'C' and contab_mes_ano = 'P'),0)
		
		set @Vlr_frete = isnull((select vlr_frete_tot_hea from house_exp_Aer with(nolock) where num_proc_hea = @Processo),0)

		Set @Vlr_Tx_Tot_HEA = (@Vlr_Agt_HEA + @Vlr_Crr_HEA + @Vlr_frete)
		--Declare @New_ID bigInt
		--set @New_ID = (select isnull(max(ID),0)+1 from ATL_INT.dbo.Efreight where Num_Proc = @Processo and Tipo_Envio = 'C' and Tipo_XML = 'XFZB')
		--insert into ATL_INT.dbo.Efreight values(@New_ID,@Processo,'C','XFZB',NULL,NULL)

--Insert into ATL_INT.dbo.XFZB_House
select 
	--@New_ID,
	HAWB_HEA						[BusinessHeaderDocument_ID],
	left(US.nome_usuario,20)					[SignatoryConsignorAuthentication_Signatory],
	llp.dt_impres_lea				[SignatoryCarrierAuthentication_ActualDateTime],
	--dt_impres_lea,getdate(),DATEDIFF(day, getdate(), dt_impres_lea),getdate()+DATEDIFF(day, getdate(), dt_impres_lea)
	--getdate()+DATEDIFF(day, getdate(), llp.dt_impres_lea)	[SignatoryCarrierAuthentication_ActualDateTime],
	--getdate()	[SignatoryCarrierAuthentication_ActualDateTime],
	left(AG.Nome_raz_soc,20)					[SignatoryCarrierAuthentication_Signatory],
	[dbo].[FRemoveAcentuacao](ENDA.Cidade)						[IssueAuthenticationLocation_Name],
	Convert(decimal(18,1),Peso_Bruto_hea)					[IncludedTareGrossWeightMeasure],
	Convert(int,Qtd_Tot_Vol_hea)	[TotalPieceQuantity],		
	HOU.MAWB_HEA					[TransportContractDocument_ID],
	UPPER(LCO.IATACODE)				[OriginLocation_ID],
	UPPER(LCO.Nome_Local)			[OriginLocation_Name],			
	UPPER(LCD.IATACODE)				[FinalDestinationLocation_ID],
	UPPER(LCD.Nome_Local)			[FinalDestinationLocation_Name],	
	
	(case when tp_frete_hea	= 'C' then 'false' else 'true' end) [TotalChargePrepaidIndicator],
	convert(decimal(18,2),vlr_frete_tot_hea	)			[WeightTotalChargeAmount],
	0								[ValuationTotalChargeAmount],
	0								[TaxTotalChargeAmount],
	
	(case when tp_frete_hea	= 'C' then 'false' else 'true' end)							[TotalDisbursementPrepaidIndicator],
	(case when tp_frete_hea	= 'C' then convert(decimal(18,2),@Vlr_AgtPP_HEA) else convert(decimal(18,2),@Vlr_Agt_HEA) end)	[AgentTotalDisbursementAmount],
	(case when tp_frete_hea	= 'C' then convert(decimal(18,2),@Vlr_CrrPP_HEA) else convert(decimal(18,2),@Vlr_Crr_HEA) end)	[CarrierTotalDisbursementAmount],
	
	(case when tp_frete_hea	= 'P' then convert(decimal(18,2),@Vlr_AgtPP_HEA + @Vlr_CrrPP_HEA + vlr_frete_tot_hea)
		 else convert(decimal(18,2),@Vlr_AgtPP_HEA + @Vlr_CrrPP_HEA) end)						[TotalPrepaidChargeAmount],
		 
	(case when tp_frete_hea	= 'C' then convert(decimal(18,2),@Vlr_Agt_HEA + @Vlr_Crr_HEA + vlr_frete_tot_hea)
		 else convert(decimal(18,2),@Vlr_Agt_HEA + @Vlr_Crr_HEA) end)						[TotalCollectChargeAmount],
	
		
	sh.Cd_Pes	[cd_Consignor],
	cs.Cd_Pes	[cd_Consignee],
	AG.Cd_Pes	[cd_FreightForwarder],
		
	
	'Main-Carriage'											[SpecifiedLogisticsTransportMovement_StageCode],
	'4'														[SpecifiedLogisticsTransportMovement_ModeCode],
	'Air'													[SpecifiedLogisticsTransportMovement_Mode],	
	--HOU.Voo_HEA											[SpecifiedLogisticsTransportMovement_ID],
	(case when len(HOU.Voo_HEA) < 3 then '00' + HOU.Voo_HEA	else HOU.Voo_HEA end) [SpecifiedLogisticsTransportMovement_ID],
	'1'														[SpecifiedLogisticsTransportMovement_SequenceNumeric],
	--CA.Nome_cia_aer											[UsedLogisticsTransportMeans_Name],
	CA.SCAC													[UsedLogisticsTransportMeans_Name],

	LLP.ATD_Lea												[ArrivalEvent_ScheduledOccurrenceDateTime],
	'Airport'												[ArrivalEvent_TypeCode],
	LLP.ATA_Lea												[DepartureEvent_ScheduledOccurrenceDateTime],
	'Airport'												[DepartureEvent_TypeCode],

	isnull([dbo].[FRemoveAcentuacao](HN.Hand_HEA_1),'Campo Descrição do manuseio de carga é obrigatório.')	[HandlingSPHInstructions],
	''										[HandlingSSRInstructions],
	''										[HandlingOSIInstructions],	
		
	convert(int,Qtd_Tot_Vol_hea)									[PieceQuantity],
	convert(decimal(18,1),Peso_Bruto_hea)							[GrossWeightMeasure],
	--convert(decimal(18,1),LLP.Peso_Cubado_Lea)						[GrossVolumeMeasure],
	--convert(decimal(18,1),Vol_Tot_HEA)								[GrossVolumeMeasure],
	(case when Vol_Tot_HEA > 0 then convert(decimal(9,3),Vol_Tot_HEA) else
	 convert(decimal(9,3),'1') end) [GrossVolumeMeasure],	
	--<ns3:GrossVolumeMeasure unitCode="MTQ" >999999.999</ns3:GrossVolumeMeasure>
	--Volume is limited to 9 characters. Should be 999999.99
	--convert(decimal(18,2),LLP.Peso_Cubado_Lea)						[GrossVolumeMeasure],
	
	
	
	convert(decimal(18,2),hou.Vlr_Frete_Tot_HEA)					[TotalChargeAmount],

	--left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[Information],
	left([dbo].[FRemoveSpecial_chars](NG.Descr),62)											[Information],


	--Obs_hea									[SummaryDescription],
	--left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[SummaryDescription],
	left([dbo].[FRemoveSpecial_chars](NG.Descr),62)											[SummaryDescription],
	
	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Altura_EA')) * 100,0)		[TransportLogisticsPackage_HeightMeasure],
	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Compr_EA'))* 100,0)	 [TransportLogisticsPackage_LengthMeasure],
	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Largura_EA'))* 100,0)					[TransportLogisticsPackage_WidthMeasure],
	isnull([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Qtd_Vol_EA'),0)					[TransportLogisticsPackage_ItemQuantity],
	isnull([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Peso_Bruto_EA'),0)				[TransportLogisticsPackage_GrossWeightMeasure],
		
	--convert(decimal(18,2),isnull(V.Altura_EA,0))					[TransportLogisticsPackage_HeightMeasure],
	--convert(decimal(18,2),isnull(V.Compr_EA,0))					[TransportLogisticsPackage_LengthMeasure],
	--convert(decimal(18,2),isnull(V.Largura_EA,0))					[TransportLogisticsPackage_WidthMeasure],

			
	--isnull(V.Qtd_Vol_EA,0)					[TransportLogisticsPackage_ItemQuantity],
	--isnull(V.Peso_Bruto_EA,0)				[TransportLogisticsPackage_GrossWeightMeasure],
	
	convert(decimal(6,1),Peso_Bruto_hea)		[ChargeableWeightMeasure],
	--convert(decimal(18,2),Peso_Bruto_hea)		[ChargeableWeightMeasure],
	
	
		
	HOU.Num_Proc_Hea,
	convert(decimal(18,2),llp.selling_rates_lea) AppliedRate,
	(case when isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') = '1' then 'M'
		else 
		'K' 
	end) CategoryCode,	
	convert(decimal(18,2),hou.vlr_frete_tot_hea)  AppliedAmount,
	
	--CA.IATA_CODE							IATA_CODE
	'DSGUNXA'								IATA_CODE,
	--INTO  XFZB_House
	
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	--	[dbo].[fBusca_Volumes_NCM](HOU.Num_Proc_HEA) 
	--ELSE
	--	null END)TypeCode
		
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	--(case when P.HTS = 1 THEN
	--	[dbo].[fBusca_Volumes_NCM](HOU.Num_Proc_HEA) 
	--ELSE
	--	null END)TypeCode
		[dbo].[fBusca_Volumes_NCM](HOU.Num_Proc_HEA)  TypeCode
		
	--	,MEA.Num_Proc_MEA,
	--(case when P.HTS = 1 THEN 1 ELSE 0 END) IncludedCustomsNote
from 
	house_exp_Aer HOU with(nolock)
	Left Join Master_Exp_Aer MEA with(nolock) on HOU.num_proc_mea = MEA.num_proc_mea
	Left Outer Join LLP_Exp_Aer LLP with(nolock) on HOU.Num_Proc_Hea = LLP.Num_Proc_Lea
	
	Left Join Pessoa AG with(nolock) on MEA.cd_export_mea = AG.cd_pes
	Left Join Endereco ENDA with(nolock) on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
	left join comunicacao COMA with(nolock) on AG.cd_pes = COMA.cd_pes and COMA.cd_tp_com = 'TC1'
	left join comunicacao COMFA with(nolock) on AG.cd_pes = COMFA.cd_pes AND COMFA.cd_tp_com = 'FC1'
	--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
	
	Left Join Pessoa CS with(nolock) on CS.cd_pes=cd_consig_hea
	Left Join Endereco ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	left join comunicacao COMC with(nolock) on CS.cd_pes = COMC.cd_pes and comc.cd_tp_com = 'TC1'
	left join comunicacao COMFC with(nolock) on CS.cd_pes = COMFC.cd_pes AND COMFC.cd_tp_com = 'FC1'
	--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
	
	Left Join Pessoa Sh with(nolock) on SH.cd_pes=cd_export_hea
	Left Join Endereco ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
	left join comunicacao COMS with(nolock) on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
	left join comunicacao COMFS with(nolock) on SH.cd_pes = COMFS.cd_pes AND COMFS.cd_tp_com = 'FC1'
	--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
		
	Left Join Cia_Aerea CA with(nolock) on LLP.cd_ciaAerea_lea = CA.cd_cia_aer
	Left Join Localidade LCO with(nolock) on HOU.cd_org_hea = LCO.cd_local
	Left Join Localidade LCD with(nolock) on Hou.cd_dst_hea = LCD.cd_local
	left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
	left join Usuario US with(nolock) on US.cd_usuario = LLP.cd_User_Impres_Lea
	
	Left Join Pessoa NF with(nolock) on NF.cd_pes=cd_export_hea	
	--Join Tipo_Moeda TM on TM.cd_tp_moeda=HOU.cd_tp_moeda
	Left Join nature_goods NG with(nolock) on HOU.num_proc_hea=NG.Num_Proc
	Left Join Handling_HEA HN with(nolock) on Hou.num_proc_hea = HN.Num_proc_hea 
	Left Join PESSOA DSP with(nolock) on cd_dsp_hea=DSP.cd_pes
	
	--left join Volume_Exp_Aer V on V.Num_Proc_HEA = HOU.Num_Proc_HEA
Where
hou.Num_Proc_hea=@Processo

--select * from ATL_INT.dbo.XFZB_House
--where ID = @New_ID and Num_Proc_Hea = @Processo
----Cadu - alterado 21/07/2016 - para o DSGUNXA, conforme solicitação do Bill Connors
----[spHEA_HouseWaybill_Rel]'EAKRY201601001BR'
--ALTER Procedure [dbo].[spHEA_HouseWaybill_Rel]--'EAKRY201511002BR'
		
--		@Processo 	VarChar(16)
--		--@User		varchar(50),
--		--@Tipo		char(1)
--AS


----declare @Processo as varchar(16)
----set @Processo = 'EAATL201408007BR'

--		Declare @Vlr_Agt_HEA	float
--		Declare @Vlr_Crr_HEA 	float		
--		Declare @Vlr_Tx_Tot_HEA float
--		Declare @Vlr_frete		float
		
--		Declare @Vlr_AgtPP_HEA	float
--		Declare @Vlr_CrrPP_HEA 	float		

--		Set @Vlr_Agt_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer with(nolock) where num_proc_HEA = @Processo and Comp_Job_HEA = 'A' and contab_mes_ano = 'C'),0)
--		Set @Vlr_Crr_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer with(nolock) where num_proc_HEA = @Processo and Comp_Job_HEA = 'C' and contab_mes_ano = 'C'),0)
		
--		Set @Vlr_AgtPP_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer with(nolock)  where num_proc_HEA = @Processo and Comp_Job_HEA = 'A' and contab_mes_ano = 'P'),0)
--		Set @Vlr_CrrPP_HEA=isnull((select sum(vlr_org_HEA)from cta_cte_HOU_exp_aer with(nolock) where num_proc_HEA = @Processo and Comp_Job_HEA = 'C' and contab_mes_ano = 'P'),0)
		
--		set @Vlr_frete = isnull((select vlr_frete_tot_hea from house_exp_Aer with(nolock) where num_proc_hea = @Processo),0)

--		Set @Vlr_Tx_Tot_HEA = (@Vlr_Agt_HEA + @Vlr_Crr_HEA + @Vlr_frete)
--		--Declare @New_ID bigInt
--		--set @New_ID = (select isnull(max(ID),0)+1 from ATL_INT.dbo.Efreight where Num_Proc = @Processo and Tipo_Envio = 'C' and Tipo_XML = 'XFZB')
--		--insert into ATL_INT.dbo.Efreight values(@New_ID,@Processo,'C','XFZB',NULL,NULL)

----Insert into ATL_INT.dbo.XFZB_House
--select 
--	--@New_ID,
--	HAWB_HEA						[BusinessHeaderDocument_ID],
--	left(US.nome_usuario,20)					[SignatoryConsignorAuthentication_Signatory],
--	llp.dt_impres_lea				[SignatoryCarrierAuthentication_ActualDateTime],
--	left(AG.Nome_raz_soc,20)					[SignatoryCarrierAuthentication_Signatory],
--	[dbo].[FRemoveAcentuacao](ENDA.Cidade)						[IssueAuthenticationLocation_Name],
--	Convert(decimal(18,1),Peso_Bruto_hea)					[IncludedTareGrossWeightMeasure],
--	Convert(int,Qtd_Tot_Vol_hea)	[TotalPieceQuantity],		
--	HOU.MAWB_HEA					[TransportContractDocument_ID],
--	UPPER(LCO.cd_local)				[OriginLocation_ID],
--	UPPER(LCO.Nome_Local)			[OriginLocation_Name],			
--	UPPER(LCD.cd_local)				[FinalDestinationLocation_ID],
--	UPPER(LCD.Nome_Local)			[FinalDestinationLocation_Name],	
	
--	(case when tp_frete_hea	= 'C' then 'false' else 'true' end) [TotalChargePrepaidIndicator],
--	convert(decimal(18,2),vlr_frete_tot_hea	)			[WeightTotalChargeAmount],
--	0								[ValuationTotalChargeAmount],
--	0								[TaxTotalChargeAmount],
	
--	(case when tp_frete_hea	= 'C' then 'false' else 'true' end)							[TotalDisbursementPrepaidIndicator],
--	(case when tp_frete_hea	= 'C' then convert(decimal(18,2),@Vlr_AgtPP_HEA) else convert(decimal(18,2),@Vlr_Agt_HEA) end)	[AgentTotalDisbursementAmount],
--	(case when tp_frete_hea	= 'C' then convert(decimal(18,2),@Vlr_CrrPP_HEA) else convert(decimal(18,2),@Vlr_Crr_HEA) end)	[CarrierTotalDisbursementAmount],
	
--	(case when tp_frete_hea	= 'P' then convert(decimal(18,2),@Vlr_AgtPP_HEA + @Vlr_CrrPP_HEA + vlr_frete_tot_hea)
--		 else convert(decimal(18,2),@Vlr_AgtPP_HEA + @Vlr_CrrPP_HEA) end)						[TotalPrepaidChargeAmount],
		 
--	(case when tp_frete_hea	= 'C' then convert(decimal(18,2),@Vlr_Agt_HEA + @Vlr_Crr_HEA + vlr_frete_tot_hea)
--		 else convert(decimal(18,2),@Vlr_Agt_HEA + @Vlr_Crr_HEA) end)						[TotalCollectChargeAmount],
	
		
--	sh.Cd_Pes	[cd_Consignor],
--	cs.Cd_Pes	[cd_Consignee],
--	AG.Cd_Pes	[cd_FreightForwarder],
		
	
--	'Main-Carriage'											[SpecifiedLogisticsTransportMovement_StageCode],
--	'4'														[SpecifiedLogisticsTransportMovement_ModeCode],
--	'Air'													[SpecifiedLogisticsTransportMovement_Mode],	
--	--HOU.Voo_HEA											[SpecifiedLogisticsTransportMovement_ID],
--	(case when len(HOU.Voo_HEA) < 3 then '00' + HOU.Voo_HEA	else HOU.Voo_HEA end) [SpecifiedLogisticsTransportMovement_ID],
--	'1'														[SpecifiedLogisticsTransportMovement_SequenceNumeric],
--	--CA.Nome_cia_aer											[UsedLogisticsTransportMeans_Name],
--	CA.SCAC													[UsedLogisticsTransportMeans_Name],

--	LLP.ATD_Lea												[ArrivalEvent_ScheduledOccurrenceDateTime],
--	'Airport'												[ArrivalEvent_TypeCode],
--	LLP.ATA_Lea												[DepartureEvent_ScheduledOccurrenceDateTime],
--	'Airport'												[DepartureEvent_TypeCode],

--	[dbo].[FRemoveAcentuacao](HN.Hand_HEA_1)						[HandlingSPHInstructions],
--	''										[HandlingSSRInstructions],
--	''										[HandlingOSIInstructions],	
		
--	convert(int,Qtd_Tot_Vol_hea)									[PieceQuantity],
--	convert(decimal(18,1),Peso_Bruto_hea)							[GrossWeightMeasure],
--	--convert(decimal(18,1),LLP.Peso_Cubado_Lea)						[GrossVolumeMeasure],
--	convert(decimal(18,1),Vol_Tot_HEA)								[GrossVolumeMeasure],		
--	--<ns3:GrossVolumeMeasure unitCode="MTQ" >999999.999</ns3:GrossVolumeMeasure>
--	--Volume is limited to 9 characters. Should be 999999.99
--	--convert(decimal(18,2),LLP.Peso_Cubado_Lea)						[GrossVolumeMeasure],
	
	
	
--	convert(decimal(18,2),hou.Vlr_Frete_Tot_HEA)					[TotalChargeAmount],
--	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[Information],
--	--Obs_hea									[SummaryDescription],
--	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[SummaryDescription],
	
--	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Altura_EA')) * 100,0)		[TransportLogisticsPackage_HeightMeasure],
--	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Compr_EA'))* 100,0)	 [TransportLogisticsPackage_LengthMeasure],
--	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Largura_EA'))* 100,0)					[TransportLogisticsPackage_WidthMeasure],
--	isnull([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Qtd_Vol_EA'),0)					[TransportLogisticsPackage_ItemQuantity],
--	isnull([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Peso_Bruto_EA'),0)				[TransportLogisticsPackage_GrossWeightMeasure],
		
--	--convert(decimal(18,2),isnull(V.Altura_EA,0))					[TransportLogisticsPackage_HeightMeasure],
--	--convert(decimal(18,2),isnull(V.Compr_EA,0))					[TransportLogisticsPackage_LengthMeasure],
--	--convert(decimal(18,2),isnull(V.Largura_EA,0))					[TransportLogisticsPackage_WidthMeasure],

			
--	--isnull(V.Qtd_Vol_EA,0)					[TransportLogisticsPackage_ItemQuantity],
--	--isnull(V.Peso_Bruto_EA,0)				[TransportLogisticsPackage_GrossWeightMeasure],
	
--	convert(decimal(6,1),Peso_Bruto_hea)		[ChargeableWeightMeasure],
--	--convert(decimal(18,2),Peso_Bruto_hea)		[ChargeableWeightMeasure],
	
	
		
--	HOU.Num_Proc_Hea,
--	convert(decimal(18,2),llp.selling_rates_lea) AppliedRate,
--	(case when isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') = '1' then 'M'
--		else 
--		'K' 
--	end) CategoryCode,	
--	convert(decimal(18,2),hou.vlr_frete_tot_hea)  AppliedAmount,
	
--	--CA.IATA_CODE							IATA_CODE
--	'DSGUNXA'								IATA_CODE,
--	--INTO  XFZB_House
	
--	(case when UPPER(LCD.Cd_Pais) in ('CN','ID')THEN
--		[dbo].[fBusca_Volumes_NCM](HOU.Num_Proc_HEA) 
--	ELSE
--		null END)TypeCode
--from 
--	house_exp_Aer HOU with(nolock)
--	Left Join Master_Exp_Aer MEA with(nolock) on HOU.num_proc_mea = MEA.num_proc_mea
--	Left Outer Join LLP_Exp_Aer LLP with(nolock) on HOU.Num_Proc_Hea = LLP.Num_Proc_Lea
	
--	Left Join Pessoa AG with(nolock) on MEA.cd_export_mea = AG.cd_pes
--	Left Join Endereco ENDA with(nolock) on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
--	left join comunicacao COMA with(nolock) on AG.cd_pes = COMA.cd_pes and COMA.cd_tp_com = 'TC1'
--	left join comunicacao COMFA with(nolock) on AG.cd_pes = COMFA.cd_pes AND COMFA.cd_tp_com = 'FC1'
--	--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
	
--	Left Join Pessoa CS with(nolock) on CS.cd_pes=cd_consig_hea
--	Left Join Endereco ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	left join comunicacao COMC with(nolock) on CS.cd_pes = COMC.cd_pes and comc.cd_tp_com = 'TC1'
--	left join comunicacao COMFC with(nolock) on CS.cd_pes = COMFC.cd_pes AND COMFC.cd_tp_com = 'FC1'
--	--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
	
--	Left Join Pessoa Sh with(nolock) on SH.cd_pes=cd_export_hea
--	Left Join Endereco ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
--	left join comunicacao COMS with(nolock) on SH.cd_pes = COMS.cd_pes AND COMS.cd_tp_com = 'TC1'
--	left join comunicacao COMFS with(nolock) on SH.cd_pes = COMFS.cd_pes AND COMFS.cd_tp_com = 'FC1'
--	--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
		
--	Left Join Cia_Aerea CA with(nolock) on LLP.cd_ciaAerea_lea = CA.cd_cia_aer
--	Left Join Localidade LCO with(nolock) on HOU.cd_org_hea = LCO.cd_local
--	Left Join Localidade LCD with(nolock) on Hou.cd_dst_hea = LCD.cd_local
--	left join Usuario US with(nolock) on US.cd_usuario = LLP.cd_User_Impres_Lea
	
--	Left Join Pessoa NF with(nolock) on NF.cd_pes=cd_export_hea	
--	--Join Tipo_Moeda TM on TM.cd_tp_moeda=HOU.cd_tp_moeda
--	Left Join nature_goods NG with(nolock) on HOU.num_proc_hea=NG.Num_Proc
--	Left Join Handling_HEA HN with(nolock) on Hou.num_proc_hea = HN.Num_proc_hea 
--	Left Join PESSOA DSP with(nolock) on cd_dsp_hea=DSP.cd_pes
	
--	--left join Volume_Exp_Aer V on V.Num_Proc_HEA = HOU.Num_Proc_HEA
--Where
--hou.Num_Proc_hea=@Processo

----select * from ATL_INT.dbo.XFZB_House
----where ID = @New_ID and Num_Proc_Hea = @Processo
GO
