SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pPropostaTaxMar_Ins 
(
@Proposta		VarChar(12),
@Rota			int,
@TptID			int = 1
)
AS

	Declare @Cd_Tp_Tx		VarChar(3) 
	Declare @Cd_Tp_Moeda	VarChar(3) 
	Declare @Valor			Float 
	Declare @Maior			Int 
	Declare @Espec		VarChar(30)

	Declare CurTaxas Cursor For 
	Select 
		TTM.Cd_Tp_Tx, TTM.Cd_Tp_Moeda, TTM.TXMValor , TTM.TXMEspec 
	From 
		Tax_Tar_Mar TTM Join Tar_Mar Tar on Tar.TAMID = TTM.TAMID 
		Join Proposta_Rot_Mar PRM on PRM.ProCod = @Proposta and PRMID = @Rota 
	Where 
		Tar.TAMCdOrg = PRM.PRMOrg and 
		Tar.TAMCdDst = PRM.PRMDst and 
		Tar.TAMCdVia = PRM.PRMGat  and 
		Tar.Cd_Armador = PRM.Cd_Armador and 
		Tar.TptID = @TptID

	Open CurTaxas 

	Fetch Next From CurTaxas into @Cd_Tp_Tx, @Cd_Tp_Moeda, @Valor , @Espec
	While @@Fetch_Status = 0 
		Begin 
			Set @Maior = IsNull((Select Max(PXMID) From Proposta_Tax_Mar Where ProCod = @Proposta and PRMID = @Rota),0) + 1 
			Insert Into Proposta_Tax_Mar Values (@Proposta, @Rota, @Maior, @Cd_Tp_Tx, @Cd_Tp_Moeda, @Valor, @Espec, 'C' )

			Fetch Next From CurTaxas into @Cd_Tp_Tx, @Cd_Tp_Moeda, @Valor, @Espec 
		End 	

	Close CurTaxas 	
	Deallocate CurTaxas
GO
