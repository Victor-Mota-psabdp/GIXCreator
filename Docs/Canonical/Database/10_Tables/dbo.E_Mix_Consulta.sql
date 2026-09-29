SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[E_Mix_Consulta](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_servico] [int] NULL,
	[id_empresa] [int] NULL,
	[id_cnpj] [int] NULL,
	[id_consulta_tipo] [int] NULL,
	[id_parametro_grupo] [int] NULL,
	[Id_parametro_tipo] [int] NULL,
	[valor] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[num_proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [I] ON [dbo].[E_Mix_Consulta]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
