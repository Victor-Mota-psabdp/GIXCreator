SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTarMarDup_Ins
(
@TAMIDOld		int,
@TAMCdOrg		varchar(3),
@TAMCdDst		varchar(3),
@TAMCdVia		varchar(3),
@Cd_Armador		varchar(3), 
@TPTId		int, 
@TAMID		int 	OUTPUT
)
AS

	Begin Transaction 
	If Exists(Select * From Tar_Mar Where TAMCdOrg = @TAMCdOrg and TAMCdDst = @TAMCdDst and TAMCdVia = TAMCdVia and Cd_Armador = @Cd_Armador and TptID = @TptID) 
		Begin 
			RollBack Transaction 
			Return -1 
		End

	Set @TAMID =  IsNull((Select max(TAMID) From Tar_Mar ),0) + 1 
	
	Insert into Tar_Mar 
		Select @TAMID, @TAMCdOrg, @TAMCdDst, @TAMCdVia, @Cd_Armador, TAMDtVal, TAMFreq, TAMTTime, TAMTTimeFator, Cd_Tp_Moeda, TAMTpFator, TAMFator, TAMObs, @TptID, getdate()  From Tar_Mar Where TAMID = @TAMIDOld 

	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -2 
		End 

	Insert into Tar_Tar_Mar
		Select @TAMID, Cd_Tp_Cont, TTMVlrComp, TTMVlrVnd, TTMBAF From Tar_Tar_Mar Where TAMID = @TAMIDOld


	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -3
		End 	

	Insert into Tax_Tar_Mar 
		Select @TAMID, Cd_Tp_Tx, Cd_Tp_Moeda, TXMValor, TXMEspec From Tax_Tar_Mar Where TAMID = @TAMIDOld 
	
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
