SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Exchange_Cta_Cte_SENT](
	[ID] [bigint] NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[IC] [bigint] NULL,
	[Tipo_Oper] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Dt_Envio] [datetime] NULL,
	[Dt_Retorno] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
