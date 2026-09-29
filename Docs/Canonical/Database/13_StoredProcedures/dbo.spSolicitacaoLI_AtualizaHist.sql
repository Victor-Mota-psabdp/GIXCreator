SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSolicitacaoLI_AtualizaHist]
	AS
Declare 	@HSGProcesso		VarChar(16)
Declare		@HSGSeq				int 
Declare 	@Shipper			VarChar(30)
Declare		@Tp_Ocor			VarChar(50)
Declare		@HSDDescricao		VarChar(2000)
Declare		@HSGData			Datetime
Declare		@HSGDataFU			Datetime
Declare		@Usuario			VarChar(50)
Declare		@Disp_Cliente		Char(1)
Declare		@Cd_Origem			Char(1)
Declare		@ID_NC				VarChar(50)
Declare		@num_solicitacao	Varchar(13)
Declare		@Seq				Int
Declare cTemp Cursor for
(
select 
	Num_Proc,null,null,nome_tp_ocor,Num_Solicitacao + ': ' + hsddescricao,
	hsgdata,HSGDataFU,Nome_usuario,Disp_Cliente,cd_origem,null,num_solicitacao,hsgseq
 from hist_geral Hist With(nolock)
Join Solicitacao_LI SLI With(nolock) on SLI.num_solicitacao=hsgprocesso
Join Tipo_Ocorrencia TC With(nolock) on TC.cd_tp_ocor=hist.cd_tp_ocor
Join Usuario US With(nolock) on US.cd_usuario=hist.cd_usuario
where hsgdataconf is null and Num_Proc <> ''
)

open cTemp

fetch next from cTemp into @HSGProcesso,@HSGSeq,@Shipper,@Tp_Ocor,@HSDDescricao,@HSGData,@HSGDataFU,@Usuario,@Disp_Cliente,@Cd_Origem,@ID_NC,@Num_Solicitacao,@Seq

While @@Fetch_Status=0
	Begin
		
		exec [spHistG_InsUPD] @HSGProcesso,@HSGSeq,@Shipper,@Tp_Ocor,@HSDDescricao,@HSGData,@HSGDataFU,@Usuario,@Disp_Cliente,@Cd_Origem,@ID_NC
		update hist_geral set hsgdataconf=getdate() where hsgprocesso=@Num_Solicitacao and hsgseq=@Seq
		fetch next from cTemp into @HSGProcesso,@HSGSeq,@Shipper,@Tp_Ocor,@HSDDescricao,@HSGData,@HSGDataFU,@Usuario,@Disp_Cliente,@Cd_Origem,@ID_NC,@Num_Solicitacao,@Seq
	End

Close cTemp
deallocate ctemp

GO
