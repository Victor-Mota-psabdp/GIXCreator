SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTarTarMar_InsUpd 
(
@TAMID		int,
@Tp_Cont		VarChar(30), 
@VlrCompra		Float=NULL, 
@VlrVenda		Float=NULL,
@TTMBAF			Float=Null
)
AS
	Declare @Cd_Tp_Cont	VarChar(3) 
	Declare @Max		Integer 

	Set @Cd_Tp_Cont = (Select Cd_Tp_Cont From Tipo_Container Where Nome_Tp_Cont = @Tp_Cont)
	
	Begin Transaction 
	If Exists(Select * From Tar_Tar_Mar Where Cd_Tp_Cont = @Cd_Tp_Cont and TAMID = @TAMID) 
		Begin 
			Update 
				Tar_Tar_Mar
			Set 
				TTMVlrComp  = @VlrCompra,
				TTMVlrVnd = @VlrVenda, 
				TTMBAF = @TTMBAF
			Where
				Cd_Tp_Cont = @Cd_Tp_Cont and 
				TAMID = @TAMID

			If @@Error  <> 0 
				Begin 
					Rollback  Transaction 
					Return -1 
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 

		End 
	Else
		Begin
			Insert into Tar_Tar_Mar (TAMID, Cd_Tp_Cont, TTMVlrComp, TTMVlrVnd, TTMBAF) values 
				(@TAMID, @Cd_Tp_Cont, @VlrCompra, @VlrVenda, @TTMBAF)
			If @@Error  <> 0 
				Begin 
					Rollback  Transaction 
					Return -1 
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 
		End

GO
