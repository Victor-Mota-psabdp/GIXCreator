SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_HouseManifest_Trigger_Rel]--'IAAPB202102001BR',''
(		
	@Num_Proc 	VarChar(16)
)	
AS

select 
	hou.Num_Proc,
	MessageHeaderDocument_ID,
	MessageHeaderDocument_Name,
	MessageHeaderDocument_TypeCode,
	MessageHeaderDocument_IssueDateTime,
	MessageHeaderDocument_PurposeCode,
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



GO
