SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTarAer_Ins
(
@TAECdOrg		varchar(3),
@TAECdDst		varchar(3),
@TAECdVia		varchar(3),
@Cd_Cia_Aer		varchar(3), 
@TptID			Int,
@TAEDtVal		datetime, 
@TAEFreq		varchar(20), 
@TAETTime		varchar(25), 
@TAETTimeFator	varchar(12), 
@Cd_Tp_Moeda	varchar(3), 
@TAETpFator		char(1), 
@TAEFator		float, 
@TAEObs		varchar(200),
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
	
	Insert into Tar_Aer (TAEID, TAECdOrg, TAECdDst, TAECdVia, Cd_Cia_Aer, TptID, TAEDtVal, TAEFreq, TAETTime, TAETTimeFator, Cd_Tp_Moeda, TAETpFator, TAEFator, TAEObs, TAEDtAlt)			
		values (@TAEID, @TAECdOrg, @TAECdDst, @TAECdVia, @Cd_Cia_Aer, @TptID, @TAEDtVal, @TAEFreq, @TAETTime, @TAETTimeFator, @Cd_Tp_Moeda, @TAETpFator, @TAEFator, @TAEObs, getdate())			

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
