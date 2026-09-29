SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Verdade_Sel]
(
	@Id			varChar(25),
	@Descricao	varChar(4),
	@Tipo	char(1)
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

if @Tipo = 'A'  or @Tipo = 'B'
	Begin		
		select Id [Code],Descricao from Verdade CP with(nolock)
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select Id [Code],Descricao from Verdade CP with(nolock)
		where 
			Id = @Id	
	End
	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select Id [Code],Descricao from Verdade CP with(nolock)
		--select Id,Descricao from Verdade CP with(nolock)	
		where 
			Descricao = @Descricao	
	End
	
if @Tipo = 'F'
	Begin
		select Id [Code],Descricao from Verdade CP with(nolock)
	End

GO
