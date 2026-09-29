SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help vwTipo_Modal_Taxa

CREATE procedure [dbo].[spvwTipo_Modal_Taxa_Sel]--null,'Teste','Z'
(
	@Code	varchar(1),
	@Modal_Type_Name varchar(10),
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

if @Tipo = 'A'  OR @TIPO = 'B'
	Begin
		select 
			Code,Modal_Type_Name [Modal Type Name]
		from vwTipo_Modal_Taxa T with(nolock)			
	End
	
if @Tipo = 'C'  OR @TIPO = 'D'
	Begin
		select 
			Code,Modal_Type_Name [Modal Type Name]
		from vwTipo_Modal_Taxa T with(nolock)	
		WHERE 	Code = @CODE		
	End
	
if @Tipo = 'N'  OR @TIPO = 'O'
	Begin
		select 
			Code,Modal_Type_Name [Modal Type Name]
		from vwTipo_Modal_Taxa T with(nolock)	
		WHERE 	Modal_Type_Name = @Modal_Type_Name	
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Code,Modal_Type_Name [Modal Type Name]
		from vwTipo_Modal_Taxa T with(nolock)
		where
			Modal_Type_Name = @Modal_Type_Name
			AND Code <> isnull(@Code,'')
	End

GO
