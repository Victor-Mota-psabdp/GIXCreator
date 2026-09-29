SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spIBrokerViewLog_Ins
(
	@ID_View	bigint,
	@Num_Proc	varchar(50),
	@Tipo	varchar(1),
	@Cd_Usuario	varchar(10)
)

as

Declare @ID bigint

set @ID = (Select ISNULL(max(ID),0)+1  from IBrokerView_Log)


	Insert INTO IBrokerView_Log (
								ID,
								ID_View,
								Num_Proc,
								Tipo,
								Cd_Usuario,
								Dt_Insert
								)
	values(
					@ID,
					@ID_View,
					@Num_Proc,
					@Tipo,
					@Cd_Usuario,
					GETDATE()
					)


GO
