SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spJobAjustePCTP78
AS

Update Tarefas_processos 
			set Dt_Conclusao=getdate(), Cd_Usuario='ATL',Dt_Insert=getdate()
Where
	num_proc in (
		select D.Num_Proc from fatura_arg FAT with(nolock)
	Left Join Fatura_Arg_DEt D  with(nolock) on FAT.ID_Fat=D.id_fat
	Left Join Tarefas_Processos TP78  with(nolock) on d.num_proc=TP78.num_proc and TP78.ID_Task=78 
	where dt_fatura >=getdate()-10 and cd_tp_Tx in ('BRO','SRV') and Dt_Conclusao is null 
group by D.Num_Proc
)
and ID_Task=78



Update item_Fat set vlr_rs=vlr_rs*-1,vlr_org=vlr_org*-1
where  dc='C' and vlr_rs <0
GO
