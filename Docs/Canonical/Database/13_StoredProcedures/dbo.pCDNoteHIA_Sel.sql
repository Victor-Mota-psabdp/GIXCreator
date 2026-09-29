SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCDNoteHIA_Sel
(
@Num_Proc 		VarChar(16),
@Cred_Dev		VarChar(10), 
@CD			Char(1)
)
 AS
	If @CD = 'C'
		Select 
			CC.*, Nome_Tp_Tx_Ing
		From 
			Cta_Cte_Hou_Imp_Aer as CC  Join Tipo_Taxa as T on CC.Cd_Tp_Tx = T.Cd_Tp_Tx 
		Where	
			Num_Proc_HIA = @Num_Proc and 
			Num_DCN_HIA is null  and
			Cd_Cred_Dev_HIA = @Cred_Dev And 
			Comp_CN_HIA = 'S'
			
	If @CD = 'D'
		Select 
			CC.*, Nome_Tp_Tx_Ing
		From 
			Cta_Cte_Hou_Imp_Aer as CC  Join Tipo_Taxa as T on CC.Cd_Tp_Tx = T.Cd_Tp_Tx 
		Where	
			Num_Proc_HIA = @Num_Proc and 
			Num_DCN_HIA is null  and
			Cd_Cred_Dev_HIA = @Cred_Dev And 
			Comp_DN_HIA = 'S'

GO
