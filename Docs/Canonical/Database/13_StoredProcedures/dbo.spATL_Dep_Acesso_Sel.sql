SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Dep_Acesso
CREATE procedure [dbo].[spATL_Dep_Acesso_Sel]--'','','B'
(
	@Cd_Area		varchar(3),
	--@Nome_Area	varchar(30),
	@Cd_Tela		varchar(3),
	--@Nome_Tela	varchar(50),
	@Tipo			char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

IF @Tipo = 'A' 
	Begin
		Select 
			US.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			TE.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Dep_Acesso UA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=UA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela
		Order by 1
	End
	
IF @Tipo = 'B'
	Begin
		Select 
			US.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			TE.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Dep_Acesso UA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=UA.Cd_Area
			Left join Tela_ATL TE with(nolock)  on TE.cd_tela=UA.cd_tela
		Where
			US.nome_area NOT like '%DESATIVADO%'
		Order by 1
	End
	
IF @Tipo = 'C'
	Begin
		Select 
			US.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			TE.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Dep_Acesso UA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=UA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela
		Where
			UA.Cd_Area = @Cd_Area
			--UA.cd_tela like @cd_tela and UA.Cd_Area like @Cd_Area
		Order by 1
	End
	
IF @Tipo = 'D'
	Begin		
		Select 
			US.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			TE.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Dep_Acesso UA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=UA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela
		Where
			UA.Cd_Area = @Cd_Area
			AND US.nome_area NOT like '%DESATIVADO%'
		Order by 1
	End
	
IF @Tipo = 'N'
	Begin
		Select 
			US.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			TE.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Dep_Acesso UA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=UA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela
		Where
			UA.cd_tela = @cd_tela
		Order by 1
	End
	
IF @Tipo = 'O'
	Begin
		Select 
			US.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			TE.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Dep_Acesso UA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=UA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela
		Where
			UA.cd_tela = @cd_tela
			AND US.nome_area NOT like '%DESATIVADO%'
		Order by 1
	End

if @Tipo = 'P' --or @Tipo = 'O'
	Begin
		Select 
			US.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			TE.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Dep_Acesso UA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=UA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela
		Where
			UA.Cd_Area = @Cd_Area AND UA.Cd_Tela = @Cd_Tela
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		Select 
			US.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			TE.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Dep_Acesso UA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=UA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela
		Where
			UA.Cd_Area = @Cd_Area AND UA.Cd_Tela <> @Cd_Tela
		Order by 1
	End

GO
