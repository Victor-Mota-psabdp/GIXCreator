SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Impostos_Doc_Register](
	[ID_Imposto] [int] NOT NULL,
	[Cd_Site] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Aliq] [decimal](18, 2) NULL,
	[Tab_Relacionada] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Campo_Retorno] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Descr_Imposto] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
