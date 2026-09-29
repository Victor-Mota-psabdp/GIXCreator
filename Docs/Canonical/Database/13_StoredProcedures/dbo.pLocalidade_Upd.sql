SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pLocalidade_Upd 
(
@Cd_Local			varchar(3), 
@Nome_Local			varchar(30),
@Cidade_Local			varchar(25), 
@Pais_Local			varchar(15), 
@Cd_Regiao			varchar(3), 
@Aerop				char(1), 
@Porto				char(1), 
@Gate				char(1), 
@BITRI				varchar(6)=Null
)
 AS 
	If  Exists(Select * From Localidade Where cd_Local = @Cd_Local) 
		Begin 
			Update  
				Localidade 
			Set 
				Nome_Local = @Nome_Local, 
				Cidade_Local = @Cidade_Local, 
				Pais_Local = @Pais_Local, 
				Cd_Regiao = @Cd_Regiao, 
				Aerop = @Aerop, 
				Porto = @Porto, 
				Gate = @Gate, 
				BITRI = @BITRI 
			Where
				Cd_local = @Cd_local 
		End 
	Else
		Return -1



GO
