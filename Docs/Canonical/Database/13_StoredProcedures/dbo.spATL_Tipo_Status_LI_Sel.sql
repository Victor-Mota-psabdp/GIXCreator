SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Tipo_Status_LI_Sel](
	@ID_Status_LI int,
	@Status_LI_Descricao varchar(50),
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

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select ID_Status_LI [Code], Status_LI_Descricao [Status LI Description] from Tipo_Status_LI	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select ID_Status_LI [Code], Status_LI_Descricao [Status LI Description] from Tipo_Status_LI	
		where ID_Status_LI = @ID_Status_LI
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select ID_Status_LI [Code], Status_LI_Descricao [Status LI Description] from Tipo_Status_LI	
		where Status_LI_Descricao = @Status_LI_Descricao
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select ID_Status_LI [Code], Status_LI_Descricao [Status LI Description] from Tipo_Status_LI	
		where Status_LI_Descricao = @Status_LI_Descricao and ID_Status_LI <> @ID_Status_LI
	End

GO
