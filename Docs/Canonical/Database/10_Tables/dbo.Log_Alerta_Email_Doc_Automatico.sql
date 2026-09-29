SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Alerta_Email_Doc_Automatico](
	[ID_Log] [bigint] IDENTITY(1,1) NOT NULL,
	[Dt_Alter] [datetime] NOT NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID] [int] NULL,
	[Nome_Task] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Id_Task] [int] NULL,
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Modal] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Dias] [float] NULL,
	[ResponderPara] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Emails] [varchar](2500) COLLATE Latin1_General_CI_AI NULL,
	[Doc_Anexos] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Mensagem] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [bit] NULL,
	[Nome_Tp_Ocor] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[JuntaPDF] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[CopyBDP] [varchar](2500) COLLATE Latin1_General_CI_AI NULL,
	[Email_Do_CompanyRegister] [bit] NULL,
	[cd_tp_carga] [int] NULL,
	[Doc_Anexos_Nao] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Assunto] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[StandardForms] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[cd_tp_pedido] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Email_do_Agente_Consolidado] [bit] NULL,
	[Cd_Transportadora] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[CopyEmail] [bit] NULL,
	[Cd_Terminal] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Zip] [bit] NULL,
	[ID_Alerta] [bigint] NULL,
	[Cd_Pes_Out] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Id_NCM] [int] NULL,
	[Cd_Pes_Agent] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Id_Necessidade_LI] [int] NULL,
	[Cd_Armador] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_Armador] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Cont] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Prod] [int] NULL,
	[ID_PD] [int] NULL,
	[Cd_Pes_Operador] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Id_Hazardous] [int] NULL,
	[Cd_Usuario_Cliente] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[BlindCopyBDP] [varchar](2500) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
