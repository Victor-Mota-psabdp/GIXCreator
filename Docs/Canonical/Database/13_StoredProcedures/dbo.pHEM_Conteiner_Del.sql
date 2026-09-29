SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEM_Conteiner_Del    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEM_Conteiner_Del
(
@Num_Proc		VarChar(16),
@Item			VarChar(2)
)
 AS	
	Delete 
		Container_Hou_Exp_Mar
	Where	
		Num_Proc_MEM  =  @Num_Proc and 
		Item_Cont_EM = @Item
	
	Return @@RowCount



GO
