SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Tipo_Documento
CREATE procedure [dbo].[spATL_Tipo_Documento_Sel]
(
	@Cd_Tp_Doc		varchar(3),
	@Nome_Tp_Doc	varchar(30),
	@Tipo			char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Statuss
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Statuss
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Statuss
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' 
	Begin
		select 
			Cd_Tp_Doc	[Code],
			Nome_Tp_Doc	[Document Type],
			Status		[Enabled] 
		from 
			Tipo_Documento with(nolock)
	End
	
if  @Tipo = 'B'
	Begin
		select 
			Cd_Tp_Doc	[Code],
			Nome_Tp_Doc	[Document Type],
			Status		[Enabled] 
		from 
			Tipo_Documento with(nolock)
		where 
			Status =1
	End

if @Tipo = 'C' 
	Begin
		select 
			Cd_Tp_Doc	[Code],
			Nome_Tp_Doc	[Document Type],
			Status		[Enabled] 
		from 
			Tipo_Documento with(nolock)
		where 
			Cd_Tp_Doc = @Cd_Tp_Doc
	End
if @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Doc	[Code],
			Nome_Tp_Doc	[Document Type],
			Status		[Enabled] 
		from 
			Tipo_Documento with(nolock)
		where 
			Cd_Tp_Doc = @Cd_Tp_Doc AND Status =1
	End
if @Tipo = 'N' 
	Begin
		select 
			Cd_Tp_Doc	[Code],
			Nome_Tp_Doc	[Document Type],
			Status		[Enabled] 
		from 
			Tipo_Documento with(nolock)
		where 
			Nome_Tp_Doc = @Nome_Tp_Doc
	End
if  @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Doc	[Code],
			Nome_Tp_Doc	[Document Type],
			Status		[Enabled] 
		from 
			Tipo_Documento with(nolock)
		where 
			Nome_Tp_Doc = @Nome_Tp_Doc AND Status =1
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Doc	[Code],
			Nome_Tp_Doc	[Document Type],
			Status		[Enabled] 
		from 
			Tipo_Documento with(nolock)
		where 
			Nome_Tp_Doc = @Nome_Tp_Doc
			 and Cd_Tp_Doc <> @Cd_Tp_Doc		
	End

GO
