SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE		FUNCTION [dbo].[fNCM_HIM]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400) 
AS  
	BEGIN 
		Declare @nNCM	VarChar(400)
		Declare @NCM	varchar(400) 

if len(@Processo)=16 and left(@Processo,5) = 'IMCSR'

	Begin
		Declare Cur_NCM cursor for 
			select 
				left(ncm,4) NCM		
			from
				Proc_NCM PN with(Nolock)
			Join
				NCM N on N.id_NCM = PN.id_NCM
			Where
				num_proc=@Processo
		open Cur_NCM
			Fetch Next From Cur_NCM Into @NCM
			While @@FETCH_STATUS = 0
			Begin
				if @nNCM='' or @nNCM is Null
					Begin
						Set @nNCM=@NCM
					end
				else
					begin
						set @nNCM=@nNCM + ' - '  + @NCM
					end
				
				Fetch Next From Cur_NCM Into @NCM
			end
		close Cur_NCM
		deallocate Cur_NCM 

	END	
	return @nNCM
		
	END




GO
