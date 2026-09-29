SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Comunicacao](
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Com] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Contato] [varchar](120) COLLATE Latin1_General_CI_AI NULL,
	[Depto_Ctt] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Int] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Area_Fone] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Prefixo] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Num_Fone] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Compl_Fone] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Ramal] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Cd_Pes] ASC,
	[Cd_Tp_Com] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Comunicacao]  WITH NOCHECK ADD  CONSTRAINT [FK__Comunicac__Cd_Pe__4E1E9780] FOREIGN KEY([Cd_Pes])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Comunicacao] CHECK CONSTRAINT [FK__Comunicac__Cd_Pe__4E1E9780]
GO
