SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Hist_Geral_2008](
	[HSGProcesso] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[HSGSeq] [int] NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Ocor] [int] NOT NULL,
	[HSDDescricao] [varchar](2000) COLLATE Latin1_General_CI_AI NOT NULL,
	[HSGData] [datetime] NOT NULL,
	[HSGDataFU] [datetime] NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[HSGDataConf] [datetime] NULL,
	[Disp_Cliente] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Origem] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[ID_NC] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Hist_Geral_ATL] PRIMARY KEY CLUSTERED 
(
	[HSGProcesso] ASC,
	[HSGSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Hist_Geral_2008]  WITH NOCHECK ADD  CONSTRAINT [FK_Hist_Geral_ATL_Tipo_Ocorrencia] FOREIGN KEY([Cd_Tp_Ocor])
REFERENCES [dbo].[Tipo_Ocorrencia] ([Cd_Tp_Ocor])
GO
ALTER TABLE [dbo].[Hist_Geral_2008] CHECK CONSTRAINT [FK_Hist_Geral_ATL_Tipo_Ocorrencia]
GO
ALTER TABLE [dbo].[Hist_Geral_2008]  WITH NOCHECK ADD  CONSTRAINT [FK_Hist_Geral_ATL_Usuario] FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
ALTER TABLE [dbo].[Hist_Geral_2008] CHECK CONSTRAINT [FK_Hist_Geral_ATL_Usuario]
GO
ALTER TABLE [dbo].[Hist_Geral_2008]  WITH NOCHECK ADD  CONSTRAINT [FK_Hist_GeralATL_Pessoa] FOREIGN KEY([Cd_Pes])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Hist_Geral_2008] CHECK CONSTRAINT [FK_Hist_GeralATL_Pessoa]
GO
