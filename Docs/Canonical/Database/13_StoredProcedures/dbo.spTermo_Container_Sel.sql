SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Termo_Container
CREATE procedure [dbo].[spTermo_Container_Sel](
	@cd_termo	int,
	@empresa	varchar(50),
	@Tipo		char(1)
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

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select cd_termo [Code], empresa [Complete Name] from Termo_Container	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		Select cd_termo [Code], empresa [Complete Name] from Termo_Container
		where cd_termo = @cd_termo
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		Select cd_termo [Code], empresa [Complete Name] from Termo_Container
		where empresa = @empresa
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		Select cd_termo [Code], empresa [Complete Name] from Termo_Container
		where empresa = @empresa and cd_termo <> @cd_termo
	End

GO
