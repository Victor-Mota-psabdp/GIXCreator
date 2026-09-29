SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Custo_Sia](
	[Num_Proc_Sia] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_tp_tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_tp_moeda_c] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[vlr_c_sia] [float] NULL,
	[cd_tp_moeda_v] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[vlr_v_sia] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
