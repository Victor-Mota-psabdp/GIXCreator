SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoMoeda_Upd
(
@Cd_Tp_Moeda		varchar(3),
@Nome_Tp_Moeda		varchar(30),
@Cod_Nac_Moeda		varchar(3),
@Cod_Int_Moeda		varchar(2),
@Cd_Moeda_Ofc		char(5)=Null,
@Cd_Loc_Ofc			varchar(5)=Null
)
 AS
	Update 
		Tipo_moeda
	Set 
		Nome_Tp_Moeda = @Nome_Tp_Moeda, 
		Cod_Nac_Moeda = @Cod_Nac_Moeda, 
		Cod_Int_Moeda = @Cod_Int_Moeda, 
		Cd_Moeda_Ofc = @Cd_Moeda_Ofc, 
		Cd_Loc_Ofc = @Cd_Loc_Ofc
	Where
		Cd_Tp_Moeda = @Cd_Tp_Moeda



GO
