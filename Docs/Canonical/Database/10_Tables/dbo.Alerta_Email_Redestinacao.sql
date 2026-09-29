SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Alerta_Email_Redestinacao](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CD_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_Tp_Alerta] [bigint] NOT NULL,
	[Dia] [int] NOT NULL,
	[DiaFim] [int] NOT NULL,
	[Email] [varchar](max) COLLATE Latin1_General_CI_AI NOT NULL,
	[Status] [bit] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins] [datetime] NOT NULL,
	[Email_CC] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Mensagem] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Alerta_Email_Redestinacao] PRIMARY KEY CLUSTERED 
(
	[CD_Pes_Grupo] ASC,
	[ID_Tp_Alerta] ASC,
	[Dia] ASC,
	[DiaFim] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
