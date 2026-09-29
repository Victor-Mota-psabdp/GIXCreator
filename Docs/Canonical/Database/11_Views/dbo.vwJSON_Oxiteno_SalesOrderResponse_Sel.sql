SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwJSON_Oxiteno_SalesOrderResponse_Sel]
AS

	select 
		S.dt_ins [Received Date],
		S.ID_SalesOrderResponse [Internal Code],
		S.sales_order,
		S.seller,
		S.data_recebimento_processo,
		S.data_carregamento,
		S.doc_embarque,
		S.buyer_consignee,
		S.destination_country,
		S.[type],
		S.peso_liquido_total,
		S.peso_bruto_total,

		S.Message, S.Dt_Ins_JOB,S.Num_Proc [JOB],S.incoterm,S.moeda,S.inland_trucker,S.agent,S.viagem,S.navio,
		S.modal,S.terminal,S.porto_embarque,S.porto_destino,S.due,S.data_due,

		L.ID_Line [Internal Line],
		L.item,
		L.nota_fiscal,
		L.data_nota_fiscal,
		L.qty,
		L.peso_bruto,
		L.ncm,L.peso_liquido,L.preco_unitario,L.valor_frete,L.invoice_value,L.comissao_agente
	from 
		ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse S with(nolock)
		join ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse_Line  L with(nolock) on S.ID_SalesOrderResponse=L.ID_SalesOrderResponse
	

GO
