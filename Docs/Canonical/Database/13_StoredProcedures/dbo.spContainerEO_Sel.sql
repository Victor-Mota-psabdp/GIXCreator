SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE	PROCEDURE spContainerEO_Sel

	@Processo	varchar(16)

As
	Select 
		Item_Cont_EO,
		Num_cont_EO,
		Nome_Tp_cont,
		Peso_Bruto_EO,
		Num_lacre_EO

	from 
		container_Hou_EXP_OUT HOU
			
	Left Outer Join Tipo_Container TC on TC.cd_tp_cont=HOU.cd_tp_cont
	where
		Hou.num_proc_HEO=@Processo





GO
