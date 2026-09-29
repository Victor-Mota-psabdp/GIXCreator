SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--06-06-2008
--Week 23
--inclusão Join com Pessoa_LLP - Claudio

CREATE Procedure [dbo].[spREAverbadas_REL]
		@DataInicial	Varchar(10),
		@DataFinal		Varchar(10)

as

select
	num_cpf_cnpj,Ordem.Numero_po_hem Ordem,DDE.numero_po_hem DDE_Number, 
	DDE.data_po_hem DDE_Data,RE.numero_po_hem RE_Number,
	RE.Data_PO_HEM RE_Data,mawb_hem,ATD_LEM,cd_pais,dt_conclusao Averbacao,
	NF.numero_po_hem NF,NF.data_po_hem Data_NF,DSE.numero_po_hem DSE_Number,DSE.data_po_hem Data_DSE
from house_exp_mar HOU
	Join Pessoa PP on pp.cd_pes=cd_export_hem
	Left Join PO_HEM DDE on DDe.num_proc_hem=HOU.num_proc_hem and DDE.ID_DC=12
	Left Join PO_HEM RE on RE.num_proc_hem=HOU.num_proc_hem and RE.ID_DC=4
	Join PO_HEM Ordem on Ordem.num_proc_hem=HOU.num_proc_hem and Ordem.ID_DC=3
	Join LLP_Exp_MAR LLP on llp.num_proc_lem=hou.num_proc_hem
	Join Localidade DST on DST.cd_local=cd_dst_hem
	Join Tarefas_Processos TF on TF.num_proc=hou.num_proc_hem and ID_Task=15
	Left Join PO_HEM NF on NF.num_proc_hem=HOU.num_proc_hem and NF.ID_DC=10
	Left Join PO_HEM DSE on DSE.num_proc_hem=HOU.num_proc_hem and DSE.ID_DC=26
Where
	Dt_conclusao between @DataInicial	 and @DataFinal


UNION ALL

select 
	num_cpf_cnpj,Ordem.Numero_po_hea Ordem,DDE.numero_po_hea DDE_Number, 
	DDE.data_po_hea DDE_Data,RE.numero_po_hea RE_Number,
	RE.Data_PO_hea RE_Data,mawb_hea,ATD_lea,cd_pais,dt_conclusao Averbacao,
	NF.numero_po_hea NF,NF.data_po_hea Data_NF,DSE.numero_po_hea DSE_Number,DSE.data_po_hea Data_DSE
from house_exp_aer HOU
	Join Pessoa PP on pp.cd_pes=cd_export_hea
	Left Join PO_hea DDE on DDe.num_proc_hea=HOU.num_proc_hea and DDE.ID_DC=12
	Left Join PO_hea RE on RE.num_proc_hea=HOU.num_proc_hea and RE.ID_DC=4
	Join PO_hea Ordem on Ordem.num_proc_hea=HOU.num_proc_hea and Ordem.ID_DC=3
	Join LLP_Exp_aer LLP on llp.num_proc_lea=hou.num_proc_hea
	Join Localidade DST on DST.cd_local=cd_dst_hea
	Join Tarefas_Processos TF on TF.num_proc=hou.num_proc_hea and ID_Task=15
	Left Join PO_hea NF on NF.num_proc_hea=HOU.num_proc_hea and NF.ID_DC=10
	Left Join PO_HEA DSE on DSE.num_proc_hea=HOU.num_proc_hea and DSE.ID_DC=26
Where 
	Dt_conclusao between @DataInicial	 and @DataFinal

UNION ALL

select 
	num_cpf_cnpj,Ordem.Numero_po_HEO Ordem,DDE.numero_po_HEO DDE_Number, 
	DDE.data_po_HEO DDE_Data,RE.numero_po_HEO RE_Number,
	RE.Data_PO_HEO RE_Data,mawb_HEO,ATD_LEO,cd_pais,dt_conclusao Averbacao,
	NF.numero_po_HEO NF,NF.data_po_HEO Data_NF,DSE.numero_po_heo DSE_Number,DSE.data_po_heo Data_DSE
from house_exp_OUT HOU
	Join Pessoa PP on pp.cd_pes=cd_export_HEO
	Left Join PO_HEO DDE on DDe.num_proc_HEO=HOU.num_proc_HEO and DDE.ID_DC=12
	Left Join PO_HEO RE on RE.num_proc_HEO=HOU.num_proc_HEO and RE.ID_DC=4
	Join PO_HEO Ordem on Ordem.num_proc_HEO=HOU.num_proc_HEO and Ordem.ID_DC=3
	Join LLP_Exp_OUT LLP on llp.num_proc_LEO=hou.num_proc_HEO
	Join Localidade DST on DST.cd_local=cd_dst_HEO
	Join Tarefas_Processos TF on TF.num_proc=hou.num_proc_HEO and ID_Task=15
	Left Join PO_HEO NF on NF.num_proc_HEO=HOU.num_proc_HEO and NF.ID_DC=10
	Left Join PO_HEO DSE on DSE.num_proc_heo=HOU.num_proc_heo and DSE.ID_DC=26
Where 
	Dt_conclusao between @DataInicial	 and @DataFinal



GO
