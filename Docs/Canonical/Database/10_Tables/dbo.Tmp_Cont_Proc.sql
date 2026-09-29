SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_Cont_Proc](
	[Processo] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Intl] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Navio] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Atrac] [datetime] NULL,
	[Dt_Oper] [datetime] NULL,
	[Dt_Reg_Alf] [datetime] NULL,
	[Dt_Ent_Term] [datetime] NULL,
	[Dt_Lib_Bl] [datetime] NULL,
	[AWB] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Rec_Doc] [datetime] NULL,
	[Dt_Doc_Camb] [datetime] NULL,
	[Dt_Devol_IM] [datetime] NULL,
	[Nome_Terminal] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Armador] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Obs_MIM] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[JOB] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[StrMachine] [varchar](30) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
