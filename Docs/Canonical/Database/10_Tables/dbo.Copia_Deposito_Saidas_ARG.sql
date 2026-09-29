SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Copia_Deposito_Saidas_ARG](
	[Num_Proc_Matriz] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc_Saida] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Quantidade] [float] NULL,
	[valor_fatura] [float] NULL,
	[valor_fob] [float] NULL,
	[valor_frete] [float] NULL,
	[valor_seguro] [float] NULL,
	[permisso] [varchar](80) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Copia_Deposito_Saidas_ARG] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_Matriz] ASC,
	[Num_Proc_Saida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
