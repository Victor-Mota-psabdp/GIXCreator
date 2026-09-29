SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PDF2ATL_APL](
	[Origem] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Mensagem] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Evento] [datetime] NULL,
	[Dt_Envio] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
