SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spEMIX_ZIP_Teste_Sel]
	
AS
	
	select Num_Proc, valor,I.ID,I.ID_Item, Campo from Emix_Retorno E  with(nolock)
		join Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where E.Tipo_Consulta = 18 and Campo = 'ZIP-RE' and I.Dt_SendToPDF2ATL is null 
		
	union all
	
	select Num_Proc, valor,I.ID,I.ID_Item, Campo from Emix_Retorno E  with(nolock)
		join Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where E.Tipo_Consulta = 20 and Campo = 'ZIP-DE' and I.Dt_SendToPDF2ATL is null 
	order by Num_Proc,ID_Item
	
	




















GO
