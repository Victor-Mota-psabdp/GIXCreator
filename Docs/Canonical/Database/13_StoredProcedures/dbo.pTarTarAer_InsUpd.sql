SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTarTarAer_InsUpd 
(
@TAEID		int,
@StrRange1		VarChar(10),
@StrRange2		VarChar(10)='',
@VlrCompra		Float=NULL, 
@VlrVenda		Float=NULL
)
AS
	Declare @Range1	Float 
	Declare @Range2	Float 
	Declare @Max		Integer 

	if  @StrRange1 = 'Mínima' 
		Begin 
			Set @Range1 = -1 
			Set @Range2 = 0 
		End 

	Else
		Begin 
			Set @Range1 = @StrRange1 
			Set @Range2 = @StrRange2
		End 

	Begin Transaction 
	If Exists(Select * From Tar_Tar_Aer Where TTARangMin = @Range1 and TAEID = @TAEID) 
		Begin 
			Update 
				Tar_Tar_Aer
			Set 
				TTAVlrComp  = @VlrCompra,
				TTAVlrVnd = @VlrVenda
			Where
				TTARangMin  = @Range1 and 
				TTARangMax = @Range2 and 
				TAEID = @TAEID

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
			Insert into Tar_Tar_Aer (TAEID, TTARangMin, TTARangMax, TTAVlrComp, TTAVlrVnd) values 
				(@TAEID, @Range1, @Range2, @VlrCompra, @VlrVenda)
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
