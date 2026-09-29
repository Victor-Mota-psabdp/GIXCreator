SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTxItemRemessaMar_Sel  
(
@Num_Proc		VarChar(16),
@Cd_Cred_Dev		VarChar(10) 
)
AS
	If Left(@Num_Proc, 2) = 'EM'
		Select 
			Cte.Cd_Tp_Tx, Nome_Tp_Tx  
		From 
			 Cta_Cte_Hou_Exp_Mar as Cte Join Tipo_Taxa as TX On Cte.Cd_Tp_Tx = Tx.Cd_Tp_Tx 
		Where
			Num_Proc_HEM = @Num_Proc and 
			Cd_Cred_Dev_HEM = @Cd_Cred_Dev and 
			((Cte.Cd_Tp_Tx = 'FRT' and DC_HEM = 'D') Or Cte.Cd_Tp_Tx = 'PBD' Or Cte.Cd_Tp_Tx = 'PSA' Or Comp_CN_HEM = 'S' Or Comp_DN_HEM = 'S')
	Else
		Begin 
			If Left(@Num_Proc, 2) = 'IM'
				Select 
					Cte.Cd_Tp_Tx, Nome_Tp_Tx 
				From 
					Cta_Cte_Hou_Imp_Mar as Cte Join Tipo_Taxa as TX On Cte.Cd_Tp_Tx = Tx.Cd_Tp_Tx 
				Where
					Num_Proc_HIM = @Num_Proc and 
					Cd_Cred_Dev_HIM = @Cd_Cred_Dev and 
					((Cte.Cd_Tp_Tx = 'FRT' and DC_HIM = 'D') Or Cte.Cd_Tp_Tx = 'PBD' Or Cte.Cd_Tp_Tx = 'PSA' Or Comp_CN_HIM = 'S' Or Comp_DN_HIM = 'S')
		End

GO
