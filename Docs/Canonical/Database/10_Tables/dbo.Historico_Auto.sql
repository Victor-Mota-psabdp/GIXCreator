SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Historico_Auto](
	[Id_Hist_Auto] [int] NOT NULL,
	[Id_Task] [int] NOT NULL,
	[Modal] [char](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Mensagem] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Ocor] [int] NULL,
	[Disp_Cliente] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
 CONSTRAINT [PK_Historico_Auto] PRIMARY KEY CLUSTERED 
(
	[Id_Hist_Auto] ASC,
	[Id_Task] ASC,
	[Modal] ASC,
	[Cd_Pes_Grupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
