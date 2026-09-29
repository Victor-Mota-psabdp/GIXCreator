SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







create       procedure [dbo].[spParidade_InsUpd]

	@Data		varchar(10),
	@Moeda		varchar(3),
	@Paridade	varchar(3),
	@ParMoeda	decimal(16,6)

AS

Begin Transaction

	IF  exists(
		SELECT
			Dt_Par, Cd_Tp_Moeda, Cd_Tp_Par
		FROM
			PARIDADE

		WHERE
			Dt_Par=@Data
		AND
			Cd_Tp_Moeda=@Moeda
		AND
			Cd_Tp_Par=@Paridade
	)


	BEGIN
		UPDATE
			PARIDADE
		SET
			Par_Moeda = @ParMoeda
		WHERE
			Dt_Par=@Data
		AND
			Cd_Tp_Moeda=@Moeda
		AND
			Cd_Tp_Par=@Paridade
	END
	ELSE
		INSERT
			PARIDADE(
				Dt_Par, Cd_Tp_Moeda, Cd_Tp_Par, Par_Moeda
				)
		Values
			(
				@Data, @Moeda, @Paridade, @ParMoeda
			)

Commit Transaction





GO
