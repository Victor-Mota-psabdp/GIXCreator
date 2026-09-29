SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select dbo.fBusca_Containers_Type ('EMCSR20080206001')
-- antonio 19/04/2023 mostrar o tipo de containes + numero do container 
--
CREATE   FUNCTION [dbo].[fBusca_Containers_Type]
(
@Processo	Varchar(16)
)
RETURNS Varchar(2000)
AS  
BEGIN 
	Declare @N_CONT	VarChar(2000)
	Declare @CONT	varchar(2000) 

	Declare Cur_CONT cursor for 
--			select (Mas.num_cont_em + '   ' + tc.Nome_Tp_Cont )  Numero from container_mas_exp_mar MAS with(nolock)
			select (Mas.num_cont_em)  Numero from container_mas_exp_mar MAS with(nolock)
				join container_hou_exp_mar HOU with(nolock) on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
				Join Tipo_Container TC on tC.cd_tp_cont=MAS.cd_tp_cont
			where HOU.Num_Proc_HEM = @Processo and LEFT(NUM_CONT_EM,1)<>'_'
           	group by MAS.num_cont_em , tc.Nome_Tp_Cont
       Union All
--           	select (MAS.num_cont_im + '   '+  tc.Nome_Tp_Cont)  Numero from container_mas_imp_mar MAS with(nolock)
           	select (MAS.num_cont_im)  Numero from container_mas_imp_mar MAS with(nolock)
           	join container_hou_imp_mar HOU with(nolock) on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
			Join Tipo_Container TC on tC.cd_tp_cont=MAS.cd_tp_cont
			where HOU.Num_Proc_HIM = @Processo  
            group by MAS.num_cont_im, tc.Nome_Tp_Cont
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
