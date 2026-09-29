SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Taxa_AX
CREATE procedure [dbo].[spATL_Tipo_Taxa_AX_Sel](
	@Cd_Charge_AX		varchar(5),
	@Descricao_Ingles	varchar(50),
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
		select Cd_Charge_AX [Code], Descricao_Ingles, CC_Custo,
			CC_Receita, Descricao_Local,CD_Charge_AX_PT,Codigo_Imposto,Codidgo_Imposto_Venda
		from 
			Tipo_Taxa_AX with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Cd_Charge_AX [Code], Descricao_Ingles, CC_Custo,
			CC_Receita, Descricao_Local,CD_Charge_AX_PT,Codigo_Imposto,Codidgo_Imposto_Venda
		from 
			Tipo_Taxa_AX with(nolock)
		where 
			Cd_Charge_AX = @Cd_Charge_AX
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Cd_Charge_AX [Code], Descricao_Ingles, CC_Custo,
			CC_Receita, Descricao_Local,CD_Charge_AX_PT,Codigo_Imposto,Codidgo_Imposto_Venda
		from 
			Tipo_Taxa_AX with(nolock)
		where 
			Descricao_Ingles = @Descricao_Ingles
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select Cd_Charge_AX [Code], Descricao_Ingles, CC_Custo,
			CC_Receita, Descricao_Local,CD_Charge_AX_PT,Codigo_Imposto,Codidgo_Imposto_Venda
		from 
			Tipo_Taxa_AX with(nolock)
		where 
			Descricao_Ingles = @Descricao_Ingles
			AND Cd_Charge_AX <> @Cd_Charge_AX
	End

GO
