SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spSFDCBDPChargesVoid_Ins]

AS

insert Exchange_Cta_Cte 

select F.Num_Proc,F.IC,'D',GETDATE(),null,null  from Exchange_Cta_Cte  F
Left Join vwctA_cte C on F.Num_Proc = C.Num_Proc_HIA and C.IC=F.IC
Left Join Exchange_Cta_Cte D on D.Num_Proc = F.Num_Proc and F.IC=D.IC and D.Tipo_Oper = 'D'
where c.Num_Proc_HIA is null 
and D.Num_Proc is null and F.Tipo_Oper <> 'D'
GO
