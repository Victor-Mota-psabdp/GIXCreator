SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  Procedure spContainerEM_Del 


	(
		@Processo	Varchar(16),
		@Item_Cont_EM 	Int

	)
As

BEGIN TRANSACTION

	Declare @Proc_MAS Varchar (14)


	Set @Proc_Mas = (
			select HOU.Num_Proc_MEM from Container_hou_exp_mar HOU
			Left Outer Join Container_Mas_Exp_Mar Mas on HOU.Num_Proc_MEM = MAS.Num_Proc_MEM and HOU.Item_Cont_Em =MAS.Item_Cont_Em
			Where HOU.Num_Proc_Hem = @Processo and MAS.Item_Cont_EM = @Item_Cont_EM
			)

	delete 
		Container_HOU_Exp_Mar
	where
		Num_Proc_Hem = @Processo and Item_Cont_EM = @Item_Cont_EM and Num_Proc_MEM = @Proc_MAS	


	delete 
		container_Mas_exp_mar
	Where 
		Num_Proc_MEM = @Proc_MAS and Item_Cont_EM = @Item_Cont_EM


Commit Transaction	





GO
