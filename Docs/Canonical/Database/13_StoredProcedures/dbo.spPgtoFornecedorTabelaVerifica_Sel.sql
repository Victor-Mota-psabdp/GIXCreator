SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPgtoFornecedorTabelaVerifica_Sel](
@TempPgtoFornecedorAX PgtoFornecedorAX READONLY
	
)
as

SET NOCOUNT ON;

delete  TempPgtoFornecedorAX

insert TempPgtoFornecedorAX
select * from @TempPgtoFornecedorAX 


--update Temp set Temp.[Status] = 'Taxa Existe na Consolidada' from TempPgtoFornecedorAX Temp 
--Join vwCliente CT with(nolock) on Temp.Num_Proc = CT.num_proc
--join vwcta_Cte CC with(nolock) on CT.Master = CC.Num_Proc_HIA
--where CT.num_proc = Temp.Num_proc and CC.cd_tp_Tx = Temp.Cd_Tp_TX and CC.DC_HIA = Temp.DC and Temp.[Status] = 'OK'



--Muda o Status para: Taxa Existe na JOB Consolidada e no JOB House
update Temp set Temp.[Status] = 'Taxa Existe na JOB Consolidada e no JOB House' from TempPgtoFornecedorAX Temp 
Join vwCliente CT with(nolock) on Temp.Num_Proc = CT.num_proc and CT.Master <>'JOB'
join vwcta_Cte CC with(nolock) on CT.Master = CC.Num_Proc_HIA and CC.cd_tp_Tx = Temp.Cd_Tp_TX and CC.DC_HIA= Temp.DC
left join vwcta_Cte CH with(nolock) on CT.num_proc = CH.Num_Proc_HIA and CH.cd_tp_Tx = Temp.Cd_Tp_TX and CH.DC_HIA= Temp.DC
--join tipo_taxa TT with(nolock) on Temp.Cd_Tp_TX = TT.cd_tp_Tx
where  CH.Num_Proc_HIA is not null and Temp.[Status] = 'OK'

--Verifica Taxa que existe no master mas não existe no House: Alterar para o Numero do Master
update Temp set Temp.Num_Proc = CT.Master  from TempPgtoFornecedorAX Temp 
Join vwCliente CT with(nolock) on Temp.Num_Proc = CT.num_proc and CT.Master <>'JOB'
join vwcta_Cte CC with(nolock) on CT.Master = CC.Num_Proc_HIA and CC.cd_tp_Tx = Temp.Cd_Tp_TX and CC.DC_HIA= Temp.DC
left join vwcta_Cte CH with(nolock) on CT.num_proc = CH.Num_Proc_HIA and CH.cd_tp_Tx = Temp.Cd_Tp_TX and CH.DC_HIA= Temp.DC
--join tipo_taxa TT with(nolock) on Temp.Cd_Tp_TX = TT.cd_tp_Tx
where  CH.Num_Proc_HIA is null and Temp.[Status] ='OK'

--Verifica se existe Cta_Cte
update Temp set Temp.[Status] = 'Taxa Não Localizada no JOB' from TempPgtoFornecedorAX Temp 
left JOIN vwcta_Cte  CC with(nolock) on Temp.Num_proc = CC.num_proc_hia  and  Temp.Cd_Tp_TX=CC.cd_tp_Tx and Temp.DC =CC.DC_HIA 
where  Temp.[Status] = 'OK' and CC.num_proc_hia is null

update Temp set Temp.[Status] =  'Taxa com pagamento: '+ CX.num_lcto  from TempPgtoFornecedorAX Temp 
left join vwCXAS  CX with(nolock) on Temp.Num_proc = CX.num_proc_hia  and  Temp.Cd_Tp_TX=CX.cd_tp_Tx and Temp.DC =CX.DC_HIA 
WHERE  CX.num_lcto is not null and (Canceled is NULL or Canceled ='') and Temp.[Status] = 'OK'


update  TempPgtoFornecedorAX  set AmountMST = replace(AmountMST,'-',''),AmountCur = replace(AmountCur,'-','') where TempPgtoFornecedorAX.[Status] = 'OK'
update  TempPgtoFornecedorAX  set AmountMST = replace(AmountMST,'.',','),AmountCur = replace(AmountCur,'.',',') where TempPgtoFornecedorAX.[Status] = 'OK'
update  TempPgtoFornecedorAX  set ExchRate = replace(convert(decimal(18,4), convert(decimal(18,4), replace(AmountMST,',','.')) / convert(decimal(18,4), replace(AmountCur,',','.'))),'.',',')  where TempPgtoFornecedorAX.[Status] = 'OK'

select * from TempPgtoFornecedorAX


GO
