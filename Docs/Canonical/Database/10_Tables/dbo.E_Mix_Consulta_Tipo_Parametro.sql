SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[E_Mix_Consulta_Tipo_Parametro](
	[id_parametro_grupo] [int] NULL,
	[id_parametro_tipo] [int] NULL,
	[Nome] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Obrigatorio] [bit] NULL,
	[Mascara] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ID_consulta_tipo] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
