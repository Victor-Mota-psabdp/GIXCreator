SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTarMar_Ins
(
@TAMCdOrg		varchar(3),
@TAMCdDst		varchar(3),
@TAMCdVia		varchar(3),
@Cd_Armador		varchar(3), 
@TptID			int,
@TAMDtVal		datetime, 
@TAMFreq		varchar(20), 
@TAMTTime		varchar(25), 
@TAMTTimeFator	varchar(12), 
@Cd_Tp_Moeda	varchar(3), 
@TAMTpFator		char(1), 
@TAMFator		float, 
@TAMObs		varchar(200),
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
	
	Insert into Tar_Mar (TAMID, TAMCdOrg, TAMCdDst, TAMCdVia, Cd_Armador, TptID, TAMDtVal, TAMFreq, TAMTTime, TAMTTimeFator, Cd_Tp_Moeda, TAMTpFator, TAMFator, TAMObs, TAMDtAlt)			
		values (@TAMID, @TAMCdOrg, @TAMCdDst, @TAMCdVia, @Cd_Armador, @TptID, @TAMDtVal, @TAMFreq, @TAMTTime, @TAMTTimeFator, @Cd_Tp_Moeda, @TAMTpFator, @TAMFator, @TAMObs, getdate())			

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
