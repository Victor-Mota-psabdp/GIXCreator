SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Container_Hou_Imp_Out](
	[Num_Proc_HIO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cont_IO] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_Cont_IO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_tp_Cont] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lacre_IO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Num_Lacre_2] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Bruto_IO] [float] NULL,
	[Dt_Vcto_Devol_IO] [datetime] NULL,
	[Dt_Devol_IO] [datetime] NULL,
	[inspecao] [char](1) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
