SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_Hist_BO_Sel] 'BOCSR201810002BR'
CREATE Procedure [dbo].[spATL_Hist_BO_Sel]-- ''
	
	@Processo	VarChar(16)

AS
	Select 
		'Saved'										[Status],
		right('000' + convert(int,HG.HSGSeq),3)		[Item],
		HG.Cd_Tp_Ocor								[Code of Occurrence],
		TOC.Nome_Tp_Ocor							[Type of Occurrence],
		HG.HSDDescricao								[Message],
		HG.HSGData									[Hist. Date],
		convert(varchar(10),HG.HSGDataFU,103)		[Follow Up],
		US.Nome_Usuario								[User],
		HG.Disp_Cliente								[Disp.],
		HG.ID_NC									[NC code],
		Descricao_NC								[NC Descricao]
		--HG.HSGProcesso,
 	from 
		Hist_Geral HG With(nolock)
		Left Outer Join Tipo_Ocorrencia TOC With(nolock) on HG.Cd_Tp_Ocor = TOC.Cd_Tp_Ocor
		Left Outer Join Usuario US With(nolock) on HG.Cd_Usuario = US.Cd_Usuario
		Left Outer Join Tipo_NC_Cliente TNC With(nolock) on TNC.cd_NC = HG.ID_NC and TNC.Ativo = 'S'
	where 
		HG.HSGProcesso=@Processo and HG.cd_origem <> 'S'
		and HG.HSGProcesso <> ''
	order by
		HG.HSGSeq desc
		
			OPTION(HASH JOIN)
GO
