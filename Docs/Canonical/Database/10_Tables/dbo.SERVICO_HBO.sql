SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[SERVICO_HBO](
	[Num_Proc_HBO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_Servico_HBO] [int] NOT NULL,
	[Numero_Servico_HBO] [varchar](80) COLLATE Latin1_General_CI_AI NOT NULL,
	[Data_Servico_HBO] [datetime] NULL,
	[Id_Servico] [int] NULL,
	[cd_usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
