SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Qty_Container_Inspecao]
(
	@Num_Proc Varchar(16)
)returns integer
AS 

BEGIN
	Declare @Valor Int	
	
		BEGIN
			set @valor= (
				select count(ch.item_cont_im) from container_mas_imp_mar CM
				Join Container_hou_imp_mar CH on CH.num_proc_mim=CM.num_proc_mim and CH.item_cont_im=CM.Item_cont_im
				Where num_proc_him=@num_proc and cd_tp_cont not in ('LCL','LCW')
				and ISNULL(inspecao,'N')= 'S'
				)
		END
		
	return @Valor
END





GO
