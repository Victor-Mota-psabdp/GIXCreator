SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Campo_Processo](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Id_Campo] [int] NOT NULL,
	[Campo_Dados] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[cd_usuario] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Campo_Processo] PRIMARY KEY CLUSTERED 
(
	[Num_Proc] ASC,
	[Id_Campo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Campo_Processo]  WITH CHECK ADD  CONSTRAINT [FK_Campo_Processo_Campo_Processo] FOREIGN KEY([Num_Proc], [Id_Campo])
REFERENCES [dbo].[Campo_Processo] ([Num_Proc], [Id_Campo])
GO
ALTER TABLE [dbo].[Campo_Processo] CHECK CONSTRAINT [FK_Campo_Processo_Campo_Processo]
GO
