SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pPropostaTaxAer_Ins 
(
@Proposta		VarChar(12),
@Rota			int,
@TptID			int = 1 
)
AS

	Declare @Cd_Tp_Tx		VarChar(3) 
	Declare @Cd_Tp_Moeda	VarChar(3) 
	Declare @Espec		VarChar(30)
	Declare @Valor			Float 
	Declare @Maior			Int 

	Declare CurTaxas Cursor For 
	Select 
		TTA.Cd_Tp_Tx, TTA.Cd_Tp_Moeda, TTA.TXAValor , TTA.TXAEspec
	From 
		Tax_Tar_Aer TTA Join Tar_Aer Tar on Tar.TAEID = TTA.TAEID 
		Join Proposta_Rot_Aer PRA on PRA.ProCod = @Proposta and PRAID = @Rota 
	Where 
		Tar.TAECdOrg = PRA.PRAOrg and 
		Tar.TAECdDst = PRA.PRADst and 
		Tar.TAECdVia = PRA.PRAGat and 
		Tar.Cd_Cia_Aer = PRA.Cd_Cia_Aer and 
		Tar.TptID = @TptID

	Open CurTaxas 

	Fetch Next From CurTaxas into @Cd_Tp_Tx, @Cd_Tp_Moeda, @Valor , @Espec
	While @@Fetch_Status = 0 
		Begin 
			Set @Maior = IsNull((Select Max(PXAID) From Proposta_Tax_Aer Where ProCod = @Proposta and PRAID = @Rota),0) + 1 
			Insert Into Proposta_Tax_Aer Values (@Proposta, @Rota, @Maior, @Cd_Tp_Tx, @Cd_Tp_Moeda, @Valor, @Espec, 'C' )

			Fetch Next From CurTaxas into @Cd_Tp_Tx, @Cd_Tp_Moeda, @Valor , @Espec
		End 	

	Close CurTaxas 	
	Deallocate CurTaxas
GO
