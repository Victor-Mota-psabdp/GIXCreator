SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Caixa](
	[Data_Cx] [datetime] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Oper_Cx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc_Cx] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_Cx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto_Cx] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref] [decimal](10, 2) NULL,
	[Dt_Conv] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Par] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Par_Moeda_Cx] [decimal](10, 6) NULL,
	[Vlr_Pgto_Rcto] [decimal](10, 2) NULL,
	[Dt_Pgto_Rcto_Cx] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_Rcb] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[IDLogCaixa] [bigint] IDENTITY(1,1) NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[Data_Cx] ASC,
	[Cd_Usuario] ASC,
	[Tp_Oper_Cx] ASC,
	[Num_Proc_Cx] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_Cx] ASC,
	[Num_Lcto_Cx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20240603-094442] ON [dbo].[Log_Caixa]
(
	[IDLogCaixa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Log_Caixa]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Par])
REFERENCES [dbo].[Tipo_Paridade] ([Cd_Tp_Par])
GO
ALTER TABLE [dbo].[Log_Caixa]  WITH CHECK ADD  CONSTRAINT [FK__Log_Caixa__Cd_Tp__251C81ED] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Log_Caixa] CHECK CONSTRAINT [FK__Log_Caixa__Cd_Tp__251C81ED]
GO
ALTER TABLE [dbo].[Log_Caixa]  WITH CHECK ADD FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
