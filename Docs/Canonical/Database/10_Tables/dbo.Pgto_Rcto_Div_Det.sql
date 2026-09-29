SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pgto_Rcto_Div_Det](
	[Num_Lcto_Div] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cta_Ctb] [varchar](13) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Centro_Custo] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_Item] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Item] [decimal](10, 2) NOT NULL,
	[Cd_Hist_Pdr] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Compl_Hist] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Emissao] [datetime] NULL,
 CONSTRAINT [PK__Pgto_Rcto_Div_De__0E391C95] PRIMARY KEY NONCLUSTERED 
(
	[Num_Lcto_Div] ASC,
	[Cd_Cta_Ctb] ASC,
	[Cd_Centro_Custo] ASC,
	[DC_Item] ASC,
	[Num_NF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div_Det]  WITH CHECK ADD  CONSTRAINT [FK__Pgto_Rcto__Cd_Ce__2022C2A6] FOREIGN KEY([Cd_Centro_Custo])
REFERENCES [dbo].[Centro_Custo] ([Cd_Centro_Custo])
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div_Det] CHECK CONSTRAINT [FK__Pgto_Rcto__Cd_Ce__2022C2A6]
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div_Det]  WITH CHECK ADD  CONSTRAINT [FK__Pgto_Rcto__Cd_Ct__2116E6DF] FOREIGN KEY([Cd_Cta_Ctb])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div_Det] CHECK CONSTRAINT [FK__Pgto_Rcto__Cd_Ct__2116E6DF]
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div_Det]  WITH CHECK ADD  CONSTRAINT [FK__Pgto_Rcto__Cd_Hi__220B0B18] FOREIGN KEY([Cd_Hist_Pdr])
REFERENCES [dbo].[Historico_Padrao] ([Cd_Hist_Pdr])
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div_Det] CHECK CONSTRAINT [FK__Pgto_Rcto__Cd_Hi__220B0B18]
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div_Det]  WITH CHECK ADD  CONSTRAINT [FK__Pgto_Rcto__Num_L__3EE740E8] FOREIGN KEY([Num_Lcto_Div])
REFERENCES [dbo].[Pgto_Rcto_Div] ([Num_Lcto_Div])
GO
ALTER TABLE [dbo].[Pgto_Rcto_Div_Det] CHECK CONSTRAINT [FK__Pgto_Rcto__Num_L__3EE740E8]
GO
