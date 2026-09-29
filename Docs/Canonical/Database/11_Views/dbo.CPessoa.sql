SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW CPessoa (CCd_Pes, CApelido)  AS
       SELECT Pessoa.Cd_Pes, Pessoa.Apelido
       FROM Pessoa

GO
