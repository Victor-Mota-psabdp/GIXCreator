SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AX_DOC_Oracle](
	[ID_AX] [bigint] IDENTITY(1,1) NOT NULL,
	[Dimensao_1] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_2] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_3] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_4] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_5] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_6] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_7] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [int] NULL,
	[NumeroInternoAX] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pessoa_AX] [int] NULL,
	[AccountType] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Aprovado] [bit] NULL,
	[Aprovado_por] [varchar](35) COLLATE Latin1_General_CI_AI NULL,
	[Data_Aprovacao] [datetime] NULL,
	[Company] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Documento] [datetime] NULL,
	[Numero_Documento] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Vencimento] [datetime] NULL,
	[Invoice_Number] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[TaxGroup] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[TaxItemGroup] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Dt_Envio_AX] [datetime] NULL,
	[Obs_AX] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [bit] NULL,
	[Dt_Canc] [datetime] NULL,
	[dt_canc_ax] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
