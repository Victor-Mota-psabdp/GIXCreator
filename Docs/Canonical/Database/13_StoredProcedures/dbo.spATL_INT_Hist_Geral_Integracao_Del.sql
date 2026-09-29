SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from ATL_INT.dbo.Hist_Geral_Integracao
--sp_help Hist_Geral_Integracao
CREATE procedure [dbo].[spATL_INT_Hist_Geral_Integracao_Del]
(	
	@ID		 bigint	
)

as

	IF EXISTS(SELECT HSGProcesso FROM ATL_INT.dbo.Hist_Geral_Integracao WHERE ID = @ID)
		begin
			DELETE ATL_INT.dbo.Hist_Geral_Integracao WHERE ID = @ID
		end


GO
