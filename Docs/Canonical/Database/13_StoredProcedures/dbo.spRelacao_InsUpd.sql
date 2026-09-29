SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







CREATE   PROCEDURE spRelacao_InsUpd

			@Cd_Pes_A 		varchar(50),
			@Pes_B 		varchar(50),
			@Tp_Rel		varchar(30),
			@Obs_Rel	varchar(2000)

AS

Begin Transaction

	Declare @Cd_Pes_B	varchar(10)
	Declare @Cd_Tp_Rel	varchar(3)	
 
	Set @Cd_Pes_B = (Select Cd_Pes from Pessoa where Apelido = @Pes_B)
	Set @Cd_Tp_Rel = (Select Cd_Tp_Rel from Tipo_Relacao where Nome_Tp_Rel = @Tp_Rel)

	If  exists (select Cd_pes_A from Relacao where cd_pes_A=@cd_pes_A and Cd_pes_B=@Cd_pes_B)
	   Begin
		Update
			Relacao
		Set
			Cd_Tp_Rel = @Cd_Tp_Rel,
			Obs_Rel = @Obs_Rel

		Where
		cd_pes_A=@cd_pes_A and Cd_pes_B=@Cd_pes_B
	   End
	Else
		Insert
			Relacao
		(
			Cd_Pes_A,
			Cd_Pes_B,
			Cd_Tp_Rel,
			Obs_Rel 

		)
		Values
		(
			@Cd_Pes_A,
			@Cd_Pes_B,
			@Cd_Tp_Rel,
			@Obs_Rel 
		)



		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

commit Transaction






GO
