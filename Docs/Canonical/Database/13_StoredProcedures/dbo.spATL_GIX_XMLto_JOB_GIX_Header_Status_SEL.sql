SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 17/02/2023 13:32hs
CREATE procedure [dbo].[spATL_GIX_XMLto_JOB_GIX_Header_Status_SEL]
(
	@ID_Req as BigInt,
	@Ref_Type VARCHAR(100)
)
as


Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],	
	(case when 
		(DTCI.StatusDate	 = '' OR DTCI.StatusDate	 IS NULL) then ''
		else  
		RIGHT(DTCI.StatusDate	,4)+'-'+ left(DTCI.StatusDate	,2) + '-'
			+ substring(DTCI.StatusDate	,3,2) end) [Data],
	'Desembaraço'						[Nome_Task],
	'ATL System'						[Usuario],
	llp.Cd_Pes_Grupo					[Grupo],
	--'P21128'							[Grupo],	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwClienteALLJOBS V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status DTCI on DTCI.ID_Req = Request.ID_Req and DTCI.StatusDescription = 'DTCI'	
	left join Tarefas_Processos TP4 on TP4.Num_Proc = 	ImportForwarderRefNbr.Ref_Number AND TP4.ID_Task = 4
	
	LEFT JOIN pessoa_llp llp with (nolock) on llp.Cd_Pes = V.cd_cliente
Where
	Request.ID_Req = @ID_Req
	--and SystemCode = @SystemCode
	and TP4.Dt_Conclusao is null
	and isnull(v.ID_Status,0) not in ('9','5')	

--union all
----retirado por solicitação da camila 100-128134
--Select 	
--	ImportForwarderRefNbr.Ref_Number			[JOB],	
--	(case when 
--		(DTPAGAMENTO_DE_ICMS.StatusDate	 = '' OR DTPAGAMENTO_DE_ICMS.StatusDate IS NULL) then ''
--		else  
--		RIGHT(DTPAGAMENTO_DE_ICMS.StatusDate,4)+'-'+ left(DTPAGAMENTO_DE_ICMS.StatusDate,2) + '-'
--			+ substring(DTPAGAMENTO_DE_ICMS.StatusDate,3,2) end) [Data],
--	'Pagamento de ICMS'									[Nome_Task],
--	'ATL System'										[Usuario],
--	'P21128'											[Grupo],
	
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
--	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	join ATL_INT.dbo.GIX_Header_Status DTPAGAMENTO_DE_ICMS on DTPAGAMENTO_DE_ICMS.ID_Req = Request.ID_Req 
--		and DTPAGAMENTO_DE_ICMS.StatusDescription = 'DTPAGAMENTO DE ICMS'
--	left join Tarefas_Processos TP24 on TP24.Num_Proc = ImportForwarderRefNbr.Ref_Number AND TP24.ID_Task = 24

--Where
--	Request.ID_Req = @ID_Req
--	and SystemCode = '1'
--	and TP24.Dt_Conclusao is null
--	and isnull(v.ID_Status,0) not in ('9','5')	

union all

Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],	
	(case when 
		(DTPAGAMENTO_AFRMM.StatusDate	 = '' OR DTPAGAMENTO_AFRMM.StatusDate IS NULL) then ''
		else  
		RIGHT(DTPAGAMENTO_AFRMM.StatusDate,4)+'-'+ left(DTPAGAMENTO_AFRMM.StatusDate,2) + '-'
			+ substring(DTPAGAMENTO_AFRMM.StatusDate,3,2) end) [Data],
	'Pagamento AFRMM'									[Nome_Task],
	'ATL System'										[Usuario],
	llp.Cd_Pes_Grupo									[Grupo],
	--'P21128'											[Grupo],
	
	Request.ID_Req		

from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type
	join vwClienteALLJOBS V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status DTPAGAMENTO_AFRMM on DTPAGAMENTO_AFRMM.ID_Req = Request.ID_Req 
		and DTPAGAMENTO_AFRMM.StatusDescription = 'DTPAGAMENTO_AFRMM'
	left join Tarefas_Processos TP25 on TP25.Num_Proc = ImportForwarderRefNbr.Ref_Number AND TP25.ID_Task = 25
	
	LEFT JOIN pessoa_llp llp with (nolock) on llp.Cd_Pes = V.cd_cliente

Where
	Request.ID_Req = @ID_Req
	--and SystemCode = @SystemCode
	and TP25.Dt_Conclusao is null
	and isnull(v.ID_Status,0) not in ('9','5')


	
--union all

--Select 	
--	ImportForwarderRefNbr.Ref_Number			[JOB],	
--	(case when 
--		(DTREGISTRO.StatusDate	 = '' OR DTREGISTRO.StatusDate IS NULL) then ''
--		else  
--		RIGHT(DTREGISTRO.StatusDate,4)+'-'+ left(DTREGISTRO.StatusDate,2) + '-'
--			+ substring(DTREGISTRO.StatusDate,3,2) end)[Data],
--	'DTREGISTRO'									[Nome_Task],
	
--	Request.ID_Req	
--from GIX_Request Request
--	join GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
--	join ATL_QA_1006.dbo.vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	join GIX_Header_Status DTREGISTRO on DTREGISTRO.ID_Req = Request.ID_Req and DTREGISTRO.StatusDescription = 'DTREGISTRO'

--Where
--	Request.ID_Req = @ID_Req
--and SystemCode = '1'

--union all

--Select 	
--	ImportForwarderRefNbr.Ref_Number			[JOB],	
--	(case when 
--		(DTEMBARQUE.StatusDate	 = '' OR DTEMBARQUE.StatusDate IS NULL) then ''
--		else  
--		RIGHT(DTEMBARQUE.StatusDate,4)+'-'+ left(DTEMBARQUE.StatusDate,2) + '-'
--			+ substring(DTEMBARQUE.StatusDate,3,2) end) [Data],
--	'DTEMBARQUE'						[Nome_Task],
	
--	Request.ID_Req
--from GIX_Request Request
--	join GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type = @Ref_Type
--	join ATL_QA_1006.dbo.vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	join GIX_Header_Status DTEMBARQUE on DTEMBARQUE.ID_Req = Request.ID_Req and DTEMBARQUE.StatusDescription = 'DTEMBARQUE'

--Where
--	Request.ID_Req = @ID_Req
--and SystemCode = '1'


union all 
--2.1.1 - when type="DataEntradaRecinto" then ActualPortofEntryDate - JOB>Task>Presença de Carga
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
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type
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

--2.1.2 - when type="DataDesembaraco" then CustomsReleaseDate - JOB>Task>Desembaraço
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
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type
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


union all 

----2.1.3 - when type="DataAverbacaoDE" then CustomsEntryPermitReleaseDate - JOB>Task>Averbação
--15 Averbação	EM
--SELECT * FROM atl_int.dbo.GIX_HEADER_STATUS WHERE ID_Req = '2380402'
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)		[JOB],	
	CONVERT(DATETIME,StatusDate,103)			[Data],
	'Averbação'									[Nome_Task],
	'ATL System'								[Usuario],
	llp.Cd_Pes_Grupo							[Grupo],
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type
	join vwHouse_Exp V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status DATA on DATA.ID_Req = Request.ID_Req 
		and DATA.StatusType = 'CustomsEntryPermitReleaseDate'
	left join Tarefas_Processos TP on TP.Num_Proc = ImportForwarderRefNbr.Ref_Number AND TP.ID_Task = 15	
	LEFT JOIN pessoa_llp llp with (nolock) on llp.Cd_Pes = V.Cd_Export

Where
	Request.ID_Req = @ID_Req
	--and SystemCode = '4'
	and TP.Dt_Conclusao is null
	and isnull(v.ID_Status,0) not in ('9','5')
	and StatusDate <> 'NULL'
	and ISDATE(StatusDate)= 1

GO
