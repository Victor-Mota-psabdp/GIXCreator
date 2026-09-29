SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Job_Justificativa_Status](
	[Id_Just] [bigint] IDENTITY(1,1) NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_Status] [bigint] NULL,
	[Justificativa] [nvarchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Destino] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Final_Destino] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Origem] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Final_Origem] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Cliente] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Notify] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Desbloqueado] [bit] NULL,
	[Dt_Alter] [datetime] NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Just] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
