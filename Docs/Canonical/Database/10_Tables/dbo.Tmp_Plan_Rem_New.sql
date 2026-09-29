SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_Plan_Rem_New](
	[IdTmp] [bigint] IDENTITY(1,1) NOT NULL,
	[Num_Proc_MIA] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_MIA] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Int_MIA] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[HAWB_HIA] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[PC] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Frete_Moeda] [float] NULL,
	[Profit_Moeda] [float] NULL,
	[Remitance_Moeda] [float] NULL,
	[Frete_RS] [float] NULL,
	[Profit_RS] [float] NULL,
	[Remitance_RS] [float] NULL,
	[GainLoss] [float] NULL,
	[StrMachine] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Tmp_Plan_Rem_New] PRIMARY KEY CLUSTERED 
(
	[IdTmp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
