SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Requerimento](
	[ID_Req] [int] NOT NULL,
	[Numero_Requerimento] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Consig_Req] [nchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[UoM_Req] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Quant_Req] [float] NOT NULL,
	[Dt_Req] [datetime] NOT NULL,
	[Dt_Vencimento_Req] [datetime] NOT NULL,
	[ID_Produto] [int] NULL,
 CONSTRAINT [PK_Requerimento] PRIMARY KEY CLUSTERED 
(
	[ID_Req] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Requerimento]  WITH CHECK ADD  CONSTRAINT [FK_Requerimento_Requerimento] FOREIGN KEY([ID_Req])
REFERENCES [dbo].[Requerimento] ([ID_Req])
GO
ALTER TABLE [dbo].[Requerimento] CHECK CONSTRAINT [FK_Requerimento_Requerimento]
GO
