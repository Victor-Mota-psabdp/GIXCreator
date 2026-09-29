SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Item_Demurrage](
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Cont] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Idm_Seq] [int] NOT NULL,
	[Idm_Per_Inic] [int] NOT NULL,
	[Idm_Per_Fim] [int] NULL,
	[Idm_Tx] [decimal](12, 2) NOT NULL,
 CONSTRAINT [PK_Item_Demurrage] PRIMARY KEY CLUSTERED 
(
	[Cd_Armador] ASC,
	[Cd_Tp_Cont] ASC,
	[Idm_Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Item_Demurrage]  WITH CHECK ADD  CONSTRAINT [FK_Item_Demurrage_Demurrage] FOREIGN KEY([Cd_Armador], [Cd_Tp_Cont])
REFERENCES [dbo].[Demurrage] ([Cd_Armador], [Cd_Tp_Cont])
GO
ALTER TABLE [dbo].[Item_Demurrage] CHECK CONSTRAINT [FK_Item_Demurrage_Demurrage]
GO
