SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from ATL_INT.dbo.JSON_Oxiteno_Salesorder_Line
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_Salesorder_Line_Sel]--'CSR','Faturamento','z'
(
	@ID_Salesorder	bigint,
	@ID_Line		bigint,
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
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			ID_Salesorder [Internal Code],
			ID_Line,item,item_codigo,descricao,un_number,quantidade,organizacao,
			data_prometida,preco_unitario,unid_medida,valor_unitario,quantidade_embalagem
			,peso_bruto,valor_frete,valor_rental,valor_total,data_liberacao
			,ncm,Peso_Liquido
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder_Line with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			ID_Salesorder [Internal Code],
			ID_Line,item,item_codigo,descricao,un_number,quantidade,organizacao,
			data_prometida,preco_unitario,unid_medida,valor_unitario,quantidade_embalagem
			,peso_bruto,valor_frete,valor_rental,valor_total,data_liberacao
			,ncm,Peso_Liquido
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder_Line with(nolock)
		where 
			ID_Salesorder = @ID_Salesorder
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			ID_Salesorder [Internal Code],
			ID_Line,item,item_codigo,descricao,un_number,quantidade,organizacao,
			data_prometida,preco_unitario,unid_medida,valor_unitario,quantidade_embalagem
			,peso_bruto,valor_frete,valor_rental,valor_total,data_liberacao
			,ncm,Peso_Liquido
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder_Line with(nolock)
		where 
			ID_Salesorder = @ID_Salesorder and
			ID_Line = @ID_Line
	End
	


	

GO
