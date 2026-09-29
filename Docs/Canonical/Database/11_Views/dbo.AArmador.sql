SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW AArmador (ACd_Armador, ANome_Armador)  AS
       SELECT Armador.Cd_Armador, Armador.Nome_Armador
       FROM Armador

GO
