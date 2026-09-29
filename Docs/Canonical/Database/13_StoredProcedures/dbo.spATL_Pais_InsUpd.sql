SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pais
CREATE PROCEDURE [dbo].[spATL_Pais_InsUpd]
(
	@Cd_Pais char(2),
	@Nome_Pais varchar(50),
	@FORM_A CHAR(1),
	@Nome_Pais_PT varchar(100),
	--	@Paraiso_Fiscal BIT,
	@HTS BIT,
	@Proibido BIT,
	@Cd_Usuario varchar(10),
	@Ativo BIT,
	@Bloqueado BIT,
	@Cd_Pais_IBGE varchar(5),
	@Cd_M49	varchar(5)
)

AS

Begin Transaction

	If  exists (select Cd_Pais from Pais where Cd_Pais=@Cd_Pais)
		Begin
			Update
				Pais
			Set
				Nome_Pais=@Nome_Pais,
				@FORM_A = @FORM_A,
				Nome_Pais_PT= @Nome_Pais_PT,
				--Paraiso_Fiscal = @Paraiso_Fiscal,
				HTS= @HTS,
				Proibido=@Proibido,
				Cd_Usuario = @Cd_Usuario,
				Ativo = @Ativo,
				Bloqueado = @Bloqueado,
				Cd_Pais_IBGE = @Cd_Pais_IBGE,
				Cd_M49 = @Cd_M49

			Where
				Cd_Pais=@Cd_Pais
		End
	Else
		Insert
			Pais(Cd_Pais,Nome_Pais,FORM_A,Nome_Pais_PT,HTS,Proibido,Cd_Usuario,Ativo, Bloqueado, Cd_Pais_IBGE, Cd_M49)

		Values
			(@Cd_Pais,@Nome_Pais,@FORM_A,@Nome_Pais_PT,@HTS,@Proibido,@Cd_Usuario,@Ativo, @Bloqueado, @Cd_Pais_IBGE, @Cd_M49)
	

Commit Transaction

GO
