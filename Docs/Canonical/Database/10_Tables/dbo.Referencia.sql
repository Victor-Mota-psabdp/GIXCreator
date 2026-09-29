SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Referencia](
	[Ref_Acesso] [varchar](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ind_Trf_Dlr_EA] [decimal](10, 2) NOT NULL,
	[Tp_Ind_Trf_Dlr_EA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ind_Trf_Out_EA] [decimal](10, 2) NOT NULL,
	[Tp_Ind_Trf_Out_EA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ind_Trf_Dlr_EM] [decimal](10, 2) NOT NULL,
	[Tp_Ind_Trf_Dlr_EM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ind_Trf_Out_EM] [decimal](10, 2) NOT NULL,
	[Tp_Ind_Trf_Out_EM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ind_Trf_Dlr_IA] [decimal](10, 2) NOT NULL,
	[Tp_Ind_Trf_Dlr_IA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ind_Trf_Out_IA] [decimal](10, 2) NOT NULL,
	[Tp_Ind_Trf_Out_IA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ind_Trf_Dlr_IM] [decimal](10, 2) NOT NULL,
	[Tp_Ind_Trf_Dlr_IM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ind_Trf_Out_IM] [decimal](10, 2) NOT NULL,
	[Tp_Ind_Trf_Out_IM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Perc_IRRF] [decimal](2, 1) NOT NULL,
	[Limite_Ded_IRRF] [decimal](6, 2) NOT NULL,
	[Ult_Comprov] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ult_Credit_Note] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ult_Debit_Note] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ult_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ult_Nota_Debito] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ult_NF_AV] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ult_NF_SP] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ult_NF_STS] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ult_Pessoa] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ult_Recibo] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ult_Remessa] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ref_CNPJ] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Ref_IE] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Ref_IM] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Ref_Acesso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
