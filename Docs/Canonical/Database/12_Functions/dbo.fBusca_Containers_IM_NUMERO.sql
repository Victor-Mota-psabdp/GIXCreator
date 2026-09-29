SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--select * from container_mas_imp_mar where num_cont_em like 'medu9035%'

--select dbo.fBusca_Containers_IM ('IMCSR20080206001')

CREATE		FUNCTION [dbo].[fBusca_Containers_IM_NUMERO]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_CONT	VarChar(400)
	Declare @CONT	varchar(400) 

	Declare Cur_CONT cursor for 
     	select (MAS.num_cont_im)  Numero from container_mas_imp_mar MAS
     	join container_hou_imp_mar HOU on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
     	where HOU.Num_Proc_HIM = @Processo
     	group by MAS.num_cont_im, cd_tp_cont,Dt_Devol_IM
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
						set @N_CONT=@N_CONT + ','  + @CONT
					end
				
				Fetch Next From Cur_CONT Into @CONT
			end
		close Cur_CONT
		deallocate Cur_CONT 
		
	return @N_CONT
	
END









GO
