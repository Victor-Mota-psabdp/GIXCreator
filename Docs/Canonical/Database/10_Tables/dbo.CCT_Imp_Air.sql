SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CCT_Imp_Air](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[FileType] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[HAWB] [varchar](11) COLLATE Latin1_General_CI_AI NULL,
	[MAWB] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Dt_Sent] [datetime] NULL,
	[XML_Sent] [xml] NULL,
	[File_Name] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[MessageHeaderDocument_ID] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[XML_Return] [xml] NULL,
	[ProtocolNumber] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Status] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[CPF] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[CNPJ] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[ErrorList] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_CCT_Imp_Air] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
