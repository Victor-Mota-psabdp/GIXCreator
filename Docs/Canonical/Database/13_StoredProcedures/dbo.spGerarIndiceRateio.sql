SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGerarIndiceRateio]

AS

---APAGA ITENS QUE TENHA ATUALIZACAO (PODE TER HAVIDO ALTERACAO DE PESO ou DE QUANTIDADE DE HOUSE)

delete Rateio_Master where num_master in (
select num_master from rateio_master where num_proc in (select distinct excprocesso from exchange where excdtenvio >=getdate()-2)
)


--INSERI NOVOS DADOS

insert dbo.Rateio_Master

select W.num_proc,master,cast(dbo.[spRateio_Mas_PesoQuantidade](W.Num_Proc,'K') as decimal(18,5)),cast(dbo.[spRateio_Mas_PesoQuantidade](W.Num_Proc,'H') as decimal(18,5)),W.cd_cliente,W.data,getdate() from vwcliente W
Left Join Rateio_Master R on R.num_proc=W.num_proc


where master <>'JOB'
and R.num_proc is null





GO
