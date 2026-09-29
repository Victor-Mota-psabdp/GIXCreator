SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Alerta_Email_Doc](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Report_Name] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Stored] [varchar](250) COLLATE Latin1_General_CI_AI NULL,
	[Doc_Anexos] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Emails] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[ResponderPara] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Task] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Tp_Ocor] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[JuntaPDF] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Nome_DC] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Disponivel] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[ConfirmacaoDeLeitura] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Alerta_Email_Doc] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
