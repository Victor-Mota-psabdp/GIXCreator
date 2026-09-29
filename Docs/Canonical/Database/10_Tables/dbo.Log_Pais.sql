SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Pais](
	[ID_Log] [int] IDENTITY(1,1) NOT NULL,
	[Dt_Alter] [datetime] NOT NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pais] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Pais] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[FORM_A] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Pais_PT] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Paraiso_Fiscal] [bit] NULL,
	[HTS] [bit] NULL,
	[Proibido] [bit] NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Bloqueado] [bit] NULL,
	[Ativo] [bit] NULL,
	[Cd_Pais_IBGE] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Cd_M49] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Log] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
