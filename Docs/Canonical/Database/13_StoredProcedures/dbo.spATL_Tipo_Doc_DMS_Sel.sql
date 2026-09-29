SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Doc_DMS
CREATE procedure [dbo].[spATL_Tipo_Doc_DMS_Sel]
(
	@ID_TP_DC	BIGINT,
	@DMS_Code varchar(5),
	@Document_Type_Name varchar(250),
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
		select
			T.ID_TP_DC				[Code],
			T.DMS_Code				[DMS Code],
			T.Document_Type_Name	[Document Type Name],
			T.ID_DC					[Doc Client Type Code],
			TD.Nome_DC				[Doc Client Type Name],
			T.Role					[Role],
			T.Comment				[Comment],			
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Doc_DMS T with(nolock)
			LEFT join TIPO_DOC_CLIENTE TD with(nolock) on TD.ID_DC=T.ID_DC
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select
			T.ID_TP_DC				[Code],
			T.DMS_Code				[DMS Code],
			T.Document_Type_Name	[Document Type Name],
				T.ID_DC					[Doc Client Type Code],
			TD.Nome_DC				[Doc Client Type Name],
			T.Role					[Role],
			T.Comment				[Comment],
		
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Doc_DMS T with(nolock)
			LEFT join TIPO_DOC_CLIENTE TD with(nolock) on TD.ID_DC=T.ID_DC
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.ativo = 1
	End

if @Tipo = 'C'
	Begin
		select
			T.ID_TP_DC				[Code],
			T.DMS_Code				[DMS Code],
			T.Document_Type_Name	[Document Type Name],
				T.ID_DC					[Doc Client Type Code],
			TD.Nome_DC				[Doc Client Type Name],
			T.Role					[Role],
			T.Comment				[Comment],
		
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Doc_DMS T with(nolock)
			LEFT join TIPO_DOC_CLIENTE TD with(nolock) on TD.ID_DC=T.ID_DC
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where			
			T.ID_TP_DC = @ID_TP_DC
	End
	
if @Tipo = 'D'
	Begin
		select
			T.ID_TP_DC				[Code],
			T.DMS_Code				[DMS Code],
			T.Document_Type_Name	[Document Type Name],
			T.ID_DC					[Doc Client Type Code],
			TD.Nome_DC				[Doc Client Type Name],
			T.Role					[Role],
			T.Comment				[Comment],
			
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Doc_DMS T with(nolock)
			LEFT join TIPO_DOC_CLIENTE TD with(nolock) on TD.ID_DC=T.ID_DC
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where			
			T.DMS_Code = @DMS_Code and
			ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select
			T.ID_TP_DC				[Code],
			T.DMS_Code				[DMS Code],
			T.Document_Type_Name	[Document Type Name],
			T.ID_DC					[Doc Client Type Code],
			TD.Nome_DC				[Doc Client Type Name],
			T.Role					[Role],
			T.Comment				[Comment],
			
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Doc_DMS T with(nolock)
			LEFT join TIPO_DOC_CLIENTE TD with(nolock) on TD.ID_DC=T.ID_DC
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where			
			T.Document_Type_Name = @Document_Type_Name 

	End
	
if @Tipo = 'O'
	Begin
		select
			T.ID_TP_DC				[Code],
			T.DMS_Code				[DMS Code],
			T.Document_Type_Name	[Document Type Name],
			T.ID_DC					[Doc Client Type Code],
			TD.Nome_DC				[Doc Client Type Name],
			T.Role					[Role],
			T.Comment				[Comment],
			
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Doc_DMS T with(nolock)
			LEFT join TIPO_DOC_CLIENTE TD with(nolock) on TD.ID_DC=T.ID_DC
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where			
			T.Document_Type_Name = @Document_Type_Name and
			ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select
			T.ID_TP_DC				[Code],
			T.DMS_Code				[DMS Code],
			T.Document_Type_Name	[Document Type Name],
				T.ID_DC					[Doc Client Type Code],
			TD.Nome_DC				[Doc Client Type Name],
			T.Role					[Role],
			T.Comment				[Comment],
		
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Doc_DMS T with(nolock)
			LEFT join TIPO_DOC_CLIENTE TD with(nolock) on TD.ID_DC=T.ID_DC
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where			
			T.Document_Type_Name = @Document_Type_Name			
			AND T.DMS_Code <> @DMS_Code
	End

GO
