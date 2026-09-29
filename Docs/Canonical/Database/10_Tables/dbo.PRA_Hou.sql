SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[PRA_Hou](
	[PRA_Num_Ref_RA] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRA_Num_Proc] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRA_MAWB] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[PRA_Ref_Int] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[PRA_HAWB] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[PRA_Tp_Frete] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[PRA_Vlr_Frete_ME] [decimal](10, 2) NULL,
	[PRA_Vlr_RA_ME] [decimal](10, 2) NULL,
	[PRA_Vlr_Frete_Real] [decimal](10, 2) NULL,
	[PRA_Vlr_Out_Real] [decimal](10, 2) NULL,
	[PRA_Vlr_RA_Real] [decimal](10, 2) NULL,
	[PRA_Vlr_VC] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[PRA_Num_Ref_RA] ASC,
	[PRA_Num_Proc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PRA_Hou]  WITH CHECK ADD FOREIGN KEY([PRA_Num_Ref_RA])
REFERENCES [dbo].[PRA] ([PRA_Num_Ref_RA])
GO
