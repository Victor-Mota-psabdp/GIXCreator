SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Tipo_TaxaXTipo_NF_Doc_Register](
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_site] [char](1) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Tipo_TaxaXTipo_NF_Doc_Register] ADD [Descricao] [varchar](500) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Tipo_TaxaXTipo_NF_Doc_Register] ADD [cd_servico] [bigint] NULL
ALTER TABLE [dbo].[Tipo_TaxaXTipo_NF_Doc_Register] ADD [Item_lei] [varchar](50) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Tipo_TaxaXTipo_NF_Doc_Register] ADD [CNAE] [varchar](25) COLLATE Latin1_General_CI_AI NULL
PRIMARY KEY NONCLUSTERED 
(
	[Cd_Tp_Tx] ASC,
	[cd_site] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tipo_TaxaXTipo_NF_Doc_Register]  WITH CHECK ADD  CONSTRAINT [FK__Tipo_Taxa__cd_si__5900DCB0] FOREIGN KEY([cd_site])
REFERENCES [dbo].[Site] ([Cd_Site])
GO
ALTER TABLE [dbo].[Tipo_TaxaXTipo_NF_Doc_Register] CHECK CONSTRAINT [FK__Tipo_Taxa__cd_si__5900DCB0]
GO
