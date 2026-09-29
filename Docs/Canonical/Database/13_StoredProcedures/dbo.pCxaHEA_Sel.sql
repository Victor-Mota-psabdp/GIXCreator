SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCxaHEA_Sel 
(
@Num_Proc_HEA	VarChar(16),
@Cd_Tp_Tx		VarChar(3)='', 
@DC_HEA		Char(1)='',
@Detalhe		Char(1)=''
)
 AS
	If @Detalhe = '' 
		Select 
			*
		From 
			Caixa_Hou_Exp_Aer
		Where 
			Num_Proc_HEA = @Num_Proc_HEA  AND 
			Cd_Tp_Tx = @Cd_Tp_Tx AND 
			DC_HEA = @DC_HEA
		Order by 
			Num_Lcto
	Else
		Select 
			Num_Rcb_HEA, Nome_Tp_Tx, Cxa.DC_HEA, Num_Lcto, Nome_Tp_Moeda, 
			Vlr_Ref_HEA, Dt_Conv_HEA, Nome_Tp_Par, Par_Moeda_HEA, Vlr_Pgto_Rcto_HEA, 
			Dt_Pgto_Rcto_HEA, Dt_Ctb_Cx_HEA 
		From 
			Cta_Cte_Hou_Exp_Aer as Cta  Join Caixa_Hou_Exp_Aer as Cxa on (Cta.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEA = Cxa.DC_HEA)
			Join Tipo_Taxa as TT  on Cxa.Cd_Tp_Tx = TT.Cd_Tp_Tx 
			Join Tipo_Moeda as TM on Cta.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
			Join Tipo_Paridade as TP on Cxa.Cd_Tp_Par = TP.Cd_Tp_Par 
		Where
			Cxa.Num_Proc_HEA = @Num_Proc_HEA
		Order by 
			Nome_Tp_Tx, Cxa.DC_HEA, Num_Lcto



GO
