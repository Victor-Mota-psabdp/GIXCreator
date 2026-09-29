SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse_Line
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_SalesOrderResponse_Line_Sel]--'','','A'
(
	@ID_SalesOrderResponse	bigint,
	@ID_Line				bigint,
	@Tipo					char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			ID_SalesOrderResponse [Internal Code],
			ID_Line,item,nota_fiscal,data_nota_fiscal,qty,peso_bruto
			,ncm,peso_liquido,
			preco_unitario,valor_frete,invoice_value,comissao_agente
		from 
			ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse_Line with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			ID_SalesOrderResponse [Internal Code],
			ID_Line,item,nota_fiscal,data_nota_fiscal,qty,peso_bruto
			,ncm,peso_liquido,
			preco_unitario,valor_frete,invoice_value,comissao_agente
		from 
			ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse_Line with(nolock)
		where 
			ID_SalesOrderResponse = @ID_SalesOrderResponse
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			ID_SalesOrderResponse [Internal Code],
			ID_Line,item,nota_fiscal,data_nota_fiscal,qty,peso_bruto
			,ncm,peso_liquido,
			preco_unitario,valor_frete,invoice_value,comissao_agente
		from 
			ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse_Line with(nolock)
		where
			ID_SalesOrderResponse = @ID_SalesOrderResponse and
			ID_Line = @ID_Line
	End

GO
