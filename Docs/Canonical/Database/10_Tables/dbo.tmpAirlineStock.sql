SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpAirlineStock](
	[IdAirlineStock] [int] IDENTITY(1,1) NOT NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Number] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Proc_Num] [varchar](19) COLLATE Latin1_General_CI_AI NULL,
	[CreaeDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
