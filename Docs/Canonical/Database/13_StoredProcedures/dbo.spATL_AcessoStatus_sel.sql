SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_AcessoStatus_sel 'IOROA201512007AR'
CREATE procedure spATL_AcessoStatus_sel
(
@Num_proc varchar(16)
)
as
select C.num_proc,CtaCte_IUD from vwClienteALLJOBS C with(nolock)
join Tipo_Status_Processo T with(nolock) on C.ID_Status = T.ID_Status
where num_proc = @num_proc 
union all
select num_proc_master,CtaCte_IUD from LLP_Master C
join Tipo_Status_Processo T with(nolock) on C.ID_Status = T.ID_Status
where num_proc_master = @num_proc 







GO
