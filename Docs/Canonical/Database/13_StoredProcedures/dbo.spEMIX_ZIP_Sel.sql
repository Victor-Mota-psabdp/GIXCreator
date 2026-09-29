SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--30-05-2018 - alterado para o ATL_INT
CREATE procedure [dbo].[spEMIX_ZIP_Sel]
	
AS
	
	--select Num_Proc, valor,I.ID,I.ID_Item, Campo from ATL_INT.dbo.Emix_Retorno E  with(nolock)
	--	join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	--where E.Tipo_Consulta = 9 and Campo = 'ZIP-CI' and I.Dt_SendToPDF2ATL is null 
	--and insert_dt > GETDATE() -90
	
	--union all
	
	--select Num_Proc, valor,I.ID,I.ID_Item ,Campo from ATL_INT.dbo.Emix_Retorno E with(nolock) 
	--	join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	--where E.Tipo_Consulta = 8 and Campo = 'ZIP-DI' and I.Dt_SendToPDF2ATL is null 
	----and Num_Proc = 'IMCSR201504594BR'
	--and insert_dt > GETDATE() -2
	
	--union all
	
	select Num_Proc, valor,I.ID,I.ID_Item, Campo from ATL_INT.dbo.Emix_Retorno E  with(nolock)
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where E.Tipo_Consulta = 12 and Campo = 'ZIP-LI' and I.Dt_SendToPDF2ATL is null 
	and insert_dt > GETDATE() -2
	and Num_Proc = 'IACTV202103002BR'
	ORDER BY I.ID,I.ID_Item
	
OPTION(HASH JOIN)
	




















GO
