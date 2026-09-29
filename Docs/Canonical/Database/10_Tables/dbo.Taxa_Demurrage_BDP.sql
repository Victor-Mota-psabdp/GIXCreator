SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Taxa_Demurrage_BDP](
	[cd_tp_cont] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Periodo] [int] NOT NULL,
	[Taxa] [float] NOT NULL,
	[Dias] [int] NOT NULL,
	[Ativo] [bit] NULL,
 CONSTRAINT [PK_Taxa_Demurrage_BDP] PRIMARY KEY CLUSTERED 
(
	[cd_tp_cont] ASC,
	[Periodo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Taxa_Demurrage_BDP]  WITH CHECK ADD  CONSTRAINT [FK_Taxa_Demurrage_BDP_Tipo_Container] FOREIGN KEY([cd_tp_cont])
REFERENCES [dbo].[Tipo_Container] ([Cd_Tp_Cont])
GO
ALTER TABLE [dbo].[Taxa_Demurrage_BDP] CHECK CONSTRAINT [FK_Taxa_Demurrage_BDP_Tipo_Container]
GO
