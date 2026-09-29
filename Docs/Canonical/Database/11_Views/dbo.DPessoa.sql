SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW DPessoa (DCd_Pes, DApelido)  AS
       SELECT Pessoa.Cd_Pes, Pessoa.Apelido
       FROM Pessoa

GO
