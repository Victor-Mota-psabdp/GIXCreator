SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_HouseManifest_Sel]'IAMTE202102001BR',''
--spHIA_HouseWaybill_Rel 'IAAPB202102001BR'
CREATE Procedure [dbo].[spATL_HouseManifest_Sel]--'IAAPB202102001BR',''
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

select 
-- string strJunta = i["BusinessHeaderDocument_ID"].ToString() + "_" + i["TransportContractDocument_ID"].ToString();
-- MessageHeaderDocument(writer, "785", "House Manifest", "2.00", i["Iata_Code"].ToString(), strJunta);
	HAWB_HIA + '_' + HOU.MAWB_HIA			[MessageHeaderDocument_ID],
	'House Manifest'						[MessageHeaderDocument_Name],
	'785'									[MessageHeaderDocument_TypeCode],
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
	UPPER(LCO.cd_local)							[MasterConsignment_OriginLocation_ID],
	UPPER(LCO.Nome_Local)						[MasterConsignment_OriginLocation_Name],			
	UPPER(LCD.cd_local)							[MasterConsignment_FinalDestinationLocation_ID],
	UPPER(LCD.Nome_Local)						[MasterConsignment_FinalDestinationLocation_Name],
	'1'											[IncludedHouseConsignment_SequenceNumeric],
	left([dbo].[FRemoveCaracteresEspeciais_EFreight]([dbo].[FRemoveAcentuacao](NG.Descr)),62)[SummaryDescription],
	[dbo].[FRemoveAcentuacao](HN.Hand_HIA_1)				[HandlingSPHInstructions]	
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
	
Where
	hou.Num_Proc_HIA=@Num_Proc

GO
