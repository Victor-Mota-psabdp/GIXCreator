SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--select dbo.fNCM('IMEXC20100801701')
--select (case when right(NCM,4) = '0000' then left(NCM,4) else NCM end) teste from NCM where ncm='01029019' 
--select * from ncm

CREATE		FUNCTION [dbo].[fNCM_DESCRICAO]
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
				DESCRICAO_NCM NCM
			from
				Proc_NCM PN
			Join
				NCM N on N.id_NCM = PN.id_NCM
			Where
								
				(
					(len(@processo)=16 and num_proc=@Processo)
				Or
					(len(@processo)=14
						and num_proc in (
									select num_proc_him from house_imp_mar where num_proc_mim=@processo 
									Union all
									select num_proc_hia from house_imp_aer where num_proc_mia=@processo 
	
						)
					)
				)

					

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
