SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PO_Master](
	[Num_Proc_Master] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_PO_Master] [int] NOT NULL,
	[Numero_PO] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Data_PO] [datetime] NULL,
	[ID_DC] [int] NULL,
	[Nome_Arquivo] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio] [datetime] NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_PO_Master] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_Master] ASC,
	[ID_PO_Master] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PO_Master]  WITH CHECK ADD  CONSTRAINT [FK_PO_Master_LLP_Master] FOREIGN KEY([Num_Proc_Master])
REFERENCES [dbo].[LLP_Master] ([Num_Proc_Master])
GO
ALTER TABLE [dbo].[PO_Master] CHECK CONSTRAINT [FK_PO_Master_LLP_Master]
GO
ALTER TABLE [dbo].[PO_Master]  WITH CHECK ADD  CONSTRAINT [FK_PO_Master_Tipo_Doc_Cliente] FOREIGN KEY([ID_DC])
REFERENCES [dbo].[Tipo_Doc_Cliente] ([ID_DC])
GO
ALTER TABLE [dbo].[PO_Master] CHECK CONSTRAINT [FK_PO_Master_Tipo_Doc_Cliente]
GO
