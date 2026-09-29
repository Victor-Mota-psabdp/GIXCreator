SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_Log_Pibernat_Ins]
(

	@Arquivo		varchar(100),
	@DataIns		Datetime,
	@Status			varchar(200),
	@DataEnvPibernat Datetime
)

AS

--sp_help Log_Pibernat

Begin Transaction
	
	Begin		
		Insert Into Log_Pibernat
			(Arquivo,DataIns,Status,DataEnvPibernat)
		Values
			(@Arquivo,@DataIns,@Status,@DataEnvPibernat)
	End
	

Commit Transaction





GO
