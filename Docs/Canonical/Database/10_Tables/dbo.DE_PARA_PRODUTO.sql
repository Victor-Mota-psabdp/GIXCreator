SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DE_PARA_PRODUTO](
	[Cd_Cliente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[GMID] [varchar](100) COLLATE Latin1_General_CI_AI NOT NULL,
	[GMID_Descr_Curta] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Trade_Product_Code] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Trade_Product_Descr] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Plan_Product_Code] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Plan_Product_Descr] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Product_Center_Code] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Product_Center_Descr] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Performance_Center_Code] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Performance_Center_Descr] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Value_Center_Code] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Value_Center_Descr] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Business_Code] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Business_Descr] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Business_Group_Code] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Business_Group_Descr] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[P_Descricao] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[S_Descricao] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[ITO_Especialista] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
