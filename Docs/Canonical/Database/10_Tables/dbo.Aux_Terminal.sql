SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Aux_Terminal](
	[Cd_Term_Ofc] [varchar](7) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Reparticao] [char](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Terminal_Ofc] [varchar](60) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
