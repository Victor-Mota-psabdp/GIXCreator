SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE	Procedure spContainerEO_Del 

@Processo	Varchar(16),
@Item_Cont_EO	Varchar(12)

As

BEGIN TRANSACTION

	delete
		Container_HOU_EXP_OUT
	where
		Num_Proc_HEO = @Processo and Item_Cont_EO = @Item_Cont_EO



Commit Transaction	







GO
