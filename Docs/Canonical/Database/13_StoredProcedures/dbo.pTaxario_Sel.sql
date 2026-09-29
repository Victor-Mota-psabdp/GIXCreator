SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTaxario_Sel 
(
@Cd_tp_Tx		Varchar(3), 
@Cd_Modal		Char(2), 
@Cd_Local 		VarChar(3), 
@TxrNat		char(1), 
@Cd_Pes		Varchar(10)
)
AS
	Select 
		Tax.*, Forn.Apelido, Loc.Nome_Local Localidade, TT.Nome_Tp_Tx 
	From 
		Taxario Tax Join Pessoa Forn on Forn.Cd_Pes = Tax.Cd_Pes  
		Join Localidade Loc on Loc.Cd_Local = Tax.Cd_Local 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Tax.Cd_Tp_Tx 
	Where
		Tax.Cd_Tp_Tx = @Cd_Tp_Tx and 
		Tax.Cd_Modal = @Cd_modal and 
		Tax.Cd_local = @Cd_local and 
		Tax.TxrNat = @TxrNat and 
		Tax.Cd_Pes = @Cd_Pes

GO
