SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Log_FComex_InsUpd]
	   @Num_Proc   varchar(16),
	   @Cd_usuario varchar(10),
       @Dt_Ins     datetime,
	   @Origem     varchar(200),
	   @Message    varchar(max)
AS

Begin Transaction
	  Begin	
		   Insert
		        dbo.Log_FComex 
		   Values			
				(@Num_Proc,@Cd_Usuario, GETDATE(),@Origem,@Message)
	  End

if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction
GO
