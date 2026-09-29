SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Temp_SAPSUN](
	[Company Code] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Purchasing Document Type] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Purchasing_Document_Number] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Item_Number] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Name of Person who Created the Object] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Item category in purchasing document] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Vendor's account number
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Name
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Country Key
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Plant
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Purchasing group] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Purchasing Document Date
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Material group] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Material_Number] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Short text
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Purchase order quantity
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Order unit
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Net order value in PO currency
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Currency Key
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Item delivery date
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Confirmation category
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Delivery date of vendor confirmation
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Deletion indicator in purchasing documen
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Tracking_Number] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Confirmation control key
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Order acknowledgment requirement
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Goods Receipt Indicator
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Quantity of goods received] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Percent Delivere
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[OPEN/ CLOSED
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Status] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Broker
] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Broker_Reference] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[INCOTERM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_EMBARQUE] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NOME_EMBARCACAO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NUMERO_CONHECIMENTO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[MOEDA_FRETE] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[VALOR_FRETE_DECLARADO_CONHECIMENTO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NUMERO_CONTAINER] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[NOME_ARMADOR] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NOME_AGENTE_CARGAS] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[FREE_TIME_CONTAINER] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_CHEGADA] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_INVOICE] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NUMERO_INVOICE] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[MOEDA] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[VALOR_TOTAL_INVOICE] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_VENCIMENTO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_PAGAMENTO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NUMERO_CONTRATO_CAMBIO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NOME_TERMINAL_NAVIO_ATRACOU] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NOME_TERMINAL_CARGA_LIBERADA] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[LIBERACAO_CONTAINER] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_DEVOLUCAO_CONTAINER] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DIAS_DEMURRAGE_PAGAR] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_SOLICITACAO_NUMERARIO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[VALOR_DEPOSITADO_CONTA_DESPACHANTE] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[VALOR_ICMS_PREVISTO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[VALOR_DEBITO_CONTA_PREVISTO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_APROVACAO_NUMERARIO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_PAGAMENTO_VALOR_DESPACHANTE] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_AUTORIZACAO_REGISTRO_DI] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_DI] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NUMERO_DI] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_LIBERACAO_DI] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_ENVIO_DRAFT_NF] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_ENVIO_NF_DESPACHANTE] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NUMERO_NF] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[DATA_ENTREGA_DOCS_TRANSPORTADORA_CARREGAR] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_CARREGAMENTO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_ENTREGA_FABRICA] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ICMS_CONHECIMENTO_TRANSPORTE] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_ENTRADA_PROCESSO_SISTEMA] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_ENVIO_PRESTACAO_CONTAS] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[VALOR_ACERTAR] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DATA_PAGAMENTO_SALDO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ICMS_REALIZADO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DEBITO_EM_CONTA_REALIZADO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CRONOLOGIA] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Material] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Quantidade] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Stock In Transit] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
