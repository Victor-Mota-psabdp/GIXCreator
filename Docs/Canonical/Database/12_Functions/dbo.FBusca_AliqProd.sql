SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  function [dbo].[FBusca_AliqProd](
			@cd_prod	Varchar(40),
			@Tipo Varchar(3)
			
		)returns Float
AS 

BEGIN
	Declare @Valor Float
	if @Tipo='II'
		Begin
			Set @Valor=Isnull((select top 1 aliq_ii from nota_fiscal_cliente_Det where cd_produto=@cd_prod order by id_nf desc),0)
		End
	if @Tipo='IPI'
		Begin
			Set @Valor=Isnull((select top 1 aliq_ipi from nota_fiscal_cliente_Det where cd_produto=@cd_prod order by id_nf desc),0)
		End		
	if @Tipo='ICM'
		Begin
			Set @Valor=Isnull((select top 1 aliq_icms from nota_fiscal_cliente_Det where cd_produto=@cd_prod order by id_nf desc),0)
		End
	if @Tipo='PIS'
		Begin
			Set @Valor=Isnull((select top 1 VL_ALIQ_PIS from nota_fiscal_cliente_Det where cd_produto=@cd_prod order by id_nf desc),0)
		End
	if @Tipo='COF'
		Begin
			Set @Valor=Isnull((select top 1 VL_ALIQ_PIS from nota_fiscal_cliente_Det where cd_produto=@cd_prod order by id_nf desc),0)
		End

		return @Valor
END





GO
