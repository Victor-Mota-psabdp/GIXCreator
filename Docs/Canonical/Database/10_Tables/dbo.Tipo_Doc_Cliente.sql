SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Doc_Cliente](
	[ID_DC] [int] NOT NULL,
	[Nome_DC] [varchar](25) COLLATE Latin1_General_CI_AI NOT NULL,
	[Smart_Doc] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Data_Obrigatoria] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Numero_Obrigatorio] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Doc_Anexo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Replica] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[GenericReference] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DMS_Code] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[House] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Data_Habilita] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Numero_Habilita] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Historico] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Multiplos] [char](1) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Tipo_Doc_Cliente] PRIMARY KEY CLUSTERED 
(
	[ID_DC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
