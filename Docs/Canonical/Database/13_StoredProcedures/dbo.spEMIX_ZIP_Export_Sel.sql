SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spEMIX_ZIP_Export_Sel 'RE'  - 355
--spEMIX_ZIP_Export_Sel 'DE' - 0

CREATE procedure [dbo].[spEMIX_ZIP_Export_Sel]--'RE'
	@Tipo varchar(10)
	
AS
	
	if @Tipo = 'RE'
		BEGIN
			select Num_Proc, valor,I.ID,I.ID_Item, Campo from ATL_INT.dbo.Emix_Retorno_Export E  with(nolock)
				join ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
			where E.Tipo_Consulta = 18 and Campo = 'ZIP-RE' and I.Dt_SendToPDF2ATL is  null 
				and insert_dt > GETDATE() -30
			order by Num_Proc,ID_Item,insert_dt
			option(hash join)
		END
	ELSE
		BEGIN
			select Num_Proc, valor,I.ID,I.ID_Item, Campo from ATL_INT.dbo.Emix_Retorno_Export E  with(nolock)
				join ATL_INT.dbo.Emix_Retorno_Export_Item I with(nolock) on I.ID = E.ID 
			where E.Tipo_Consulta = 20 and Campo = 'ZIP-DE' and I.Dt_SendToPDF2ATL is null
			and insert_dt > GETDATE() -30
			order by Num_Proc,ID_Item
			option(hash join)
		END 
	
	
	




















GO
