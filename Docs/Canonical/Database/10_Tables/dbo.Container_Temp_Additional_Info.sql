SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Container_Temp_Additional_Info](
	[ID] [bigint] NULL,
	[ID_House_Temp] [bigint] NULL,
	[ID_Req] [bigint] NULL,
	[Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Item_Cont_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Cont] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Cont_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[dt_entregaPlanta] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[dt_entregaArmazem] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[dt_saidaArmazem] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[dt_saidaVazio] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[local_entrega] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[dt_devolucao] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[local_entrega_vazio] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Mercadoria] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ativo] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Bruto_EM_VGM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[UOM_VGM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio_VGM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Responsavel_VGM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Metodo_VGM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[TatcNumber] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[dt_ReleaseTatc] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Itinerary_ID] [varchar](200) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
