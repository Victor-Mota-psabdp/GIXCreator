SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Termo_Pagamento](
	[ID_Log] [bigint] IDENTITY(1,1) NOT NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Termo] [int] NULL,
	[Descricao_Termo] [nvarchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Dias] [int] NULL,
	[Dt_Base] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Mapa_ATL] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Ativo] [bit] NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
