SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoMoeda_Del 
(
@Cd_Tp_Moeda		varchar(3),
@Nome_Tp_Moeda		varchar(30),
@Cod_Nac_Moeda		varchar(3),
@Cod_Int_Moeda		varchar(2),
@Cd_Moeda_Ofc		char(5)=Null,
@Cd_Loc_Ofc			varchar(5)=Null
)
 AS
	Delete
		Tipo_moeda
	Where
		Cd_Tp_Moeda = @Cd_Tp_Moeda



GO
