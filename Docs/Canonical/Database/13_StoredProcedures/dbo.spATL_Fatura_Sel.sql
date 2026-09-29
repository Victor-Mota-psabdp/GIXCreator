SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Fatura_Sel]--'IMCSR201507352BR','XTH','D'
(
@Num_Proc varchar(16),
@Cd_Tp_Tx varchar(3),
@DC char(1)
)
as

SELECT     
Num_Proc,VW.Cd_Tp_Tx,VW.DC, FatCod
FROM  vwFaturas_CHB_Validas VW with(nolock)
Where Vw.Num_Proc = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and Vw.DC = @DC
GO
