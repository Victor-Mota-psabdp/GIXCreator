SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHIM_Pessoa_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHIM_Pessoa_Sel
(
@House		VarChar(25)='', 
@Processo		VarChar(16)=''
)
 AS
	If @House <> ''
		Select  
			Num_Proc_HIM, Cd_Import_HIM, Apelido 
		From  
			House_Imp_Mar, Pessoa 
		Where 
			HAWB_HIM = @House  AND 
			Cd_Import_HIM = Cd_Pes
	Else
		Select  
			HAWB_HIM, Num_Proc_HIM, Cd_Import_HIM, Apelido 
		From  
			House_Imp_Mar, Pessoa 
		Where 
			Num_Proc_HIM = @Processo  AND 
			Cd_Import_HIM = Cd_Pes



GO
