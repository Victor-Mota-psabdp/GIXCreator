SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCxaHEM_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCxaHEM_Sel 
(
@Num_Proc_HEM	VarChar(16),
@Cd_Tp_Tx		VarChar(3)='', 
@DC_HEM		Char(1)='',
@Detalhe		Char(1)=''
)
 AS
	If @Detalhe = '' 
		Select 
			*
		From 
			Caixa_Hou_Exp_Mar
		Where 
			Num_Proc_HEM = @Num_Proc_HEM  AND 
			Cd_Tp_Tx = @Cd_Tp_Tx AND 
			DC_HEM = @DC_HEM
		Order by 
			Num_Lcto
	Else
		Select 
			Num_Rcb_HEM, Nome_Tp_Tx, Cxa.DC_HEM, Num_Lcto, Nome_Tp_Moeda, 
			Vlr_Ref_HEM, Dt_Conv_HEM, Nome_Tp_Par, Par_Moeda_HEM, Vlr_Pgto_Rcto_HEM, 
			Dt_Pgto_Rcto_HEM, Dt_Ctb_Cx_HEM 
		From 
			Cta_Cte_Hou_Exp_Mar as Cta  Join Caixa_Hou_Exp_Mar as Cxa on (Cta.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEM = Cxa.DC_HEM)
			Join Tipo_Taxa as TT  on Cxa.Cd_Tp_Tx = TT.Cd_Tp_Tx 
			Join Tipo_Moeda as TM on Cta.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
			Join Tipo_Paridade as TP on Cxa.Cd_Tp_Par = TP.Cd_Tp_Par 
		Where
			Cxa.Num_Proc_HEM = @Num_Proc_HEM
		Order by 
			Nome_Tp_Tx, Cxa.DC_HEM, Num_Lcto



GO
