SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Exchange_PO_Temp](
	[ID] [bigint] NULL,
	[ID_House_Temp] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Dt_Envio] [datetime] NULL,
	[Dt_Retorno] [datetime] NULL,
	[Dt_Atd] [datetime] NULL,
	[Dt_Booking] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
