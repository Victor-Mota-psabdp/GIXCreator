SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Cadu - alterado 21/07/2016 - para o DSGUNXA, conforme solicitação do Bill Connors
--[spMEA_Waybill_Rel]'EAGRU201502001'

--[spMEA_Waybill_Rel]'EAGIG201408002'
--select * from Master_Exp_Aer where Num_Proc_MEA = 'EAVCP201507003'
--03/10/2019 - alterado p nao ter house_exp, pq pode ter varios houses

CREATE PROCEDURE [dbo].[spMEA_Waybill_Rel]--'EAVCP201909003'

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
		

select distinct
	--CA.IATA_CODE							ID,
	'DSGUNXA'								ID,
	MAWB_MEA								[BusinessHeaderDocument_ID],
	left(US.nome_usuario,20)				[SignatoryConsignorAuthentication_Signatory],
	MEA.Dt_Impres_MEA						[SignatoryCarrierAuthentication_ActualDateTime],
	left(AG.Nome_raz_soc,20)				[SignatoryCarrierAuthentication_Signatory],
	[dbo].[FRemoveAcentuacao](ENDA.Cidade)							[IssueAuthenticationLocation_Name],
	
	----falta esta parte que precisa pegar do altera_bl
	--[NilCarriageValueIndicator]
	--DeclaredValueForCarriageAmount
	--[NilCustomsValueIndicator]
	--DeclaredValueForCustomsAmount
	--NilInsuranceValueIndicator
	--InsuranceValueAmount

	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end) [TotalChargePrepaidIndicator],
	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end)	[TotalDisbursementPrepaidIndicator],
	
	Convert(decimal(18,1),Peso_Bruto_MEA)	[IncludedTareGrossWeightMeasure],
	convert(decimal(18,2),MEA.Vol_Tot_MEA)	[GrossVolumeMeasure],
	convert(decimal(18,1),mEA.Peso_Bruto_MEA)	[GrossWeightMeasure],
	convert(int,Qtd_Tot_Vol_MEA)			[PieceQuantity],
	Convert(int,Qtd_Tot_Vol_MEA)			[TotalPieceQuantity],
	convert(decimal(18,2),MEA.Vlr_Frete_MEA)	[TotalChargeAmount],
	
	Sh.Cd_Pes	[cd_Consignor],
	cs.Cd_Pes	[cd_Consignee],
	AG.Cd_Pes	[cd_FreightForwarder],
		
	--UPPER(LCO.Cd_Pais) + ' ' + UPPER(LCO.cd_local)		[OriginLocation_ID],
	UPPER(LCO.IATACODE)		[OriginLocation_ID],
	UPPER(LCO.Nome_Local)			[OriginLocation_Name],			
	--UPPER(LCD.Cd_Pais) + ' ' + UPPER(LCD.iatacode)				[FinalDestinationLocation_ID],
	UPPER(LCD.IATACODE)				[FinalDestinationLocation_ID],
	UPPER(LCD.Nome_Local)			[FinalDestinationLocation_Name],
	'Main-Carriage'											[SpecifiedLogisticsTransportMovement_StageCode],
	'4'														[SpecifiedLogisticsTransportMovement_ModeCode],
	'Air'													[SpecifiedLogisticsTransportMovement_Mode],	
	--mea.Voo_MEA												[SpecifiedLogisticsTransportMovement_ID],
	(case when len(mea.Voo_MEA) < 3 then '00' + mea.Voo_MEA else mea.Voo_MEA end) [SpecifiedLogisticsTransportMovement_ID],
	'1'														[SpecifiedLogisticsTransportMovement_SequenceNumeric],
	--CA.Nome_cia_aer											[UsedLogisticsTransportMeans_Name],
	CA.SCAC											[UsedLogisticsTransportMeans_Name],
	
	LLP.ATD_Master											[ArrivalEvent_ScheduledOccurrenceDateTime],
	'Airport'												[ArrivalEvent_TypeCode],
	LLP.ATA_Master											[DepartureEvent_ScheduledOccurrenceDateTime],
	'Airport'												[DepartureEvent_TypeCode],
	
	--HN.Hand_mEA_1							[HandlingSPHInstructions],
	[dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](MEA.Obs_MEA))		[HandlingSPHInstructions],
	--left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[Information],	
	[dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](MEA.Obs_MEA))[Information],
	--HN.Hand_mEA_1,
	--HN.Hand_MEA_2,
	--HN.Hand_MEA_3,	
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[HandlingSSRInstructions],
		
	''										[HandlingOSIInstructions],
	'PX'									[TransportPaymentMethodCode], --não sei
	
	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Altura_EA')) * 100,0)	[TransportLogisticsPackage_HeightMeasure],
	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Compr_EA'))* 100,0)	 [TransportLogisticsPackage_LengthMeasure],
	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Largura_EA'))* 100,0)	[TransportLogisticsPackage_WidthMeasure],
	isnull([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Qtd_Vol_EA'),0)					[TransportLogisticsPackage_ItemQuantity],
	isnull([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Peso_Bruto_EA'),0)				[TransportLogisticsPackage_GrossWeightMeasure],
	
	
	
	
	
	
	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end)		[PrepaidIndicator],
	
	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Agt_MEA) 
				else convert(decimal(18,2),@Vlr_AgtPP_MEA) end)	[AgentTotalDuePayableAmount],
				
	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Crr_MEA) 
			else convert(decimal(18,2),@Vlr_CrrPP_MEA) end)	[CarrierTotalDuePayableAmount],
	
	(case when MEA.Tp_Frete_MEA= 'P' then convert(decimal(18,2),@Vlr_AgtPP_MEA + @Vlr_CrrPP_MEA + Vlr_Frete_MEA)
		 else convert(decimal(18,2),@Vlr_AgtPP_MEA + @Vlr_CrrPP_MEA) end)	[TotalPrepaidChargeAmount],
		 
	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Agt_MEA + @Vlr_Crr_MEA + Vlr_Frete_MEA)
		 else convert(decimal(18,2),@Vlr_Agt_MEA + @Vlr_Crr_MEA) end)		[TotalCollectChargeAmount],
		
	convert(decimal(18,1),Peso_Bruto_MEA)		[ChargeableWeightMeasure],
	
	convert(decimal(18,2),MEA.Vlr_Frete_MEA)		[WeightChargeTotalAmount],
	
	--convert(decimal(18,2),@Vlr_Tx_Tot_MEA) [GrandTotalAmount],
	
	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Agt_MEA) + convert(decimal(18,2),@Vlr_Crr_MEA)+ convert(decimal(18,2),MEA.Vlr_Frete_MEA)
				else convert(decimal(18,2),@Vlr_AgtPP_MEA) + convert(decimal(18,2),@Vlr_CrrPP_MEA) + convert(decimal(18,2),MEA.Vlr_Frete_MEA) end)	[GrandTotalAmount],
	
	--ISNULL(Dbo.fBusca_CampoCliente (@processo, 47),'0.00')	AppliedRate,
	
	--(case when isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') = '1' then 'Min'
	--	else 
	--	convert(varchar(50),convert(decimal(18,2),(convert(decimal(18,2),MEA.Vlr_Frete_MEA)/convert(decimal(18,2),LLP.Peso_Cubado))))
	--end) 
	
	convert(decimal(18,2),(convert(decimal(18,2),MEA.Vlr_Frete_MEA)/convert(decimal(18,2),LLP.Peso_Cubado))) AppliedRate,
	
	(case when isnull(dbo.fBusca_CampoCliente(MEA.Num_Proc_MEA,89),'2') = '1' then 'M'
		else 
		'K' 
	end) CategoryCode,
	
	convert(decimal(18,2),MEA.Vlr_Frete_MEA)  AppliedAmount,
	
		[dbo].[FRemoveAcentuacao](NG.Descr)					[SummaryDescription],
	MEA.MAWB_MEA								[TransportContractDocument_ID],
	
	--left([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Descr'),62)[House_Information]
	left([dbo].[FRemoveSpecial_chars]([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Descr')),62)[House_Information]
	
	--left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao]([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Descr'))),62)[House_Information]
		
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
	
	,ENDS.CD_pais											[ConsignorParty_CountryID],
	ENDC.CD_pais											[ConsigneeParty_CountryID],
	--(case when UPPER(ENDC.CD_pais) = 'CN' THEN
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	--	(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
	--		'EIN23-1878776'
	--	ELSE
	--		'EIN20-8141384'	
	--	end) 
	--ELSE
	--	'' end)	EIN_Number,
		
	(case when P.HTS = 1 THEN 
		(case when isnull(dbo.fBusca_CampoCliente(MEA.num_proc_mea,178),'BDP') = 'BDP' then 
			'Contact: ' + isnull(CMSH.Contato,'') + ' - EIN23-1878776'
		ELSE
			'Contact: ' + isnull(CMSH.Contato,'') + ' - EIN20-8141384'	
		end) 
	ELSE
		'' end)	EIN_Number,
		
	----(case when UPPER(ENDC.CD_pais) = 'CN' THEN
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	--	CP18.Campo_Dados ELSE
	--	null END) USCI,
	
	(case when P.HTS = 1 THEN
		'Contact: ' + isnull(CMSH.Contato,'') + ' - ' + CP18.Campo_Dados ELSE
		'' END) USCI,		
		
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	(case when P.HTS = 1 THEN 1 ELSE 0 END) IncludedCustomsNote,
		
	--(case when UPPER(LCD.Cd_Pais) in ('CN','ID','MY')THEN
	(case when P.HTS = 1 THEN
		--[dbo].[fBusca_Volumes_NCM](HOU.Num_Proc_HEA) 
		[dbo].[fBusca_Volumes_Master_EA_NCM](MEA.Num_Proc_MEA) 
	ELSE
		null END)TypeCode
	
from 
	Master_Exp_Aer MEA with(nolock)
	--Join house_exp_Aer HOU with(nolock) on MEA.num_proc_mea = HOU.num_proc_mea
	--Join llp_exp_Aer LL on HOU.Num_Proc_HEA = LL.Num_Proc_Lea
	Left Outer Join LLP_Master LLP with(nolock) on MEA.num_proc_mea = LLP.Num_Proc_master
	Left Join Pessoa AG with(nolock) on MEA.cd_export_mea = AG.cd_pes
	Left Join Endereco ENDA with(nolock) on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
	--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
	Left Join Cia_Aerea CA with(nolock) on MEA.cd_cia_aer = CA.cd_cia_aer
	Left Join Pessoa NF with(nolock) on NF.cd_pes=cd_export_mea
	Left Join Pessoa CS with(nolock) on CS.cd_pes=cd_consig_mea
	Left Join Endereco ENDC with(nolock) on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
	Left Join Endereco ENDI with(nolock) on CS.cd_pes=ENDI.cd_pes and ENDC.cd_tp_end = 'INT'
	--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
	Left Join Pessoa Sh with(nolock) on SH.cd_pes=cd_export_mea
	Left Join Endereco ENDS with(nolock) on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
		Left Join Comunicacao CMSH	with(nolock) on CMSH.cd_pes=SH.cd_pes and CMSH.Cd_Tp_Com='TC1'
	--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
	Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=mea.cd_tp_moeda
	Left Join nature_goods NG with(nolock) on MEA.num_proc_mea =NG.Num_Proc	
	Left Join Handling_MEA HN with(nolock) on MEA.num_proc_mea = HN.Num_proc_mea 
	--Left Join PESSOA DSP on cd_dsp_hea=DSP.cd_pes
	Left Join Localidade LCO with(nolock) on MEA.cd_org_mea = LCO.cd_local
	Left Join Localidade LCD with(nolock) on MEA.cd_dst_mea = LCD.cd_local
	left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
	Left Join Comunicacao CM with(nolock) on CM.cd_pes=cs.cd_pes and CM.cd_Tp_com='HBL'
	
	left join Usuario US with(nolock) on US.cd_usuario = MEA.cd_User_Impres_mea
	
	--left join Volume_Exp_Aer V on V.Num_Proc_HEA = HOU.Num_Proc_HEA
	
	left join Campo_Pessoa CP18 with(nolock) on CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
	left join Campo_Processo CP178 with(nolock) on CP178.Num_Proc = MEA.num_proc_mea and CP178.Id_Campo = '178'
	left join Armador Arm with(nolock) on Arm.Cd_Armador = CP178.Campo_Dados
	--left join Exchange_E_AirFreight Exc on Exc.Num_Proc_Mea = MEA.Num_Proc_mea
Where
	MEA.Num_Proc_mea=@Processo
	--and Exc.Num_Proc_Mea_Dt_Envio is null 
	
	
	
----Cadu - alterado 21/07/2016 - para o DSGUNXA, conforme solicitação do Bill Connors
----[spMEA_Waybill_Rel]'EAGRU201502001'

----[spMEA_Waybill_Rel]'EAGIG201408002'
----select * from Master_Exp_Aer where Num_Proc_MEA = 'EAVCP201507003'

--ALTER PROCEDURE [dbo].[spMEA_Waybill_Rel]--'EAGRU201610006'

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
--	'DSGUNXA'								ID,
--	MAWB_MEA								[BusinessHeaderDocument_ID],
--	left(US.nome_usuario,20)				[SignatoryConsignorAuthentication_Signatory],
--	MEA.Dt_Impres_MEA						[SignatoryCarrierAuthentication_ActualDateTime],
--	left(AG.Nome_raz_soc,20)				[SignatoryCarrierAuthentication_Signatory],
--	[dbo].[FRemoveAcentuacao](ENDA.Cidade)							[IssueAuthenticationLocation_Name],
	
--	----falta esta parte que precisa pegar do altera_bl
--	--[NilCarriageValueIndicator]
--	--DeclaredValueForCarriageAmount
--	--[NilCustomsValueIndicator]
--	--DeclaredValueForCustomsAmount
--	--NilInsuranceValueIndicator
--	--InsuranceValueAmount

--	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end) [TotalChargePrepaidIndicator],
--	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end)	[TotalDisbursementPrepaidIndicator],
	
--	Convert(decimal(18,1),Peso_Bruto_MEA)	[IncludedTareGrossWeightMeasure],
--	convert(decimal(18,2),MEA.Vol_Tot_MEA)	[GrossVolumeMeasure],
--	convert(decimal(18,1),mEA.Peso_Bruto_MEA)	[GrossWeightMeasure],
--	convert(int,Qtd_Tot_Vol_MEA)			[PieceQuantity],
--	Convert(int,Qtd_Tot_Vol_MEA)			[TotalPieceQuantity],
--	convert(decimal(18,2),MEA.Vlr_Frete_MEA)	[TotalChargeAmount],
	
--	Sh.Cd_Pes	[cd_Consignor],
--	cs.Cd_Pes	[cd_Consignee],
--	AG.Cd_Pes	[cd_FreightForwarder],
		
--	--UPPER(LCO.Cd_Pais) + ' ' + UPPER(LCO.cd_local)		[OriginLocation_ID],
--	UPPER(LCO.cd_local)		[OriginLocation_ID],
--	UPPER(LCO.Nome_Local)			[OriginLocation_Name],			
--	--UPPER(LCD.Cd_Pais) + ' ' + UPPER(LCD.iatacode)				[FinalDestinationLocation_ID],
--	UPPER(LCD.iatacode)				[FinalDestinationLocation_ID],
--	UPPER(LCD.Nome_Local)			[FinalDestinationLocation_Name],
--	'Main-Carriage'											[SpecifiedLogisticsTransportMovement_StageCode],
--	'4'														[SpecifiedLogisticsTransportMovement_ModeCode],
--	'Air'													[SpecifiedLogisticsTransportMovement_Mode],	
--	--mea.Voo_MEA												[SpecifiedLogisticsTransportMovement_ID],
--	(case when len(mea.Voo_MEA) < 3 then '00' + mea.Voo_MEA else mea.Voo_MEA end) [SpecifiedLogisticsTransportMovement_ID],
--	'1'														[SpecifiedLogisticsTransportMovement_SequenceNumeric],
--	--CA.Nome_cia_aer											[UsedLogisticsTransportMeans_Name],
--	CA.Cd_Cia_Aer											[UsedLogisticsTransportMeans_Name],
	
--	LLP.ATD_Master											[ArrivalEvent_ScheduledOccurrenceDateTime],
--	'Airport'												[ArrivalEvent_TypeCode],
--	LLP.ATA_Master											[DepartureEvent_ScheduledOccurrenceDateTime],
--	'Airport'												[DepartureEvent_TypeCode],
	
--	--HN.Hand_mEA_1							[HandlingSPHInstructions],
--	[dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](MEA.Obs_MEA))		[HandlingSPHInstructions],
--	--left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[Information],	
--	[dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](MEA.Obs_MEA))[Information],
--	--HN.Hand_mEA_1,
--	--HN.Hand_MEA_2,
--	--HN.Hand_MEA_3,	
--	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[HandlingSSRInstructions],
		
--	''										[HandlingOSIInstructions],
--	'PX'									[TransportPaymentMethodCode], --não sei
	
--	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Altura_EA')) * 100,0)	[TransportLogisticsPackage_HeightMeasure],
--	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Compr_EA'))* 100,0)	 [TransportLogisticsPackage_LengthMeasure],
--	isnull(convert(decimal(18,2),[dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Largura_EA'))* 100,0)	[TransportLogisticsPackage_WidthMeasure],
--	isnull([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Qtd_Vol_EA'),0)					[TransportLogisticsPackage_ItemQuantity],
--	isnull([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Peso_Bruto_EA'),0)				[TransportLogisticsPackage_GrossWeightMeasure],
	
	
	
	
	
	
--	(case when MEA.Tp_Frete_MEA	= 'C' then 'false' else 'true' end)		[PrepaidIndicator],
	
--	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Agt_MEA) 
--				else convert(decimal(18,2),@Vlr_AgtPP_MEA) end)	[AgentTotalDuePayableAmount],
				
--	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Crr_MEA) 
--			else convert(decimal(18,2),@Vlr_CrrPP_MEA) end)	[CarrierTotalDuePayableAmount],
	
--	(case when MEA.Tp_Frete_MEA= 'P' then convert(decimal(18,2),@Vlr_AgtPP_MEA + @Vlr_CrrPP_MEA + Vlr_Frete_MEA)
--		 else convert(decimal(18,2),@Vlr_AgtPP_MEA + @Vlr_CrrPP_MEA) end)	[TotalPrepaidChargeAmount],
		 
--	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Agt_MEA + @Vlr_Crr_MEA + Vlr_Frete_MEA)
--		 else convert(decimal(18,2),@Vlr_Agt_MEA + @Vlr_Crr_MEA) end)		[TotalCollectChargeAmount],
		
--	convert(decimal(18,1),Peso_Bruto_MEA)		[ChargeableWeightMeasure],
	
--	convert(decimal(18,2),MEA.Vlr_Frete_MEA)		[WeightChargeTotalAmount],
	
--	--convert(decimal(18,2),@Vlr_Tx_Tot_MEA) [GrandTotalAmount],
	
--	(case when MEA.Tp_Frete_MEA	= 'C' then convert(decimal(18,2),@Vlr_Agt_MEA) + convert(decimal(18,2),@Vlr_Crr_MEA)+ convert(decimal(18,2),MEA.Vlr_Frete_MEA)
--				else convert(decimal(18,2),@Vlr_AgtPP_MEA) + convert(decimal(18,2),@Vlr_CrrPP_MEA) + convert(decimal(18,2),MEA.Vlr_Frete_MEA) end)	[GrandTotalAmount],
	
--	--ISNULL(Dbo.fBusca_CampoCliente (@processo, 47),'0.00')	AppliedRate,
	
--	--(case when isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') = '1' then 'Min'
--	--	else 
--	--	convert(varchar(50),convert(decimal(18,2),(convert(decimal(18,2),MEA.Vlr_Frete_MEA)/convert(decimal(18,2),LLP.Peso_Cubado))))
--	--end) 
	
--	convert(decimal(18,2),(convert(decimal(18,2),MEA.Vlr_Frete_MEA)/convert(decimal(18,2),LLP.Peso_Cubado))) AppliedRate,
	
--	(case when isnull(dbo.fBusca_CampoCliente(MEA.Num_Proc_MEA,89),'2') = '1' then 'M'
--		else 
--		'K' 
--	end) CategoryCode,
	
--	convert(decimal(18,2),MEA.Vlr_Frete_MEA)  AppliedAmount,
	
--		[dbo].[FRemoveAcentuacao](NG.Descr)					[SummaryDescription],
--	MEA.MAWB_MEA								[TransportContractDocument_ID],
	
--	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao]([dbo].[fBusca_Volumes_Soma_Campos](MEA.Num_Proc_MEA,'Descr'))),62)[House_Information]
		
--	--upper(lcd.iatacode)		cd_cia_aer,	
--	--MEA.cd_tp_moeda,
--	--dbo.fBusca_CampoCliente (@processo, 47) exchangeRate,
--	--dbo.fBusca_CampoCliente (@processo, 39) ref_accountinginfo,
--	--'0'						selling_rates,
--	--NG.Descr				NATURES_GOODS,
--	--left(MEA.MAWB_mEA,3)	COMECO,
--	--right(MEA.MAWB_mEA,8)	FIM,
--	--@Vlr_Agt_MEA			Valor_Agente,
--	--@Vlr_Crr_MEA			Valor_Carrier,
--	--@Vlr_Tx_Tot_MEA			Total_Taxa,
--	--dbo.spTaxasMasterEA(@Processo) Taxas,
--	--dbo.spHouseEA(@Processo)Houses,
--	--Obs_mea,
--	--isnull(dbo.fBusca_CampoCliente(hou.Num_Proc_hea,89),'2') FreteMinimo,
--	--ENDI.Rua				Rua_CiaAer,
--	--ENDI.Numero				Numero_CiaAer,
--	--ENDI.Compl_End			Compl_CiaAer,
--	--ENDI.Bairro				Bairro_CiaAer,
--	--ENDI.Cidade				Ciade_CiaAer,
--	--ENDI.Pais				Pais_CiaAer,	
--	--@Vlr_AgtPP_MEA Valor_AgentePP,
--	--@Vlr_CrrPP_MEA Valor_CarrierPP,	
--	--'+' + Cd_Int + ' ' + cd_area_fone + ' '+ prefixo +'-'+num_fone Telefone,
--	--MEA.dt_ImpressDraft_mea dt_draft
	
--	,ENDS.CD_pais											[ConsignorParty_CountryID],
--	ENDC.CD_pais											[ConsigneeParty_CountryID],
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
--		null END) USCI,
		
--	(case when UPPER(LCD.Cd_Pais) in ('CN','ID')THEN
--		1 ELSE
--		0 END) IncludedCustomsNote,
		
--	(case when UPPER(LCD.Cd_Pais) in ('CN','ID')THEN
--		[dbo].[fBusca_Volumes_NCM](HOU.Num_Proc_HEA) 
--	ELSE
--		null END)TypeCode
	
--from 
--	Master_Exp_Aer MEA
--	Join house_exp_Aer HOU on MEA.num_proc_mea = HOU.num_proc_mea
--	--Join llp_exp_Aer LL on HOU.Num_Proc_HEA = LL.Num_Proc_Lea
--	Left Outer Join LLP_Master LLP on MEA.num_proc_mea = LLP.Num_Proc_master
--	Left Join Pessoa AG on MEA.cd_export_mea = AG.cd_pes
--	Left Join Endereco ENDA on MEA.cd_export_mea = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
--	--Left Join Pais PSA on ENDA.UF = PSA.cd_pais
--	Left Join Cia_Aerea CA on MEA.cd_cia_aer = CA.cd_cia_aer
--	Left Join Pessoa NF on NF.cd_pes=cd_export_mea
--	Left Join Pessoa CS on CS.cd_pes=cd_consig_mea
--	Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
--	Left Join Endereco ENDI on CS.cd_pes=ENDI.cd_pes and ENDC.cd_tp_end = 'INT'
--	--Left Join Pais PSC on ENDC.UF = PSC.cd_pais 
--	Left Join Pessoa Sh on SH.cd_pes=cd_export_mea
--	Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDS.cd_tp_end = 'COM'
--	--Left Join Pais PSS on ENDS.UF = PSS.cd_pais 
--	Join Tipo_Moeda TM on TM.cd_tp_moeda=mea.cd_tp_moeda
--	Left Join nature_goods NG on MEA.num_proc_mea =NG.Num_Proc	
--	Left Join Handling_MEA HN on MEA.num_proc_mea = HN.Num_proc_mea 
--	--Left Join PESSOA DSP on cd_dsp_hea=DSP.cd_pes
--	Left Join Localidade LCO on MEA.cd_org_mea = LCO.cd_local
--	Left Join Localidade LCD on MEA.cd_dst_mea = LCD.cd_local
--	Left Join Comunicacao CM on CM.cd_pes=cs.cd_pes and cd_Tp_com='HBL'
	
--	left join Usuario US on US.cd_usuario = MEA.cd_User_Impres_mea
	
--	--left join Volume_Exp_Aer V on V.Num_Proc_HEA = HOU.Num_Proc_HEA
	
--	left join Campo_Pessoa CP18 on CP18.Cd_Pes = CS.Cd_Pes and CP18.Id_Campo = '18'
--	left join Campo_Processo CP178 on CP178.Num_Proc = MEA.num_proc_mea and CP178.Id_Campo = '178'
--	left join Armador Arm on Arm.Cd_Armador = CP178.Campo_Dados
--Where
--	MEA.Num_Proc_mea=@Processo





GO
