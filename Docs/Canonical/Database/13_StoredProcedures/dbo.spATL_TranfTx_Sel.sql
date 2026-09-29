SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TranfTx_Sel](
@Num_ProcReal Varchar(16)

)
as

select Cd_Tp_Tx, Nome_Tp_Tx from Tipo_Taxa
where  Nome_Tp_Tx like 'LI CHB%' and Desat_Tx = 'N' 
and Cd_Tp_Tx not in (Select Cd_Tp_Tx from Cta_Cte_Hou_Imp_Mar where Num_Proc_HIM = @Num_ProcReal)-- order by Nome_Tp_Tx
GO
