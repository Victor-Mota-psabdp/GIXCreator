SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Base_Nota_Fiscal_AX_TAX_GROUP](
	[Nota_Fiscal] [int] NULL,
	[Ref_Acesso] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Tax_Group] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Data] [datetime] NULL,
	[CNPJ] [varchar](20) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
