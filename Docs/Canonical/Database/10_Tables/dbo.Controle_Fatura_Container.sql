SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Controle_Fatura_Container](
	[cd_controlefatura] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[container] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[lacre] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[active] [bit] NULL,
	[valor_container] [decimal](10, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
