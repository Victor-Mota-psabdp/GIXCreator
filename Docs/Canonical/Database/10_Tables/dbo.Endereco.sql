SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Endereco](
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_End] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Rua] [varchar](40) COLLATE Latin1_General_CI_AI NOT NULL,
	[Numero] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Compl_End] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[CEP] [char](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[Bairro] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Cidade] [varchar](25) COLLATE Latin1_General_CI_AI NOT NULL,
	[UF] [char](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Pais] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CD_pais] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[scac] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cod_IBGE] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__Endereco__2180FB33] PRIMARY KEY CLUSTERED 
(
	[Cd_Pes] ASC,
	[Cd_Tp_End] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Endereco]  WITH NOCHECK ADD  CONSTRAINT [FK__Endereco__Cd_Pes__50FB042B] FOREIGN KEY([Cd_Pes])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Endereco] CHECK CONSTRAINT [FK__Endereco__Cd_Pes__50FB042B]
GO
