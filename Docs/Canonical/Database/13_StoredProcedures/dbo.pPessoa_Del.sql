SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pPessoa_Del    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPessoa_Del 
(
@Cd_Pes			varchar(10)
)
 AS
	If Exists(Select Apelido From Pessoa Where Cd_pes = @Cd_Pes)
		Delete 
			Pessoa 
		Where
			Cd_Pes = @Cd_Pes
	
	Else
		Return -1



GO
