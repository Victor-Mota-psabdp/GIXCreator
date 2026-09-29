SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTipoOcorrencia_Ins 
(
@Nome_Tp_Ocor	VarChar(30),
@Customer		Int,
@Max			Int=Null OUTPUT
)
AS
	If @Customer = 1 
		Set @Max = IsNull((Select Max(Cd_Tp_Ocor) From Tipo_Ocorrencia Where Cd_Tp_Ocor>1000),1000) + 1
	Else
		Set @Max = IsNull((Select Max(Cd_Tp_Ocor) From Tipo_Ocorrencia Where Cd_Tp_Ocor<1000),0) +1 

	Insert Into Tipo_Ocorrencia Values (@Max, @Nome_Tp_Ocor)
GO
