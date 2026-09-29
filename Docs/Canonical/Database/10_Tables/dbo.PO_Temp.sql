SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PO_Temp](
	[ID_House_Temp] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_Req] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_PO_Temp] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Numero_PO_Temp] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Data_PO_Temp] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_DC] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20240506-145030] ON [dbo].[PO_Temp]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
