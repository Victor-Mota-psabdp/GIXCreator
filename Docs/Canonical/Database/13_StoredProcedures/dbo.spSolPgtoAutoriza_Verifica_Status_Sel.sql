SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spSolPgtoAutoriza_Verifica_Status_Sel]--'8024557'
(
	@ID bigint
)
as

select [Status] from vwSolPgtoCtaCteApr SL
where 
	[Register Number] = @ID
	
	

GO
