SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pedido_Det_Perigoso_Temp](
	[ID] [bigint] NOT NULL,
	[Item] [varchar](200) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_pedido] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[cd_produto] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Produto] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Lote] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAZMAT_CD] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAZMAT_CLASS_CD] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAZMAT_DESC] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[HAZMAT_CONTACT] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAZMAT_PAGE] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAZMAT_FPOINT] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAZMAT_FPOINT_CD] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAZMAT_PULL_DESC_FRM_BDP] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAZMAT_ORG_DESC] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAZMAT_DESC_QUAL] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_House_Temp] [bigint] NOT NULL,
	[ID_Req] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Pedido_Det_Perigoso_Temp] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
