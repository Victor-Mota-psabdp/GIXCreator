SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Volume_Imp_Mar](
	[Num_Proc_HIM] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_IM] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qtd_Vol_IM] [float] NOT NULL,
	[Compr_IM] [decimal](9, 3) NOT NULL,
	[Largura_IM] [decimal](9, 3) NOT NULL,
	[Altura_IM] [decimal](9, 3) NOT NULL,
	[Cd_Tp_Unidade] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vol_Item_IM] [decimal](9, 3) NOT NULL,
	[Id_NCM] [int] NULL,
	[Peso_Bruto_IM] [float] NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Marca_IM] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Contra_Marca] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Item_Cont_IM] [varchar](10) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
