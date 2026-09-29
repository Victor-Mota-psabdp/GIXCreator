SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fDW_CNTNR_EQUIP_CT]
(
	@Num_Proc Varchar(16) 
)

returns integer

AS 

BEGIN
	Declare @Valor Int	
	SET @Valor = 0
	if LEFT(@NUM_PROC,2)='EM'
		BEGIN
			set @valor=(
				select count(ch.item_cont_em) from container_mas_exp_mar CM
				Join Container_hou_exp_mar CH on CH.num_proc_mem=CM.num_proc_mem and CH.item_cont_em=CM.Item_cont_em
				Where num_proc_hem=@num_proc and cd_tp_cont not in ('LCL','LCW')
				)
		END
	ELSE
		BEGIN
			set @valor= (
				select count(ch.item_cont_im) from container_mas_imp_mar CM
				Join Container_hou_imp_mar CH on CH.num_proc_mim=CM.num_proc_mim and CH.item_cont_im=CM.Item_cont_im
				Where num_proc_him=@num_proc and cd_tp_cont not in ('LCL','LCW')
				)
		END
		
	return @Valor
END





GO
