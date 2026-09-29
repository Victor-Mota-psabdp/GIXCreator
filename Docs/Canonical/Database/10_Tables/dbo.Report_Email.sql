SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Report_Email](
	[Id_Alerta] [int] IDENTITY(1,1) NOT NULL,
	[Id_Report] [int] NOT NULL,
	[Tipo] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Mes_Semana] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dia] [varchar](31) COLLATE Latin1_General_CI_AI NOT NULL,
	[hr_Envio] [int] NOT NULL,
	[Email] [varchar](3000) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Ultimo_Envio] [datetime] NULL,
	[Obs] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Parametros] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Disable] [bit] NULL,
 CONSTRAINT [PK_Report_Email] PRIMARY KEY CLUSTERED 
(
	[Id_Alerta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
