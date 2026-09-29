SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHIM_Conteiner_Ins    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHIM_Conteiner_Ins
(
@Num_Proc		VarChar(16),
@Item			VarChar(2)
)
 AS	
	Insert Into 
		Container_Hou_Imp_Mar
		(Num_Proc_MIM, Item_Cont_IM, Num_Proc_HIM)
	Values
		(Left(@Num_Proc, 14),  @Item, @Num_Proc)
	
	Return @@RowCount



GO
