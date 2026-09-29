SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerLog_Ins](
@Processo varchar(16),
@CdUsuario varchar(15),
@ID_View datetime
)
as

Declare @ID bigint

set @ID = (Select isnull(MAX(ID),0)+1 from IBrokerTXT_Log)

Insert dbo.IBrokerTXT_Log(
						ID,
						Num_Proc,
						Cd_Usuario,
						Dt_Insert,
						ID_View
						)
					values
					(
					@ID,
					@Processo,
					@CdUsuario,
					GETDATE(),
					@ID_View
					)
						
						

GO
