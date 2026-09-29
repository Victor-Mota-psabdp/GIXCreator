SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Grupo
--sp_help Grupo
CREATE procedure [dbo].[spATLDN_Grupo_Sel]--'','','B'
(	
	@Cd_Pes_Grupo	varchar(10),
	@Apelido		varchar(20),
	--@Grupo			varchar(3),
	@Tipo			char(1)
)
as

	--sp_help Pessoa
	--Declare @Cd_Pes_Grupo varchar(10)
	--set @Cd_Pes_Grupo = (select Cd_Pes from Pessoa where Apelido = @Apelido)
	--if @Cd_Pes_Grupo is null
	--set @Cd_Pes_Grupo = '%'	
	
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
			G.Cd_Pes_Grupo		[Code],
			P.Apelido			[Group Name], 
			G.Grupo				[Group],
			Unit				[Unit],
			Smart_IMP			[Smart IMP],
			Smart_EXP			[Smart EXP],			
			Admin				[Administrator],			
			AX_GRUPO			[AX Group],
			U.Nome_Usuario		[Group Responsible]		 
		From 
			Grupo G	with(nolock) 			
			join Pessoa P with(nolock) on P.Cd_Pes=G.Cd_Pes_Grupo
			left join Usuario U  with(nolock) on U.Cd_Usuario=G.Responsavel
	End
	
IF @Tipo = 'B'
	Begin
		Select
			G.Cd_Pes_Grupo		[Code],
			P.Apelido			[Group Name], 
			G.Grupo				[Group],
			Unit				[Unit],
			Smart_IMP			[Smart IMP],
			Smart_EXP			[Smart EXP],			
			Admin				[Administrator],			
			AX_GRUPO			[AX Group],
			U.Nome_Usuario		[Group Responsible]		 
		From 
			Grupo G	with(nolock) 			
			join Pessoa P with(nolock) on P.Cd_Pes=G.Cd_Pes_Grupo
			left join Usuario U  with(nolock) on U.Cd_Usuario=G.Responsavel
		Where
			P.Desat_Pes = 'N'
	End
	
IF @Tipo = 'C'
	Begin
		Select
			G.Cd_Pes_Grupo		[Code],
			P.Apelido			[Group Name], 
			G.Grupo				[Group],
			Unit				[Unit],
			Smart_IMP			[Smart IMP],
			Smart_EXP			[Smart EXP],			
			Admin				[Administrator],			
			AX_GRUPO			[AX Group],
			U.Nome_Usuario		[Group Responsible]		 
		From 
			Grupo G	with(nolock) 			
			join Pessoa P with(nolock) on P.Cd_Pes=G.Cd_Pes_Grupo
			left join Usuario U  with(nolock) on U.Cd_Usuario=G.Responsavel
		Where
			G.Cd_Pes_Grupo = @Cd_Pes_Grupo		
	End
	
IF @Tipo = 'D'
	Begin		
		Select
			G.Cd_Pes_Grupo		[Code],
			P.Apelido			[Group Name], 
			G.Grupo				[Group],
			Unit				[Unit],
			Smart_IMP			[Smart IMP],
			Smart_EXP			[Smart EXP],			
			Admin				[Administrator],			
			AX_GRUPO			[AX Group],
			U.Nome_Usuario		[Group Responsible]		 
		From 
			Grupo G	with(nolock) 			
			join Pessoa P with(nolock) on P.Cd_Pes=G.Cd_Pes_Grupo
			left join Usuario U  with(nolock) on U.Cd_Usuario=G.Responsavel
		Where
			G.Cd_Pes_Grupo = @Cd_Pes_Grupo
			and P.Desat_Pes = 'N'			
	End
	
IF @Tipo = 'N'
	Begin
		Select
			G.Cd_Pes_Grupo		[Code],
			P.Apelido			[Group Name], 
			G.Grupo				[Group],
			Unit				[Unit],
			Smart_IMP			[Smart IMP],
			Smart_EXP			[Smart EXP],			
			Admin				[Administrator],			
			AX_GRUPO			[AX Group],
			U.Nome_Usuario		[Group Responsible]		 
		From 
			Grupo G	with(nolock) 			
			join Pessoa P with(nolock) on P.Cd_Pes=G.Cd_Pes_Grupo
			left join Usuario U  with(nolock) on U.Cd_Usuario=G.Responsavel
		Where
			P.Apelido = @Apelido	
	End
	
IF @Tipo = 'O'
	Begin
		Select
			G.Cd_Pes_Grupo		[Code],
			P.Apelido			[Group Name], 
			G.Grupo				[Group],
			Unit				[Unit],
			Smart_IMP			[Smart IMP],
			Smart_EXP			[Smart EXP],			
			Admin				[Administrator],			
			AX_GRUPO			[AX Group],
			U.Nome_Usuario		[Group Responsible]		 
		From 
			Grupo G	with(nolock) 			
			join Pessoa P with(nolock) on P.Cd_Pes=G.Cd_Pes_Grupo
			left join Usuario U  with(nolock) on U.Cd_Usuario=G.Responsavel
		Where
			P.Apelido = @Apelido
			AND P.Desat_Pes = 'N'
	End
	












GO
