SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Viagem_LLP](
	[ID_Viagem] [int] NOT NULL,
	[ID_Navio] [int] NOT NULL,
	[Modal] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[NR_Viagem] [varchar](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[ETD] [datetime] NULL,
	[ATD] [datetime] NULL,
	[ETA] [datetime] NULL,
	[ATA] [datetime] NULL,
	[Original_ETA] [datetime] NULL,
	[ativo] [bit] NOT NULL,
	[dt_ins] [datetime] NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Ano_Viagem] [int] NULL,
	[id_op] [int] NULL,
	[manifesto] [varchar](11) COLLATE Latin1_General_CI_AI NULL,
	[Notes] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Id_Terminal] [varchar](3) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
