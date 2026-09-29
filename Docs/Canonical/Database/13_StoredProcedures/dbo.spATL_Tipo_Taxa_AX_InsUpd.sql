SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Taxa_AX
CREATE PROCEDURE [dbo].[spATL_Tipo_Taxa_AX_InsUpd]
(
	@Cd_Charge_AX		varchar(5),
	@Descricao_Ingles	varchar(50),
	@CC_Custo			varchar(25),
	@CC_Receita			varchar(25),
	@Descricao_Local	varchar(50),
	@CD_Charge_AX_PT	varchar(5),
	@Codigo_Imposto		varchar(10),
	@Codidgo_Imposto_Venda varchar(20)
)

AS

Begin Transaction

	If  exists (select Cd_Charge_AX from Tipo_Taxa_AX where Cd_Charge_AX=@Cd_Charge_AX)
		Begin
			Update
				Tipo_Taxa_AX
			Set
				Descricao_Ingles=@Descricao_Ingles,
				CC_Custo=@CC_Custo,
				CC_Receita=@CC_Receita,
				Descricao_Local=@Descricao_Local,
				CD_Charge_AX_PT=@CD_Charge_AX_PT,
				Codigo_Imposto=@Codigo_Imposto,
				Codidgo_Imposto_Venda=@Codidgo_Imposto_Venda
			Where
				Cd_Charge_AX=@Cd_Charge_AX
		End
	Else
		Insert
			Tipo_Taxa_AX(Cd_Charge_AX,Descricao_Ingles,CC_Custo,CC_Receita,Descricao_Local,CD_Charge_AX_PT,Codigo_Imposto,Codidgo_Imposto_Venda)

		Values
			(@Cd_Charge_AX,@Descricao_Ingles,@CC_Custo,@CC_Receita,@Descricao_Local,@CD_Charge_AX_PT,@Codigo_Imposto,@Codidgo_Imposto_Venda)
	

Commit Transaction

GO
