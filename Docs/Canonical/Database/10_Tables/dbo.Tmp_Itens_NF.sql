SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_Itens_NF](
	[StrMachine] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Tp_Tx] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
