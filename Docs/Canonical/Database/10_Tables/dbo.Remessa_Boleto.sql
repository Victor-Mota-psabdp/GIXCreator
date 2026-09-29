SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Remessa_Boleto](
	[id_remessa] [bigint] IDENTITY(1,1) NOT NULL,
	[cd_boleto] [varchar](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[remessa_dt_picture] [datetime] NULL,
	[remessa_cd_user_picture] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[remessa_file_name] [varchar](250) COLLATE Latin1_General_CI_AI NULL,
	[remessa_header_line] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[remessa_detail_line] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[remessa_footer_ine] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[remessa_line_register] [bigint] NULL,
	[remessa_flag_generated] [bit] NULL,
	[remessa_date_generated] [datetime] NULL,
	[Cd_Boleto_Digito] [varchar](8) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
