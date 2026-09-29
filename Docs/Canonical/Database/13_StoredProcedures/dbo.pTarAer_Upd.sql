SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTarAer_Upd
(
@TAEID		int, 
@TAECdOrg		varchar(3),
@TAECdDst		varchar(3),
@TAECdVia		varchar(3),
@Cd_Cia_Aer		varchar(3), 
@TptID			int,  
@TAEDtVal		datetime, 
@TAEFreq		varchar(20), 
@TAETTime		varchar(25), 
@TAETTimeFator	varchar(12), 
@Cd_Tp_Moeda	varchar(3), 
@TAETpFator		char(1), 
@TAEFator		float, 
@TAEObs		varchar(200)
)
AS

	Begin Transaction 
	If  Exists(Select * From Tar_Aer Where TAECdOrg = @TAECdOrg and TAECdDst = @TAECdDst and TAECdVia = TAECdVia and Cd_Cia_Aer = @Cd_Cia_Aer and TptID = @TptID and TAEID <> @TAEID) 
		Begin 
			RollBack Transaction 
			Return -1 
		End

	Update 
		Tar_Aer
	Set 
		TAECdOrg = @TAECdOrg, 
		TAECdDst = @TAECdDst, 
		TAECdVia = @TAECdVia, 
		Cd_Cia_Aer = @Cd_Cia_Aer, 
		TptID = @TptID, 
		TAEDtVal = @TAEDtVal, 
		TAEFreq = @TAEFreq,
		TAETTime = @TAETTime, 
		TAETTimeFator= @TAETTimeFator,
		Cd_Tp_Moeda = @Cd_Tp_Moeda, 
		TAETpFator = @TAETpFator, 
		TAEFator = @TAEFator,
		TAEObs = @TAEObs,
		TAEDtAlt = getdate()
	Where 
		TAEID = @TAEID

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
