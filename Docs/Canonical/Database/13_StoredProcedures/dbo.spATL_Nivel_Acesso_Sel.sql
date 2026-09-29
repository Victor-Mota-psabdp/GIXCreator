SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Nivel_Acesso
CREATE procedure [dbo].[spATL_Nivel_Acesso_Sel]--'','','B'
(
	
	@Cd_Area		varchar(3),
	--@Nome_Area		varchar(30),
	@Cd_Tela		varchar(3),
	--@Nome_Tela		varchar(50),
	@Cd_Nivel		varchar(3),
	--@Tipo_Nivel		varchar(30),	
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
			NA.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			NA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			NA.Cd_Nivel		[Level Code],
			N.tipo_nivel	[Level Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Nivel_Acesso NA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=NA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=NA.cd_tela
			left join nivel N with(nolock) on N.cd_nivel=NA.cd_nivel
	End
	
IF @Tipo = 'B'
	Begin
		Select 
			NA.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			NA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			NA.Cd_Nivel		[Level Code],
			N.tipo_nivel	[Level Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Nivel_Acesso NA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=NA.Cd_Area
			Left join Tela_ATL TE with(nolock)  on TE.cd_tela=NA.cd_tela
			left join nivel N with(nolock) on N.cd_nivel=NA.cd_nivel
		Where
			US.nome_area NOT like '%DESATIVADO%'
	End
	
IF @Tipo = 'C'
	Begin
		Select 
			NA.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			NA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			NA.Cd_Nivel		[Level Code],
			N.tipo_nivel	[Level Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Nivel_Acesso NA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=NA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=NA.cd_tela
			left join nivel N with(nolock) on N.cd_nivel=NA.cd_nivel
		Where
			NA.cd_tela = @cd_tela and NA.Cd_Area = @Cd_Area
			and N.Cd_Nivel = @Cd_Nivel
	End
	
IF @Tipo = 'D'
	Begin		
		Select 
			NA.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			NA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			NA.Cd_Nivel		[Level Code],
			N.tipo_nivel	[Level Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Nivel_Acesso NA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=NA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=NA.cd_tela
			left join nivel N with(nolock) on N.cd_nivel=NA.cd_nivel
		Where
			NA.cd_tela = @cd_tela and NA.Cd_Area = @Cd_Area
			and N.Cd_Nivel = @Cd_Nivel
			AND US.nome_area NOT like '%DESATIVADO%'
	End
	
IF @Tipo = 'N'
	Begin
		Select 
			NA.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			NA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			NA.Cd_Nivel		[Level Code],
			N.tipo_nivel	[Level Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Nivel_Acesso NA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=NA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=NA.cd_tela
			left join nivel N with(nolock) on N.cd_nivel=NA.cd_nivel
		Where
			--TE.Nome_Tela like @Nome_Tela and US.Nome_Area like @Nome_Area
			NA.cd_tela = @cd_tela and NA.Cd_Area = @Cd_Area
			and N.Cd_Nivel = @Cd_Nivel
	End
	
IF @Tipo = 'O'
	Begin
		Select 
			NA.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			NA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			NA.Cd_Nivel		[Level Code],
			N.tipo_nivel	[Level Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Nivel_Acesso NA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=NA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=NA.cd_tela
			left join nivel N with(nolock) on N.cd_nivel=NA.cd_nivel
		Where
			--TE.Nome_Tela like @Nome_Tela and US.Nome_Area like @Nome_Area
			--and N.Tipo_Nivel like @Tipo_Nivel
			NA.cd_tela = @cd_tela and NA.Cd_Area = @Cd_Area
			and N.Cd_Nivel = @Cd_Nivel
			AND US.nome_area NOT like '%DESATIVADO%'
	End

GO
