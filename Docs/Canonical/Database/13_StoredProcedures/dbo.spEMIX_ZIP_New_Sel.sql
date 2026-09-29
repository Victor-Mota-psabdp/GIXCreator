SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spEMIX_ZIP_New_Sel]
	
AS
	
	select Num_Proc, valor,I.ID,I.ID_Item, Campo, '006' Id_Dc from ATL_INT.dbo.Emix_Retorno E  with(nolock)
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where E.Tipo_Consulta = 9 and Campo = 'ZIP-CI' and I.Dt_SendToPDF2ATL is null 
	and insert_dt > GETDATE() -2
	
	union all
	
	select Num_Proc, valor,I.ID,I.ID_Item ,Campo,'005' Id_Dc from ATL_INT.dbo.Emix_Retorno E with(nolock) 
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where E.Tipo_Consulta = 8 and Campo = 'ZIP-DI' and I.Dt_SendToPDF2ATL is null
	and insert_dt > GETDATE() -2
	
	union all

	--90 = 
	--select Num_Proc, valor,I.ID,I.ID_Item, Campo from ATL_INT.dbo.Emix_Retorno E  with(nolock)
	--	join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	--where E.Tipo_Consulta = 12 and Campo = 'ZIP-LI' and I.Dt_SendToPDF2ATL is null 
	--and insert_dt > GETDATE() -90
	--

	select SOL.Num_Solicitacao [Num_Proc],valor,I.ID,I.ID_Item , Campo,'023' ID_DC from Solicitacao_LI SOL  with(nolock)	
		join ATL_INT.dbo.Emix_Retorno E with(nolock) on E.Num_Proc = SOL.num_proc
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where 
		E.Tipo_Consulta = 12 and Campo = 'ZIP-LI' and I.Dt_SendToPDF2ATL is null 
		and insert_dt > GETDATE() -2
	ORDER BY I.ID,I.ID_Item
	
OPTION(HASH JOIN)
	




















GO
