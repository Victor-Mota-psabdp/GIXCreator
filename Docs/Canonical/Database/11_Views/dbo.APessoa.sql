SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW APessoa (ACd_Pes, AApelido)  AS
       SELECT Pessoa.Cd_Pes, Pessoa.Apelido
       FROM Pessoa

GO
