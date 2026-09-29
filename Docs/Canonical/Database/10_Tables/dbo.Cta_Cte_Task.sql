SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cta_Cte_Task](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_DC] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Modal] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Id_Task] [int] NOT NULL,
	[Id_Pd] [int] NOT NULL,
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins] [datetime] NULL,
	[Ativo] [bit] NOT NULL,
 CONSTRAINT [PK_CtaCteTask] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[Cd_Tp_Tx] ASC,
	[Cd_Tp_DC] ASC,
	[Cd_Tp_Modal] ASC,
	[Id_Task] ASC,
	[Id_Pd] ASC,
	[Cd_Pes_Grupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
