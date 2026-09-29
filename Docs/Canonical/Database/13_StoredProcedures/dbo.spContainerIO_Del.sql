SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE	Procedure spContainerIO_Del 

@Processo	Varchar(16),
@ITEM_Cont_IO	INT

As

BEGIN TRANSACTION



	delete
		Container_HOU_Imp_OUT
	where
		Num_Proc_HIO = @Processo and Item_Cont_IO = @Item_Cont_IO



	

Commit Transaction	






GO
