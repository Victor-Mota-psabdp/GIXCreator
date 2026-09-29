SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHIM_Conteiner_Del    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHIM_Conteiner_Del
(
@Num_Proc		VarChar(16),
@Item			VarChar(2)
)
 AS	
	Delete 
		Container_Hou_Imp_Mar
	Where	
		Num_Proc_MIM  =  @Num_Proc and 
		Item_Cont_IM = @Item
	
	Return @@RowCount



GO
