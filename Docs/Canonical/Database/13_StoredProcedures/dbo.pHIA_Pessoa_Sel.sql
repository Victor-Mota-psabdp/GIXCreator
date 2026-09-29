SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pHIA_Pessoa_Sel
(
@House		VarChar(25)='', 
@Processo		VarChar(16)=''
)
 AS
	If @House <> ''
		Select  
			Num_Proc_HIA, Cd_Import_HIA, Apelido 
		From  
			House_Imp_Aer, Pessoa 
		Where 
			HAWB_HIA = @House  AND 
			Cd_Import_HIA = Cd_Pes
	Else
		Select  
			HAWB_HIA, Num_Proc_HIA, Cd_Import_HIA, Apelido 
		From  
			House_Imp_Aer, Pessoa 
		Where 
			Num_Proc_HIA = @Processo  AND 
			Cd_Import_HIA = Cd_Pes



GO
