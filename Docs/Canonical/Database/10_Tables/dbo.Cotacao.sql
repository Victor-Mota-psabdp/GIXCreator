SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cotacao](
	[Num_Cot] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Cot] [datetime] NOT NULL,
	[Cd_Org_Cot] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_Cot] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Modal_Cot] [char](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Prod] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Oper] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ck_Perigosa] [bit] NOT NULL,
	[Ck_Perecivel] [bit] NOT NULL,
	[Dados_Adic_Cot] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Det_Pick_Up_Cot] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Obs_Cot] [varchar](300) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
