SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pComunicacao_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pComunicacao_Sel 
(
@Cd_Pes		VarChar(10),
@Cd_Tp_Com		VarChar(3)='' 
)
 AS
	If @Cd_Tp_Com = '' 
		Select 
			C.*, T.Nome_Tp_Com
		From 
			Comunicacao as C Left Outer Join Tipo_Comunicacao as T on C.Cd_Tp_Com = T.Cd_Tp_Com 
		Where 
			C.Cd_Pes = @Cd_Pes
	Else
		Select 
			C.*, T.Nome_Tp_Com
		From 
			Comunicacao as C Left Outer Join Tipo_Comunicacao as T on C.Cd_Tp_Com = T.Cd_Tp_Com 
		Where
			Cd_Pes = @Cd_Pes and 
			C.Cd_Tp_Com = @Cd_Tp_Com



GO
