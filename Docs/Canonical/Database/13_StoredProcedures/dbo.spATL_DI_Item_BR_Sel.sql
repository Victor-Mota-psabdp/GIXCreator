SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help exec spATL_DI_Item_BR_Sel 'IAAMZ201606001BR','127045', 'A'

/*
A - Todos os registros - Existentes
*/

CREATE procedure [dbo].[spATL_DI_Item_BR_Sel]
(
    @num_proc   varchar(16),
	@cd_produto int,
	@Tipo    	CHAR(1) 
)
as

Begin
        select 
		Num_Proc,
		Item,
		cd_Produto,
		PesoLiquido,
		PesoBruto,
		Vlr_Item,
		FOB_USD,
		FOB_Reais,
		Frete_USD,
		Frete_Reais,
		Seguro_USD,
		Seguro_Reais,
		Acrescimos_USD,
		Acrescimos_Reais,
		Aliq_IPI,
		IPI_Reais,
		Aliq_II,
		II_Reais,
		LI_PERIODICIDADE,
		VALOR_ANTIDUMP,
		Quantidade,
		Taxa_siscomex,
		FOB_Moeda,
		Frete_Moeda_Prepaid,
		Frete_Moeda_Collect,
		Frete_Moeda,
		Valor_CIF_Reais,
		Valor_II,
		Valor_IPI,
		Valor_ICMS,
		Valor_PIS,
		Valor_Cofins,
		Dt_Ins
	from 
	DI_Item_BR With(nolock)
	Where num_proc  = @num_proc
	And   cd_produto = @cd_produto
End
GO
