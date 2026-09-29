SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Produto_Perigoso](
	[cd_prod] [int] NOT NULL,
	[uncode] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[classCode] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[HazMat_Name_Material] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HazMat_Description] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[HazMat_Contact] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[HazMat_Phone] [varchar](24) COLLATE Latin1_General_CI_AI NULL,
	[FlashPoint] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[measureCode] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[packingCode] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[EMS_MFAG_NUMBERS] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ShipperProperName] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[MarinePollutant] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[MFAG] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[EMS] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[Density] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Produto_Perigoso] PRIMARY KEY CLUSTERED 
(
	[cd_prod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Produto_Perigoso]  WITH CHECK ADD  CONSTRAINT [FK_Produto_Perigoso_Produto_Perigoso] FOREIGN KEY([cd_prod])
REFERENCES [dbo].[Produto_Perigoso] ([cd_prod])
GO
ALTER TABLE [dbo].[Produto_Perigoso] CHECK CONSTRAINT [FK_Produto_Perigoso_Produto_Perigoso]
GO
