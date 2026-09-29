SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Navio_LLP](
	[Dt_Ins] [datetime] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Id_Navio] [int] NOT NULL,
	[Nome_Navio] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Nacionalidade] [char](2) COLLATE Latin1_General_CI_AI NULL,
	[LLoyd] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[cd_pais] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[cd_armador] [varchar](3) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
