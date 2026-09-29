SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Report_Log_Ins]
	@Report varchar(100),
	@Cd_Usuario varchar(50),
	@dtInicio datetime,
	@strSQL varchar(200)
AS

declare @ID_Report int
set @ID_Report = (select top 1 ID from report with(nolock) where Report_Name = @Report)

BEGIN TRANSACTION

	INSERT INTO
		Report_Log(ID_Report, CD_Usuario, dtInicio, dtFinal, strSQL)
	VALUES
		(
		@ID_Report, @Cd_Usuario, @dtInicio, getdate(), @strSQL
		)
	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION

GO
