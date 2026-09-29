SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATLDN_Usuario_Sel '','Erica Maria Silva','O'
CREATE procedure [dbo].[spATLDN_Usuario_Sel](
	@Cd_Usuario char(6),
	@Nome_Usuario varchar(30),
	@Tipo char(1)
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
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]		
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
	End

if  @Tipo = 'B'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			US.Ck_Ativo = 1
	End

if @Tipo = 'C'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			Cd_Usuario = @Cd_Usuario
	End	
	
if @Tipo = 'D'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			Cd_Usuario = @Cd_Usuario AND US.Ck_Ativo = 1
	End		
	
if @Tipo = 'N'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE 
			Nome_Usuario = @Nome_Usuario or ADUserName = @Nome_Usuario
	End
	
if @Tipo = 'O'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE 
			(Nome_Usuario = @Nome_Usuario  or ADUserName = @Nome_Usuario)
			AND US.Ck_Ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE		
			Nome_Usuario = @Nome_Usuario AND Cd_Usuario <> @Cd_Usuario
	End

if @Tipo = 'E'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			--Cd_Usuario = @Cd_Usuario AND 
			US.Ck_Ativo = 1 and
			Cd_Usuario in ('raposo','MAX','NI','dar','wv')
	End	

if @Tipo = 'F'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 		
		
		WHERE
			Cd_Usuario = @Cd_Usuario AND 
			US.Ck_Ativo = 1 and
			Cd_Usuario in ('raposo','MAX','NI','dar','wv')
	End	
	
	/*
	
	
--spATLDN_Usuario_Sel '','Erica Maria Silva','O'
ALTER procedure [dbo].[spATLDN_Usuario_Sel](
	@Cd_Usuario char(6),
	@Nome_Usuario varchar(30),
	@Tipo char(1)
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
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]		
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
	End

if  @Tipo = 'B'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			US.Ck_Ativo = 1
	End

if @Tipo = 'C'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			Cd_Usuario = @Cd_Usuario
	End	
	
if @Tipo = 'D'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			Cd_Usuario = @Cd_Usuario AND US.Ck_Ativo = 1
	End		
	
if @Tipo = 'N'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE 
			Nome_Usuario = @Nome_Usuario
	End
	
if @Tipo = 'O'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE 
			Nome_Usuario = @Nome_Usuario AND US.Ck_Ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE		
			Nome_Usuario = @Nome_Usuario AND Cd_Usuario <> @Cd_Usuario
	End

if @Tipo = 'E'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			--Cd_Usuario = @Cd_Usuario AND 
			US.Ck_Ativo = 1 and
			Cd_Usuario in ('raposo','MAX','NI','dar','wv')
	End	

if @Tipo = 'F'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department Name],
			GR.ID_Tp_GR_Usuario			[Type Group User Code],
			Grupo						[Type Group User Name],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language Name],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level Name],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], 
			ADUserName					[AD User Name],
			Ck_Ativo					[Enabled]			
		FROM Usuario US		(nolock)
		left Join Area AR	(nolock)on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock)on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock)on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)on US.Grupo = GR.Nome_Tp_GR_Usuario 		
		
		WHERE
			Cd_Usuario = @Cd_Usuario AND 
			US.Ck_Ativo = 1 and
			Cd_Usuario in ('raposo','MAX','NI','dar','wv')
	End	
	


/*
--spATLDN_Usuario_Sel 'ADMIN','','D'
--sp_help Usuario cadu 02/04/2019 - 11hs
ALTER procedure [dbo].[spATLDN_Usuario_Sel](
	@Cd_Usuario char(6),
	@Nome_Usuario varchar(30),
	@Tipo char(1)
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
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department],
			GR.ID_Tp_GR_Usuario			[Group Code],-- Alessandra 11/06/2020
			Grupo						[Group],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], -- Alessandra 11/06/2020
			ADUserName					[AD User Name], -- Alessandra 11/06/2020	
			Ck_Ativo			
		FROM usuario US		(nolock)
		left Join Area AR	(nolock) 
			on US.Cd_Area = AR.Cd_Area
		left Join Idioma ID (nolock) 
			on US.Cd_Idioma = ID.Cd_Idioma
		left Join Nivel NV	(nolock) 
			on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)
			on US.Grupo = GR.Nome_Tp_GR_Usuario 
	End

if  @Tipo = 'B'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department],
			GR.ID_Tp_GR_Usuario			[Group Code],-- Alessandra 11/06/2020
			Grupo						[Group],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], -- Alessandra 11/06/2020
			ADUserName					[AD User Name], -- Alessandra 11/06/2020	
			Ck_Ativo	
		FROM usuario US		(nolock)
		left Join Area AR	(nolock) 
			on AR.Cd_Area=US.Cd_Area
		left Join Idioma ID (nolock) 
			on ID.Cd_Idioma=US.Cd_Idioma
		left Join Nivel NV	(nolock) 
			on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)
			on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			US.Ck_Ativo = 1
	End

if @Tipo = 'C'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department],
			GR.ID_Tp_GR_Usuario			[Group Code],-- Alessandra 11/06/2020
			Grupo						[Group],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], -- Alessandra 11/06/2020
			ADUserName					[AD User Name], -- Alessandra 11/06/2020	
			Ck_Ativo	
		FROM usuario US		(nolock)
		left Join Area AR	(nolock) 
			on AR.Cd_Area=US.Cd_Area
		left Join Idioma ID (nolock) 
			on ID.Cd_Idioma=US.Cd_Idioma
		left Join Nivel NV	(nolock) 
			on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)
			on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			Cd_Usuario = @Cd_Usuario
	End	
	
if @Tipo = 'D'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department],
			GR.ID_Tp_GR_Usuario			[Group Code],-- Alessandra 11/06/2020
			Grupo						[Group],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], -- Alessandra 11/06/2020
			ADUserName					[AD User Name], -- Alessandra 11/06/2020	
			Ck_Ativo	
		FROM usuario US		(nolock)
		left Join Area AR	(nolock) 
			on AR.Cd_Area=US.Cd_Area
		left Join Idioma ID (nolock) 
			on ID.Cd_Idioma=US.Cd_Idioma
		left Join Nivel NV	(nolock) 
			on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)
			on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			Cd_Usuario = @Cd_Usuario AND US.Ck_Ativo = 1
	End		
	
if @Tipo = 'N'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department],
			GR.ID_Tp_GR_Usuario			[Group Code],-- Alessandra 11/06/2020
			Grupo						[Group],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], -- Alessandra 11/06/2020
			ADUserName					[AD User Name], -- Alessandra 11/06/2020	
			Ck_Ativo	
		FROM usuario US		(nolock)
		left Join Area AR	(nolock) 
			on AR.Cd_Area=US.Cd_Area
		left Join Idioma ID (nolock) 
			on ID.Cd_Idioma=US.Cd_Idioma
		left Join Nivel NV	(nolock) 
			on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)
			on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE 
			Nome_Usuario = @Nome_Usuario
	End
	
if @Tipo = 'O'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department],
			GR.ID_Tp_GR_Usuario			[Group Code],-- Alessandra 11/06/2020
			Grupo						[Group],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], -- Alessandra 11/06/2020
			ADUserName					[AD User Name], -- Alessandra 11/06/2020	
			Ck_Ativo	
		FROM usuario US		(nolock)
		left Join Area AR	(nolock) 
			on AR.Cd_Area=US.Cd_Area
		left Join Idioma ID (nolock) 
			on ID.Cd_Idioma=US.Cd_Idioma
		left Join Nivel NV	(nolock) 
			on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)
			on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE 
			Nome_Usuario = @Nome_Usuario AND US.Ck_Ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department],
			GR.ID_Tp_GR_Usuario			[Group Code],-- Alessandra 11/06/2020
			Grupo						[Group],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], -- Alessandra 11/06/2020
			ADUserName					[AD User Name], -- Alessandra 11/06/2020	
			Ck_Ativo	
		FROM usuario US		(nolock)
		left Join Area AR	(nolock) 
			on AR.Cd_Area=US.Cd_Area
		left Join Idioma ID (nolock) 
			on ID.Cd_Idioma=US.Cd_Idioma
		left Join Nivel NV	(nolock) 
			on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)
			on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE		
			Nome_Usuario = @Nome_Usuario AND Cd_Usuario <> @Cd_Usuario
	End

if @Tipo = 'E'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department],
			GR.ID_Tp_GR_Usuario			[Group Code],-- Alessandra 11/06/2020
			Grupo						[Group],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], -- Alessandra 11/06/2020
			ADUserName					[AD User Name], -- Alessandra 11/06/2020	
			Ck_Ativo	
		FROM usuario US		(nolock)
		left Join Area AR	(nolock) 
			on AR.Cd_Area=US.Cd_Area
		left Join Idioma ID (nolock) 
			on ID.Cd_Idioma=US.Cd_Idioma
		left Join Nivel NV	(nolock) 
			on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)
			on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			--Cd_Usuario = @Cd_Usuario AND 
			US.Ck_Ativo = 1 and
			Cd_Usuario in ('raposo','MAX','NI','dar','wv')
	End	

if @Tipo = 'F'
	Begin
		SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department],
			GR.ID_Tp_GR_Usuario			[Group Code],-- Alessandra 11/06/2020
			Grupo						[Group],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], -- Alessandra 11/06/2020
			ADUserName					[AD User Name], -- Alessandra 11/06/2020	
			Ck_Ativo	
		FROM usuario US		(nolock)
		left Join Area AR	(nolock) 
			on AR.Cd_Area=US.Cd_Area
		left Join Idioma ID (nolock) 
			on ID.Cd_Idioma=US.Cd_Idioma
		left Join Nivel NV	(nolock) 
			on US.Cd_Nivel = NV.Cd_Nivel
		left join Tipo_Grupo_Usuario GR (nolock)
			on US.Grupo = GR.Nome_Tp_GR_Usuario 
		WHERE
			Cd_Usuario = @Cd_Usuario AND 
			US.Ck_Ativo = 1 and
			Cd_Usuario in ('raposo','MAX','NI','dar','wv')
	End	
	
*/	
--select 
	--	Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
	--	Email [E-Mail],Grupo [Group],Ck_Ativo,Fone [Phone Number],
	--	US.Cd_Area [Department Code], AR.nome_area [Department],
	--	US.Cd_Idioma [Code Language],ID.Nome_Idioma [Code Language],
	--	US.Cd_Nivel [Code Level],NV.Tipo_Nivel [Code Level]
	--from usuario US		with(nolock)
	--left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
	--left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
	--left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
	
	/*
	
	--spATLDN_Usuario_Sel 'ERBSON','','D'
--sp_help Usuario
ALTER procedure [dbo].[spATLDN_Usuario_Sel](
	@Cd_Usuario char(6),
	@Nome_Usuario varchar(30),
	@Tipo char(1)
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
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo			
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
	End

if  @Tipo = 'B'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE
			US.Ck_Ativo = 1
	End

if @Tipo = 'C'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE
			Cd_Usuario = @Cd_Usuario
	End
	
	
if @Tipo = 'D'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE
			Cd_Usuario = @Cd_Usuario AND US.Ck_Ativo = 1
	End	
	
	
if @Tipo = 'N'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE 
			Nome_Usuario = @Nome_Usuario
	End
	
if @Tipo = 'O'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE 
			Nome_Usuario = @Nome_Usuario AND US.Ck_Ativo = 1
	End

	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE		
			Nome_Usuario = @Nome_Usuario AND Cd_Usuario <> @Cd_Usuario
	End
	
	
	--select 
	--	Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
	--	Email [E-Mail],Grupo [Group],Ck_Ativo,Fone [Phone Number],
	--	US.Cd_Area [Department Code], AR.nome_area [Department],
	--	US.Cd_Idioma [Code Language],ID.Nome_Idioma [Code Language],
	--	US.Cd_Nivel [Code Level],NV.Tipo_Nivel [Code Level]
	--from usuario US		with(nolock)
	--left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
	--left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
	--left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
	

	

	
	
----spATLDN_Usuario_Sel 'ERBSON','','D'
----sp_help Usuario
--ALTER procedure [dbo].[spATLDN_Usuario_Sel](
--	@Cd_Usuario char(6),
--	@Nome_Usuario varchar(30),
--	@Tipo char(1)
--)
--as

--/*
--A, /// Todos os registros - Existentes
--B, /// Todos os registros - Ativos
--C, /// Busca pelo Codigo - Existentes
--D, /// Busca pelo Codigo - Ativos
--N, /// Busca pelo Nome - Existentes
--O /// Busca pelo Nome - Ativos
--*/

--if @Tipo = 'A' 
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo			
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--	End

--if  @Tipo = 'B'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE
--			US.Ck_Ativo = 1
--	End

--if @Tipo = 'C'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE
--			Cd_Usuario = @Cd_Usuario
--	End
	
	
--if @Tipo = 'D'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE
--			Cd_Usuario = @Cd_Usuario AND US.Ck_Ativo = 1
--	End	
	
	
--if @Tipo = 'N'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE 
--			Nome_Usuario = @Nome_Usuario
--	End
	
--if @Tipo = 'O'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE 
--			Nome_Usuario = @Nome_Usuario AND US.Ck_Ativo = 1
--	End

	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE		
--			Nome_Usuario = @Nome_Usuario AND Cd_Usuario <> @Cd_Usuario
--	End
	
	
--	--select 
--	--	Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--	--	Email [E-Mail],Grupo [Group],Ck_Ativo,Fone [Phone Number],
--	--	US.Cd_Area [Department Code], AR.nome_area [Department],
--	--	US.Cd_Idioma [Code Language],ID.Nome_Idioma [Code Language],
--	--	US.Cd_Nivel [Code Level],NV.Tipo_Nivel [Code Level]
--	--from usuario US		with(nolock)
--	--left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--	--left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--	--left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel*/

	
	
	SELECT 
			Cd_Usuario					[Code],
			Nome_Usuario				[Complete Name],
			 '********************'		[Password],
			Cargo						[Position],
			US.Cd_Area					[Department Code], 
			AR.nome_area				[Department],
			GR.ID_Tp_GR_Usuario			[Group Code],-- Alessandra 11/06/2020
			Grupo						[Group],
			US.Cd_Idioma				[Language Code],
			ID.Nome_Idioma				[Language],
			US.Cd_Nivel					[Level Code],
			NV.Tipo_Nivel				[Level],
			Fone						[Phone Number],
			Email						[E-Mail],
			ADDomain					[AD Domain], -- Alessandra 11/06/2020
			ADUserName					[AD User Name], -- Alessandra 11/06/2020	
			Ck_Ativo	*/
	
	
	--select 
	--	Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
	--	Email [E-Mail],Grupo [Group],Ck_Ativo,Fone [Phone Number],
	--	US.Cd_Area [Department Code], AR.nome_area [Department],
	--	US.Cd_Idioma [Code Language],ID.Nome_Idioma [Code Language],
	--	US.Cd_Nivel [Code Level],NV.Tipo_Nivel [Code Level]
	--from usuario US		with(nolock)
	--left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
	--left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
	--left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
	
	/*
	
	--spATLDN_Usuario_Sel 'ERBSON','','D'
--sp_help Usuario
ALTER procedure [dbo].[spATLDN_Usuario_Sel](
	@Cd_Usuario char(6),
	@Nome_Usuario varchar(30),
	@Tipo char(1)
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
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo			
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
	End

if  @Tipo = 'B'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE
			US.Ck_Ativo = 1
	End

if @Tipo = 'C'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE
			Cd_Usuario = @Cd_Usuario
	End
	
	
if @Tipo = 'D'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE
			Cd_Usuario = @Cd_Usuario AND US.Ck_Ativo = 1
	End	
	
	
if @Tipo = 'N'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE 
			Nome_Usuario = @Nome_Usuario
	End
	
if @Tipo = 'O'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE 
			Nome_Usuario = @Nome_Usuario AND US.Ck_Ativo = 1
	End

	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT 
			Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
			--US.Cd_Area [Department Code], 
			AR.nome_area [Department],
			Grupo [Group],
			--US.Cd_Idioma [Code Language],
			ID.Nome_Idioma [Language],
			--US.Cd_Nivel [Code Level],
			NV.Tipo_Nivel [Level],
			Fone [Phone Number],Email [E-Mail],Ck_Ativo
		FROM usuario US			with(nolock)
			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
		WHERE		
			Nome_Usuario = @Nome_Usuario AND Cd_Usuario <> @Cd_Usuario
	End
	
	
	--select 
	--	Cd_Usuario [Code],Nome_Usuario [Complete Name],'********************' AS Password,Cargo [Position],
	--	Email [E-Mail],Grupo [Group],Ck_Ativo,Fone [Phone Number],
	--	US.Cd_Area [Department Code], AR.nome_area [Department],
	--	US.Cd_Idioma [Code Language],ID.Nome_Idioma [Code Language],
	--	US.Cd_Nivel [Code Level],NV.Tipo_Nivel [Code Level]
	--from usuario US		with(nolock)
	--left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
	--left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
	--left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
	

	

	
	
----spATLDN_Usuario_Sel 'ERBSON','','D'
----sp_help Usuario
--ALTER procedure [dbo].[spATLDN_Usuario_Sel](
--	@Cd_Usuario char(6),
--	@Nome_Usuario varchar(30),
--	@Tipo char(1)
--)
--as

--/*
--A, /// Todos os registros - Existentes
--B, /// Todos os registros - Ativos
--C, /// Busca pelo Codigo - Existentes
--D, /// Busca pelo Codigo - Ativos
--N, /// Busca pelo Nome - Existentes
--O /// Busca pelo Nome - Ativos
--*/

--if @Tipo = 'A' 
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo			
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--	End

--if  @Tipo = 'B'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE
--			US.Ck_Ativo = 1
--	End

--if @Tipo = 'C'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE
--			Cd_Usuario = @Cd_Usuario
--	End
	
	
--if @Tipo = 'D'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE
--			Cd_Usuario = @Cd_Usuario AND US.Ck_Ativo = 1
--	End	
	
	
--if @Tipo = 'N'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE 
--			Nome_Usuario = @Nome_Usuario
--	End
	
--if @Tipo = 'O'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE 
--			Nome_Usuario = @Nome_Usuario AND US.Ck_Ativo = 1
--	End

	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		SELECT 
--			Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--			--US.Cd_Area [Department Code], 
--			AR.nome_area [Department],
--			Grupo [Group],
--			--US.Cd_Idioma [Code Language],
--			ID.Nome_Idioma [Language],
--			--US.Cd_Nivel [Code Level],
--			NV.Tipo_Nivel [Level],
--			Fone [Phone Number],Email [E-Mail],Ck_Ativo
--		FROM usuario US			with(nolock)
--			left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--			left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--			left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel
--		WHERE		
--			Nome_Usuario = @Nome_Usuario AND Cd_Usuario <> @Cd_Usuario
--	End
	
	
--	--select 
--	--	Cd_Usuario [Code],Nome_Usuario [Complete Name],Senha [Password],Cargo [Position],
--	--	Email [E-Mail],Grupo [Group],Ck_Ativo,Fone [Phone Number],
--	--	US.Cd_Area [Department Code], AR.nome_area [Department],
--	--	US.Cd_Idioma [Code Language],ID.Nome_Idioma [Code Language],
--	--	US.Cd_Nivel [Code Level],NV.Tipo_Nivel [Code Level]
--	--from usuario US		with(nolock)
--	--left Join Area AR	with(nolock) on AR.Cd_Area=US.Cd_Area
--	--left Join Idioma ID with(nolock) on ID.Cd_Idioma=US.Cd_Idioma
--	--left Join Nivel NV	with(nolock) on US.Cd_Nivel = NV.Cd_Nivel*/

GO
