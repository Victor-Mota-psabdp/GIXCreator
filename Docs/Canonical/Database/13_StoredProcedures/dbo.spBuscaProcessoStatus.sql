SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spBuscaProcessoStatus]
AS

select dbo.fBusca_Tarefa(num_proc_lim,13) GoodReceipt,dbo.fBusca_Tarefa(num_proc_lim,40) Prestacao, num_proc_lim,ata_lim,atd_lim,DP.campo_dados Desp,st.campo_dados from llp_imp_mar
Left Join Campo_Processo DP on num_proc_lim=DP.num_proc and DP.id_campo=32
Left Join Campo_Processo ST on num_proc_lim=ST.num_proc and ST.id_campo=79
Where
	(ST.CAMPO_DADOS is null or ST.CAMPO_DADOS <> 5)

union 

select dbo.fBusca_Tarefa(num_proc_lia,13) GoodReceipt,dbo.fBusca_Tarefa(num_proc_lia,40) Prestacao, num_proc_lia,ata_lia,atd_lia,DP.campo_dados Desp,st.campo_dados from llp_imp_aer
Left Join Campo_Processo DP on num_proc_lia=DP.num_proc and DP.id_campo=32
Left Join Campo_Processo ST on num_proc_lia=ST.num_proc and ST.id_campo=79
Where
	(ST.CAMPO_DADOS is null or ST.CAMPO_DADOS <> 5)


union 

select dbo.fBusca_Tarefa(num_proc_lio,13) GoodReceipt,dbo.fBusca_Tarefa(num_proc_lio,40) Prestacao, num_proc_lio,ata_lio,atd_lio,DP.campo_dados Desp,st.campo_dados from llp_imp_out
Left Join Campo_Processo DP on num_proc_lio=DP.num_proc and DP.id_campo=32
Left Join Campo_Processo ST on num_proc_lio=ST.num_proc and ST.id_campo=79
Where
	(ST.CAMPO_DADOS is null or ST.CAMPO_DADOS <> 5)





GO
