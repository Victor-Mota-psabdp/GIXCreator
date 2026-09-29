SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Alerta_Email_Doc_Historico](
	[Id_Alerta_Email] [int] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
