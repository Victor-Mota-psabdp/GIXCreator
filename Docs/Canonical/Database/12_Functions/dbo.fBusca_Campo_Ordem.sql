SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_Campo_Ordem]
(
	@Cd_Pedido	Int,
	@ID_Campo	int
)
RETURNS Varchar(400) 
AS
BEGIN
		declare @Resultado as varchar(400)

		set @Resultado = (select Campo_Dados from Campo_Ordem With(nolock) where Cd_Pedido=@cd_pedido and ID_Campo=@ID_Campo)

		RETURN @Resultado
END









GO
