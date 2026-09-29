SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select dbo.fNCM('IMEXC20100801701')
--select (case when right(NCM,4) = '0000' then left(NCM,4) else NCM end) teste from NCM where ncm='01029019' 
--select * from ncm

CREATE		FUNCTION [dbo].[fNCM]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400) 
AS  
	BEGIN 
		Declare @nNCM	VarChar(400)
		Declare @NCM	varchar(400) 

		Declare Cur_NCM cursor for 
			select
				(case when right(NCM,4) = '0000' then left(NCM,4) else NCM end) NCM
			from
				Proc_NCM PN with(nolock)
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

	return @nNCM
		
	END




GO
