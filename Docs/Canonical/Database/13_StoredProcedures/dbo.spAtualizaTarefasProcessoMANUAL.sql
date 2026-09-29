SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spAtualizaTarefasProcessoMANUAL] --'EKA'
(
@Grupo varchar(3)
)
as

/*
SELECT TOP 1 * FROM tipo_tarefas
SELECT TOP 1 * FROM tarefas_processos
select * from Hist_geral_sistema where HSGProcesso='IAOXT20100801701'
select * from tipo_ocorrencia where cd_tp_ocor='55'
*/

declare @cd_pes_grupo varchar(10)
set @cd_pes_grupo = (select cd_pes_grupo from grupo with(nolock) where grupo=@Grupo)

--insert into tarefas_processos(Num_proc,id_task,Dt_conclusao,dt_previsao,cd_usuario)

select distinct
	H.HSGProcesso, T.ID_task , null, dbo.fBusca_Data(H.HSGProcesso,Tipo_Data) + dias, NULL --, Tipo_Data
from 
	Hist_geral_sistema H with(nolock)
	join tipo_tarefas T with(nolock) on T.modal =  left(H.HSGProcesso,2) and (cd_pes_grupo =@Cd_Pes_Grupo or cd_pes_grupo='10017')
	left join tarefas_processos TP with(nolock) on TP.Num_Proc=H.HSGProcesso and TP.id_task = T.id_task
where 
	right(left(HSGProcesso,5),3)= @Grupo
--	left(H.HSGProcesso,5)='IOOXT'
	and Num_proc is null
	and HSGProcesso not in (select HSGProcesso from Hist_geral_sistema where cd_tp_ocor='55')
	and dbo.fBusca_Data(H.HSGProcesso,Tipo_Data) is not null
	and T.id_task = '40'
--and HSGProcesso = 'EMOXT20100700101'



GO
