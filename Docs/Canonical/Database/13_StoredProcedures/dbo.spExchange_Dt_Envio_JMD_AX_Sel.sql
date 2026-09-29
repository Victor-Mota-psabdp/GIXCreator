SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spExchange_Dt_Envio_JMD_AX_Sel]
AS

	SET NOCOUNT ON;
	
	select distinct  excprocesso Job,min(O.ExcDataAlt) Data, 'U' strInstrucao from dbo.Exchange O with(nolock) 
	Join vwcliente C with(nolock) on C.num_proc COLLATE DATABASE_DEFAULT =O.excprocesso COLLATE DATABASE_DEFAULT
	Join AX_Master_XML AX with(nolock) on AX.num_proc=O.ExcProcesso
	where 
		O.Dt_Envio_JMD_AX is null 
		and len(O.excprocesso)=16 	
		and O.ExcDataAlt > '2020-01-01'
		--and ExcProcesso = 'IAHNK202604001BR'
	group by  
		O.excprocesso 
	order by 2


--select  * from Exchange O where ExcProcesso = 'EMSAM202602011BR' --and O.Dt_Envio_JMD_AX is null 
--select  * from Exchange_JMD_AX_ATL where Num_Proc = 'EMSAM202602011BR' --and O.Dt_Envio_JMD_AX is null 
--select  * from AX_Master_XML where num_proc = 'EMSAM202602011BR'

-- SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
--where routine_definition like '%Exchange%'

GO
