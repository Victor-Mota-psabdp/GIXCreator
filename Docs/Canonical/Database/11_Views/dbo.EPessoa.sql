SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW EPessoa (ECd_Pes, EApelido)  AS
       SELECT Pessoa.Cd_Pes, Pessoa.Apelido
       FROM Pessoa

GO
