SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FMC_Miro](
	[ID_Miro] [int] NOT NULL,
	[NF_Miro] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio] [datetime] NULL,
	[Status] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Retorno] [datetime] NULL,
	[Fatura_PC] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Miro] [float] NULL,
	[Mensagem_Retorno] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[ID_Evento] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Resultado] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Closed] [bit] NULL,
	[OBS] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Alerta] [datetime] NULL,
 CONSTRAINT [PK_FMC_Miro] PRIMARY KEY CLUSTERED 
(
	[ID_Miro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
