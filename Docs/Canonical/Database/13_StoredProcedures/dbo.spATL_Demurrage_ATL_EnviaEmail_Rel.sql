SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido email: br.sao.contasareceber@bdpint.com;lucas.balilla@bdpint.com
--retirado email: camylla.rezende@bdpint.com

CREATE procedure [dbo].[spATL_Demurrage_ATL_EnviaEmail_Rel]

as

select 
	--'carlos.eduardo@bdpint.com;diego.ferreira@bdpint.com'	[strDestinatario],
	--isnull([dbo].[fBusca_Emal_Comunicacao](DM.cd_pes,'IM%'),'') [strDestinatario],
	
	(case when [dbo].[fBusca_Emal_Comunicacao](DM.cd_pes,'IM%') IS null THEN '' 
		else
		[dbo].[fBusca_Emal_Comunicacao](DM.cd_pes,'IM%') + ';demurragebr@bdpint.com;br.sao.contasareceber@bdpint.com' END)[strDestinatario],
	
	'Cobrança de Demurrage - ' 
		+ DM.Processo + DM.Fatura
		+ ' - Importador: ' +  DM.Apelido					[strAssunto], 	
		
		
	--Prezado cliente,
	--Informamos  que acusamos a devolução do container abaixo relacionado que incidiu  em demurrage 
	--devido a utilização do mesmo num período superior ao free time acordado.	
				
	'Prezado cliente, ' + '|' +
	'Informamos que acusamos a devolução do container abaixo relacionado que incidiu em demurrage devido a utilização do mesmo num período superior ao free time acordado.' + '||' +			
	'Container: ' + DET.Container  + '|' + 
	'Data de Atracação: ' + DM.Atracacao  + '|' +
	'Data de Devolução: ' + DET.Dt_Devolucao  + '|' +
	'Valor em USD:'  + convert(varchar(20),DM.Valor) + '|' +
	'Origem: ' + ORG.nome_local + '|' +
	'Destino: ' + DST.nome_local + '|' +
	'Free Time: ' + convert(varchar(20),DET.F_Time) + '|' +
	'Vencimento: ' + DM.vencimento   + '||' +	
	
	'Favor confirmar recebimento e informar data de pagamento'  + '||' +	

	'Em anexo segue a nota de débito' + '|||Created automatically by ATL System'  [strCorpoMSG], 
	DM.Processo + DM.Fatura + '.pdf'						strAnexo,
	'demurragebr@bdpint.com'								strResponderPara,
	'Fatura_demurrageATL.rpt'								Report_Name,
	DM.Processo + DM.Fatura									Fatura,
	DM.Processo												Num_Proc,
	'20'												[strAnexosObrigatorios],
	'Arquivos não encontrados para serem anexados ao email, JOB: ' + DM.Processo + 
			'|Favor verificar se existem os seguintes documentos estão no JOB: | 
			20	Doc. Embarque'	+ '|||' +
			'Caso o arquivo já exista no ATL, favor anexar uma outra copia'	[CorpoMSG_Doc_Anexos],
			
	'Cliente: ' + DM.Apelido	+ ' sem emails cadastrados, JOB: ' + HOU.Num_Proc_HIM 
	[CorpoMSG_strDestinatario],
	
	--'lucas.balilla@bdpint.com' [strEmailBDPCopiaDestinatario]
	'demurragebr@bdpint.com;br.sao.sistemas@bdpint.com' [strDestinatarioErro]

from 
	Demurrage_ATL DM with(nolock)
	join Demurrage_ATL_Det DET  with(nolock) on DM.Processo = DET.Processo and DM.Fatura = DET.Fatura
	join House_Imp_Mar HOU with(nolock) on HOU.Num_Proc_HIM = DM.Processo
	join Localidade ORG with(nolock) on ORG.Cd_Local = HOU.Cd_Org_HIM	
	join Localidade DST with(nolock) on DST.Cd_Local = HOU.Cd_Dst_HIM
where 
	dt_envio is null
	and cd_pes is not null

	

	

GO
