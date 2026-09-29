SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Volume_Exp_Out](
	[Num_Proc_HEO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_EO] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qtd_Vol_EO] [float] NOT NULL,
	[Compr_EO] [decimal](7, 5) NOT NULL,
	[Largura_EO] [decimal](7, 5) NOT NULL,
	[Altura_EO] [decimal](7, 3) NOT NULL,
	[Cd_Tp_Unidade] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vol_Item_EO] [decimal](7, 3) NOT NULL,
	[Id_NCM] [int] NULL,
	[Peso_Bruto_EO] [float] NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Marca_EO] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Contra_Marca] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Volume_Exp_Out] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEO] ASC,
	[Item_EO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
