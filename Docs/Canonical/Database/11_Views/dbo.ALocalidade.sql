SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW ALocalidade (ACd_Local, ANome_Local)  AS
       SELECT Localidade.Cd_Local, Localidade.Nome_Local
       FROM Localidade

GO
