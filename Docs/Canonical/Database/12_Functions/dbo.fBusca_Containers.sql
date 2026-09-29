SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from
--update invoice_cliente
--set status='Created'
--where num_proc='EMCSR20080214101'
--select * from container_mas_exp_mar where num_cont_em like 'medu9035%'

--select dbo.fBusca_Containers ('EMCSR20080206001')

CREATE		FUNCTION [dbo].[fBusca_Containers]
(
@Processo	Varchar(16)
)
RETURNS Varchar(2000)
AS  
BEGIN 
	Declare @N_CONT	VarChar(2000)
	Declare @CONT	varchar(2000) 

	Declare Cur_CONT cursor for 
		select (MAS.num_cont_em +'  '+ cd_tp_cont)  Numero from container_mas_exp_mar MAS with(nolock)
		join container_hou_exp_mar HOU with(nolock) on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
             	where HOU.Num_Proc_HEM = @Processo and LEFT(NUM_CONT_EM,1)<>'_'
             	group by MAS.num_cont_em , cd_tp_cont
             	Union All
             	select (MAS.num_cont_im +'  '+ cd_tp_cont )  Numero from container_mas_imp_mar MAS with(nolock)
             	join container_hou_imp_mar HOU with(nolock) on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
             	where HOU.Num_Proc_HIM = @Processo  
             	group by MAS.num_cont_im, cd_tp_cont
----------------------------------------------------------------------------
		open Cur_CONT
			Fetch Next From Cur_CONT Into @CONT
			While @@FETCH_STATUS = 0
			Begin
				if @N_CONT='' or @N_CONT is Null
					Begin
						Set @N_CONT=@CONT
					end
				else
					begin
						set @N_CONT=@N_CONT + '; '  + @CONT
					end
				
				Fetch Next From Cur_CONT Into @CONT
			end
		close Cur_CONT
		deallocate Cur_CONT 
		
	return @N_CONT
	
END










GO
