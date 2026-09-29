SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pSaldoCtaCte_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pSaldoCtaCte_Sel 
(
@Banco		VarChar(3),
@Agencia		VarChar(5), 
@Num_Cta_Cte		VarChar(20)
)
 As 
	Select 
		Vlr_Saldo
	From 
		Saldo_Cta_Cte 
	Where 
		Cd_Banco = @Banco and 
		Cd_Agencia = @Agencia and  
		Num_Cta_Cte = @Num_Cta_Cte 
	Order By 
		Cast((substring(data_ref,4,4) + '-' + substring(data_ref, 1,2) + '-01') as datetime)



GO
