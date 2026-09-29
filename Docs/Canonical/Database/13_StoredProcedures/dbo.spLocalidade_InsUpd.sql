SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  procedure [dbo].[spLocalidade_InsUpd]

	@Cd_Local	varchar(3),
	@Nome_Local	varchar(30),
	@Cidade_Local	varchar(25),
	@Pais_Local	varchar(50),
	@Cd_Regiao	varchar(3),
	@Aerop	char(1),
	@Porto	char(1),
	@Gate	char(1),
	@BITRI	varchar(6),
	@Cd_Pais	varchar(3),
	@IATACODE	varchar(3),
	@SCAC	varchar(6),
	@Desat_loc	char(1),
	@dt_criacao	datetime

AS

Begin Transaction

	Set @Pais_Local = (select nome_pais from pais where cd_pais = @cd_Pais)

	if @Pais_Local is null
		begin
			set @Pais_Local = ''
		end

	If  exists (select cd_local from Localidade where cd_local=@Cd_Local)
	Begin
		Update
			Localidade
		Set
			Nome_Local = @Nome_Local,
			Cidade_Local = @Cidade_Local,
			Cd_Pais =@Cd_Pais,
			Cd_Regiao=@Cd_Regiao,
			Aerop=@Aerop,
			Porto=@Porto,
			Gate=@Gate,
			Bitri=@BiTri,
			IATACODE = @IATACODE,
			SCAC = @SCAC,
			pais_local = @Pais_Local,
			Desat_Loc = @Desat_Loc
		Where
			cd_local = @Cd_Local
	End
	Else
		Insert Localidade
			(
				Cd_Local,
				Nome_Local,
				Cidade_Local,
				Cd_Pais,
				Cd_Regiao,
				Aerop,
				Porto,
				Gate,
				BiTri,
				IATACODE,
				SCAC,
				Pais_local,
				Desat_Loc,
				Dt_Criacao
			)
		Values
			(
				@Cd_Local,
				@Nome_Local,
				@Cidade_Local,
				@Cd_Pais,
				@Cd_Regiao,
				@Aerop,
				@Porto,
				@Gate,
				@BiTri,
				@IATACODE,
				@SCAC,
				@Pais_Local,
				@Desat_loc,
				getdate()
			)

Commit Transaction




GO
