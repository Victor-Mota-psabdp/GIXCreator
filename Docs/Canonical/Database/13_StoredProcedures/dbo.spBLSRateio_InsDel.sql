SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spBLSRateio_InsDel

AS

insert contabilidade_bls
select I.data,+R.num_proc,I.cd_Tp_tx,dc,valor*r_K,valor*r_K,tipo,encerrado,conta_Debito,conta_credito,cd_pes,historico + ' - Rateio Job: ' +R.num_proc From contabilidade_bls I
Join Rateio_Master R on R.num_proc=I.num_proc
Join Tipo_Taxa TT on TT.cd_tp_Tx=I.cd_tp_Tx
where rateio_tx='K'
--Join vwcliente W on Master=I.num_proc
union all

select I.data,+R.num_proc,I.cd_Tp_tx,dc,valor*r_q,valor*r_q,tipo,encerrado,conta_Debito,conta_credito,cd_pes,historico + ' - Rateio Job: ' +R.num_proc From contabilidade_bls I
Join Rateio_Master R on R.num_proc=I.num_proc
Join Tipo_Taxa TT on TT.cd_tp_Tx=I.cd_tp_Tx
where rateio_tx<>'K'

delete contabilidade_bls where num_proc in (select  num_proc from Rateio_Master)
GO
