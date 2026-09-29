SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Usuario_Cliente
CREATE PROCEDURE [dbo].[spATLDN_Usuario_Cliente_Sel]
(
	@Cd_Usuario		varchar(20),
	@Nome_Usuario	varchar(50),
	@Cd_Cliente		varchar(10),
	@Tipo char(1)
)	
as

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT
			A.Cd_Usuario	[Code],
			A.Nome_Usuario	[User Name] ,
			A.Email			[Email],
			A.Ativo			[Enabled],
			A.Plasticos		[Plastics],
			A.dt_ins		[Created Date],
			A.Cd_Cliente	[Group Code],
			U.Apelido		[Group Name]
		FROM Usuario_Cliente A with(nolock)
			LEFT JOIN Pessoa U on U.Cd_Pes = A.Cd_Cliente
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			A.Cd_Usuario	[Code],
			A.Nome_Usuario	[User Name] ,
			A.Email			[Email],
			A.Ativo			[Enabled],
			A.Plasticos		[Plastics],
			A.dt_ins		[Created Date],
			A.Cd_Cliente	[Group Code],
			U.Apelido		[Group Name]
		FROM Usuario_Cliente A with(nolock)
			LEFT JOIN Pessoa U on U.Cd_Pes = A.Cd_Cliente
		where 
			A.Cd_Usuario = @Cd_Usuario AND
			U.Cd_Pes = @Cd_Cliente
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT
			A.Cd_Usuario	[Code],
			A.Nome_Usuario	[User Name] ,
			A.Email			[Email],
			A.Ativo			[Enabled],
			A.Plasticos		[Plastics],
			A.dt_ins		[Created Date],
			A.Cd_Cliente	[Group Code],
			U.Apelido		[Group Name]
		FROM Usuario_Cliente A with(nolock)
			LEFT JOIN Pessoa U on U.Cd_Pes = A.Cd_Cliente
		where 
			A.Nome_Usuario = @Nome_Usuario AND
			U.Cd_Pes = @Cd_Cliente
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT
			A.Cd_Usuario	[Code],
			A.Nome_Usuario	[User Name] ,
			A.Email			[Email],
			A.Ativo			[Enabled],
			A.Plasticos		[Plastics],
			A.dt_ins		[Created Date],
			A.Cd_Cliente	[Group Code],
			U.Apelido		[Group Name]
		FROM Usuario_Cliente A with(nolock)
			LEFT JOIN Pessoa U on U.Cd_Pes = A.Cd_Cliente
		where 
			A.Cd_Usuario = @Cd_Usuario AND
			U.Cd_Pes = @Cd_Cliente			
	End

if @Tipo = 'P' 
	Begin
		SELECT
			A.Cd_Usuario	[Code],
			A.Nome_Usuario	[User Name] ,
			A.Email			[Email],
			A.Ativo			[Enabled],
			A.Plasticos		[Plastics],
			A.dt_ins		[Created Date],
			A.Cd_Cliente	[Group Code],
			U.Apelido		[Group Name]
		FROM Usuario_Cliente A with(nolock)
			LEFT JOIN Pessoa U on U.Cd_Pes = A.Cd_Cliente
		where
			U.Cd_Pes = @Cd_Cliente
	End


GO
