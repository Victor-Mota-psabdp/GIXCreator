SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pLucratCliente_Ins 
(
@StrMachine		VarChar(30)
)
AS
	Declare @Pos	Int 
	Declare @Cliente	VarChar(30) 
	Declare @Resultado	Float 
	Set @Pos = 1
	
	Delete 	TMP_Lucrat_Pos  Where StrMachine = @StrMachine

	Declare CurLucro Cursor For 
	Select 
		Cliente, Sum(Cta_Cte_House) + Sum(Cta_Cte_Master) as Resultado 
	From 
		Tmp_lucrat
	Where
		StrMachine = @StrMachine 
	Group by 
		Cliente
	Order by 
		Resultado Desc 

	Open CurLucro 

	Fetch Next From CurLucro Into @Cliente, @Resultado 

	While @@Fetch_Status = 0
		Begin 
			Insert Into TMP_Lucrat_Pos Values (@StrMachine, @Pos, @Cliente, @Resultado) 
			Set @Pos = @Pos + 1 			
			Fetch Next From CurLucro Into @Cliente, @Resultado 
		End
	Close CurLucro
	Deallocate curlucro

GO
