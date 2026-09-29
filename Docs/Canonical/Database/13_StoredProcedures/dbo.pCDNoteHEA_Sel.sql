SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCDNoteHEA_Sel
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
			Cta_Cte_Hou_Exp_Aer as CC  Join Tipo_Taxa as T on CC.Cd_Tp_Tx = T.Cd_Tp_Tx 
		Where	
			Num_Proc_HEA = @Num_Proc and 
			Num_DCN_HEA is null  and
			Cd_Cred_Dev_HEA = @Cred_Dev And 
			Comp_CN_HEA = 'S'
			
	If @CD = 'D'
		Select 
			CC.*, Nome_Tp_Tx_Ing
		From 
			Cta_Cte_Hou_Exp_Aer as CC  Join Tipo_Taxa as T on CC.Cd_Tp_Tx = T.Cd_Tp_Tx 
		Where	
			Num_Proc_HEA = @Num_Proc and 
			Num_DCN_HEA is null  and
			Cd_Cred_Dev_HEA = @Cred_Dev And 
			Comp_DN_HEA = 'S'

GO
