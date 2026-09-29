SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--select * from container_mas_imp_mar where num_cont_em like 'medu9035%'

--select dbo.FHistoricoLinhas ('IALVS201411021BR')

CREATE	FUNCTION [dbo].FHistoricoLinhas
(
@num_Proc	Varchar(16)
)
RETURNS Varchar(4000)
AS  
BEGIN 
	Declare @N_Hist	VarChar(4000)
	Declare @Hist	varchar(4000) 
set @N_Hist = ''
	Declare Cur_Hist  cursor for 
	Select CONVERT(varchar(10),hsgdata,103) + ' - ' + HSDDescricao Item  from Hist_Geral with(nolock) where Disp_Cliente='S' and HSGProcesso=@Num_proc order by hsgdata desc




----------------------------------------------------------------------------
		open Cur_Hist
			Fetch Next From Cur_Hist Into @Hist
			While @@FETCH_STATUS = 0
			Begin
				if @N_Hist='' or @Hist is Null
					Begin
						Set @N_Hist=@Hist
					end
				else
					begin
						set @N_Hist=@N_Hist + '; '  + @Hist
					end
				
				Fetch Next From Cur_Hist Into @Hist
			end
		close Cur_Hist
		deallocate Cur_Hist 
		
	return @N_Hist
	
END










GO
