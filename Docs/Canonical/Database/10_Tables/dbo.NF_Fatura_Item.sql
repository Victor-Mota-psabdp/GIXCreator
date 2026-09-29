SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NF_Fatura_Item](
	[ID] [bigint] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC] [varchar](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Org] [float] NULL,
	[Paridade] [float] NULL,
	[Vlr_RS] [float] NULL,
	[Vlr_Iva] [float] NULL,
	[Vlr_Cont_Item] [float] NULL,
	[Nota_Fiscal] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Acesso] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[ONF] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[RTX] [char](1) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
