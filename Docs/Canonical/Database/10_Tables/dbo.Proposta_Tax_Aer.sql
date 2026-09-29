SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Proposta_Tax_Aer](
	[PROCOD] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRAID] [int] NOT NULL,
	[PXAID] [int] NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[PXAValor] [float] NOT NULL,
	[PXAEspecif] [varchar](300) COLLATE Latin1_General_CI_AI NOT NULL,
	[PXATipo] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
 CONSTRAINT [PK_Poposta_Tax_Aer] PRIMARY KEY CLUSTERED 
(
	[PROCOD] ASC,
	[PRAID] ASC,
	[PXAID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Proposta_Tax_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Poposta_Tax_Aer_Proposta_Rot_Aer] FOREIGN KEY([PROCOD], [PRAID])
REFERENCES [dbo].[Proposta_Rot_Aer] ([PROCOD], [PRAID])
GO
ALTER TABLE [dbo].[Proposta_Tax_Aer] CHECK CONSTRAINT [FK_Poposta_Tax_Aer_Proposta_Rot_Aer]
GO
ALTER TABLE [dbo].[Proposta_Tax_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Poposta_Tax_Aer_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Proposta_Tax_Aer] CHECK CONSTRAINT [FK_Poposta_Tax_Aer_Tipo_Moeda]
GO
ALTER TABLE [dbo].[Proposta_Tax_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Poposta_Tax_Aer_Tipo_Taxa] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Proposta_Tax_Aer] CHECK CONSTRAINT [FK_Poposta_Tax_Aer_Tipo_Taxa]
GO
