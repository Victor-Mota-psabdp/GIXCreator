SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spINTDocAnexos_CORTEVA]
		as

select 
	Nome_Arquivo,Smart_DOc,DA.num_proc + '_' +Smart_Doc+'.PDF' Nome_Doc,
	'01BDPBRSAO_'+DA.num_proc+'_'+right('0000' + DMS_Code ,4) + '_01_add' DMS_Arquivo,
	 DMS_Code,dt_creacao,Anexado_em

from 
	Doc_Anexos DA with(nolock)
	Join tipo_doc_cliente TC with(nolock) on TC.id_dc=DA.id_dc
	Join dbo.vwClienteALLJOBS AJ	with(nolock) on DA.num_proc = AJ.Num_Proc	
	left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO =DA.num_proc
	left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO
	left join Pessoa CS with(nolock) on AJ.cd_cliente = CS.Cd_Pes
where
	dt_envio is null 
	and len(DA.num_proc)=16
	and left(DA.num_proc,2) <> 'BO'
	and right(DA.num_proc,2)in ('BR','01')
	and isnull(Anexado_em,'01-01-2014') >=getdate()-360 
	and DMS_Code is not null and DMS_Code <> ''
	--and DMS_Code not in ('0010','0025','0036','0039','0047','0053','0057','0059','0066','0030','114','0049','0103')
	and	(J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1)
	AND (CS.Apelido like 'DOW AGRO%' or CS.Apelido like 'DUPONT%' or CS.Apelido like 'DU PONT%' OR CS.Apelido = 'DOW - 3770C') 

GO
