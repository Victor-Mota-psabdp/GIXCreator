SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    Procedure spAuditEM

as
select 
	hou.Num_proc_hem JOB,nr_reserva,ETD_LEM ETD,ETA_LEM ETA,ATA_LEM ATA,peso_bruto_hem Peso_Bruto,Peso_liquido_hem Peso_liquido, 
	ATD_LEM ATD,Navio_Hem Navio,Viagem_hem Viagem,Invoice.Numero_PO_HEM Invoice,pl.num_proc PL,re_anexo.num_proc Re_Anexo,Re.numero_po_hem Re_Number,
	DEs.Dt_Conclusao Desembaraco,Canal_lem canal,POD.dt_Conclusao POD, POL.dt_conclusao POL,
	Customer_PO.numero_po_hem Customer_PO,PO.numero_po_hem Num_PO,DL_Cargo_Lem Dead_Line,Nome_Armador,DOC.dt_Conclusao DOC,
	Courier_Number_LEM Courier,cd_courier,Nome_Usuario CSR
from house_exp_mar HOU
	Join LLP_Exp_Mar LLP on LLp.num_proc_lem=hou.num_proc_hem
	jOIN Job_exp_mar JOB on JOb.num_proc_hem=hou.num_proc_hem
	Join Armador ARM on ARM.cd_armador=LLP.cd_armador_lem
	Left Join PO_HEM Invoice on hou.num_proc_hem=invoice.num_proc_hem and Invoice.id_dc=2
	lEFT jOIN Doc_Anexos PL on hou.num_proc_hem=pl.num_proc and pl.id_dc=11
	Left Join Po_Hem RE on HOU.num_proc_hem=RE.num_proc_hem and RE.Id_DC=4
	Left Join Doc_Anexos RE_Anexo on HOU.Num_proc_hem=RE_Anexo.num_proc and Re_Anexo.id_dc=4
	Left Join Tarefas_processos DES on HOU.Num_proc_hem=DES.num_Proc and DES.ID_Task=4
	Left Join Tarefas_processos pod on HOU.Num_proc_hem=POD.num_Proc and POD.ID_Task=13
	Left Join Tarefas_processos POL on HOU.Num_proc_hem=POL.num_Proc and POL.ID_Task=10
	Left Join Po_HEM PO on PO.num_proc_hem=HOU.NUM_PROC_HEM AND PO.ID_DC=1
	Left Join Po_HEM Customer_PO on Customer_PO.num_proc_hem=HOU.NUM_PROC_HEM AND Customer_PO.ID_DC=1
	Left Join Tarefas_processos DOC on HOU.Num_proc_hem=DOC.num_Proc and DOC.ID_Task=12
	Left Join usuario US on job.cd_usuario=us.cd_usuario





GO
