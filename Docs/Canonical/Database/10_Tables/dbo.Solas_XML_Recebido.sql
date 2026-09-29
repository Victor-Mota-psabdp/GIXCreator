SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Solas_XML_Recebido](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Nome_Arquivo] [varchar](500) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[Solas_XML_Recebido] ADD [ForwarderReferenceNumber] [varchar](200) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Solas_XML_Recebido] ADD [BookingNumber] [varchar](200) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Solas_XML_Recebido] ADD [MasterBillofLadingNumber] [varchar](200) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Solas_XML_Recebido] ADD [EquipmentInitial] [varchar](200) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Solas_XML_Recebido] ADD [EquipmentNumber] [varchar](200) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Solas_XML_Recebido] ADD [DocsRcvdDate] [varchar](200) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Solas_XML_Recebido] ADD [XML_DOC_Retorno] [varchar](max) COLLATE Latin1_General_CI_AI NULL
 CONSTRAINT [PK_Solas_XML_Recebido] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Solas_XML_Recebido] ADD  CONSTRAINT [DF_Solas_XML_Recebido_Dt_Ins]  DEFAULT (getdate()) FOR [Dt_Ins]
GO
