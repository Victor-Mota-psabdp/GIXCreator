SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_FinancialSFDCControle_Rel](
@Dt_Inicial datetime
)
as
select C.Num_Proc_HIA[JOB],C.IC [IC Number],C.Dt_Ins_HIA [Dt Ins. CtaCte] from  vwCta_Cte C With(nolock)
join Tipo_Taxa TT With(nolock) on C.Cd_Tp_Tx = TT.Cd_Tp_Tx and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1') 
left join Exchange_Cta_Cte E With(nolock) on C.IC = E.IC and C.Num_Proc_HIA = E.Num_Proc
where E.IC is null and CONVERT(datetime, C.Dt_Ins_HIA,105) >='2016-01-01'

union all

select C.Num_Proc_HIA,C.IC,C.Dt_Ins_HIA [Dt Ins. CtaCte] from  vwCta_Cte C With(nolock)
join Tipo_Taxa TT With(nolock) on C.Cd_Tp_Tx = TT.Cd_Tp_Tx and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1') 
left join Exchange_Cta_Cte E With(nolock) on C.IC = E.IC and C.Num_Proc_HIA = E.Num_Proc
left join vwCXAS CX With(nolock) on C.Num_Proc_HIA = Cx.Num_Proc_HIA and C.DC_HIA = CX.DC_HIA and C.Cd_Tp_Tx = CX.Cd_Tp_Tx
where E.IC is null and year(CONVERT(datetime, C.Dt_Ins_HIA,105)) > '2008'  and CX.Num_Lcto is null and Desp_Org_HIA = 'N' and substring(C.Num_Proc_HIA,3,3) not in ('REM','JOB')
GO
