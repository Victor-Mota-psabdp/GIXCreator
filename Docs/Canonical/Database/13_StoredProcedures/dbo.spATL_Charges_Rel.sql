SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Charges_Rel] --'ALL'
	@all varchar(3)
AS

Declare @TempDt Table (
	Cd_Tp_Tx varchar(3),
	Dt_Ins	datetime
	
)
insert @TempDt
select cd_tp_tx, MAX(convert(datetime,Dt_Ins_HIA, 105)) Dt_Ins from vwcta_Cte with(nolock)
--Left Join vwCXAS CX with(nolock) on CC.Num_Proc_HIA = CX.Num_Proc_HIA and CC.Cd_Tp_Tx = CX.Cd_Tp_Tx and CC.DC_HIA = CX.DC_HIA  
group by Cd_Tp_Tx
having MAX(convert(datetime,Dt_Ins_HIA, 105)) > = '2015-01-01'

union 

select CC.cd_tp_tx, MAX(convert(datetime,Dt_Ins_HIA, 105)) Dt_Ins from vwcta_Cte CC with(nolock)
Left Join vwCXAS CX with(nolock) on CC.Num_Proc_HIA = CX.Num_Proc_HIA and CC.Cd_Tp_Tx = CX.Cd_Tp_Tx and CC.DC_HIA = CX.DC_HIA  
where CX.Num_Lcto is null
group by CC.Cd_Tp_Tx

Declare @TempDtJOB Table (
	Cd_Tp_Tx varchar(3),
	Dt_Ins	datetime,
	Num_Proc varchar(16),
	QTY int
)

insert @TempDtJOB
select DT.Cd_Tp_Tx,DT.Dt_Ins,MAX(JOB.Num_Proc_HIA),NULL from @TempDt DT
join vwcta_Cte JOB with(nolock) on DT.Cd_Tp_Tx = JOB.Cd_Tp_Tx and DT.Dt_Ins = convert(datetime,JOB.Dt_Ins_HIA, 105)
group by DT.Cd_Tp_Tx,DT.Dt_Ins


update Q set Q.QTY =  J.QTY  from @TempDtJOB Q JOIN
(select JOB.Cd_Tp_Tx,COUNT(QTY.Num_Proc_HIA)QTY from @TempDtJOB JOB
join vwcta_Cte QTY with(nolock) on JOB.Cd_Tp_Tx = QTY.Cd_Tp_Tx 
where convert(datetime,QTY.Dt_Ins_HIA, 105) > = '2015-01-01'
group by JOB.Cd_Tp_Tx) as J on Q.Cd_tp_tx = J.cd_tp_Tx

update Q set Q.QTY =  J.QTY  from @TempDtJOB Q JOIN
(select JOB.Cd_Tp_Tx,COUNT(QTY.Num_Proc_HIA)QTY from @TempDtJOB JOB
join vwcta_Cte QTY with(nolock) on JOB.Cd_Tp_Tx = QTY.Cd_Tp_Tx 
Left Join vwCXAS CX with(nolock) on QTY.Num_Proc_HIA = CX.Num_Proc_HIA and QTY.Cd_Tp_Tx = CX.Cd_Tp_Tx and QTY.DC_HIA = CX.DC_HIA  
where CX.Num_Lcto is null
group by JOB.Cd_Tp_Tx) as J on Q.Cd_tp_tx = J.cd_tp_Tx and Q.QTY is NULL


select 
T.Cd_Tp_Tx,
TT.Nome_Tp_Tx,
TT.CD_AX_Repasse,
TT.CD_AX_Resultado,
T.Dt_Ins,
T.Num_Proc,
T.QTY
from @TempDtJOB T
join Tipo_Taxa TT on T.Cd_Tp_Tx = TT.cd_Tp_tx
where TT.Desat_Tx = 'N' order by QTY



GO
