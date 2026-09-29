SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Exchange_E_AirFreight](
	[ExcId] [int] IDENTITY(1,1) NOT NULL,
	[Num_Proc_Mea] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc_Hea] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc_Mea_Dt_Ins] [datetime] NULL,
	[Num_Proc_Mea_Dt_Envio] [datetime] NULL,
	[Num_Proc_Hea_Dt_Envio] [datetime] NULL,
	[Num_Proc_Hea_Dt_Ins] [datetime] NULL,
 CONSTRAINT [PK_E_AirFreight_Exchange] PRIMARY KEY CLUSTERED 
(
	[ExcId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
