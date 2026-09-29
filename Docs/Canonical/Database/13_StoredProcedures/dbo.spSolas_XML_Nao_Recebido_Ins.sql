SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spSolas_XML_Nao_Recebido_Ins]
(
	@Num_Proc varchar(16)
)
as

Begin Transaction
	begin
		insert Solas_XML_Nao_Recebido (num_proc)
			values(@Num_Proc)
	end

Commit Transaction 


GO
