SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE		FUNCTION [dbo].[fBusca_HAWB]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_CONT	VarChar(400)
	Declare @CONT	varchar(400) 

	Declare Cur_CONT cursor for
		select hou.hawb_him HAWB from master_imp_mar MAS
		Join House_Imp_mar HOU on hou.num_proc_mim=mas.num_proc_mim
		where mas.num_proc_mim = @Processo		
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
						set @N_CONT=@N_CONT + '/ '  + @CONT
					end
				
				Fetch Next From Cur_CONT Into @CONT
			end
		close Cur_CONT
		deallocate Cur_CONT 
		
	return @N_CONT
	
END










GO
