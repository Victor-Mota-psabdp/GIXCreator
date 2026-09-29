SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Container_Additional_Info](
	[num_proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[num_cont] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[dt_entregaPlanta] [datetime] NULL,
	[dt_entregaArmazem] [datetime] NULL,
	[dt_saidaArmazem] [datetime] NULL,
	[dt_saidaVazio] [datetime] NULL,
	[local_entrega] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[dt_devolucao] [datetime] NULL,
	[local_entrega_vazio] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Mercadoria] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL,
	[ativo] [bit] NULL,
	[Peso_Bruto_EM_VGM] [float] NULL,
	[UOM_VGM] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio_VGM] [datetime] NULL,
	[Nome_Responsavel_VGM] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Metodo_VGM] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[TatcNumber] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[dt_ReleaseTatc] [datetime] NULL,
	[Itinerary_ID] [varchar](20) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
