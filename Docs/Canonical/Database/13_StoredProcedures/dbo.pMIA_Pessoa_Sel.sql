SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMIA_Pessoa_Sel
(
@Master		VarChar(25)='', 
@Processo		VarChar(16)=''
)
 AS
	If @Master <> ''
		Select 
			Num_Proc_MIA, Cd_Consig_MIA, Apelido 
		From 
			Master_Imp_Aer, Pessoa 
		Where 
			MAWB_MIA = @Master  AND 
			Cd_Consig_MIA = Cd_Pes
	Else
		Select 
			MAWB_MIA, Num_Proc_MIA, Cd_Consig_MIA, Apelido 
		From 
			Master_Imp_Aer, Pessoa 
		Where 
			Num_Proc_MIA = @Processo  AND 
			Cd_Consig_MIA  = Cd_Pes



GO
