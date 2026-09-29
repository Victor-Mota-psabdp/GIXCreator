SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_Containers_Lacre_Tara]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_CONT	VarChar(400)
	Declare @CONT	varchar(400) 

	Declare Cur_CONT cursor for 

     	select 'Containers: ' + MAS.num_cont_em + ' Lacre: ' + isnull(num_lacre_em,'') + ' Tara: ' + isnull(convert(varchar,Tara_em),'')Numero from container_mas_exp_mar MAS with(nolock)
		join container_hou_exp_mar HOU with(nolock) on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
        where HOU.Num_Proc_HEM = @Processo and LEFT(NUM_CONT_EM,1)<>'_'
         group by MAS.num_cont_em ,num_lacre_em,Tara_em
			Union All
		select 'Container(s): ' + MAS.num_cont_im + ' [' + nome_tp_cont + '] - ' + 'Seal: ' + isnull(num_lacre_im,'') Numero 
		from container_mas_imp_mar MAS with(nolock)
		join container_hou_imp_mar HOU with(nolock) on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
		join tipo_container TP on TP.cd_tp_cont = MAS.cd_tp_cont
        where HOU.Num_Proc_HIM = @Processo and LEFT(NUM_CONT_IM,1)<>'_'
         group by MAS.num_cont_im ,num_lacre_im,Tara_im,nome_tp_cont
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
