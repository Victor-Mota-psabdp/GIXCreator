SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help NCM
CREATE Procedure [dbo].[spATLDN_NCM_Sel]
(
	--@Id_NCM		int,
	@NCM		varchar(20),
	@Tipo		char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes - Order
D, /// Busca pelo Codigo - Ativos - Order
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			Id_NCM [Code],
			N.NCM [NCM],
			N.NCM [NCM Code],Descricao_NCM[NCM Description],
			Alterado [Changed],Vencimento [Due Date],
			N.cd_usuario [User Code],
			U.nome_usuario	[User Name],
			DT_INS [Insert Date],
			Excecao [Exception]
		from NCM N with(nolock)
			left join Usuario U on U.cd_usuario = N.cd_usuario
	End

--if @Tipo = 'C' or @Tipo = 'D'
--	Begin
--		select 
--			Id_NCM [Code],N.NCM [NCM],N.NCM [NCM Code],Descricao_NCM[NCM Description],
--			Alterado [Changed],Vencimento [Due Date],
--			N.cd_usuario [User Code],
--			U.nome_usuario	[User Name],
--			DT_INS [Insert Date],
--			Excecao [Exception]
--		from NCM N with(nolock)
--			left join Usuario U on U.cd_usuario = N.cd_usuario
--		where 
--			Id_NCM = @Id_NCM
--	End	
	
--if @Tipo = 'N' or @Tipo = 'O'
if @Tipo = 'C' or @Tipo = 'D' or @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			Id_NCM [Code],N.NCM [NCM],N.NCM [NCM Code],Descricao_NCM[NCM Description],
			Alterado [Changed],Vencimento [Due Date],
			N.cd_usuario [User Code],
			U.nome_usuario	[User Name],
			DT_INS [Insert Date],
			Excecao [Exception]
		from NCM N with(nolock)
			left join Usuario U on U.cd_usuario = N.cd_usuario
		where 
			N.NCM = @NCM
	End	
GO
