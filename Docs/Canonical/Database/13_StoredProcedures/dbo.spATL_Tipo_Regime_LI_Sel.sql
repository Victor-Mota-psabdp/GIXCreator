SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Regime_LI
CREATE procedure [dbo].[spATL_Tipo_Regime_LI_Sel](
	@ID_Regime_LI int,
	@Regime_LI_Descricao varchar(50),
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
		select ID_Regime_LI [Code], Regime_LI_Descricao [Type of Regime Name] from Tipo_Regime_LI
	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select ID_Regime_LI [Code], Regime_LI_Descricao [Type of Regime Name] from Tipo_Regime_LI
		where ID_Regime_LI = @ID_Regime_LI
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select ID_Regime_LI [ID Regime], Regime_LI_Descricao [Type of Regime Name] from Tipo_Regime_LI
		where Regime_LI_Descricao = @Regime_LI_Descricao
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select ID_Regime_LI [Code], Regime_LI_Descricao [Type of Regime Name] from Tipo_Regime_LI
		where Regime_LI_Descricao = @Regime_LI_Descricao and ID_Regime_LI <> @ID_Regime_LI
	End

GO
