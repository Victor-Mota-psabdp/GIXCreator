SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LLP_ARG](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Adua_Saida] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Adua_Registro] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Forma_Pgto] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Condic_Pgto] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Banco] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Coefic_Exp] [float] NULL,
	[Reemb_Exp] [float] NULL,
	[Comissao] [float] NULL,
	[Royalties] [float] NULL,
	[Imp_Nat] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Imp_Temp] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Consolidacao] [datetime] NULL,
	[ETA_BuenosAires] [datetime] NULL,
	[Paridade_Oper] [float] NULL,
	[Tipo_Dest] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_Agente_ATA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Vcto_Invoice] [datetime] NULL,
	[Consig_CtaCte] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_LLP_ARG] PRIMARY KEY CLUSTERED 
(
	[Num_Proc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
