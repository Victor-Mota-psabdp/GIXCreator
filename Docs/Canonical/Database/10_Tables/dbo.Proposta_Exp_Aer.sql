SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Proposta_Exp_Aer](
	[Num_Prop_EA] [varchar](11) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_PEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Export_PEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ctt_Cli_PEA] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Prod] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Fonte] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Msg_PEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Fchto_PEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cancel_PEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_PEA] [varchar](4000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__Proposta_Exp_Aer__25518C17] PRIMARY KEY CLUSTERED 
(
	[Num_Prop_EA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Proposta_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Ex__6225902D] FOREIGN KEY([Cd_Export_PEA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Proposta_Exp_Aer] CHECK CONSTRAINT [FK__Proposta___Cd_Ex__6225902D]
GO
