SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_GIX_XMLto_JOB_GIX_Header_Campo_Processo_SEL]--16741
(	
	@ID_Req as BigInt,
	@Ref_Type VARCHAR(100)
)
as

--Paridade

Select 	distinct
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Paridade D.I.'								[Descr_Campo],	
	replace(convert(varchar(25),convert(float,ExchangeRateAmt.AmountValue)),'.',',')	[Campo_Dados],
	'ATL'										[cd_usuario],
	'ATL System'								[Usuario],
	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type-- 'ImportForwarderRefNbr'
	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Amount ExchangeRateAmt on ExchangeRateAmt.ID_Req = Request.ID_Req 
		and ExchangeRateAmt.AmountType  = 'ExchangeRateAmt'	
	join ATL_INT.dbo.GIX_Header_Status DTREGISTRO on DTREGISTRO.ID_Req = Request.ID_Req and DTREGISTRO.StatusDescription = 'DTREGISTRO'	
Where
	Request.ID_Req = @ID_Req and 
	--SystemCode = '1' and
	DTREGISTRO.StatusDate is not null

--Select 	distinct
--	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
--	'Paridade D.I.'								[Descr_Campo],	
--	replace(convert(varchar(25),convert(float,ExchangeRateAmt.AmountValue)),'.',',')	[Campo_Dados],
--	'ATL'										[cd_usuario],
--	'ATL System'								[Usuario],
	
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
--	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	join ATL_INT.dbo.GIX_Header_Amount ExchangeRateAmt on ExchangeRateAmt.ID_Req = Request.ID_Req 
--		and ExchangeRateAmt.AmountType  = 'ExchangeRateAmt'	
--	left join Campo_processo C31 on C31.Num_Proc = V.Num_Proc and C31.Id_Campo = 31
--Where
--	Request.ID_Req = @ID_Req and 
--	SystemCode = '1'
--	and C31.Campo_Dados is null


UNION ALL	
--Termo de Pagamento
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	'Termo de Pagamento'						[Descr_Campo],	
	convert(varchar(25),TM.Cd_Termo)			[Campo_Dados],
	'ATL'										[cd_usuario],
	'ATL System'								[Usuario],	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type =@Ref_Type -- 'ImportForwarderRefNbr'
	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left join Campo_Processo CP on CP.Num_Proc = V.Num_Proc and Id_Campo = 87
	join ATL_INT.dbo.GIX_Header_Commercial_Invoice TP on TP.ID_Req = Request.ID_Req
	join Termo_Pagamento TM on TM.Cd_Termo = TP.TermsofPaymentCode
Where
	Request.ID_Req =@ID_Req
	--and SystemCode = '1'
	and cp.Campo_Dados is null
	and ISNUMERIC(TP.TermsofPaymentCode) = 1
	
--select * from ATL_INT.dbo.GIX_Header_Commercial_Invoice
--select * from ATL_INT.dbo.GIX_Request_Header
--select * from Tipo_Campo_Cliente where Descr_Campo like 'termo%'

--select * from Termo_Pagamento
--select TermsofPaymentCode,* from ATL_INT.dbo.GIX_Header_Commercial_Invoice where ID_Req  =2
--select * from ATL_INT.dbo.XML_Oxiteno where ID = 2

--select TermsofPaymentCode,* from ATL_INT.dbo.GIX_Header_Commercial_Invoice 
--select * from Tipo_Campo_Cliente where Descr_Campo = 'Paridade D.I.'


--select * from ATL_INT.dbo.GIX_Request_Header Request
--join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req
--where Num_Proc = 'IMOXT201807005BR'

--Select 	distinct
--	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
--	'Paridade D.I.'								[Descr_Campo],	
--	replace(convert(varchar(25),convert(float,ExchangeRateAmt.AmountValue)),'.',',')	[Campo_Dados],
--	'ATL'										[cd_usuario],
--	'ATL System'								[Usuario],
	
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
--	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	join ATL_INT.dbo.GIX_Header_Amount ExchangeRateAmt on ExchangeRateAmt.ID_Req = Request.ID_Req 
--		and ExchangeRateAmt.AmountType  = 'ExchangeRateAmt'	
--	join ATL_INT.dbo.GIX_Header_Status DTREGISTRO on DTREGISTRO.ID_Req = Request.ID_Req and DTREGISTRO.StatusDescription = 'DTREGISTRO'	
--Where
--	Request.ID_Req = @ID_Req and 
--	SystemCode = '1' and
--	DTREGISTRO.StatusDate is not null


GO
