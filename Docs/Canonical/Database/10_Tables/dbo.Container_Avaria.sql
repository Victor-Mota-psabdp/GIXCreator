SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Container_Avaria](
	[Codigo] [bigint] NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Termo] [datetime] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[BL] [varchar](25) COLLATE Latin1_General_CI_AI NOT NULL,
	[Container] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desc_Lavagem] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Valor_Termo] [decimal](10, 2) NULL,
	[Qty_Avaria] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Desc_Avaria] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Qty_Avaria_2] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Desc_Avaria_2] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Qty_Avaria_3] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Desc_Avaria_3] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Tp_Termo] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Armador] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Taxa_Indisponibilidade_Container] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Container_Avaria] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
