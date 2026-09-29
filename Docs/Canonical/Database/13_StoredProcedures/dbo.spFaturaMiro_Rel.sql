SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spFaturaMiro_Rel]

as

/*
	Rotina utilizada para mostrar quais faturas estão disponiveis para inclusão
	na tabela FMC_Miro

*/




select Distinct TF.num_proc fatura, TF.num_proc processo_pc, 'I' Tipo from tarefas_processos TF
Left Join FMC_MIRO MI on left(mi.fatura_pc,16)=TF.num_proc and id_evento = 'I'
Join Custo_Cliente CC on tf.num_proc=cc.num_proc
Join FMC_Plano_Contas_v2 PC on PC.id_evento='I' and cc.cd_tp_tx=PC.cd_tp_Tx

where
	id_task=13 and dt_conclusao >='12-01-2013' and TF.num_proc like 'I%FMC%' and mi.fatura_pc is null
	and month(dt_conclusao )=month(getdate()) and year(dt_conclusao )=year(getdate()) 
--	and tf.num_proc in (
--'IMFMC201306073BR','IMFMC201307055BR','IMFMC201307056BR'

	
--	)
	--and fatura_pc='IMFMC201302013BR'
UNION ALL

select distinct TF.num_proc fatura, TF.num_proc processo_pc, 'S' Tipo from tarefas_processos TF
Left Join FMC_MIRO MI on left(mi.fatura_pc,16)=TF.num_proc and id_evento = 'S'
Join Custo_Cliente CC on TF.num_proc=cc.num_proc
Join FMC_Plano_Contas_v2 PC on PC.id_evento='S' and cc.cd_tp_tx=PC.cd_tp_Tx
Join FMC_MIRO IV on IV.fatura_pc=TF.num_proc and IV.ID_Evento='I' and IV.Status='E' and IV.Mensagem_REtorno is null

where
	id_task=13 and dt_conclusao >='12-01-2013'and TF.num_proc like 'I%FMC%' and mi.fatura_pc is null
	and month(dt_conclusao )=month(getdate()) and year(dt_conclusao )=year(getdate()) 
--and tf.num_proc='IMFMC201302013BR'
Union All



select Distinct TF.num_proc fatura, TF.num_proc processo_pc, 'C' Tipo from tarefas_processos TF
Left Join FMC_MIRO MI on left(mi.fatura_pc,16)=TF.num_proc and id_evento = 'C'
Join Custo_Cliente CC on TF.num_proc=cc.num_proc
Join FMC_Plano_Contas_v2 PC on PC.id_evento='C' and cc.cd_tp_tx=PC.cd_tp_Tx
Join FMC_MIRO IV on IV.fatura_pc=TF.num_proc and IV.ID_Evento='I' and IV.Status='E' and IV.Mensagem_REtorno is null

where
	id_task=13 and dt_conclusao >='12-01-2013'and TF.num_proc like 'I%FMC%' and mi.fatura_pc is null
	and month(dt_conclusao )=month(getdate()) and year(dt_conclusao )=year(getdate()) 
--and tf.num_proc='IMFMC201302013BR'
Union All


select Distinct TF.num_proc fatura, TF.num_proc processo_pc, 'T' Tipo from tarefas_processos TF
Left Join FMC_MIRO MI on left(mi.fatura_pc,16)=TF.num_proc and id_evento = 'T'
Join Custo_Cliente CC on TF.num_proc=cc.num_proc
Join FMC_Plano_Contas_v2 PC on PC.id_evento='T' and cc.cd_tp_tx=PC.cd_tp_Tx
Join FMC_MIRO IV on IV.fatura_pc=TF.num_proc and IV.ID_Evento='I' and IV.Status='E' and IV.Mensagem_REtorno is null

where
	id_task=13 and dt_conclusao >='12-01-2013'and TF.num_proc like 'I%FMC%' and mi.fatura_pc is null
	and month(dt_conclusao )=month(getdate()) and year(dt_conclusao )=year(getdate()) 
--and tf.num_proc='IMFMC201302013BR'
Union all



select Distinct TF.num_proc fatura, TF.num_proc processo_pc, 'R' Tipo from tarefas_processos TF
Left Join FMC_MIRO MI on left(mi.fatura_pc,16)=TF.num_proc and id_evento = 'R'
Join Custo_Cliente CC on TF.num_proc=cc.num_proc
Join FMC_Plano_Contas_v2 PC on PC.id_evento='R' and cc.cd_tp_tx=PC.cd_tp_Tx
Join FMC_MIRO IV on IV.fatura_pc=TF.num_proc and IV.ID_Evento='I' and IV.Status='E' and IV.Mensagem_REtorno is null

where
	id_task=13 and dt_conclusao >='12-01-2013'and TF.num_proc like 'I%FMC%' and mi.fatura_pc is null
	and month(dt_conclusao )=month(getdate()) and year(dt_conclusao )=year(getdate()) 

--and tf.num_proc='IMFMC201302013BR'

Union All


select distinct TF.num_proc fatura, TF.num_proc processo_pc, 'F' Tipo from tarefas_processos TF
Left Join FMC_MIRO MI on left(mi.fatura_pc,16)=TF.num_proc and id_evento = 'F'
Join Custo_Cliente CC on TF.num_proc=cc.num_proc and CC.cd_Tp_Tx in ('BRO','SDA','XAI','SRV')
Join FMC_Plano_Contas_v2 PC on PC.id_evento='F' and cc.cd_tp_tx=PC.cd_tp_Tx
Join FMC_MIRO IV on IV.fatura_pc=TF.num_proc and IV.ID_Evento='I' and IV.Status='E' and IV.Mensagem_REtorno is null

where
	id_task=13 and dt_conclusao >='12-01-2013'and TF.num_proc like 'I%FMC%' and mi.fatura_pc is null
	and TF.Num_Proc in (select processo_pc from fatura_chb where fatura_chb.status_pc='E')
	and month(dt_conclusao )=month(getdate()) and year(dt_conclusao )=year(getdate()) 
	
	--and tf.num_proc in ('IMFMC201306067BR','IMFMC201306071BR','IMFMC201306072BR'
	--,'IMFMC201307009BR','IMFMC201307021BR','IMFMC201307022BR','IMFMC201307043BR','IMFMC201308013BR')


Union All


select distinct TF.num_proc fatura, TF.num_proc processo_pc, 'K' Tipo from tarefas_processos TF
Left Join FMC_MIRO MI on left(mi.fatura_pc,16)=TF.num_proc and id_evento = 'K'
Join Custo_Cliente CC on TF.num_proc=cc.num_proc and CC.cd_Tp_Tx in ('XI2')
Join FMC_Plano_Contas_v2 PC on PC.id_evento='K' and cc.cd_tp_tx=PC.cd_tp_Tx
Join FMC_MIRO IV on IV.fatura_pc=TF.num_proc and IV.ID_Evento='F' and IV.Status='E' and IV.Mensagem_REtorno is null

where
	id_task=13 and dt_conclusao >='12-01-2013'and TF.num_proc like 'I%FMC%' and mi.fatura_pc is null
	--and TF.Num_Proc in (select processo_pc from fatura_chb where fatura_chb.status_pc='E')
	and month(dt_conclusao )=month(getdate()) and year(dt_conclusao )=year(getdate()) 


GO
