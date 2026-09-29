SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_Imp_Bco](
	[StrMachine] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Lcto] [datetime] NOT NULL,
	[Historico_Lcto] [varchar](300) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Lcto] [decimal](10, 2) NOT NULL,
	[Duplic_Lcto] [bit] NOT NULL,
	[Confirm_Duplic] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
