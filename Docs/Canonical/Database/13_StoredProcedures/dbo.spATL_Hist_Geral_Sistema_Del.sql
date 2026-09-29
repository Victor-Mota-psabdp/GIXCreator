SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Hist_Geral_Sistema
CREATE procedure [dbo].[spATL_Hist_Geral_Sistema_Del]
(
	@HSGProcesso varChar(16),
	@HSGSeq		 int,
	@Tipo		 char(1)
)

as

	IF EXISTS(SELECT HSGProcesso FROM Hist_Geral_Sistema WHERE HSGProcesso = @HSGProcesso AND HSGSeq = @HSGSeq)
		begin
			DELETE Hist_Geral_Sistema WHERE HSGProcesso = @HSGProcesso AND HSGSeq = @HSGSeq
		end

GO
