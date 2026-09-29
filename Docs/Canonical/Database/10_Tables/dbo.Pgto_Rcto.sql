SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Pgto_Rcto](
	[Num_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Banco] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Agencia] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cta_Cte] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Pgto_Rcto] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Forma_Pgto_Rcto] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Doc] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Doc] [decimal](10, 2) NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Vcto] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Concil] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cta_Cte_Cliente] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Pgto_Rcto] ADD [Ck_Doctos] [char](1) COLLATE Latin1_General_CI_AI NOT NULL
ALTER TABLE [dbo].[Pgto_Rcto] ADD [cd_centro_custo] [varchar](5) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Pgto_Rcto] ADD [cd_bancoTerceros] [varchar](3) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Pgto_Rcto] ADD [sispag] [varchar](15) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Pgto_Rcto] ADD [cd_usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Pgto_Rcto] ADD [Last_UPD] [datetime] NULL
PRIMARY KEY CLUSTERED 
(
	[Num_Lcto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Pgto_Rcto] ADD  CONSTRAINT [DF_Pgto_Rcto_Ck_Doctos]  DEFAULT ('N') FOR [Ck_Doctos]
GO
ALTER TABLE [dbo].[Pgto_Rcto]  WITH CHECK ADD FOREIGN KEY([Cd_Banco], [Cd_Agencia], [Num_Cta_Cte])
REFERENCES [dbo].[Cta_Cte] ([Cd_Banco], [Cd_Agencia], [Num_Cta_Cte])
GO
ALTER TABLE [dbo].[Pgto_Rcto]  WITH NOCHECK ADD  CONSTRAINT [FK__Pgto_Rcto__Cd_Pe__3FDB6521] FOREIGN KEY([Cd_Pes])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Pgto_Rcto] CHECK CONSTRAINT [FK__Pgto_Rcto__Cd_Pe__3FDB6521]
GO
