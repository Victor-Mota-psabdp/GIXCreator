SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spBuscaFinancialItemsVoid_Sel]

AS

	SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_SENT IA on IA.ID=E.ID
			Where
				E.dt_envio is null 


--select D.Num_Proc, D.IC, d.Dt_Ins Void_Dt, D.ID  from Exchange_Cta_Cte D 
--Left Join Exchange_Cta_Cte I on D.Num_Proc = I.Num_Proc and D.IC=I.IC and I.Dt_Envio is null and I.Tipo_Oper <> 'D'
--where D.Tipo_Oper='D' and D.Dt_Envio is null and 
--I.num_proc is null 




select D.Num_Proc, D.IC, d.Dt_Ins Void_Dt, D.ID  from Exchange_Cta_Cte D  with(nolock)
Left Join Exchange_Cta_Cte I with(nolock) on D.Num_Proc = I.Num_Proc and D.IC=I.IC and I.Dt_Retorno is  null and I.Tipo_Oper <> 'D'
where D.Tipo_Oper='D' and D.Dt_Envio is null and 
I.num_proc is  null and LEN(D.Num_Proc) = 16
union all
select C.Num_Proc, D.IC, d.Dt_Ins Void_Dt, D.ID  from Exchange_Cta_Cte D with(nolock) 
Left Join Exchange_Cta_Cte I with(nolock) on D.Num_Proc = I.Num_Proc and D.IC=I.IC and I.Dt_Retorno is  null and I.Tipo_Oper <> 'D'
join vwCliente C with(nolock) on D.num_proc=C.Master
where D.Tipo_Oper='D' and D.Dt_Envio is null and 
I.num_proc is null and LEN(D.Num_Proc) = 14
GO
