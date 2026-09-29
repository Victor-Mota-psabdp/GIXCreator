SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer_Profile_Taxas](
	[ID_CP] [int] NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Fornecedor] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tipo_Compra] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Compra] [float] NULL,
	[Vlr_Min_Compra] [float] NULL,
	[Cd_Tp_Moeda_Compra] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Range_Compra] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tipo_Venda] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Venda] [float] NULL,
	[Vlr_Min_Venda] [float] NULL,
	[Cd_Tp_Moeda_Venda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Range_Venda] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Campo_Obs_Taxas] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[IVA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Id_DC] [int] NULL,
	[Vlr_Max_Compra] [float] NULL,
	[Vlr_Max_Venda] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
