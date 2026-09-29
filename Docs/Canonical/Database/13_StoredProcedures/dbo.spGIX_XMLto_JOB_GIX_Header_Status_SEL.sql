SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGIX_XMLto_JOB_GIX_Header_Status_SEL]--40
	@ID_Req as BigInt,
	@ImportForwarderRefNbr Varchar(30)
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
	'P21128'									[Grupo],
	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status DTCI on DTCI.ID_Req = Request.ID_Req and DTCI.StatusDescription = 'DTCI'	
	left join Tarefas_Processos TP4 on TP4.Num_Proc = 	ImportForwarderRefNbr.Ref_Number AND TP4.ID_Task = 4
Where
	Request.ID_Req = @ID_Req
	and SystemCode = '1'
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
	'P21128'											[Grupo],
	
	Request.ID_Req		

from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Status DTPAGAMENTO_AFRMM on DTPAGAMENTO_AFRMM.ID_Req = Request.ID_Req 
		and DTPAGAMENTO_AFRMM.StatusDescription = 'DTPAGAMENTO_AFRMM'
	left join Tarefas_Processos TP25 on TP25.Num_Proc = 	ImportForwarderRefNbr.Ref_Number AND TP25.ID_Task = 25

Where
	Request.ID_Req = @ID_Req
	and SystemCode = '1'
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
--		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
--	join ATL_QA_1006.dbo.vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	join GIX_Header_Status DTEMBARQUE on DTEMBARQUE.ID_Req = Request.ID_Req and DTEMBARQUE.StatusDescription = 'DTEMBARQUE'

--Where
--	Request.ID_Req = @ID_Req
--and SystemCode = '1'


GO
