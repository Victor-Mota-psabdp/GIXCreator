SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_TranfTxJOB_Sel 'IMLVS201501001BR'
CREATE procedure [dbo].[spATL_TranfTxJOB_Sel](
@Num_ProcTemp Varchar(16)

)
as

select 	Num_Proc_HIM Num_Proc, CC.Cd_Tp_Tx, DC_HIM DC from Cta_Cte_Hou_Imp_Mar CC
	join Tipo_Taxa TT on CC.Cd_Tp_Tx = TT.Cd_Tp_Tx
	where Num_Proc_HIM = @Num_ProcTemp and (Nome_Tp_Tx like 'LI %CHB%' or Nome_Tp_Tx like 'Licenca de Importa%')

union all
select 	Num_Proc_HIA Num_Proc, CC.Cd_Tp_Tx, DC_HIA DC from Cta_Cte_Hou_Imp_Aer CC
	join Tipo_Taxa TT on CC.Cd_Tp_Tx = TT.Cd_Tp_Tx
	where Num_Proc_HIA = @Num_ProcTemp and (Nome_Tp_Tx like 'LI %CHB%' or Nome_Tp_Tx like 'Licenca de Importa%')
GO
