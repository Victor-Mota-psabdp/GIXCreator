SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pessoa_Banco](
	[id_pes_banco] [int] IDENTITY(1,1) NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_Item] [int] NOT NULL,
	[Id_Tp_Banco] [int] NOT NULL,
	[Cd_Banco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Agencia] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Conta_Corrente] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [bit] NOT NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL,
 CONSTRAINT [PK_Pessoa_Banco] PRIMARY KEY CLUSTERED 
(
	[id_pes_banco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
