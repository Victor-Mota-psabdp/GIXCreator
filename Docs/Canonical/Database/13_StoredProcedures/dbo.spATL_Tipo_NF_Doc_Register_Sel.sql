SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_NF_Doc_Register
CREATE procedure [dbo].[spATL_Tipo_NF_Doc_Register_Sel]--null,'Teste','Z'
(
	@Cd_Site		char(1),
	@Cd_Servico		Int,
	@Item_lei		varchar(50),
	@CNAE			varchar(25),
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
--sp_help Site
if @Tipo = 'A' 
	Begin
		select
			A.Cd_Servico		[Service Code],
			A.Item_lei			[Item Lei],
			A.CNAE				[CNAE],
			A.Descricao			[Description],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Desativada		[Disabled],
			A.Cd_Site			[Site Code],
			S.Nome_Site			[Site Name]
		from Tipo_NF_Doc_Register A with(nolock) 
			Join Site S with(nolock) on S.Cd_Site = A.Cd_Site	
			left join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario	
	End
	
if  @Tipo = 'B'
	Begin
		select
			A.Cd_Servico		[Service Code],
			A.Item_lei			[Item Lei],
			A.CNAE				[CNAE],
			A.Descricao			[Description],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Desativada		[Disabled],
			A.Cd_Site			[Site Code],
			S.Nome_Site			[Site Name]
		from Tipo_NF_Doc_Register A with(nolock) 
			Join Site S with(nolock) on S.Cd_Site = A.Cd_Site	
			left join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario	
		where
			A.Cd_Site = @Cd_Site			
	
	End

if @Tipo = 'C'
	Begin
		select
			A.Cd_Servico		[Service Code],
			A.Item_lei			[Item Lei],
			A.CNAE				[CNAE],
			A.Descricao			[Description],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Desativada		[Disabled],
			A.Cd_Site			[Site Code],
			S.Nome_Site			[Site Name]
		from Tipo_NF_Doc_Register A with(nolock) 
			Join Site S with(nolock) on S.Cd_Site = A.Cd_Site	
			left join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario	
		where
			A.Cd_Servico = @Cd_Servico		
	End
	
if @Tipo = 'D'
	Begin
		select
			A.Cd_Servico		[Service Code],
			A.Item_lei			[Item Lei],
			A.CNAE				[CNAE],
			A.Descricao			[Description],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Desativada		[Disabled],
			A.Cd_Site			[Site Code],
			S.Nome_Site			[Site Name]
		from Tipo_NF_Doc_Register A with(nolock) 
			Join Site S with(nolock) on S.Cd_Site = A.Cd_Site	
			left join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario	
		where
			A.Item_lei = @Item_lei 
		Order by 1
	End
	
if @Tipo = 'N'
	Begin
		select
			A.Cd_Servico		[Service Code],
			A.Item_lei			[Item Lei],
			A.CNAE				[CNAE],
			A.Descricao			[Description],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Desativada		[Disabled],
			A.Cd_Site			[Site Code],
			S.Nome_Site			[Site Name]
		from Tipo_NF_Doc_Register A with(nolock) 
			Join Site S with(nolock) on S.Cd_Site = A.Cd_Site	
			left join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario	
		where
			A.CNAE = @CNAE
	End
	
if @Tipo = 'O'
	Begin
		select
			A.Cd_Servico		[Service Code],
			A.Item_lei			[Item Lei],
			A.CNAE				[CNAE],
			A.Descricao			[Description],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Desativada		[Disabled],
			A.Cd_Site			[Site Code],
			S.Nome_Site			[Site Name]
		from Tipo_NF_Doc_Register A with(nolock) 
			Join Site S with(nolock) on S.Cd_Site = A.Cd_Site	
			left join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario	
		where
			A.Cd_Servico = @Cd_Servico and A.Item_lei = @Item_lei
			and A.CNAE = @CNAE	
	End

if @Tipo = 'P'
	Begin
		select
			A.Cd_Servico		[Service Code],
			A.Item_lei			[Item Lei],
			A.CNAE				[CNAE],
			A.Descricao			[Description],
			A.cd_usuario		[User Code],
			US.Nome_Usuario		[User Name],
			A.dt_ins			[Insert Date],
			A.Desativada		[Disabled],
			A.Cd_Site			[Site Code],
			S.Nome_Site			[Site Name]
		from Tipo_NF_Doc_Register A with(nolock) 
			Join Site S with(nolock) on S.Cd_Site = A.Cd_Site	
			left join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario	
		where
			A.Cd_Servico = @Cd_Servico and A.Cd_Site = @Cd_Site				
	End




GO
