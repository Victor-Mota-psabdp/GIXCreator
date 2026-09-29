SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







CREATE    PROCEDURE spGrupo_InsUpd

			@Cd_Pes		varchar(10),
			@Pes_Grupo 	varchar(50),
			@Cd_Planta	varchar(30),
			@Cd_Vendor	varchar(50)

AS

Begin Transaction

	Declare @Cd_Pes_Grupo	varchar(10)
 
	Set @Cd_Pes_Grupo = (Select Cd_Pes from Pessoa where Apelido = @Pes_Grupo)

	If  exists (select Cd_pes from Pessoa_LLP where Cd_Pes = @Cd_Pes)
	   Begin
		Update
			Pessoa_LLP
		Set
			Cd_Vendor = @Cd_Vendor,
			Cd_Planta = @Cd_Planta,
			Cd_Pes_Grupo = @Cd_Pes_Grupo

		Where
		Cd_Pes = @Cd_Pes 
	   End
	Else
		Insert
			Pessoa_LLP
		(
			Cd_Pes,
			Cd_Planta,
			Cd_Pes_Grupo,
			Cd_Vendor


		)
		Values
		(
			@Cd_Pes,
			@Cd_Planta,
			@Cd_Pes_Grupo,
			@Cd_Vendor
		)



		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

commit Transaction







GO
