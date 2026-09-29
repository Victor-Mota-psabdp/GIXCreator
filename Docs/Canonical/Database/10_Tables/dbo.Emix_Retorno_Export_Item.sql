SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Emix_Retorno_Export_Item](
	[ID] [bigint] NOT NULL,
	[ID_Item] [int] NOT NULL,
	[Campo] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Insert_Dt] [datetime] NULL,
	[Read_Dt] [datetime] NULL,
	[Dt_Create_ZIP] [datetime] NULL,
	[Dt_SendToPDF2ATL] [datetime] NULL,
	[Valor_ATL] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Emix_Retorno_Export_Item] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[ID_Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Emix_Retorno_Export_Item]  WITH CHECK ADD  CONSTRAINT [FK_Emix_Retorno_Export_Item_Emix_Retorno_Export] FOREIGN KEY([ID])
REFERENCES [dbo].[Emix_Retorno_Export] ([ID])
GO
ALTER TABLE [dbo].[Emix_Retorno_Export_Item] CHECK CONSTRAINT [FK_Emix_Retorno_Export_Item_Emix_Retorno_Export]
GO
