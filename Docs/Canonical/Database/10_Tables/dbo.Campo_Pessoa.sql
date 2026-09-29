SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Campo_Pessoa](
	[Cd_Pes] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Id_Campo] [int] NOT NULL,
	[Campo_Dados] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Cd_Usuario] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Campo_Pessoa] PRIMARY KEY CLUSTERED 
(
	[Cd_Pes] ASC,
	[Id_Campo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Campo_Pessoa]  WITH CHECK ADD  CONSTRAINT [FK_Campo_Pessoa_Campo_Pessoa] FOREIGN KEY([Cd_Pes], [Id_Campo])
REFERENCES [dbo].[Campo_Pessoa] ([Cd_Pes], [Id_Campo])
GO
ALTER TABLE [dbo].[Campo_Pessoa] CHECK CONSTRAINT [FK_Campo_Pessoa_Campo_Pessoa]
GO
