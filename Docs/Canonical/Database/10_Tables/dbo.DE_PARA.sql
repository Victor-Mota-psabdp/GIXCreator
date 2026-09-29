SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DE_PARA](
	[Cd_Cliente] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tipo] [int] NOT NULL,
	[Cd_Org] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Descr_Org] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Ativo] [bit] NULL
) ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[DE_PARA] ADD [Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL

GO
SET ANSI_PADDING OFF
GO
