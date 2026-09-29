SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- select dbo.fBusca_TipoContainers ('IMAKZ20090800401')

CREATE	FUNCTION [dbo].[fBusca_TipoContainers]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_CONT	VarChar(400)
	Declare @CONT	varchar(400) 

	Declare Cur_CONT cursor for 
		select Nome_tp_cont from container_mas_exp_mar MAS
		join container_hou_exp_mar HOU on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
		join tipo_container TC on MAS.cd_tp_cont=TC.cd_tp_cont
		where HOU.Num_Proc_HEM = @Processo
		group by Nome_tp_cont
		Union All
		select Nome_tp_cont from container_mas_imp_mar MAS
		join container_hou_imp_mar HOU on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
		join tipo_container TC on MAS.cd_tp_cont=TC.cd_tp_cont
		where HOU.Num_Proc_HIM = @Processo
		group by Nome_tp_cont
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
