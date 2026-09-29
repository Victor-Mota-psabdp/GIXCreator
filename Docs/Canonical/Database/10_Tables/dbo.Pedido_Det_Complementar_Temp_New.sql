SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Pedido_Det_Complementar_Temp_New](
	[ID] [bigint] NOT NULL,
	[Item] [varchar](200) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_pedido] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[cd_produto] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Produto] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Lote] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_ins] [datetime] NULL,
	[Cd_Pes_Fabricante] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Pes_Fabricante] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pais_Fabricante] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Pais_Fabricante] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_FOB] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_TP_AC] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_AC] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_House_Temp] [bigint] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Pedido_Det_Complementar_Temp_New] ADD [ID_Req] [varchar](200) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Pedido_Det_Complementar_Temp_New] ADD [Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL
 CONSTRAINT [PK_Pedido_Det_Complementar_Temp_New] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
