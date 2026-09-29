SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Proposta_Tax_Mar](
	[PROCOD] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRMID] [int] NOT NULL,
	[PXMID] [int] NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[PXMValor] [float] NOT NULL,
	[PXMEspecif] [varchar](300) COLLATE Latin1_General_CI_AI NOT NULL,
	[PXMTipo] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
 CONSTRAINT [PK_Poposta_Tax_Mar] PRIMARY KEY CLUSTERED 
(
	[PROCOD] ASC,
	[PRMID] ASC,
	[PXMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Proposta_Tax_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Poposta_Tax_Mar_Proposta_Rot_Mar] FOREIGN KEY([PROCOD], [PRMID])
REFERENCES [dbo].[Proposta_Rot_Mar] ([PROCOD], [PRMID])
GO
ALTER TABLE [dbo].[Proposta_Tax_Mar] CHECK CONSTRAINT [FK_Poposta_Tax_Mar_Proposta_Rot_Mar]
GO
ALTER TABLE [dbo].[Proposta_Tax_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Poposta_Tax_Mar_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Proposta_Tax_Mar] CHECK CONSTRAINT [FK_Poposta_Tax_Mar_Tipo_Moeda]
GO
ALTER TABLE [dbo].[Proposta_Tax_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Poposta_Tax_Mar_Tipo_Taxa] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Proposta_Tax_Mar] CHECK CONSTRAINT [FK_Poposta_Tax_Mar_Tipo_Taxa]
GO
