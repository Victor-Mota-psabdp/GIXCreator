SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Site](
	[Cd_Site] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Site] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Aliq_Pis] [decimal](18, 2) NULL,
	[Aliq_Cofins] [decimal](18, 2) NULL,
	[Aliq_IRRF] [decimal](18, 2) NULL,
	[Aliq_CSLL] [decimal](18, 2) NULL,
	[Aliq_ISS] [decimal](18, 2) NULL,
	[Site_AX] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Status] [bit] NULL,
	[CNPJ_BDP] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[InscricaoMunicipal] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[CodigoMunicipio] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__Site__6CD828CA] PRIMARY KEY NONCLUSTERED 
(
	[Cd_Site] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
