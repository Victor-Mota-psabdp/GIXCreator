SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spSPEDEXP_rEL]
		(
			@num_proc	Varchar(16),
			@num_nf		Varchar(40)
		)

AS
select 
	right(num_cpf_cnpj,14) CNPJ,NF.NUMERO_PO_HEM NF, 
	NF.DATA_PO_HEM DATA_NF, RE.NUMERO_PO_HEM RE_NUMBER,
	RE.DATA_PO_HEM Data_RE,DDE.NUMERO_PO_HEM DDE_NUMBER,
	DDE.DATA_PO_HEM DATA_DDE,Dt_BL_Lem,COMPROVANTE.DATA_PO_HEM DATA_COMPROVANTE,
	DBO.fBusca_Tarefa(NUM_PROC_LEM,15) AVERBACAO,ISNULL(HAWB_HEM,MAWB_HEM) CONHECIMENTO,
	12 Tipo_Conhecimento,000 Pais,cd_pais_synchro,comprovante.numero_po_hem NUMERO_COMPROVANTE,
	DSE.numero_po_HEM DSE,Org.Nome_Local Origem_Despacho, 	UN_LOCTN_SUBDIV_CD UF,
	Dt_Conclusao Dt_Despacho


from 
	house_exp_mar HOU
	join pessoa pp on pp.cd_pes=cd_export_hem
	Join Po_HEM NF on NF.num_proc_hem=hou.num_proc_hem AND NF.ID_DC=10
	lEFT Join Po_HEM re on RE.num_proc_hem=hou.num_proc_hem AND RE.ID_DC=4
	lEFT Join Po_HEM DDE on DDE.num_proc_hem=hou.num_proc_hem AND DDE.ID_DC=12
	Inner Join LLP_Exp_Mar LLP on LLP.num_proc_lem=hou.num_proc_hem
	lEFT Join Po_HEM COMPROVANTE on COMPROVANTE.num_proc_hem=hou.num_proc_hem AND COMPROVANTE.ID_DC=62
	Left Outer Join Localidade DST on DST.cd_local=cd_dst_hem
	Left Outer Join Pais_Synchro_Int_Dow CNTY on CNTY.cd_pais=DST.cd_pais
	lEFT Join Po_hem DSE on DSE.num_proc_hem=hou.num_proc_hem AND DSE.ID_DC=26
	Left Join Localidade Org on org.cd_local=cd_org_hem
	Left Join BDPINT_Localidade SCAC on SCAC.un_loctn_cd=org.cd_local and org.cd_pais=iso_2_ltr_cntry_cd
	Left Join Tarefas_Processos TP on TP.num_proc=hou.num_proc_hem and id_task=4
WHERE
	NF.NUMERO_PO_HEM = @NUM_NF AND HOU.NUM_PROC_HEM=@NUM_PROC


UNION

select 
	right(num_cpf_cnpj,14) CNPJ,NF.NUMERO_PO_hea NF, 
	NF.DATA_PO_hea DATA_NF, Isnull(RE.NUMERO_PO_hea,DSE.Numero_PO_Hea) RE_NUMBER,
	Isnull(RE.DATA_PO_hea,DSE.Data_Po_Hea) Data_RE,DDE.NUMERO_PO_hea DDE_NUMBER,
	DDE.DATA_PO_hea DATA_DDE,ATD_lea,COMPROVANTE.DATA_PO_hea DATA_COMPROVANTE,
	DBO.fBusca_Tarefa(NUM_PROC_lea,15) AVERBACAO,ISNULL(HAWB_hea,MAWB_hea) CONHECIMENTO,
	12 Tipo_Conhecimento,000 Pais,cd_pais_synchro,comprovante.numero_po_hea NUMERO_COMPROVANTE,
	DSE.numero_po_hea  DSE,Org.Nome_Local Origem_Despacho,
	UN_LOCTN_SUBDIV_CD UF,	Dt_Conclusao Dt_Despacho


from 
	house_exp_Aer HOU
	join pessoa pp on pp.cd_pes=cd_export_hea
	Join Po_hea NF on NF.num_proc_hea=hou.num_proc_hea AND NF.ID_DC=10
	lEFT Join Po_hea re on RE.num_proc_hea=hou.num_proc_hea AND RE.ID_DC=4
	lEFT Join Po_hea DDE on DDE.num_proc_hea=hou.num_proc_hea AND DDE.ID_DC=12
	Inner Join LLP_Exp_Aer LLP on LLP.num_proc_lea=hou.num_proc_hea
	lEFT Join Po_hea COMPROVANTE on COMPROVANTE.num_proc_hea=hou.num_proc_hea AND COMPROVANTE.ID_DC=62
	Left Outer Join Localidade DST on DST.cd_local=cd_dst_hea
	Left Outer Join Pais_Synchro_Int_Dow CNTY on CNTY.cd_pais=DST.cd_pais
	lEFT Join Po_hea DSE on DSE.num_proc_hea=hou.num_proc_hea AND DSE.ID_DC=26
	Left Join Localidade Org on org.cd_local=cd_org_hea
	Left Join BDPINT_Localidade SCAC on SCAC.un_loctn_cd=org.cd_local and org.cd_pais=iso_2_ltr_cntry_cd
	Left Join Tarefas_Processos TP on TP.num_proc=hou.num_proc_hea and id_task=4


WHERE
	NF.NUMERO_PO_hea = @NUM_NF AND HOU.NUM_PROC_hea=@NUM_PROC











GO
