SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Cta_Cte_Task](
	[ID_Log] [bigint] IDENTITY(1,1) NOT NULL,
	[Dt_Alter] [datetime] NOT NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID] [bigint] NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_DC] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Modal] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Id_Task] [int] NULL,
	[Id_Pd] [int] NULL,
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Ativo] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
