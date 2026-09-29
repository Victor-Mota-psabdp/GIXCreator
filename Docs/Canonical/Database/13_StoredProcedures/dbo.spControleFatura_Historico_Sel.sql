SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    Procedure [dbo].[spControleFatura_Historico_Sel]-- 'EMSTB201105024BR'
	
	@Processo	VarChar(16)

AS	

	Select 
		right('000' + convert(varchar(3),HG.HSGSeq),3)	[Item],
		TOC.Nome_Tp_Ocor								[Type Of Occurrence],
		HG.HSDDescricao									[Message],
		convert(varchar(12),HG.HSGData,103)				[Hist. Date],
		convert(varchar(12),HG.HSGDataFU,103)			[Follow Up],
		US.Nome_Usuario									[User],
		HG.Disp_Cliente									[Disp.],
		Descricao_NC									[NC],
		'Saved'											[Status]		
 	from 
		Hist_Geral HG with(nolock)
		Left Outer Join Tipo_Ocorrencia TOC with(nolock) on HG.Cd_Tp_Ocor = TOC.Cd_Tp_Ocor
		Left Outer Join Usuario US with(nolock) on HG.Cd_Usuario = US.Cd_Usuario
		Left Outer Join Tipo_NC_Cliente TNC with(nolock) on TNC.cd_NC = HG.ID_NC and TNC.Ativo = 'S'
	where 
		HG.HSGProcesso=@Processo and HG.cd_origem <> 'S'
	order by
		HG.HSGSeq desc



GO
