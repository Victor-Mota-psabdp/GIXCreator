SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW BLocalidade (BCd_Local, BNome_Local)  AS
       SELECT Localidade.Cd_Local, Localidade.Nome_Local
       FROM Localidade

GO
