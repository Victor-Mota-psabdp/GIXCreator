SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Grupo_Acesso
create procedure [dbo].[spATL_Grupo_Acesso_Sel]--'','','B'
(
	
	@Cd_Tela		varchar(3),
	@Cd_Pes_Grupo	varchar(10),
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

IF @Tipo = 'A'  or @Tipo = 'B'
	Begin
		Select 			
			GA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			GA.Cd_Pes_Grupo	[Group Code],
			P.Apelido		[Group Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Grupo_Acesso GA	with(nolock) 			
			Left join tela_atl TE with(nolock)  on TE.cd_tela=GA.Cd_Tela
			left join Pessoa P with(nolock) on P.cd_pes=GA.cd_pes_grupo
	End
	

IF @Tipo = 'C' or @Tipo = 'D'
	Begin
		Select 			
			GA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			GA.Cd_Pes_Grupo	[Group Code],
			P.Apelido		[Group Name],
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Grupo_Acesso GA	with(nolock) 			
			Left join tela_atl TE with(nolock)  on TE.cd_tela=GA.Cd_Tela
			left join Pessoa P with(nolock) on P.cd_pes=GA.cd_pes_grupo
		Where
			GA.cd_tela = @cd_tela and GA.Cd_Pes_Grupo=Cd_Pes_Grupo
		
	End
	
IF @Tipo = 'N' or @Tipo = 'O'
	Begin
		Select 			
			GA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			GA.Cd_Pes_Grupo	[Group Code],
			P.Apelido		[Group Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Grupo_Acesso GA	with(nolock) 			
			Left join tela_atl TE with(nolock)  on TE.cd_tela=GA.Cd_Tela
			left join Pessoa P with(nolock) on P.cd_pes=GA.cd_pes_grupo
		Where
			GA.cd_tela = @cd_tela and GA.Cd_Pes_Grupo=Cd_Pes_Grupo
	End
	

GO
