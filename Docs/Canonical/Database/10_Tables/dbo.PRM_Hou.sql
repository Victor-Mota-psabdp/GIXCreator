SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[PRM_Hou](
	[PRM_Num_Ref_RM] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRM_Num_Proc] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRM_MAWB] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[PRM_Ref_Int] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[PRM_HAWB] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[PRM_Tp_Frete] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[PRM_Vlr_Frete_ME] [decimal](10, 2) NULL,
	[PRM_Vlr_RM_ME] [decimal](10, 2) NULL,
	[PRM_Vlr_Frete_Real] [decimal](10, 2) NULL,
	[PRM_Vlr_Out_Real] [decimal](10, 2) NULL,
	[PRM_Vlr_RM_Real] [decimal](10, 2) NULL,
	[PRM_Vlr_VC] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[PRM_Num_Ref_RM] ASC,
	[PRM_Num_Proc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PRM_Hou]  WITH CHECK ADD FOREIGN KEY([PRM_Num_Ref_RM])
REFERENCES [dbo].[PRM] ([PRM_Num_Ref_RM])
GO
