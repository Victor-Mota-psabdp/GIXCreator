SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Fatura](
	[FatCod] [varchar](17) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[FatDtVenc] [datetime] NOT NULL,
	[FatObs] [varchar](5000) COLLATE Latin1_General_CI_AI NULL,
	[FatStatus] [smallint] NULL,
	[FatDtEmissao] [datetime] NULL,
	[Vlr_Cont] [decimal](18, 2) NULL,
	[Dt_Cont] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Print] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Canc] [datetime] NULL,
	[Dt_Cont_Canc] [datetime] NULL,
	[dt_envio_ax] [datetime] NULL,
	[dt_envio_canc_ax] [datetime] NULL,
	[FatVendorInvoiceNumber] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_Fatura] ON [dbo].[Fatura]
(
	[FatCod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Fatura_01] ON [dbo].[Fatura]
(
	[FatStatus] ASC,
	[FatDtEmissao] ASC
)
INCLUDE([FatCod],[Cd_Pes],[FatDtVenc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Fatura] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
