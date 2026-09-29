SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOG_NCM](
	[Dt_Ins_NCM] [datetime] NOT NULL,
	[Cd_Usuario_NCM] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Oper_NCM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Id_NCM] [int] NOT NULL,
	[NCM] [char](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[Descricao_NCM] [varchar](400) COLLATE Latin1_General_CI_AI NOT NULL,
	[Alterado] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vencimento] [datetime] NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[DT_INS] [datetime] NULL,
	[Excecao] [varchar](400) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
