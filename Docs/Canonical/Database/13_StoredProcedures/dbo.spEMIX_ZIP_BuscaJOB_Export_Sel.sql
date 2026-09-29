SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 21-8 - alterei p hea - re
CREATE procedure [dbo].[spEMIX_ZIP_BuscaJOB_Export_Sel]--'170020628001','DE'
	@RE_DE as varchar(12),
	@tipo as varchar(2)
AS

--4	RE Number
--12	DDE
	
	--select distinct HEM.Num_Proc_HEM [Num_Proc],'004' ID_DC,I.ID,I.ID_Item , Campo from PO_HEM HEM 
	select distinct HEM.Num_Proc [Num_Proc],'004' ID_DC,I.ID,I.ID_Item , Campo from E_Mix_Consulta HEM with(nolock)
		join ATL_INT.dbo.Emix_Retorno_Export E with(nolock) on E.Num_Proc = HEM.Num_Proc and E.ID_Envio = HEM.id
		join ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
	where
		(
		replace(replace(HEM.valor,'-',''),'/','') =@RE_DE		
		)
		--and HEM.ID_DC =4
		and E.Tipo_Consulta = 18
		and Campo = 'ZIP-RE'
		and Dt_SendToPDF2ATL is null
		
	union all
	
	select distinct HEM.Num_Proc [Num_Proc],'012' ID_DC,I.ID,I.ID_Item , Campo from E_Mix_Consulta HEM with(nolock)
		join ATL_INT.dbo.Emix_Retorno_Export E with(nolock) on E.Num_Proc = HEM.Num_Proc and E.ID_Envio = HEM.id
		join ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
	where
		(
		replace(replace(HEM.valor,'-',''),'/','') =@RE_DE		
		)
		and E.Tipo_Consulta = 20
		and Campo = 'ZIP-DE'
		and Dt_SendToPDF2ATL is null
option(hash join)	
		
	--union all
	
	--	select HEA.Num_Proc_HEA  [Num_Proc],'004' ID_DC,I.ID,I.ID_Item, Campo from PO_HEA HEA with(nolock)
	--	join E_Mix_Consulta C with(nolock) on C.num_proc = HEA.Num_Proc_HEA and replace(replace(C.valor,'-',''),'/','') = replace(replace(HEA.Numero_PO_HEA,'-',''),'/','')	
	--	join Emix_Retorno_Export E with(nolock) on E.Num_Proc = HEA.Num_Proc_HEA  and E.ID_Envio = C.ID
	--	join Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
	--where
	--	(
	--		replace(replace(HEA.Numero_PO_HEA,'-',''),'/','') = @RE_DE		
	--	)
	--	and HEA.ID_DC =4
	--	and E.Tipo_Consulta = 18
	--	and Campo = 'ZIP-RE'
	--	and Dt_SendToPDF2ATL is null
		
	--UNION ALL
	
	--select HEO.Num_Proc_HEO [Num_Proc],'004' ID_DC,I.ID,I.ID_Item , Campo from PO_HEO HEO with(nolock)	
	--	join Emix_Retorno_Export E with(nolock) on E.Num_Proc = HEO.Num_Proc_HEO
	--	join Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
	--where
	--	(
	--	replace(replace(HEO.Numero_PO_HEO,'-',''),'/','') = @RE_DE		
	--	)
	--	and HEO.ID_DC =4
	--	and E.Tipo_Consulta = 18
	--	and Campo = 'ZIP-RE'
	--	and Dt_SendToPDF2ATL is null
	
	--UNION ALL

	--select distinct HEM.Num_Proc_HEM [Num_Proc],'012' ID_DC,I.ID,I.ID_Item , Campo from PO_HEM HEM with(nolock)
	--	join Emix_Retorno_Export E with(nolock) on E.Num_Proc = HEM.Num_Proc_HEM
	--	join Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
	--where
	--	(
	--	replace(replace(HEM.Numero_PO_HEM,'-',''),'/','') = @RE_DE		
	--	)
	--	and HEM.ID_DC =12
	--	and E.Tipo_Consulta = 20
	--	and Campo = 'ZIP-DE'
		
	--union all
	
	--	select HEA.Num_Proc_HEA  [Num_Proc],'012' ID_DC,I.ID,I.ID_Item, Campo from PO_HEA HEA with(nolock)
	--	join Emix_Retorno_Export E with(nolock) on E.Num_Proc = HEA.Num_Proc_HEA
	--	join Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
	--where
	--	(
	--	replace(replace(HEA.Numero_PO_HEA,'-',''),'/','') = @RE_DE		
	--	)
	--	and HEA.ID_DC =12
	--	and E.Tipo_Consulta = 20
	--	and Campo = 'ZIP-DE'
		
	--UNION ALL
	
	--select HEO.Num_Proc_HEO [Num_Proc],'012' ID_DC,I.ID,I.ID_Item , Campo from PO_HEO HEO with(nolock)
	--	join Emix_Retorno_Export E with(nolock) on E.Num_Proc = HEO.Num_Proc_HEO
	--	join Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
	--where
	--	(
	--	replace(replace(HEO.Numero_PO_HEO,'-',''),'/','') = @RE_DE		
	--	)
	--	and HEO.ID_DC =12
	--	and E.Tipo_Consulta = 20
	--	and Campo = 'ZIP-DE'

GO
