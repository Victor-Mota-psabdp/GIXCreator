SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create	FUNCTION [dbo].[fBusca_CampoPessoa]
(
@CdPes	Varchar(10),
@ID_Campo	int
)
RETURNS Varchar(400) 
AS
BEGIN
		declare @Resultado as varchar(400)

		set @Resultado = (select Campo_Dados from Campo_Pessoa With(nolock) where Cd_Pes=@CdPes and ID_Campo=@ID_Campo)

		RETURN @Resultado
END









GO
