SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spARG_AirlineStock_Upd]
(
	@Type int
	,@Number varchar(20)
	,@CdCia varchar(100)
	,@NumProc varchar(20)
)
AS
BEGIN
	if @Type=1 --ENABLE
		BEGIN
			Update AirlineStock set Proc_Num = null WHERE Number= @Number AND Cd_Cia_Aer=@CdCia
			Update House_Exp_Aer set MAWB_HEA='' WHERE Num_Proc_HEA=@NumProc
			Update Master_Exp_Aer Set MAWB_MEA='' Where Num_Proc_MEA=@NumProc
		END
	IF @Type=2 -- Disable
		BEGIN
			Update AirlineStock set Proc_Num='JOB' WHERE Number= @Number AND Cd_Cia_Aer=@CdCia
		END
	IF @Type=3 -- Used
		BEGIN
			Update AirlineStock set Proc_Num = @NumProc WHERE Number= @Number AND Cd_Cia_Aer=(Select Cd_Cia_Aer from Cia_Aerea where Nome_Cia_Aer= @CdCia)
		END
END
GO
