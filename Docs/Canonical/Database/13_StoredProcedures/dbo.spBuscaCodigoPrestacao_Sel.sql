SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CADU - INCLUI  a order by  - 21-07-2016 -17h
CREATE Procedure [dbo].[spBuscaCodigoPrestacao_Sel]--'IMCSR201606159BR'
	@num_proc varchar(16)
	
as

select 
	TT.cd_tp_Tx,TT.Nome_Tp_Tx 
from Tipo_Taxa TT with(nolock)
	Left Join vwcta_Cte cta with(nolock) on cta.Cd_Tp_Tx=TT.cd_tp_Tx and Cta.Num_Proc_HIA = @Num_proc
	Left Join vwFaturasValidas V with(nolock) on V.Cd_Tp_Tx=TT.cd_tp_Tx and V.Num_Proc = @Num_proc
where 
	Nome_Tp_Tx like 'Prestação de Contas%' 
	and TT.Cd_Tp_Tx<> 'XXV'
	and Cta.Num_Proc_HIA is null  
	and V.Num_Proc is null
	and TT.Desat_Tx ='N'
ORDER BY 2



GO
