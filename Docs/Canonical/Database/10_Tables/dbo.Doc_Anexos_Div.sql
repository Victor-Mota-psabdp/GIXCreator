SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Doc_Anexos_Div](
	[Item_Doc] [int] NOT NULL,
	[Id_Tipo_Doc] [int] NOT NULL,
	[Id_Doc] [int] NOT NULL,
	[Cd_Prod] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Arquivo] [varchar](100) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Anexo] [datetime] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Venc] [datetime] NULL,
 CONSTRAINT [PK_Doc_Anexos_Div] PRIMARY KEY CLUSTERED 
(
	[Item_Doc] ASC,
	[Id_Tipo_Doc] ASC,
	[Id_Doc] ASC,
	[Cd_Prod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
