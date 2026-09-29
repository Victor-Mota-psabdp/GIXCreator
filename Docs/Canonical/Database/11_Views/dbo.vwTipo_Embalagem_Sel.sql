SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTipo_Embalagem_Sel]
AS
	select 
			T.Cd_Tp_Embal		[Code],
			T.Nome_Tp_Embal		[Package Name],
			T.Cd_Embal_Ofc		[Official Code],
			A.Nome_Embalagem	[Official Package Name],
			T.ISO_CODE			[ISO_CODE],
			Cd_Smart			[Code Smart],			
			Convert(bit,(Case when T.Ativo = 'S' then 1 else 0 End)) [Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.Data				[Insert Date]			
			--Nome_Tp_Embal		[Nome Embalagem],
			--T.Cd_Embal_Ofc		[Code Official],			
			--Ativo,
			--Data,
			--T.Cd_Usuario, 
			--U.Nome_Usuario		
	
		from Tipo_Embalagem T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			left join Aux_Embalagem A  with(nolock) on A.Cd_Embal_Ofc=T.Cd_Embal_Ofc
		where
			Cd_Tp_Embal  <>'0'
			and	ativo = 'S'

GO
