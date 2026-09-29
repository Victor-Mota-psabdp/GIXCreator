SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pPortoViagem_Sel 
(
@Viagem		VArchar(6),
@Ano			VarChar(4)
)
AS
	select loc.nome_local porto from viagem vg join localidade loc on loc.cd_local = vg.porto  where nr_viagem = @Viagem and ano_viagem = @ano
GO
