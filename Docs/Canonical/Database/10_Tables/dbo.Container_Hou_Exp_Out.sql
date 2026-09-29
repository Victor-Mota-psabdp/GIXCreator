SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Container_Hou_Exp_Out](
	[Num_Proc_HEO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cont_EO] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_Cont_EO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_tp_Cont] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Num_Lacre_EO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Num_Lacre_2] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Bruto_EO] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
