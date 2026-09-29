SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[vwcusto_temp]


as

select distinct fat.cd_tp_Tx,vlr_PC Vlr_Pgto_Rcto_HIA,tp.num_proc Num_Proc_HIA from fatura_chb_item FAT
Join Tipo_Taxa TT on tt.cd_tp_tx=FAT.cd_tp_TX
Join tarefas_Processos TP on TP.id_task=4 and num_proc=left(fatura_cc,16)
Left Join Custo_processo CP on CP.num_proc=left(fatura_cc,16) and fat.cd_tp_Tx=CP.cd_tp_Tx
Join fatura_chb FP on FP.fatura_pc=FAtura_cc
where imprime='S' and nome_tp_Tx not like 'Adiantamento%' 
and tp.num_proc like 'I%CSR%' and dt_conclusao > ='01-01-2012'
and cp.num_proc is null
and status_pc='E'


GO
