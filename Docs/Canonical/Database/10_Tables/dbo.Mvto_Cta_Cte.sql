SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Mvto_Cta_Cte](
	[Num_Lcto_Mov] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Banco] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Agencia] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cta_Cte] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_Mov] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Pgto_Rcto_Mov] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Doc_Mov] [decimal](10, 2) NOT NULL,
	[Concil_Mov] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ctb_Mvto] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Historico] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY NONCLUSTERED 
(
	[Num_Lcto_Mov] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Mvto_Cta_Cte]  WITH CHECK ADD FOREIGN KEY([Cd_Banco], [Cd_Agencia], [Num_Cta_Cte])
REFERENCES [dbo].[Cta_Cte] ([Cd_Banco], [Cd_Agencia], [Num_Cta_Cte])
GO
