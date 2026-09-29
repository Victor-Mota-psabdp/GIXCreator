SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Type_Integration_Received](
	[Id_Integration_Received] [bigint] IDENTITY(1,1) NOT NULL,
	[Name_Integration_Received] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Status] [bit] NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
 CONSTRAINT [PK_Type_Integration_Received] PRIMARY KEY CLUSTERED 
(
	[Id_Integration_Received] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
