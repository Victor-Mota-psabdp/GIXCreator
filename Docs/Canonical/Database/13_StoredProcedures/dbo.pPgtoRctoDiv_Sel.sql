SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pPgtoRctoDiv_Sel    Script Date: 25/10/2002 08:59:46 ******/
/****** Object:  Stored Procedure dbo.pPgtoRctoDiv_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPgtoRctoDiv_Sel 
(
@NumLcto		VarChar(12)=''
)
 AS
	If @NumLcto <> '' 
		Select 
			Num_Lcto_Div, DC_Div, Dt_Pgto_Rcto_Div, Pgt.Cd_Banco, Pgt.Cd_Agencia, Pgt.Num_Cta_Cte, Titular, Forma_Pgto_Rcto_Div, Num_Doc_Div, 
			Vlr_Doc_Div, Pgt.Cd_Pes, Apelido, Dt_Vcto_Div, Concil_Div , Cta_Cte_Cliente_Div, Ck_Doctos
		From 	
			Pgto_Rcto_Div as Pgt Join Cta_Cte as Cta on (Pgt.Cd_Banco = Cta.Cd_Banco and Pgt.Cd_Agencia = Cta.Cd_Agencia and Pgt.Num_Cta_Cte = Cta.Num_Cta_Cte) 
			Join Pessoa as Pes on Pgt.Cd_Pes = Pes.Cd_Pes 
		Where 
			Num_Lcto_Div = @NumLcto
	Else
		Select 
			Num_Lcto_Div 
		From 
			Pgto_Rcto_Div		
		Order by 
			Right(Num_Lcto_Div,10)  Desc

GO
