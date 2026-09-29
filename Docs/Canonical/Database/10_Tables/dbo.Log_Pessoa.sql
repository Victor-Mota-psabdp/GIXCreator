SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Pessoa](
	[Cd_Usr_Resp] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Alt] [datetime] NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Apelido] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Raz_Soc] [varchar](60) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_CPF_CNPJ] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_RG_IE] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Ativ] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Classe] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Grupo] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cta_Ctb] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Cad] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desat_Pes] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_Pes] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Num_Insc_Munic] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Pes] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
 CONSTRAINT [PK_Log_Pessoa] PRIMARY KEY CLUSTERED 
(
	[Cd_Usr_Resp] ASC,
	[Dt_Alt] ASC,
	[Cd_Pes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
