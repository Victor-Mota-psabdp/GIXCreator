SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwJSON_Oxiteno_Purchaseorder_Sel]
AS
	select 
		P.dt_ins [Received Date],
		P.ID_Purchaseorder [Internal Code],
		P.nr_oc,
		P.data_oc,
		P.incoterm,
		P.moeda,
		P.status,
		P.exportador,
		P.modal,
		P.valor_total,
		P.pais_origem,
		P.pais_destino,
		P.cia,
		P.filial,
		P.nome_comprador,
		P.exportador_cod,
		P.exportador_end_cod,
		P.empresa_cod,
		P.empresa_cnpj,
		P.exportador_endereco,
		P.exportador_end_cidade,
		P.exportador_end_cep,
		--P.exportador_end_pais,
		(case when P.exportador_end_pais = 'USA' then 'United States' else P.exportador_end_pais end) exportador_end_pais,
		--[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](P.ID_Purchaseorder,'data_requisicao') Dt_Pedido,
		P.data_oc Dt_Pedido,
		[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](P.ID_Purchaseorder,'data_promessa') DL_Chegada,
	
		P.termo_pagamento,
		P.local_origem,
		P.local_destino,
		isnull(P.tipo_carga,'FCL') tipo_carga,
		P.area_compradora,

		P.[Message] Message,
		P.cd_pedido,

		P.Dt_Ins_JOB		[JOB Created Date],
		P.Num_Proc			[JOB],

		--LINE
		L.ID_Line  [Internal Line],
		L.nr_linha_oc,
		L.nr_entrega,
		L.data_requisicao,
		L.data_promessa,
		L.codigo_produto,
		L.descricao_produto,
		L.ncm,
		L.unidade_medida,
		L.quantidade,
		L.valor_unitario,
		L.valor_total_linha,
		L.nr_requisicao,
		L.etd_oc,
		L.eta_oc,
		--Informations Pre Defined
		PS.Cd_Pes					[Group Code],
		PS.Apelido					[Group Name],
		TP.cd_Tp_Pedido				[Type Code],
		TP.Nome_Tp_Pedido			[Type Name],
		TSP.Cd_Tp_Status_Pedido		[Status Code],
		TSP.Nome_Tp_Status_Pedido	[Status Name]	
	from ATL_INT.dbo.JSON_Oxiteno_Purchaseorder P with(nolock)
		join ATL_INT.dbo.JSON_Oxiteno_Purchaseorder_Line  L with(nolock) on P.ID_Purchaseorder=L.ID_Purchaseorder
		join Pessoa PS with(nolock) on PS.cd_pes = 'P21128'
		join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '2'
		join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'	
	Where
		P.dt_ins > '2022-09-06'
	

GO
