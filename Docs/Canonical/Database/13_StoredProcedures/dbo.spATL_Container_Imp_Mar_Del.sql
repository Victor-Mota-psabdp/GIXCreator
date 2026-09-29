SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[spATL_Container_Imp_Mar_Del] 
(
	@Num_Proc		varchar(16),
	@Item_Cont_IM	varchar(10)
)

As

BEGIN TRANSACTION

	Declare @Proc_MAS	Varchar (14)

	Set @Proc_Mas = (
			select HOU.Num_Proc_MIM from Container_hou_imp_mar HOU
			Left Outer Join Container_Mas_Imp_Mar Mas on HOU.Num_Proc_MIM = MAS.Num_Proc_MIM and HOU.Item_Cont_IM =MAS.Item_Cont_IM
			Where HOU.Num_Proc_HIM = @Num_Proc  and MAS.Item_Cont_IM = @Item_Cont_IM
			)
	delete
		Container_HOU_Imp_Mar
	where
		Num_Proc_HIM = @Num_Proc and Item_Cont_IM = @Item_Cont_IM and Num_Proc_MIM = @Proc_MAS


	delete 
		container_Mas_imp_mar
	Where 
		Num_Proc_MIM = @Proc_MAS AND Item_Cont_IM = @Item_Cont_IM

	

Commit Transaction	





GO
