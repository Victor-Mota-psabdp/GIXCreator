SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMvtoCtaCte_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pMvtoCtaCte_Sel 
(
@Num_Lcto		VarChar(12) = ''
)
 AS
	If @Num_Lcto <> '' 
		Select 
			MCT.*, Cta.Titular
		From 
			Mvto_Cta_Cte as MCT  Join Banco as Bco  on MCT.Cd_Banco = Bco.Cd_Banco 
			Join Agencia as Ag on (MCT.Cd_Banco = Ag.Cd_Banco and MCT.Cd_Agencia= Ag.Cd_Agencia) 
			Join Cta_Cte as Cta on (MCT.Cd_Banco = Cta.Cd_Banco and MCT.Cd_Agencia = Cta.Cd_Agencia and MCT.Num_Cta_Cte = Cta.Num_Cta_Cte)
			
		Where
			Num_Lcto_Mov = @Num_Lcto 
	Else
		Select 
			Num_Lcto_Mov	
		From 
			Mvto_Cta_Cte
		Order by 
			Num_Lcto_Mov



GO
