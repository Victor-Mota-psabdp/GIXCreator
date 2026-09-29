SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEM_Conteiner_Ins    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEM_Conteiner_Ins
(
@Num_Proc		VarChar(16),
@Item			VarChar(2)
)
 AS	
	Insert Into 
		Container_Hou_Exp_Mar
		(Num_Proc_MEM, Item_Cont_EM, Num_Proc_HEM)
	Values
		(Left(@Num_Proc, 14),  @Item, @Num_Proc)
	
	Return @@RowCount



GO
