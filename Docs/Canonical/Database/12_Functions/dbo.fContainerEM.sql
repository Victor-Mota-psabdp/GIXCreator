SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select dbo.fContainerEM ('EMCSR20080100201')

CREATE		FUNCTION [dbo].[fContainerEM] 
(
@Processo	Varchar(16)
)
RETURNS Varchar(400) 
AS  
BEGIN 
		Declare @NCONT	VarChar(400)
		Declare @CONTAINER	varchar(400) 


		Declare Cur_CONT cursor for 
			select
				count(HOU.item_cont_em) qtd, + ' ' +  MAS.cd_tp_cont
			from
				container_hou_exp_mar  HOU
				Join container_mas_exp_mar MAS on 
				MAS.item_cont_em = HOU.item_cont_em and 
				MAS.num_proc_MEM = HOU.num_proc_MEM
			Where
				HOU.num_proc_hem=@Processo
			group by
				MAS.cd_tp_cont
----------------------------------------------------------------------------
		open Cur_CONT
			Fetch Next From Cur_CONT Into @CONTAINER
			While @@FETCH_STATUS = 0
			Begin
				if @NCONT='' or @NCONT is Null
					Begin
						Set @NCONT=@CONTAINER
					end
				else
					begin
						set @NCONT=@NCONT + ' - '  + @CONTAINER
					end
				
				Fetch Next From Cur_CONT Into @CONTAINER
			end
		close Cur_CONT
		deallocate Cur_CONT 
		
	return @NCONT
	
END







GO
