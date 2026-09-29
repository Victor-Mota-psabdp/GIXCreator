SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_GIX_XMLto_JOB_GIX_Header_Status_Pibernat_Json_SEL]
(
	@ID_Req as BigInt,
	@Ref_Type VARCHAR(100)
)
as


--2.1.1 - Header/References/ActualPortofEntryDate (Regra: Vazio) - JOB>Task>Presença de Carga
--189	Presença de Carga	EM
--SELECT * FROM atl_int.dbo.GIX_HEADER_STATUS WHERE ID_Req = '2380402'

Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)		[JOB],	
	CONVERT(DATETIME,StatusDate,103)			[Data],
	'Presença de Carga'							[Nome_Task],
	'ATL System'								[Usuario],
	llp.Cd_Pes_Grupo							[Grupo],
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type --'BDPJobNumber' 
	join vwHouse_Exp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status DATA on DATA.ID_Req = Request.ID_Req 
		and DATA.StatusType = 'ActualPortofEntryDate'
	left join Tarefas_Processos TP on TP.Num_Proc = ImportForwarderRefNbr.Ref_Number AND TP.ID_Task = 189
	
	LEFT JOIN pessoa_llp llp with (nolock) on llp.Cd_Pes = V.Cd_Export

Where
	Request.ID_Req = @ID_Req
	--and SystemCode = '4'
	and TP.Dt_Conclusao is null
	and isnull(v.ID_Status,0) not in ('9','5')
	and StatusDate <> 'NULL'
	and ISDATE(StatusDate)= 1

union all 
--2.1.2 -  Header/References/CustomsReleaseDate - JOB>Task>Desembaraço
--4	Desembaraço	EM
--SELECT * FROM atl_int.dbo.GIX_HEADER_STATUS WHERE ID_Req = '2380402'
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)		[JOB],	
	CONVERT(DATETIME,StatusDate,103)			[Data],
	'Desembaraço'								[Nome_Task],
	'ATL System'								[Usuario],
	llp.Cd_Pes_Grupo							[Grupo],
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type --'BDPJobNumber' 
	join vwHouse_Exp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status DATA on DATA.ID_Req = Request.ID_Req 
		and DATA.StatusType = 'CustomsReleaseDate'
	left join Tarefas_Processos TP on TP.Num_Proc = ImportForwarderRefNbr.Ref_Number AND TP.ID_Task = 4	
	LEFT JOIN pessoa_llp llp with (nolock) on llp.Cd_Pes = V.Cd_Export

Where
	Request.ID_Req = @ID_Req
	--and SystemCode = '4'
	and TP.Dt_Conclusao is null
	and isnull(v.ID_Status,0) not in ('9','5')
	and StatusDate <> 'NULL'
	and ISDATE(StatusDate)= 1
GO
