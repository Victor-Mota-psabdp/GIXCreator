SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Volume_Exp_Aer](
	[Num_Proc_HEA] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_EA] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qtd_Vol_EA] [float] NOT NULL,
	[Compr_EA] [decimal](9, 3) NOT NULL,
	[Largura_EA] [decimal](9, 3) NOT NULL,
	[Altura_EA] [decimal](9, 3) NOT NULL,
	[Cd_Tp_Unidade] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vol_Item_EA] [decimal](9, 3) NOT NULL,
	[ID_NCM] [int] NULL,
	[Peso_Bruto_EA] [float] NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Marca_EA] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Contra_Marca] [varchar](2000) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
