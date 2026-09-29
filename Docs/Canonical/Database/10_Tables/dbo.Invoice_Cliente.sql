SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Invoice_Cliente](
	[ID_INV] [int] NOT NULL,
	[Num_Invoice] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Data_Invoice] [datetime] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Cliente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Seguro] [float] NULL,
	[Status] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Obs_PL] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Re_Marks] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Customer_Bank] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Linguagem] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vencimento] [datetime] NULL,
	[Prazo] [int] NULL,
	[Dt_Envio] [datetime] NULL,
	[Cd_Termo] [int] NULL,
	[Obs_INV] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[cd_pais] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Invoice_Cliente] PRIMARY KEY CLUSTERED 
(
	[ID_INV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
