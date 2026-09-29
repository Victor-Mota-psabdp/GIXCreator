SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Alerta_Email_SLI_Rel]

AS

select 
	EXC.Num_Solicitacao												[SLI],
	EXC.Type														[Type],
	--'andrea.boschin@bdpint.com;roberta.beltran@bdpint.com'			[CopyBDP],	
	'br.sao.grupoeastman@bdpint.com;carlos.eduardo@bdpint.com'		[CopyBDP],
	U.email															[ResponderPara],
	
	'Arquivos não encontrados para serem anexados ao email, SLI: ' + EXC.Num_Solicitacao + 
			'|Favor verificar se existem os seguintes documentos estão na SLI: | ' 
			+ isnull(convert(varchar(10),D.Id_DC),'')	[CorpoMSG_Doc_Anexos],


	SLI.num_proc										[JOB],
	CS.Apelido											[Consignee],
	[dbo].[fBusca_DATA_PO_Modal](SLI.num_proc, 1)		[Num_PO],
	SLI.num_li											[LI],
		
	(case when EXC.Type = 'L' then 'Emissao de LI'
		Else
		(case when EXC.Type = 'A' then 'Green Light'
		else
		(case when EXC.Type = 'D' then 'LI Deferida'
	end)end)end)										[Assunto],
	
	'Envio de E-mail'									[Tipo_Ocorrencia],
	
	D.Id_DC												[Doc_Anexos],
	
	[dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'SL%')[Emails],
	
	(case when EXC.Type = 'L' 
		then 
		'********** References ****************' + '|' +
		'BDP Ref.:' + SLI.Num_Proc + '|' +	
		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',SLI.Num_Proc,1),'') + '|' +
		'Customer PO:' + isnull(dbo.fBusca_TipoDocCliente('N',SLI.Num_Proc,9),'')  + '|' +
		'Produto : ' + isnull([dbo].[fBusca_PRODUTO_Solicitacao_LI](SLI.Num_Solicitacao),'') + '|' +
		'LI: ' + isnull(SLI.num_li,'') + '|' +	
		'Data da Emissão: ' + isnull(convert(varchar(20),SLI.DT_LI,107),'') +'|' +
		'Status: ' + isnull(ST.Status_LI_Descricao,'') + '|' +	
		'*************************************'  + '|' +
		'by BDP System' 				
	Else
	(case when EXC.Type = 'A' 
		then 
			'********** References ****************' + '|' +
			'BDP Ref.:' + SLI.Num_Proc + '|' +	
			'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',SLI.Num_Proc,1),'') + '|' +
			'Customer PO:' + isnull(dbo.fBusca_TipoDocCliente('N',SLI.Num_Proc,9),'')  + '|' +
			'Produto : ' + isnull([dbo].[fBusca_PRODUTO_Solicitacao_LI](SLI.Num_Solicitacao),'') + '|' +
			'LI: ' + isnull(SLI.num_li,'') + '|' +	
			'Data da Emissão: ' + isnull(convert(varchar(20),SLI.DT_LI,107),'') +'|' +
			'Embarque Autorizado: ' + isnull(convert(varchar(20),SLI.Dt_Aut_Embarque,107),'') +'|' +
			'Status: ' + isnull(ST.Status_LI_Descricao,'') + '|' +	
			'*************************************'  + '|' +
			'by BDP System' 	
	Else
	(case when EXC.Type = 'D' 
		then 
			'********** References ****************' + '|' +
			'BDP Ref.:' + SLI.Num_Proc + '|' +	
			'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',SLI.Num_Proc,1),'') + '|' +
			'Customer PO:' + isnull(dbo.fBusca_TipoDocCliente('N',SLI.Num_Proc,9),'')  + '|' +
			'Produto : ' + isnull([dbo].[fBusca_PRODUTO_Solicitacao_LI](SLI.Num_Solicitacao),'') + '|' +
			'LI: ' + isnull(SLI.num_li,'') + '|' +	
			'Data da Emissão: ' + isnull(convert(varchar(20),SLI.DT_LI,107),'') +'|' +
			'Data do Deferimento: ' + isnull(convert(varchar(20),SLI.Dt_Deferimento,107),'') +'|' +
			'Status: ' + isnull(ST.Status_LI_Descricao,'') + '|' +	
			'*************************************'  + '|' +
			'by BDP System' 	
	end)end)end)	[CorpoMSG]	
	
	
	
	--'********** References ****************' + '|' +
	--'BDP Ref.:' + SLI.Num_Proc + '|' +	
	--'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',SLI.Num_Proc,1),'') + '|' +
	--'Customer PO:' + isnull(dbo.fBusca_TipoDocCliente('N',SLI.Num_Proc,9),'')  + '|' +
	--'Produto : ' + isnull([dbo].[fBusca_PRODUTO_Solicitacao_LI](SLI.Num_Solicitacao),'') + '|' +
	--'LI: ' + isnull(SLI.num_li,'') + '|' +	
	--'Data da Emissão: ' + isnull(convert(varchar(20),SLI.DT_LI,107),'') +'|' +
	--'Status: ' + isnull(ST.Status_LI_Descricao,'') + '|' +	
	--'*************************************'  + '|' +
	--'by BDP System' 									[CorpoMSG]	
from Exchange_SLI EXC with(nolock)
	join Solicitacao_LI		SLI		with (nolock)on SLI.Num_Solicitacao = EXC.Num_Solicitacao
	Join Tipo_status_LI		ST		with (nolock)on SLI.id_status= ST.id_status_li
	join Usuario			U		with (nolock)on U.Cd_Usuario = SLI.Cd_Usuario_Req	
	Join Doc_Anexos			D		with (nolock)on D.Num_Proc =EXC.Num_Solicitacao and Id_DC =23
	Join vwCliente_Alerta	LLP		with (nolock)on SLI.Num_Proc = LLP.num_proc
	join Pessoa				CS		with(nolock) on CS.Cd_Pes = LLP.cd_cliente	
where	
	D.Anexado_Em > EXC.Dt_ins and
	EXC.DT_Send is null
	and SLI.ID_Status not in (8,1,12)
	

GO
