SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEM_Pessoa_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEM_Pessoa_Sel
(
@House		VarChar(25)='', 
@Processo		VarChar(16)=''
)
 AS
	If @House <> ''
		SELECT 
			Num_Proc_HEM, Cd_Export_HEM, Apelido 
		FROM 
			House_Exp_Mar, Pessoa 
		WHERE 
			HAWB_HEM = @House  AND 
			Cd_Export_HEM = Cd_Pes
	Else
		SELECT 
			HAWB_HEM, Num_Proc_HEM, Cd_Export_HEM, Apelido 
		FROM 
			House_Exp_Mar, Pessoa 
		WHERE 
			Num_Proc_HEM = @Processo  AND 
			Cd_Export_HEM = Cd_Pes



GO
