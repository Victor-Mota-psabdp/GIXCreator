SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[spContainerIO_Sel]

	@Processo	varchar(16)

As
	Select 
		item_cont_io,
		Num_cont_IO,
		Nome_Tp_cont,
		Peso_Bruto_IO,
		Num_lacre_IO,
		Dt_Vcto_Devol_IO,
		Dt_Devol_IO,
		isnull(inspecao,'N') inspecao
	from 
		container_Hou_IMP_OUT HOU with (nolock)
			
	Left Outer Join Tipo_Container TC with (nolock) on TC.cd_tp_cont=HOU.cd_tp_cont
	where
		Hou.num_proc_HIO=@Processo






GO
