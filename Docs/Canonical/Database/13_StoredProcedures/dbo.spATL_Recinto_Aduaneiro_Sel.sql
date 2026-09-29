SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Recinto_Aduaneiro
CREATE procedure [dbo].[spATL_Recinto_Aduaneiro_Sel]
(
	@ID				BigInt,	
	@Cd_Recinto		varchar(10),
	@Nome_Recinto	varchar(MAX),
	@Cd_Local		varchar(3),
	@Tipo			char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' 
	Begin
		select 
			T.ID		[Code],
			T.Cd_Recinto	[Customs Area Code],
			T.Nome_Recinto	[Customs Area Name],
			T.Cd_local		[Place Code],
			L.Nome_local	[Place Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]
		
		from Recinto_Aduaneiro T with(nolock)
			left join Localidade L with(nolock) on L.Cd_local=T.Cd_local
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			T.ID		[Code],
			T.Cd_Recinto	[Customs Area Code],
			T.Nome_Recinto	[Customs Area Name],
			T.Cd_local		[Place Code],
			L.Nome_local	[Place Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]	
		
		from Recinto_Aduaneiro T with(nolock)
			left join Localidade L with(nolock) on L.Cd_local=T.Cd_local
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.ID = @ID
	End

if @Tipo = 'C'
	Begin
		select 
			T.ID		[Code],
			T.Cd_Recinto	[Customs Area Code],
			T.Nome_Recinto	[Customs Area Name],
			T.Cd_local		[Place Code],
			L.Nome_local	[Place Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]	
		
		from Recinto_Aduaneiro T with(nolock)
			left join Localidade L with(nolock) on L.Cd_local=T.Cd_local
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.Cd_Recinto = @Cd_Recinto
	End
	
if @Tipo = 'D'
	Begin
		select 
			T.ID		[Code],
			T.Cd_Recinto	[Customs Area Code],
			T.Nome_Recinto	[Customs Area Name],
			T.Cd_local		[Place Code],
			L.Nome_local	[Place Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]		
		
		from Recinto_Aduaneiro T with(nolock)
			left join Localidade L with(nolock) on L.Cd_local=T.Cd_local
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.Cd_Recinto = @Cd_Recinto and
			ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			T.ID		[Code],
			T.Cd_Recinto	[Customs Area Code],
			T.Nome_Recinto	[Customs Area Name],
			T.Cd_local		[Place Code],
			L.Nome_local	[Place Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]
		
		from Recinto_Aduaneiro T with(nolock)
			left join Localidade L with(nolock) on L.Cd_local=T.Cd_local
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.Nome_Recinto = @Nome_Recinto
	End
	
if @Tipo = 'O'
	Begin
		select 
			T.ID		[Code],
			T.Cd_Recinto	[Customs Area Code],
			T.Nome_Recinto	[Customs Area Name],
			T.Cd_local		[Place Code],
			L.Nome_local	[Place Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]	
		
		from Recinto_Aduaneiro T with(nolock)
			left join Localidade L with(nolock) on L.Cd_local=T.Cd_local
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.Nome_Recinto = @Nome_Recinto and
			ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			T.ID		[Code],
			T.Cd_Recinto	[Customs Area Code],
			T.Nome_Recinto	[Customs Area Name],
			T.Cd_local		[Place Code],
			L.Nome_local	[Place Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]		
		
		from Recinto_Aduaneiro T with(nolock)
			left join Localidade L with(nolock) on L.Cd_local=T.Cd_local
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.Nome_Recinto = @Nome_Recinto
			AND T.Cd_Recinto <> @Cd_Recinto
	End

GO
