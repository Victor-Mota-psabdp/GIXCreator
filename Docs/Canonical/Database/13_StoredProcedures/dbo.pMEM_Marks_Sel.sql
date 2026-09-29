SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMEM_Marks_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMEM_Marks_Sel 
(
@Processo	VarChar(16)
)
 AS
	Select 
		* 
	From 
		Mrk_Mas_Exp_Mar
	Where
		Num_Proc_MEM = @Processo 



GO
