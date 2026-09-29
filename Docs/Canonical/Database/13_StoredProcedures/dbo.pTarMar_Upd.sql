SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTarMar_Upd
(
@TAMID		int, 
@TAMCdOrg		varchar(3),
@TAMCdDst		varchar(3),
@TAMCdVia		varchar(3),
@Cd_Armador		varchar(3), 
@TPTId		int, 
@TAMDtVal		datetime, 
@TAMFreq		varchar(20), 
@TAMTTime		varchar(25), 
@TAMTTimeFator	varchar(12), 
@Cd_Tp_Moeda	varchar(3), 
@TAMTpFator		char(1), 
@TAMFator		float, 
@TAMObs		varchar(200)
)
AS

	Begin Transaction 
	If  Exists(Select * From Tar_Mar Where TAMCdOrg = @TAMCdOrg and TAMCdDst = @TAMCdDst and TAMCdVia = TAMCdVia and Cd_Armador = @Cd_Armador and TptID = @TptID and TAMID <> @TAMID) 
		Begin 
			RollBack Transaction 
			Return -1 
		End

	Update 
		Tar_Mar
	Set 
		TAMCdOrg = @TAMCdOrg, 
		TAMCdDst = @TAMCdDst, 
		TAMCdVia = @TAMCdVia, 
		Cd_Armador = @Cd_Armador, 
		TPTId = @TPTId, 
		TAMDtVal = @TAMDtVal, 
		TAMFreq = @TAMFreq,
		TAMTTime = @TAMTTime, 
		TAMTTimeFator= @TAMTTimeFator,
		Cd_Tp_Moeda = @Cd_Tp_Moeda, 
		TAMTpFator = @TAMTpFator, 
		TAMFator = @TAMFator,
		TAMObs = @TAMObs,
		TAMDtAlt = getdate()
	Where 
		TAMID = @TAMID

	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -2 
		End 
	Else
		Begin 
			Commit Transaction 
			Return 1 
		End
GO
