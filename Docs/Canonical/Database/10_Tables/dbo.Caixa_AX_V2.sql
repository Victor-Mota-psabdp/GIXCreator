SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Caixa_AX_V2](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref] [decimal](10, 2) NOT NULL,
	[Par_Moeda] [decimal](10, 6) NOT NULL,
	[Vlr_Pgto_Rcto] [decimal](10, 2) NOT NULL,
	[Dt_Pgto_Rcto] [datetime] NOT NULL,
	[Status] [bit] NOT NULL,
	[Dt_Ins] [datetime] NOT NULL,
	[Dt_Del] [datetime] NULL,
 CONSTRAINT [PK_Caixa_AX_V2] PRIMARY KEY CLUSTERED 
(
	[Num_Proc] ASC,
	[Cd_Tp_Tx] ASC,
	[DC] ASC,
	[Num_Lcto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
