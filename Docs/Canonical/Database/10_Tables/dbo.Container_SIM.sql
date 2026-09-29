SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Container_SIM](
	[Num_Proc_Sim] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_Cont] [int] NOT NULL,
	[cd_tp_cont] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Qtd_Sim] [int] NULL,
	[Ativo] [char](1) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
