SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sELECT * FROM PARIDADE WHERE Dt_Par='21/11/2019' 
--sELECT * FROM PARIDADE WHERE Dt_Par='28/02/2021' and cd_tp_par ='OFC'
--sp_help Paridade

CREATE procedure [dbo].[spATLDN_Paridade_InsUpd]
(
	@Dt_Par			varchar(10),
	@Cd_Tp_Moeda	varchar(3),
	@Cd_Tp_Par		varchar(3),
	@Par_Moeda		decimal(16,6),
	@cd_usuario		varchar(6)
)

AS

Begin Transaction

if exists(Select cd_tp_moeda from tipo_moeda where cd_tp_moeda = @Cd_Tp_Moeda)
	BEGIN
		IF exists(SELECT Dt_Par FROM PARIDADE WHERE Dt_Par=@Dt_Par AND	Cd_Tp_Moeda=@Cd_Tp_Moeda AND Cd_Tp_Par=@Cd_Tp_Par)
		BEGIN
			UPDATE PARIDADE
			SET
				Par_Moeda = @Par_Moeda
			WHERE
				Dt_Par=@Dt_Par AND Cd_Tp_Moeda=@Cd_Tp_Moeda AND	Cd_Tp_Par=@Cd_Tp_Par
		END
	ELSE
		BEGIN
			INSERT
				PARIDADE
				(
					Dt_Par, Cd_Tp_Moeda, Cd_Tp_Par, Par_Moeda
				)
			Values
				(
					@Dt_Par, @Cd_Tp_Moeda, @Cd_Tp_Par, @Par_Moeda
				)
		END	
	
		BEGIN	
			insert into Log_Paridade
				([Dt_Ins],[Cd_Usuario],[Dt_Par],[Cd_Tp_Moeda],[Cd_Tp_Par],[Par_Moeda])
			values
				(getdate(), @cd_usuario,@Dt_Par, @Cd_Tp_Moeda, @Cd_Tp_Par, @Par_Moeda)
		END

END	

Commit Transaction





GO
