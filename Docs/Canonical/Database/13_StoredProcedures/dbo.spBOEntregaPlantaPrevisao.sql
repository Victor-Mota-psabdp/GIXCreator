SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spBOEntregaPlantaPrevisao]

as

select upper(PS.num_proc) processo,dl_chegada Data from pedido PD
Join Pedido_ship  PS on PS.cd_pedido=PD.cd_pedido
Left Join Tarefas_Processos TF on PS.num_proc=TF.num_proc and id_task=13 
where (Dl_chegada <> dt_previsao or dt_previsao is null) 
and left(PS.num_proc,1)='I' and ps.num_proc like '%CSR%'
group by 
ps.num_proc,dl_chegada

GO
