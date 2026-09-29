SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pEndereco_Sel 
(
@Cd_Pes		VarChar(10) ,
@Cd_Tp_End		VarChar(3)=''
)
 AS
	If @Cd_Tp_End <> '' 
		Select 
			Ender.* , TE.Nome_Tp_End as Tipo_Ender, Ps.Cd_Tp_Classe
		From 
			Pessoa as Ps Join  Endereco as Ender on Ps.Cd_Pes = Ender.Cd_Pes 
			Left Outer Join Tipo_Endereco as TE on Ender.Cd_Tp_End = TE.Cd_Tp_End 
		Where
			Ender.Cd_Pes = @Cd_Pes and 
			Ender.Cd_Tp_End = @Cd_Tp_End 
	Else

		Select 
			Ender.* , TE.Nome_Tp_End as Tipo_Ender, Ps.Cd_Tp_Classe
		From 
			Pessoa as Ps Join  Endereco as Ender on Ps.Cd_Pes = Ender.Cd_Pes 
			Left Outer Join Tipo_Endereco as TE on Ender.Cd_Tp_End = TE.Cd_Tp_End 
		Where
			Ender.Cd_Pes = @Cd_Pes

GO
