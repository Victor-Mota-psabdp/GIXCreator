SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Pessoa_New](
	[Dt_Ins] [datetime] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Apelido] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Raz_Soc] [varchar](60) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_CPF_CNPJ] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Num_RG_IE] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Ativ] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Classe] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Grupo] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Cta_Ctb] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Cad] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desat_Pes] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_Pes] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Num_Insc_Munic] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Pes] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dupl_Cta_Master] [bit] NULL,
	[Email] [varchar](75) COLLATE Latin1_General_CI_AI NULL,
	[PgtoRcto] [bit] NOT NULL,
	[GLOBAL_ENTITY_ID] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Id_Log] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
