SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vwJSON_Oxiteno_Salesorder_Sel]
AS

SELECT
	S.dt_ins [Received Date],S.ID_Salesorder [Internal Code],
	S.numero_pedido,
	S.Num_Proc JOB,
	S.cnpj,
	S.data_pedido_venda,
	S.cliente_codigo,
	S.cliente_nome,
	S.observacoes,
	S.pedido_cliente,
	S.forma_pagamento,
	S.incoterm,
	S.local_origem,
	S.local_destino,
	S.moeda,
	S.tipo_equipamento,
	S.tipo_carga,
	S.pais_destino,
	S.modal,	
	S.valor_total,
	S.seller,
	S.[Message] Message,
	L.ID_Line [Internal Line],
	L.item,L.item_codigo,
	L.descricao,
	L.un_number,
	L.quantidade,
	L.organizacao,
	L.data_prometida,
	L.preco_unitario,
	L.unid_medida,
	L.valor_unitario,
	L.quantidade_embalagem
	,L.peso_bruto,
	L.valor_frete,
	L.valor_rental,
	L.valor_total ValorTotalItem,
	L.data_liberacao,
	L.ncm,
	L.Peso_Liquido
	--Informations Pre Defined
	,P.Cd_Pes					[Group Code],
	P.Apelido					[Group Name],
	TP.cd_Tp_Pedido				[Type Code],
	TP.Nome_Tp_Pedido			[Type Name],
	TSP.Cd_Tp_Status_Pedido		[Status Code],
	TSP.Nome_Tp_Status_Pedido	[Status Name],
	PA.Cd_Pais					[Origin Code],
	PA.Nome_Pais				[Origin Name]
from ATL_INT.dbo.JSON_Oxiteno_Salesorder S with(nolock)
	join ATL_INT.dbo.JSON_Oxiteno_Salesorder_Line  L with(nolock) on S.ID_Salesorder=L.ID_Salesorder
	join Pessoa P with(nolock) on P.cd_pes = 'P21128'
	join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '3'
	join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
	join Pais PA with(nolock) on PA.Cd_Pais = 'BR'
	--join Tipo_Modal TM with(nolock) on TM.Id = 'S'
	

GO
