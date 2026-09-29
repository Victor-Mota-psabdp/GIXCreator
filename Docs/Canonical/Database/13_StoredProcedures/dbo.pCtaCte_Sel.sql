SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCte_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCte_Sel 
(
@Cd_Banco 		VarChar(3)='',
@Cd_Agencia 		VarChar(5)='',
@Num_Cta_Cte		VarChar(20)='',
@Titular		VarChar(20)=''
)
 AS
	If @Cd_Banco <> '' 
		Select 
			*
		From 
			Cta_Cte 
		Where
			Cd_Banco =@Cd_Banco and 
			Cd_Agencia = @Cd_Agencia and 
			Num_Cta_Cte = @Num_Cta_Cte
	Else 
		Begin 
			If @Titular <> '' 
				Select 
					*
				From 
					Cta_Cte
				Where
					Titular like @Titular 
			Else 
				Select 
					*
				From 
					Cta_Cte
				Order by 
					Titular
		End



GO
