SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pComunicacao_Del    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pComunicacao_Del
(
@Cd_Pes		varchar(10), 
@Cd_Tp_Com		varchar(3)
)
AS
	If Exists(Select * From Comunicacao Where Cd_Pes = @Cd_Pes and Cd_Tp_Com=@Cd_Tp_Com)
		Delete 
			Comunicacao  
		Where
			Cd_Pes = @Cd_Pes and 
			Cd_Tp_Com=@Cd_Tp_Com
	Else 
		Return -1



GO
