SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Log_Paridade
--ALTER TABLE Log_Paridade ADD [ID_Log] [bigint] IDENTITY (1, 1) NOT NULL
--ALTER TABLE Log_Paridade ADD [Tp_Oper] [char](1)  NULL
--select * from Paridade where dt_par = '28/07/2022'

CREATE procedure [dbo].[spATL_Log_Paridade_InsUpd]
(
	@ID_Log			bigint,
	@Dt_Alter		Datetime,
	@Tp_Oper		varchar(1),
	@Dt_Par			varchar(10),
	@Cd_Tp_Moeda	varchar(3),
	@Cd_Tp_Par		varchar(3),
	@Par_Moeda		decimal(16,6),
	@cd_usuario		varchar(6)
)

AS

Begin Transaction
	
		BEGIN	
			insert into Log_Paridade
				([Dt_Ins],[Cd_Usuario],[Dt_Par],[Cd_Tp_Moeda],[Cd_Tp_Par],[Par_Moeda],Tp_Oper)
			values
				(getdate(), @cd_usuario,@Dt_Par, @Cd_Tp_Moeda, @Cd_Tp_Par, @Par_Moeda,@Tp_Oper)
		END
		

Commit Transaction





GO
