SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Oper
CREATE procedure [dbo].[spATLDN_Tipo_Oper_Sel]
(
	@Cd_Tp_Oper		char(3),
	@Nome_Tp_Oper	varchar(30),
	@Tipo			char(1)
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
		SELECT O.Cd_Tp_Oper AS Code,
			--O.Nome_Tp_Oper AS [Freight Name],
			O.Nome_Tp_Oper AS [Incoterm Name],
			--O.Cd_Tp_Frete  as [Freight Type],
			O.Cd_Tp_Frete  as [Freight Type Code],
			F.Nome_Tp_Frete  as [Freight Type Name]
		from Tipo_Oper O with(nolock)
		left join tipo_frete F with(nolock) on F.Cd_Tp_Frete = O.Cd_Tp_Frete
		WHERE cd_tp_oper not in ('CSR','BDP')
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT O.Cd_Tp_Oper AS Code,
			--O.Nome_Tp_Oper AS [Freight Name],
			O.Nome_Tp_Oper AS [Incoterm Name],
			--O.Cd_Tp_Frete  as [Freight Type],
			O.Cd_Tp_Frete  as [Freight Type Code],
			F.Nome_Tp_Frete  as [Freight Type Name]
		from Tipo_Oper O with(nolock)
		left join tipo_frete F with(nolock) on F.Cd_Tp_Frete = O.Cd_Tp_Frete
		where Cd_Tp_Oper = @Cd_Tp_Oper AND  cd_tp_oper not in ('CSR','BDP')
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT O.Cd_Tp_Oper AS Code,
			--O.Nome_Tp_Oper AS [Freight Name],
			O.Nome_Tp_Oper AS [Incoterm Name],
			--O.Cd_Tp_Frete  as [Freight Type],
			O.Cd_Tp_Frete  as [Freight Type Code],
			F.Nome_Tp_Frete  as [Freight Type Name]
		from Tipo_Oper O with(nolock)
		left join tipo_frete F with(nolock) on F.Cd_Tp_Frete = O.Cd_Tp_Frete
		where Nome_Tp_Oper = @Nome_Tp_Oper AND  cd_tp_oper not in ('CSR','BDP')
	End
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT O.Cd_Tp_Oper AS Code,
			--O.Nome_Tp_Oper AS [Freight Name],
			O.Nome_Tp_Oper AS [Incoterm Name],
			--O.Cd_Tp_Frete  as [Freight Type],
			O.Cd_Tp_Frete  as [Freight Type Code],
			F.Nome_Tp_Frete  as [Freight Type Name]
		from Tipo_Oper O with(nolock)
		left join tipo_frete F with(nolock) on F.Cd_Tp_Frete = O.Cd_Tp_Frete
		where Nome_Tp_Oper = @Nome_Tp_Oper AND Cd_Tp_Oper <> @Cd_Tp_Oper
		AND  cd_tp_oper not in ('CSR','BDP')
	End

if @Tipo = 'P' or @Tipo = 'Q'
	Begin
		SELECT O.Cd_Tp_Oper AS Code,
			--O.Nome_Tp_Oper AS [Freight Name],
			O.Nome_Tp_Oper AS [Incoterm Name],
			--O.Cd_Tp_Frete  as [Freight Type],
			O.Cd_Tp_Frete  as [Freight Type Code],
			F.Nome_Tp_Frete  as [Freight Type Name]
		from Tipo_Oper O with(nolock)
		left join tipo_frete F with(nolock) on F.Cd_Tp_Frete = O.Cd_Tp_Frete
		where Nome_Tp_Oper = @Nome_Tp_Oper or Cd_Tp_Oper = @Cd_Tp_Oper
	End

GO
