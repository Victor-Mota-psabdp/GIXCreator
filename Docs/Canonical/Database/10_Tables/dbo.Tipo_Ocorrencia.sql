SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Ocorrencia](
	[Cd_Tp_Ocor] [int] NOT NULL,
	[Nome_Tp_Ocor] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Previsao_Obrigatoria] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Permite_Dias_Anteriores] [int] NULL,
 CONSTRAINT [PK__Tipo_Ocorrencia__7A3223E8] PRIMARY KEY NONCLUSTERED 
(
	[Cd_Tp_Ocor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Permite X dias anteriores a Data de Inserção' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tipo_Ocorrencia', @level2type=N'COLUMN',@level2name=N'Permite_Dias_Anteriores'
GO
