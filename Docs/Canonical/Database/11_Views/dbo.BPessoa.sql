SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW BPessoa (BCd_Pes, BApelido)  AS
       SELECT Pessoa.Cd_Pes, Pessoa.Apelido
       FROM Pessoa

GO
