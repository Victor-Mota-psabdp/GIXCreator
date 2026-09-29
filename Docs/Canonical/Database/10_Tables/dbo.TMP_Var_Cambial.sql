SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_Var_Cambial](
	[Processo] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Taxa] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[DC] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CredDev] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[Moeda] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[VlrOrigem] [decimal](10, 2) NULL,
	[Paridade] [float] NULL,
	[Dt_Pgto] [datetime] NULL,
	[Moeda_Opos] [char](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Ref] [decimal](10, 2) NULL,
	[Total_Pgto] [decimal](10, 2) NULL,
	[Machine] [varchar](20) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
