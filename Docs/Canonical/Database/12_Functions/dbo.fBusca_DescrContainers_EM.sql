SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE		FUNCTION [dbo].[fBusca_DescrContainers_EM]
(
	@Processo	Varchar(16),
	@Tipo		Varchar(50)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_CONT	VarChar(400)
	Declare @CONT	varchar(400) 

--	Declare Cur_CONT cursor for
if @Tipo = 'Container'
	if Len(@Processo) = 16
		Begin
			Declare Cur_CONT cursor for

     		select MAS.Num_Cont_EM Descr from container_mas_exp_mar MAS
     		join container_hou_exp_mar HOU on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
     		where HOU.Num_Proc_HEM = @Processo
     		group by MAS.Num_Cont_EM, cd_tp_cont
		End
	Else
		Begin
			Declare Cur_CONT cursor for

     		select MAS.Num_Cont_EM Descr from container_mas_exp_mar MAS
     		join container_hou_exp_mar HOU on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
     		where MAS.Num_Proc_MEM = @Processo
     		group by MAS.Num_Cont_EM, cd_tp_cont
		End
if @Tipo = 'Lacre'
	if Len(@Processo) = 16
		Begin
			Declare Cur_CONT cursor for

     		select MAS.Num_Lacre_EM  Lacre from container_mas_exp_mar MAS
     		join container_hou_exp_mar HOU on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
     		where HOU.Num_Proc_HEM =@Processo
     		group by MAS.Num_Lacre_EM
		End
	Else
		Begin
			Declare Cur_CONT cursor for

     		select MAS.Num_Lacre_EM  Lacre from container_mas_exp_mar MAS
     		join container_hou_exp_mar HOU on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
     		where MAS.Num_Proc_MEM = @Processo
     		group by MAS.Num_Lacre_EM
		End
if @Tipo = 'Peso'
	if Len(@Processo) = 16
		Begin
			Declare Cur_CONT cursor for

     		select MAS.Peso_Bruto_EM Peso from container_mas_exp_mar MAS
     		join container_hou_exp_mar HOU on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
     		where HOU.Num_Proc_HEM =@Processo
     		group by MAS.Peso_Bruto_EM
		End
	Else
		Begin
			Declare Cur_CONT cursor for

     		select MAS.Peso_Bruto_EM  Peso from container_mas_exp_mar MAS
     		join container_hou_exp_mar HOU on HOU.Item_Cont_EM = MAS.Item_Cont_EM and MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
     		where MAS.Num_Proc_MEM = @Processo
     		group by MAS.Peso_Bruto_EM
		End
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
