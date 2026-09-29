SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Volume_Imp_Aer](
	[Num_Proc_HIA] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_IA] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qtd_Vol_IA] [float] NOT NULL,
	[Compr_IA] [decimal](9, 3) NOT NULL,
	[Largura_IA] [decimal](9, 3) NOT NULL,
	[Altura_IA] [decimal](9, 3) NOT NULL,
	[Cd_Tp_Unidade] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vol_Item_IA] [decimal](9, 3) NOT NULL,
	[ID_NCM] [int] NULL,
	[Peso_Bruto_IA] [float] NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Marca_IA] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Contra_Marca] [varchar](2000) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
