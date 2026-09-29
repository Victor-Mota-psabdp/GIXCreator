SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Exchange_GTNexus
CREATE procedure [dbo].[spATL_Exchange_GTNexus_InsUpd]
(
	@ID				BigInt,
	@Num_Proc		varchar(16),	
	@cd_tp_gix		varchar(2),
	@Dt_Ins			datetime,
	@Dt_Send		datetime,
	@Cd_Usuario		varchar(6),
	@Cd_Tp_EnvioGix 	varchar(1)	
)
as

	if exists(select * from Exchange_GTNexus where ID = @ID)
		BEGIN
			Update
				Exchange_GTNexus
			Set
				Dt_Send = @Dt_Send
			where 
				ID = @ID
		END
	else
		BEGIN
			insert into Exchange_GTNexus
				(
					Num_Proc,Type,Dt_Ins,Dt_Send,Cd_Usuario,Tipo_Envio
				)
			Values
				(
					@Num_Proc,@cd_tp_gix,@Dt_Ins,@Dt_Send,@Cd_Usuario,@Cd_Tp_EnvioGix
				)
		END
	


GO
