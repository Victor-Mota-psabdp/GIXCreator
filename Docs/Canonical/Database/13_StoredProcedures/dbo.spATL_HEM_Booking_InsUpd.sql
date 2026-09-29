SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_HEM_Booking_InsUpd] 
(
	@Processo			VarChar(16), 
	@Cd_Tp_Com_Cli 		Varchar(3),
	@Cd_Pes_Dcto		varchar(10),
	@Cd_Tp_Com_Dcto		Varchar(3),
	@Cd_Pes_Crg			varchar(10), 
	@Cd_Tp_Com_Crg		Varchar(3),
	@Obs				VarChar(500),
	@Booking			Varchar(30),
	@DL_Draft_Lem		Datetime,	
	@DL_Cargo_Lem		Datetime,
	@Cd_Retirada_Vazios	Varchar(10),
	@DL_VGM_Lem			Datetime
)
AS
BEGIN TRANSACTION		


--JOB
	if exists(select Num_Proc_HEM from Job_Exp_Mar where Num_Proc_HEM = @Processo)
	Begin
		Update 
			Job_Exp_Mar
		Set 
			Cd_Tp_Com_Cli=@Cd_Tp_Com_Cli,
			Cd_Pes_Dcto=@Cd_Pes_Dcto, 
			Cd_Tp_Com_Dcto=@Cd_Tp_Com_Dcto, 
			Cd_Pes_Crg=@Cd_Pes_Crg, 
			Cd_Tp_Com_Crg=@Cd_Tp_Com_Crg,
			Obs_JEM = @Obs,
			--Nr_Reserva = @Booking,
			Cd_Retirada_Vazios=@Cd_Retirada_Vazios
		Where
			Num_Proc_HEM = @Processo
	end

---LLP
	if exists(select Num_Proc_LEM from LLP_Exp_Mar where Num_Proc_LEM = @Processo)
	Begin
		Update 
			LLP_Exp_Mar
		Set 
			DL_Draft_Lem = @DL_Draft_Lem,
			DL_Cargo_Lem = @DL_Cargo_Lem,
			DL_VGM_Lem = @DL_VGM_Lem		
		Where
			Num_Proc_LEM = @Processo
	End
	   
	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END


COMMIT TRANSACTION












GO
