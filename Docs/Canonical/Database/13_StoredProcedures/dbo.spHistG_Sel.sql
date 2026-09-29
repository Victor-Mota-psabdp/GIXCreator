SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    Procedure [dbo].[spHistG_Sel] --'EMSTB201105024BR'
	
	@Processo	VarChar(16)

AS	

	Select 
		HG.HSGProcesso,
		HG.HSGSeq,
		TOC.Nome_Tp_Ocor	Tipo_Ocor,
		HG.HSDDescricao,
		HG.HSGData,
		HG.HSGDataFU,
		US.Nome_Usuario		Usuario,	
		HG.Disp_Cliente,
		Descricao_NC ID_NC
 	from 
		Hist_Geral HG With(nolock)
		Left Outer Join Tipo_Ocorrencia TOC With(nolock) on HG.Cd_Tp_Ocor = TOC.Cd_Tp_Ocor
		Left Outer Join Usuario US With(nolock) on HG.Cd_Usuario = US.Cd_Usuario
		Left Outer Join Tipo_NC_Cliente TNC With(nolock) on TNC.cd_NC = HG.ID_NC --and TNC.Ativo = 'S'
	where 
		HG.HSGProcesso=@Processo and HG.cd_origem <> 'S'
	order by
		HG.HSGSeq desc
		
		OPTION(HASH JOIN)



GO
