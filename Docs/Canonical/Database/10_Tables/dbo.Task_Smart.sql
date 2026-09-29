SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Task_Smart](
	[ID_Task_Smart] [int] NOT NULL,
	[ID_Task] [int] NOT NULL,
	[Modal] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Campo_Conclusao] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Campo_Previsao] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
