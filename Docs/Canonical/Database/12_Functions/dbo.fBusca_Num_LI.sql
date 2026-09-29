SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[fBusca_Num_LI]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_CONT	VarChar(400)
	Declare @CONT	varchar(400) 

	Declare Cur_CONT cursor for 
     	select num_li from solicitacao_li     	
     		where Num_Proc = @Processo and id_status = 5   
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
