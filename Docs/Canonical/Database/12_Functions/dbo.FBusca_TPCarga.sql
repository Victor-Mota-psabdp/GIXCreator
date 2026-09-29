SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create function FBusca_TPCarga(
			@Num_Proc Varchar(16)						
		)
RETURNS Varchar(3)
AS 
BEGIN
	Declare @Retorno Varchar (3)
	IF LEFT(@NUM_PROC,2)='IM'
			BEGIN
				SET @Retorno=(
					select max(cd_tp_cont) from 
							Container_mas_imp_mar CM
					Join Container_hou_imp_mar CH on
												CH.num_proc_mim=CM.num_proc_mim and ch.item_cont_im=cm.item_Cont_im
					Where 
							num_proc_him=@num_proc
						)
			END

	ELSE
			BEGIN
				SET @Retorno=(
					select max(cd_tp_cont) from 
							Container_mas_exp_mar CM
					Join Container_hou_exp_mar CH on
												CH.num_proc_mem=CM.num_proc_mem and ch.item_cont_em=cm.item_Cont_em
					Where 
							num_proc_hem=@num_proc
						)
			END

		if left(@Retorno,1)='L' 
				SEt @Retorno='LCL'
		else
			Set @Retorno='FCL'
	
	return @Retorno

END





GO
