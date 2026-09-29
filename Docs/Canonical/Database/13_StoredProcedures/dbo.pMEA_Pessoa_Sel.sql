SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMEA_Pessoa_Sel
(
@Master		VarChar(25)='', 
@Processo		VarChar(16)=''
)
 AS
	If @Master <> ''
		Select 
			Num_Proc_MEA, Cd_Export_MEA, Apelido 
		From 
			Master_Exp_Aer, Pessoa 
		Where 
			MAWB_MEA = @Master  AND 
			Cd_Export_MEA = Cd_Pes
	Else
		Select 
			MAWB_MEA, Num_Proc_MEA, Cd_Export_MEA, Apelido 
		From 
			Master_Exp_Aer, Pessoa 
		Where 
			Num_Proc_MEA = @Processo  AND 
			Cd_Export_MEA = Cd_Pes



GO
