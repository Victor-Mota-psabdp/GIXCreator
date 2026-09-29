SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_Item_Demonst_Frete](
	[StrMachine] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpRemessa] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpMaster] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpHouse] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpVlrFrete] [float] NULL,
	[TmpDeducao] [float] NULL,
	[TmpIncoterm] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[TmpPage] [int] NULL,
	[TmpLine] [int] NULL,
	[TmpFreteEfet] [float] NULL,
	[TmpMoedaRem] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[TmpDestino] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[TmpEndereco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Tmp_Item_Demonst_Frete] PRIMARY KEY CLUSTERED 
(
	[StrMachine] ASC,
	[TmpRemessa] ASC,
	[TmpMaster] ASC,
	[TmpHouse] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
