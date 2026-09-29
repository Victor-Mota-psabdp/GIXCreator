SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Mvto_Cta_Cte](
	[Data_Mov] [datetime] NULL,
	[Tipo_Oper_Mov] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Num_Lcto_Mov] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Banco] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Agencia] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cta_Cte] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_Mov] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Pgto_Rcto_Mov] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Doc_Mov] [decimal](10, 2) NOT NULL,
	[Concil_Mov] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ctb_Mvto] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Historico] [varchar](300) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
