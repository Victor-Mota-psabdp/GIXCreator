SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spEMIX_ZIP_Export_Teste_Sel]--'RE'
	@Tipo varchar(10)
	
AS
	
	if @Tipo = 'RE'
		BEGIN
			select Num_Proc, valor,I.ID,I.ID_Item, Campo from Emix_Retorno_Export E  with(nolock)
				join Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
			where 
				E.Tipo_Consulta = 18 
				and Campo = 'ZIP-RE' 
				--and I.Dt_SendToPDF2ATL is  null 
				and I.ID in(855610)
				--in(473737,473738,473739,473735,473736)
			order by Num_Proc,ID_Item,insert_dt
		END
	ELSE
		BEGIN
			select Num_Proc, valor,I.ID,I.ID_Item, Campo from Emix_Retorno_Export E  with(nolock)
				join Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
			where E.Tipo_Consulta = 20 and Campo = 'ZIP-DE' and I.Dt_SendToPDF2ATL is null
			order by Num_Proc,ID_Item
		END 
	
	
	




















GO
