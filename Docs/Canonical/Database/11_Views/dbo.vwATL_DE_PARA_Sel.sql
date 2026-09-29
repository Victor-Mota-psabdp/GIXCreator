SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help DE_PARA
CREATE VIEW [dbo].[vwATL_DE_PARA_Sel]
AS
		SELECT
			A.Cd_Tipo		[Type],
			T.Nome_Tipo		[Type Name],
			A.Cd_Cliente	[Group Code],
			P.Apelido		[Group Name],			
			Cd_Org			[Origin] ,
			Cd_Dst			[Destination],
			Descr_Org		[Origin Description],
			A.dt_ins		[Insert Date],
			A.Ativo			[Enabled],
			A.Cd_Usuario	[User Code],
			u.Nome_Usuario	[User Name]
		FROM 
			DE_PARA A with(nolock)
			JOIN Pessoa P on P.Cd_Pes = A.Cd_Cliente
			left JOIN Usuario U on U.Cd_Usuario = A.Cd_Usuario
			left JOIN Tipo_De_Para T on T.Cd_Tipo = A.Cd_Tipo

GO
