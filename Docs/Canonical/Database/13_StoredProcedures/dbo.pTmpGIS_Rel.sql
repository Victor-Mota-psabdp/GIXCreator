SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pTmpGIS_Rel 
(
@StrMachine		VarChar(30)
)
AS
	Select 
		TG.*, Pes.Apelido
	From 
		Tmp_GIS TG Join Pessoa Pes on Pes.Cd_Pes = TG.Cd_Pes 
	Where
		TG.TmpMachine = @StrMachine
GO
