SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTxItemRemessaAer_Sel  
(
@Num_Proc		VarChar(16),
@Cd_Cred_Dev		VarChar(10) 
)
AS
	If Left(@Num_Proc, 2) = 'EA'
		Select 
			Cte.Cd_Tp_Tx, Nome_Tp_Tx  
		From 
			 Cta_Cte_Hou_Exp_Aer as Cte Join Tipo_Taxa as TX On Cte.Cd_Tp_Tx = Tx.Cd_Tp_Tx 
		Where
			Num_Proc_HEA = @Num_Proc and 
			Cd_Cred_Dev_HEA = @Cd_Cred_Dev and 
			((Cte.Cd_Tp_Tx = 'FRT' and DC_HEA = 'D') Or Cte.Cd_Tp_Tx = 'PBD' Or Cte.Cd_Tp_Tx = 'PSA' Or Comp_CN_HEA = 'S' Or Comp_DN_HEA = 'S')
	Else
		Begin 
			If Left(@Num_Proc, 2) = 'IA'
				Select 
					Cte.Cd_Tp_Tx, Nome_Tp_Tx 
				From 
					 Cta_Cte_Hou_Imp_Aer as Cte Join Tipo_Taxa as TX On Cte.Cd_Tp_Tx = Tx.Cd_Tp_Tx 
				Where
					Num_Proc_HIA = @Num_Proc and 
					Cd_Cred_Dev_HIA = @Cd_Cred_Dev and 
					((Cte.Cd_Tp_Tx = 'FRT' and DC_HIA = 'D') Or Cte.Cd_Tp_Tx = 'PBD' Or Cte.Cd_Tp_Tx = 'PSA' Or Comp_CN_HIA = 'S' Or Comp_DN_HIA = 'S')
		End

GO
