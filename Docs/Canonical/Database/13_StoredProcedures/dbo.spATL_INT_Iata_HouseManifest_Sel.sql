SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_HouseManifest_Sel]'IAMTE202102001BR',''
--[spATL_INT_Iata_HouseManifest_Sel] 'IAMTE202102001BR',''
--spHIA_HouseWaybill_Rel 'IAAPB202102001BR'
CREATE Procedure [dbo].[spATL_INT_Iata_HouseManifest_Sel]--'IAAPB202102001BR',''
(		
	@Num_Proc 	VarChar(16),
	@Tipo		char(1)
)	
AS

IF	not exists(select Num_Proc from ATL_INT.dbo.Iata_HouseManifest where Num_Proc = @Num_Proc)
	BEGIN
		select 
			hou.Num_Proc_HIA [Num_Proc],
		-- string strJunta = i["BusinessHeaderDocument_ID"].ToString() + "_" + i["TransportContractDocument_ID"].ToString();
		-- MessageHeaderDocument(writer, "785", "House Manifest", "2.00", i["Iata_Code"].ToString(), strJunta);
			HAWB_HIA + '_' + HOU.MAWB_HIA			[MessageHeaderDocument_ID],
			'House Manifest'						[MessageHeaderDocument_Name],
			'785'									[MessageHeaderDocument_TypeCode],
			''										[MessageHeaderDocument_IssueDateTime],
			'Creation'								[MessageHeaderDocument_PurposeCode],
			'2.00'									[MessageHeaderDocument_VersionID],

			'C'										[MessageHeaderDocument_SenderParty_schemeID_0],
			'RUSAGT82BDPI/ATL01'					[MessageHeaderDocument_SenderParty_Value_0],

			'O'										[MessageHeaderDocument_SenderParty_schemeID_1],
			'01'									[MessageHeaderDocument_SenderParty_Value_1],

			'C'										[MessageHeaderDocument_RecipientParty_schemeID],
			'DSGUNXA'								[MessageHeaderDocument_RecipientParty_Value],
		--BusinessHeaderDocument(writer, "703", "HouseWaybill", strHouseJOB);
			HAWB_HIA									[BusinessHeaderDocument_ID],
		-- MasterConsignment
			'KGM'										[MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode],
			Convert(decimal(18,1),Peso_Bruto_HIA)		[MasterConsignment_IncludedTareGrossWeightMeasure_Value],
			Convert(int,Qtd_Tot_Vol_HIA)				[MasterConsignment_TotalPieceQuantity],		
			HOU.MAWB_HIA								[MasterConsignment_TransportContractDocument_ID],
			UPPER(LCO.IATACODE)							[MasterConsignment_OriginLocation_ID],
			UPPER(LCO.Nome_Local)						[MasterConsignment_OriginLocation_Name],			
			UPPER(LCD.IATACODE)							[MasterConsignment_FinalDestinationLocation_ID],
			UPPER(LCD.Nome_Local)						[MasterConsignment_FinalDestinationLocation_Name],
			'1'											[IncludedHouseConsignment_SequenceNumeric],
			left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[SummaryDescription],
			[dbo].[FRemoveAcentuacao](HN.Hand_HIA_1)				[HandlingSPHInstructions]
			
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

			Join Pessoa CS with(nolock) on CS.cd_pes=cd_consig_HIA
			Left Join Pessoa_llp	PLLP with(nolock)		on HOU.cd_consig_HIA	= PLLP.Cd_Pes
			Left Join Pessoa		PG with(nolock)			on PG.Cd_Pes			= PLLP.Cd_Pes_grupo
	
		Where
			hou.Num_Proc_HIA=@Num_Proc
	END
ELSE
	BEGIN
		select 
			hou.Num_Proc,
			MessageHeaderDocument_ID,
			MessageHeaderDocument_Name,
			MessageHeaderDocument_TypeCode,
			MessageHeaderDocument_IssueDateTime,		
			HOU.MessageHeaderDocument_PurposeCode,--Creation, Update e Deletion
			MessageHeaderDocument_VersionID,
			MessageHeaderDocument_SenderParty_schemeID_0,
			MessageHeaderDocument_SenderParty_Value_0,
			MessageHeaderDocument_SenderParty_schemeID_1,
			MessageHeaderDocument_SenderParty_Value_1,
			MessageHeaderDocument_RecipientParty_schemeID,
			MessageHeaderDocument_RecipientParty_Value,
			BusinessHeaderDocument_ID,
			MasterConsignment_IncludedTareGrossWeightMeasure_UnitCode,
			MasterConsignment_IncludedTareGrossWeightMeasure_Value,
			MasterConsignment_TotalPieceQuantity,
			MasterConsignment_TransportContractDocument_ID,
			MasterConsignment_OriginLocation_ID,
			MasterConsignment_OriginLocation_Name,
			MasterConsignment_FinalDestinationLocation_ID,
			MasterConsignment_FinalDestinationLocation_Name,
			IncludedHouseConsignment_SequenceNumeric,
			SummaryDescription,
			HandlingSPHInstructions
			
			,HOU.Cd_Pes_grupo 		[Group Code],
			PG.Apelido				[Group Name],
			HOU.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name],
			HOU.Notes				[Notes]
		from 
			ATL_INT.dbo.Iata_HouseManifest HOU with(nolock)	
			Left Join Pessoa		PG with(nolock)	on PG.Cd_Pes= HOU.Cd_Pes_grupo
			Left Join Usuario		US with(nolock)	on US.Cd_Usuario= HOU.Cd_Usuario			
		Where
			hou.Num_Proc=@Num_Proc

	END

GO
