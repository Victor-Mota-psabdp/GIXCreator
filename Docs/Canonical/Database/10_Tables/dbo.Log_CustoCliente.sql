SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_CustoCliente](
	[Data_CC] [datetime] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Oper_CC] [char](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc_CC] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pedido] [int] NOT NULL,
	[Cd_Produto] [int] NOT NULL,
	[Cd_tp_tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Item_Custo] [decimal](19, 2) NULL,
	[Num_NF_Custo] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Prestacao] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Retencao] [float] NULL,
	[Ganancias] [float] NULL,
	[Tipo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Debito] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CUIT] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Id_Log] [bigint] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
