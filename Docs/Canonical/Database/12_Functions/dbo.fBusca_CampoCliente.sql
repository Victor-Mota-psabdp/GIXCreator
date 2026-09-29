SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	FUNCTION [dbo].[fBusca_CampoCliente]
(
@Processo	Varchar(16),
@ID_Campo	int
)
RETURNS Varchar(400) 
AS
BEGIN
		declare @Resultado as varchar(400)

		set @Resultado = (select Campo_Dados from campo_processo With(nolock) where num_proc=@processo and ID_Campo=@ID_Campo)

		RETURN @Resultado
END









GO
