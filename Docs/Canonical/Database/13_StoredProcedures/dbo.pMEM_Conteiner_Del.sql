SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMEM_Conteiner_Del    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMEM_Conteiner_Del 
(
@Num_Proc			varchar(14), 
@Item_Cont			varchar(2)
)
 AS
	Delete From  
		Container_Mas_Exp_Mar
	Where 
		Num_Proc_MEM = @Num_Proc and 
		Item_Cont_EM = @Item_Cont



GO
