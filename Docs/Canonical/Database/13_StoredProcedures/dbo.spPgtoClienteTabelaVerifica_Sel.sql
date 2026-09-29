SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPgtoClienteTabelaVerifica_Sel](
@TempPgtoClienteAX PgtoClienteAX READONLY
	
)
as

SET NOCOUNT ON;

delete TempPgtoClienteAX

insert TempPgtoClienteAX
select * from @TempPgtoClienteAX



--Muda o Status para: Taxa Existe na JOB Consolidada e no JOB House
update Temp set Temp.[Status] = 'Taxa Existe na JOB Consolidada e no JOB House' from TempPgtoClienteAX Temp 
Join vwCliente CT with(nolock) on Temp.Num_Proc = CT.num_proc and CT.Master <>'JOB'
join vwcta_Cte CC with(nolock) on CT.Master = CC.Num_Proc_HIA and CC.cd_tp_Tx = Temp.Cd_Tp_TX and CC.DC_HIA= Temp.DC
left join vwcta_Cte CH with(nolock) on CT.num_proc = CH.Num_Proc_HIA and CH.cd_tp_Tx = Temp.Cd_Tp_TX and CH.DC_HIA= Temp.DC
--join tipo_taxa TT with(nolock) on Temp.Cd_Tp_TX = TT.cd_tp_Tx
where  CH.Num_Proc_HIA is not null and Temp.[Status] = 'OK'
option(hash join)
--Verifica Taxa que existe no master mas não existe no House: Alterar para o Numero do Master
update Temp set Temp.Num_Proc = CT.Master  from TempPgtoClienteAX Temp 
Join vwCliente CT with(nolock) on Temp.Num_Proc = CT.num_proc and CT.Master <>'JOB'
join vwcta_Cte CC with(nolock) on CT.Master = CC.Num_Proc_HIA and CC.cd_tp_Tx = Temp.Cd_Tp_TX and CC.DC_HIA= Temp.DC
left join vwcta_Cte CH with(nolock) on CT.num_proc = CH.Num_Proc_HIA and CH.cd_tp_Tx = Temp.Cd_Tp_TX and CH.DC_HIA= Temp.DC
--join tipo_taxa TT with(nolock) on Temp.Cd_Tp_TX = TT.cd_tp_Tx
where  CH.Num_Proc_HIA is null and Temp.[Status] ='OK'
option(hash join)
--Verifica se existe Cta_Cte
update Temp set Temp.[Status] = 'Taxa Não Localizada no JOB' from TempPgtoClienteAX Temp 
left JOIN vwcta_Cte  CC with(nolock) on Temp.Num_proc = CC.num_proc_hia  and  Temp.Cd_Tp_TX=CC.cd_tp_Tx and Temp.DC =CC.DC_HIA 
where  Temp.[Status] = 'OK' and CC.num_proc_hia is null
option(hash join)

update Temp set Temp.[Status] = 'Taxa com pagamento: '+ CX.num_lcto  from TempPgtoClienteAX Temp  
left join vwCXAS  CX with(nolock) on Temp.Num_proc = CX.num_proc_hia  and  Temp.Cd_Tp_TX=CX.cd_tp_Tx and Temp.DC =CX.DC_HIA 
WHERE  CX.num_lcto is not null  and(Canceled is  NULL or Canceled ='')  and Temp.[Status] = 'OK'
option(hash join)

update Temp set Temp.[Status] = 'Pagamento Cancelado: '+ CX.num_lcto + ' Dt. Cancel.: ' + convert(varchar(10),Cx.Dt_Del,103) from TempPgtoClienteAX Temp  
join Caixa_AX  CX with(nolock) on Temp.OrigVoucher = CX.Num_Lcto
WHERE  Cx.Dt_Del is not null  and Temp.[Status] = 'OK'
option(hash join)


update  TempPgtoClienteAX  set AmountMST = replace(AmountMST,'-',''),AmountCur = replace(AmountCur,'-','') where TempPgtoClienteAX.[Status] = 'OK'
update  TempPgtoClienteAX  set AmountMST = replace(AmountMST,'.',','),AmountCur = replace(AmountCur,'.',',') where TempPgtoClienteAX.[Status] = 'OK'
update  TempPgtoClienteAX  set ExchRate = replace(convert(decimal(18,4), convert(decimal(18,4), replace(AmountMST,',','.')) / convert(decimal(18,4), replace(AmountCur,',','.'))),'.',',')  where TempPgtoClienteAX.[Status] = 'OK'

select * from TempPgtoClienteAX
GO
