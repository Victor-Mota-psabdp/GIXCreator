SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Termo_Pagamento_Del]
(
	@Cd_Termo INT
)
as
	UPDATE Termo_Pagamento SET ATIVO = 0 where Cd_Termo= @Cd_Termo

GO
