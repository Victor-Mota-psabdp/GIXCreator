SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMEM_Pessoa_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMEM_Pessoa_Sel
(
@Master		VarChar(25)='', 
@Processo		VarChar(16)=''
)
 AS
	If @Master <> ''
		Select 
			Num_Proc_MEM, Cd_Export_MEM, Apelido 
		From 
			Master_Exp_Mar, Pessoa 
		Where 
			MAWB_MEM = @Master  AND 
			Cd_Export_MEM = Cd_Pes
	Else
		Select 
			MAWB_MEM, Num_Proc_MEM, Cd_Export_MEM, Apelido 
		From 
			Master_Exp_Mar, Pessoa 
		Where 
			Num_Proc_MEM = @Processo  AND 
			Cd_Export_MEM = Cd_Pes



GO
