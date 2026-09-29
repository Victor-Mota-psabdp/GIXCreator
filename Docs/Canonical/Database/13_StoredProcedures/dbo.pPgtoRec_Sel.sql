SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pPgtoRec_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPgtoRec_Sel
(
@Num_Lcto		VarChar(12) = ''
)
 AS
	If @Num_Lcto <> '' 
		Select 
			PR.*, Cta.Titular, PS.Apelido, Ag.Nome_Agencia
		From 
			Pgto_Rcto as PR  Join Banco as Bco  on PR.Cd_Banco = Bco.Cd_Banco 
			Join Agencia as Ag on (PR.Cd_Banco = Ag.Cd_Banco and PR.Cd_Agencia= Ag.Cd_Agencia) 
			Join Cta_Cte as Cta on (PR.Cd_Banco = Cta.Cd_Banco and PR.Cd_Agencia = Cta.Cd_Agencia and PR.Num_Cta_Cte = Cta.Num_Cta_Cte)		
			Join Pessoa as PS on PR.Cd_Pes = PS.Cd_Pes
		Where
			PR.Num_Lcto = @Num_Lcto
	Else
		Select 
			Num_Lcto
		From 
			Pgto_Rcto 
		Order by 
			Right(Num_Lcto,10)  Desc



GO
