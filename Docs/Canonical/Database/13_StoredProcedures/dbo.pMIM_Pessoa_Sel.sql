SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMIM_Pessoa_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMIM_Pessoa_Sel
(
@Master		VarChar(25)='', 
@Processo		VarChar(16)=''
)
 AS
	If @Master <> ''
		Select 
			Num_Proc_MIM, Cd_Consig_MIM, Apelido 
		From 
			Master_Imp_Mar, Pessoa 
		Where 
			MAWB_MIM = @Master  AND 
			Cd_Consig_MIM = Cd_Pes
	Else
		Select 
			MAWB_MIM, Num_Proc_MIM, Cd_Consig_MIM, Apelido 
		From 
			Master_Imp_Mar, Pessoa 
		Where 
			Num_Proc_MIM = @Processo  AND 
			Cd_Consig_MIM  = Cd_Pes



GO
