SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Operador_Portuario
CREATE PROCEDURE [dbo].[spATL_Tipo_Operador_Portuario_Sel]
(
	@ID_OP			Int,
	@Descricao_OP	varchar(100),
	@Tipo			char(1)
)
	
as

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT
			T.ID_OP			[Code],
			T.Descricao_OP	[Port Operator Name] ,
			T.Ativo			[Enabled],
			T.Dt_Criacao	[Created Date],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name]
		FROM 
			Tipo_Operador_Portuario T with(nolock)
			left JOIN Usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
		
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			T.ID_OP			[Code],
			T.Descricao_OP	[Port Operator Name] ,
			T.Ativo			[Enabled],
			T.Dt_Criacao	[Created Date],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name]
		FROM 
			Tipo_Operador_Portuario T with(nolock)
			left JOIN Usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
		WHERE			
			ID_OP = @ID_OP
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT
			T.ID_OP			[Code],
			T.Descricao_OP	[Port Operator Name] ,
			T.Ativo			[Enabled],
			T.Dt_Criacao	[Created Date],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name]
		FROM 
			Tipo_Operador_Portuario T with(nolock)
			left JOIN Usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
		where 
			Descricao_OP = @Descricao_OP
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT
			T.ID_OP			[Code],
			T.Descricao_OP	[Port Operator Name] ,
			T.Ativo			[Enabled],
			T.Dt_Criacao	[Created Date],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name]
		FROM 
			Tipo_Operador_Portuario T with(nolock)
			left JOIN Usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario
		where
			Descricao_OP = @Descricao_OP and ID_OP <> @ID_OP			
	End

GO
