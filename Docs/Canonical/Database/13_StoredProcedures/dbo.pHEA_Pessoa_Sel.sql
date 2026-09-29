SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHEA_Pessoa_Sel
(
@House		VarChar(25)='', 
@Processo		VarChar(16)=''
)
 AS
	If @House <> ''
		Select 
			Num_Proc_HEA, Cd_Export_HEA, Apelido 
		From
			House_Exp_Aer, Pessoa 
		Where 
			HAWB_HEA = @House  AND 
			Cd_Export_HEA = Cd_Pes
	Else
		Select  
			HAWB_HEA, Num_Proc_HEA, Cd_Export_HEA, Apelido 
		From
			House_Exp_Aer, Pessoa 
		Where 
			Num_Proc_HEA = @Processo  AND 
			Cd_Export_HEA = Cd_Pes



GO
