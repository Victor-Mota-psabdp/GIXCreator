SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spMapaIMPFiscal]

	as

select NUM_PROC_LIM,right(num_cpf_cnpj,14) CNPJ,po.numero_po_him PO_Number,DI.numero_po_him DI_Number,dT_CONCLUSAO,DI.Data_PO_HIM Data_DI,isnull(hawb_him,mawb_him) BL,ATD_LIM,cd_pais,isnull(nota_fiscal,nf.numero_po_him) nota,isnull(emissao,nf.data_po_him) nota from house_imp_mar HOU with(nolock)
left Join Po_HIM PO with(nolock) on PO.num_proc_him=HOU.num_proc_him and po.id_dc=1
Left Join tarefas_processos TF with(nolock) on TF.num_proc=hou.num_proc_him and Id_task=4
Join LLP_Imp_MAR LLP with(nolock) on LLp.num_proc_lim=HOU.num_proc_him
Join Pessoa PP with(nolock) on PP.cd_pes=cd_consig_him
Join Localidade org with(nolock) on org.cd_local=cd_org_him
Join Po_HIM DI with(nolock) on di.num_proc_him=HOU.num_proc_him and di.id_dc=5
left Join Po_HIM NF with(nolock) on NF.num_proc_him=HOU.num_proc_him and NF.id_dc=10
Left Join NotA_cliente NC with(nolock) on hou.num_proc_him=NC.num_proc


UNION

select NUM_PROC_LIO,right(num_cpf_cnpj,14) CNPJ,po.numero_po_HIO PO_Number,DI.numero_po_HIO DI_Number,DT_CONCLUSAO,DI.Data_PO_HIO Data_DI,isnull(hawb_HIO,mawb_HIO) BL,ATD_LIO,cd_pais,isnull(nota_fiscal,nf.numero_po_HIO) nota,isnull(emissao,nf.data_po_HIO) nota from house_imp_OUT HOU with(nolock)
left Join Po_HIO PO with(nolock) on PO.num_proc_HIO=HOU.num_proc_HIO and po.id_dc=1
Left Join tarefas_processos TF with(nolock) on TF.num_proc=hou.num_proc_HIO and Id_task=4
Join LLP_Imp_OUT LLP with(nolock) on LLp.num_proc_LIO=HOU.num_proc_HIO
Join Pessoa PP with(nolock) on PP.cd_pes=cd_consig_HIO
Join Localidade org with(nolock) on org.cd_local=cd_org_HIO
Join Po_HIO DI with(nolock) on di.num_proc_HIO=HOU.num_proc_HIO and di.id_dc=5
left Join Po_HIO NF with(nolock) on NF.num_proc_HIO=HOU.num_proc_HIO and NF.id_dc=10
Left Join NotA_cliente NC with(nolock) on hou.num_proc_HIO=NC.num_proc

UNION


select NUM_PROC_LIA,right(num_cpf_cnpj,14) CNPJ,po.numero_po_HIA PO_Number,DI.numero_po_HIA DI_Number,DT_CONCLUSAO,DI.Data_PO_HIA Data_DI,isnull(hawb_HIA,mawb_HIA) BL,ATD_LIA,cd_pais,isnull(nota_fiscal,nf.numero_po_HIA) nota,isnull(emissao,nf.data_po_HIA) nota from house_imp_AER HOU with(nolock)
left Join Po_HIA PO with(nolock) on PO.num_proc_HIA=HOU.num_proc_HIA and po.id_dc=1
Left Join tarefas_processos TF with(nolock) on TF.num_proc=hou.num_proc_HIA and Id_task=4
Join LLP_Imp_AER LLP with(nolock) on LLp.num_proc_LIA=HOU.num_proc_HIA
Join Pessoa PP with(nolock) on PP.cd_pes=cd_consig_HIA
Join Localidade org with(nolock) on org.cd_local=cd_org_HIA
Join Po_HIA DI with(nolock) on di.num_proc_HIA=HOU.num_proc_HIA and di.id_dc=5
left Join Po_HIA NF with(nolock) on NF.num_proc_HIA=HOU.num_proc_HIA and NF.id_dc=10
Left Join NotA_cliente NC with(nolock) on hou.num_proc_HIA=NC.num_proc



GO
