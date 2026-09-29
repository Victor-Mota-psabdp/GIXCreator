SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Volume_Imp_Out](
	[Num_Proc_HIO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_IO] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qtd_Vol_IO] [float] NOT NULL,
	[Compr_IO] [decimal](7, 3) NOT NULL,
	[Largura_IO] [decimal](7, 3) NOT NULL,
	[Altura_IO] [decimal](7, 3) NOT NULL,
	[Cd_Tp_Unidade] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vol_Item_IO] [decimal](7, 3) NOT NULL,
	[ID_NCM] [int] NULL,
	[Peso_Bruto_IO] [float] NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Marca_IO] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Contra_Marca] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Volume_Imp_Out] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HIO] ASC,
	[Item_IO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
