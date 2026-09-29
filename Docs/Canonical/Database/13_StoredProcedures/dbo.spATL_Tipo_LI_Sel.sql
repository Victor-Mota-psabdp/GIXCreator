SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_Tipo_LI_Sel '2','','F'
CREATE procedure [dbo].[spATL_Tipo_LI_Sel]
(
	@ID_Tipo int,
	@Nome_Tp_LI varchar(30),
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
		Select ID_Tipo [Code], Nome_Tp_LI [Type of LI] from Tipo_LI	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		Select ID_Tipo [Code], Nome_Tp_LI [Type of LI] from Tipo_LI
		where ID_Tipo = @ID_Tipo
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		Select ID_Tipo [Code], Nome_Tp_LI [Type of LI] from Tipo_LI
		where Nome_Tp_LI = @Nome_Tp_LI
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		Select ID_Tipo [Code], Nome_Tp_LI [Type of LI] from Tipo_LI
		where Nome_Tp_LI = @Nome_Tp_LI and ID_Tipo <> @ID_Tipo
	End
	
if @Tipo = 'F'
	Begin
		Select ID_Tipo [Code], LEFT(Nome_Tp_LI,3) [Type of LI] from Tipo_LI
		where 
		(Nome_Tp_LI = @Nome_Tp_LI OR ID_Tipo = @ID_Tipo)
		AND ID_Tipo IN (2,3)
	End

GO
