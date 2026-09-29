SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Doc_Anexos_Temp](
	[ID] [bigint] NULL,
	[ID_House_Temp] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_Req] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Item_Doc] [int] NULL,
	[Nome_Arquivo] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_DC] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DMS_Code] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
