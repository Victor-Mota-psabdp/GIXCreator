SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_Prosoft](
	[IDMachine] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Doc] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Doc_Compl] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Doc] [datetime] NOT NULL,
	[DC_Doc] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_Tax] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cta_Ctb] [char](5) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Lcto] [decimal](14, 2) NOT NULL,
	[CCusto] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Historico] [varchar](240) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
