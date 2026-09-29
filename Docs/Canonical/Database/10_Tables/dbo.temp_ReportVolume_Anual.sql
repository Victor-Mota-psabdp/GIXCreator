SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[temp_ReportVolume_Anual](
	[Nome_Cliente] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Modal] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Localidade] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Janeiro] [bigint] NULL,
	[Fevereiro] [bigint] NULL,
	[Marco] [bigint] NULL,
	[Abril] [bigint] NULL,
	[Maio] [bigint] NULL,
	[Junho] [bigint] NULL,
	[Julho] [bigint] NULL,
	[Agosto] [bigint] NULL,
	[Setembro] [bigint] NULL,
	[Outubro] [bigint] NULL,
	[Novembro] [bigint] NULL,
	[Dezembro] [bigint] NULL,
 CONSTRAINT [PK_temp_ReportVolume_Anual_1] PRIMARY KEY CLUSTERED 
(
	[Nome_Cliente] ASC,
	[Modal] ASC,
	[Localidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Janeiro]  DEFAULT ((0)) FOR [Janeiro]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Fevereiro]  DEFAULT ((0)) FOR [Fevereiro]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Marco]  DEFAULT ((0)) FOR [Marco]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Abril]  DEFAULT ((0)) FOR [Abril]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Maio]  DEFAULT ((0)) FOR [Maio]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Junho]  DEFAULT ((0)) FOR [Junho]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Julho]  DEFAULT ((0)) FOR [Julho]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Agosto]  DEFAULT ((0)) FOR [Agosto]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Setembro]  DEFAULT ((0)) FOR [Setembro]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Outubro]  DEFAULT ((0)) FOR [Outubro]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Novembro]  DEFAULT ((0)) FOR [Novembro]
GO
ALTER TABLE [dbo].[temp_ReportVolume_Anual] ADD  CONSTRAINT [DF_temp_ReportVolume_Anual_Dezembro]  DEFAULT ((0)) FOR [Dezembro]
GO
