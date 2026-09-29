SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Pgto_Rcto_Div](
	[Num_Lcto_Div] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Banco] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Agencia] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cta_Cte] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_Div] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Pgto_Rcto_Div] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Forma_Pgto_Rcto_Div] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Pgto_Rcto_Div] ADD [Num_Doc_Div] [varchar](12) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Pgto_Rcto_Div] ADD [Vlr_Doc_Div] [decimal](10, 2) NOT NULL
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[Pgto_Rcto_Div] ADD [Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL
ALTER TABLE [dbo].[Pgto_Rcto_Div] ADD [Dt_Vcto_Div] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL
ALTER TABLE [dbo].[Pgto_Rcto_Div] ADD [Concil_Div] [char](1) COLLATE Latin1_General_CI_AI NOT NULL
ALTER TABLE [dbo].[Pgto_Rcto_Div] ADD [Cta_Cte_Cliente_Div] [varchar](50) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Pgto_Rcto_Div] ADD [Ck_Doctos] [bit] NOT NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Pgto_Rcto_Div] ADD [sispag] [varchar](15) COLLATE Latin1_General_CI_AI NULL
PRIMARY KEY NONCLUSTERED 
(
	[Num_Lcto_Div] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div] ADD  DEFAULT (0) FOR [Ck_Doctos]
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div]  WITH NOCHECK ADD  CONSTRAINT [FK__Pgto_Rcto__Cd_Pe__42B7D1CC] FOREIGN KEY([Cd_Pes])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div] CHECK CONSTRAINT [FK__Pgto_Rcto__Cd_Pe__42B7D1CC]
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div]  WITH CHECK ADD FOREIGN KEY([Cd_Banco], [Cd_Agencia], [Num_Cta_Cte])
REFERENCES [dbo].[Cta_Cte] ([Cd_Banco], [Cd_Agencia], [Num_Cta_Cte])
GO
