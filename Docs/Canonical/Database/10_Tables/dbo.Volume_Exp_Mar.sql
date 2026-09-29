SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Volume_Exp_Mar](
	[Num_Proc_HEM] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_EM] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qtd_Vol_EM] [float] NOT NULL,
	[Compr_EM] [decimal](9, 3) NOT NULL,
	[Largura_EM] [decimal](9, 3) NOT NULL,
	[Altura_EM] [decimal](9, 3) NOT NULL,
	[Cd_Tp_Unidade] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vol_Item_EM] [decimal](9, 3) NOT NULL,
	[ID_NCM] [int] NULL,
	[Peso_Bruto_EM] [float] NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Marca_EM] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Contra_Marca] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Item_Cont_EM] [varchar](10) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
