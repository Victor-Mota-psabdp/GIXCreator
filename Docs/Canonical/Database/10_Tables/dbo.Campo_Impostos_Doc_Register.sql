SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Campo_Impostos_Doc_Register](
	[ID] [int] NOT NULL,
	[Cd_Site] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Id_Imposto] [int] NOT NULL,
	[Valor] [decimal](18, 2) NULL,
	[Base] [decimal](18, 2) NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
