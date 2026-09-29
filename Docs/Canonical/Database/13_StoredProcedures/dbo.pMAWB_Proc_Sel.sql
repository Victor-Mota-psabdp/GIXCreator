SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMAWB_Proc_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMAWB_Proc_Sel 
(
@Master		VarChar(25)='', 
@Processo		VarChar(14)=''
)
 AS
	If @Master <>  '' 
		Select 
			*
		From 
			Master_Exp_mar 
		Where
			MAWB_MEM = @Master
		
	Else
		Select 
			* 
		From 
			Master_Exp_mar 
		Where
			Num_Proc_MEM = @Processo 



GO
