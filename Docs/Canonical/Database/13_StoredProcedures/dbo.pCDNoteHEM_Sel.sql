SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCDNoteHEM_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCDNoteHEM_Sel
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
			Cta_Cte_Hou_Exp_Mar as CC  Join Tipo_Taxa as T on CC.Cd_Tp_Tx = T.Cd_Tp_Tx 
		Where	
			Num_Proc_HEM = @Num_Proc and 
			Num_DCN_HEM is null  and
			Cd_Cred_Dev_HEM = @Cred_Dev And 
			Comp_CN_HEM = 'S'
			
	If @CD = 'D'
		Select 
			CC.*, Nome_Tp_Tx_Ing
		From 
			Cta_Cte_Hou_Exp_Mar as CC  Join Tipo_Taxa as T on CC.Cd_Tp_Tx = T.Cd_Tp_Tx 
		Where	
			Num_Proc_HEM = @Num_Proc and 
			Num_DCN_HEM is null  and
			Cd_Cred_Dev_HEM = @Cred_Dev And 
			Comp_DN_HEM = 'S'



GO
