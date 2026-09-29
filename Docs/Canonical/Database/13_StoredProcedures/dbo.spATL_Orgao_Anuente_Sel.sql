SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Orgao_Anuente
CREATE procedure [dbo].[spATL_Orgao_Anuente_Sel]
(
	@ID_Orgao	int,
	@Nome_Orgao_Anuente varchar(60),
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
		select ID_Orgao [Code],Nome_Orgao_Anuente [Orgao Anuente Name] 
		from Orgao_Anuente with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select ID_Orgao [Code],Nome_Orgao_Anuente [Orgao Anuente Name] from Orgao_Anuente with(nolock)
		where ID_Orgao = @ID_Orgao
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select ID_Orgao [Code],Nome_Orgao_Anuente [Orgao Anuente Name] from Orgao_Anuente  with(nolock)
		where Nome_Orgao_Anuente = @Nome_Orgao_Anuente
	End
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select ID_Orgao [Code],Nome_Orgao_Anuente [Orgao Anuente Name] from Orgao_Anuente  with(nolock)
		where Nome_Orgao_Anuente = @Nome_Orgao_Anuente AND ID_Orgao <> @ID_Orgao
	End

GO
