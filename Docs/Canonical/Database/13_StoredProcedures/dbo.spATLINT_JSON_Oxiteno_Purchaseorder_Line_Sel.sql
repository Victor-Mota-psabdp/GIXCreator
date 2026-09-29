SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from ATL_INT.dbo.JSON_Oxiteno_Purchaseorder_Line
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_Purchaseorder_Line_Sel]--'CSR','Faturamento','z'
(
	@ID_Purchaseorder	bigint,
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
			ID_Purchaseorder [Internal Code],
			ID_Line,nr_linha_oc,nr_entrega,data_requisicao,data_promessa,codigo_produto,
			descricao_produto,ncm,unidade_medida,quantidade,valor_unitario,valor_total_linha
			,nr_requisicao,etd_oc,eta_oc
		from 
			ATL_INT.dbo.JSON_Oxiteno_Purchaseorder_Line with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			ID_Purchaseorder [Internal Code],
			ID_Line,nr_linha_oc,nr_entrega,data_requisicao,data_promessa,codigo_produto,
			descricao_produto,ncm,unidade_medida,quantidade,valor_unitario,valor_total_linha
			,nr_requisicao,etd_oc,eta_oc
		from 
			ATL_INT.dbo.JSON_Oxiteno_Purchaseorder_Line with(nolock)
		where 
			ID_Purchaseorder = @ID_Purchaseorder
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			ID_Purchaseorder [Internal Code],
			ID_Line,nr_linha_oc,nr_entrega,data_requisicao,data_promessa,codigo_produto,
			descricao_produto,ncm,unidade_medida,quantidade,valor_unitario,valor_total_linha
			,nr_requisicao,etd_oc,eta_oc
		from 
			ATL_INT.dbo.JSON_Oxiteno_Purchaseorder_Line with(nolock)
		where
			ID_Purchaseorder = @ID_Purchaseorder and
			ID_Line = @ID_Line
	End
	

	

GO
