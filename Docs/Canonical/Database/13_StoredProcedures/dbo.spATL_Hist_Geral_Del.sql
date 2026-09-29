SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Hist_Geral
CREATE procedure [dbo].[spATL_Hist_Geral_Del]
(
	@HSGProcesso varChar(16),
	@HSGSeq		 int,
	@Tipo		 char(1)
)

as

	IF EXISTS(SELECT HSGProcesso FROM hist_Geral WHERE HSGProcesso = @HSGProcesso AND HSGSeq = @HSGSeq)
		begin
			DELETE hist_Geral WHERE HSGProcesso = @HSGProcesso AND HSGSeq = @HSGSeq
		end


GO
