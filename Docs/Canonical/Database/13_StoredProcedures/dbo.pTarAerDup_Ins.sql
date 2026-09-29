SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTarAerDup_Ins
(
@TAEIDOld		int,
@TAECdOrg		varchar(3),
@TAECdDst		varchar(3),
@TAECdVia		varchar(3),
@Cd_Cia_Aer		varchar(3), 
@TptID			int, 
@TAEID		int 	OUTPUT
)
AS

	Begin Transaction 
	If Exists(Select * From Tar_Aer Where TAECdOrg = @TAECdOrg and TAECdDst = @TAECdDst and TAECdVia = TAECdVia and Cd_Cia_Aer = @Cd_Cia_Aer and TptID = @TptID) 
		Begin 
			RollBack Transaction 
			Return -1 
		End

	Set @TAEID =  IsNull((Select max(TAEID) From Tar_Aer ),0) + 1 
	
	Insert into Tar_Aer 
		Select @TAEID, @TAECdOrg, @TAECdDst, @TAECdVia, @Cd_Cia_Aer, TAEDtVal, TAEFreq, TAETTime, TAETTimeFator, Cd_Tp_Moeda, TAETpFator, TAEFator, TAEObs, @TptID, getdate() From Tar_Aer Where TAEID = @TAEIDOld 

	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -2 
		End 

	Insert into Tar_Tar_Aer
		Select @TAEID, TTARangMin, TTARangMax, TTAVlrComp, TTAVlrVnd From Tar_Tar_Aer Where TAEID = @TAEIDOld


	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -3
		End 	

	Insert into Tax_Tar_Aer 
		Select @TAEID, Cd_Tp_Tx, Cd_Tp_Moeda, TXAValor, TXAEspec From Tax_tar_aer Where TAEID = @TAEIDOld 
	
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -4
		End 	
	Else
		Begin 
			Commit Transaction 
			Return 1 
		End
GO
