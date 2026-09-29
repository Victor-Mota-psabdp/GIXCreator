SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pTaxaNegExpMar_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pTaxaNegExpMar_Sel 
(
@Proposta		VarChar(11)='', 
@Cd_Taxa		Char(3)='', 
@Cd_Peso_Tx		Char(1)=''
)
 AS
	If @Cd_Taxa = '' and @Cd_Peso_Tx = ''
		Select 
			Distinct 
				Num_Prop_EM, Cd_Tp_Tx 
			From  
				Taxa_Neg_Exp_Mar 
			Where 
				Num_Prop_EM = @Proposta 
	Else 
		Select 
			*
		From 
			Taxa_Neg_Exp_Mar
		Where 
			Num_Prop_EM = @Proposta and 
			Cd_Tp_Tx =  @Cd_Taxa and 
			Cd_Peso_Tx = @Cd_Peso_Tx



GO
