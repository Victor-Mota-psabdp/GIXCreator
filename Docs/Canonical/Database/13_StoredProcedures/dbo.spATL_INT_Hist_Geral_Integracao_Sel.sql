SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_INT_Hist_Geral_Integracao_Del.
--spATL_INT_Hist_Geral_Integracao_InsUpd
--sp_help Hist_Geral
CREATE procedure [dbo].[spATL_INT_Hist_Geral_Integracao_Sel]
(
	@Num_proc	varChar(16),
	@ID			bigint,
	@Tipo		char(1)
)

as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/
if @Tipo = 'A'  or @Tipo = 'B'
	Begin
		Select 
			convert(varchar(25),'Saved')					[Status],
			HG.HSGProcesso								[JOB],
			right('000' + convert(int,HG.HSGSeq),3)		[Item],
			HG.Cd_Tp_Ocor								[Occurrence Type Code],
			TOC.Nome_Tp_Ocor							[Occurrence Type],
			HG.HSDDescricao								[Message],
			HG.Cd_Pes									[Client Code],
			P.Apelido									[Client Name],
			HG.HSGData									[Hist. Date],
			convert(varchar(10),HG.HSGDataFU,103)		[Follow Up],
			HG.Cd_Usuario								[User Code],
			US.Nome_Usuario								[User Name],
			HG.Disp_Cliente								[Available],
			HG.ID_NC									[NC Code],
			TNC.Descricao_NC							[NC Description]
 		from 
			ATL_INT.dbo.Hist_Geral_Integracao HG With(nolock)
			Left Outer Join Tipo_Ocorrencia TOC With(nolock) on HG.Cd_Tp_Ocor = TOC.Cd_Tp_Ocor
			Left Outer Join Usuario US With(nolock) on HG.Cd_Usuario = US.Cd_Usuario
			Left Outer Join Pessoa P With(nolock) on P.Cd_Pes = HG.Cd_Pes
			Left Outer Join Tipo_NC_Cliente TNC With(nolock) on TNC.cd_NC = HG.ID_NC and TNC.Ativo = 'S'
		where 
			HG.HSGProcesso=@Num_proc 
			and HG.HSGProcesso <> ''
		order by
			HG.HSGSeq desc
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		Select 
			convert(varchar(25),'Saved')				[Status],
			HG.HSGProcesso								[JOB],
			right('000' + convert(int,HG.HSGSeq),3)		[Item],
			HG.Cd_Tp_Ocor								[Occurrence Type Code],
			TOC.Nome_Tp_Ocor							[Occurrence Type],
			HG.HSDDescricao								[Message],
			HG.Cd_Pes									[Client Code],
			P.Apelido									[Client Name],
			HG.HSGData									[Hist. Date],
			convert(varchar(10),HG.HSGDataFU,103)		[Follow Up],
			HG.Cd_Usuario								[User Code],
			US.Nome_Usuario								[User Name],
			HG.Disp_Cliente								[Available],
			HG.ID_NC									[NC Code],
			TNC.Descricao_NC							[NC Description]
 		from 
			ATL_INT.dbo.Hist_Geral_Integracao HG With(nolock)
			Left Outer Join Tipo_Ocorrencia TOC With(nolock) on HG.Cd_Tp_Ocor = TOC.Cd_Tp_Ocor
			Left Outer Join Usuario US With(nolock) on HG.Cd_Usuario = US.Cd_Usuario
			Left Outer Join Pessoa P With(nolock) on P.Cd_Pes = HG.Cd_Pes
			Left Outer Join Tipo_NC_Cliente TNC With(nolock) on TNC.cd_NC = HG.ID_NC and TNC.Ativo = 'S'
		where 
			HG.ID=@ID			
	End

GO
