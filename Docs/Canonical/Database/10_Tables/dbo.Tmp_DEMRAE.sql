SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_DEMRAE](
	[StrMachine] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Remessa] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[House] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Org] [decimal](18, 2) NULL,
	[Vlr_Ded] [decimal](18, 2) NULL,
	[Tx_Dol] [float] NULL,
	[Tx_Conv] [float] NULL,
	[Incoterm] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Transportador] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CNPJ_Transp] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Pais_Trans] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[IE] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Line] [int] NULL,
	[Page] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
