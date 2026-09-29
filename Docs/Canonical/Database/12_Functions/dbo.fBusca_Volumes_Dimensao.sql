SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	FUNCTION [dbo].[fBusca_Volumes_Dimensao] 
(
	@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN
	Declare @N_GMID	VarChar(400)
	Declare @GMID	varchar(400)

	Declare Cur_GMID cursor for 
		Select	'DIMS' + convert(Varchar(10),convert(int,Compr_EA * 100)) + 'x' +
			convert(Varchar(10),convert(int,Largura_EA * 100)) + 'x' +
			convert(Varchar(10),convert(int,Altura_EA * 100)) +
			' cm (' + convert(Varchar(10),Qtd_Vol_EA) + ')' Result
		from 
			Volume_Exp_Aer HOU with(nolock)
		Where
			num_proc_hea =@Processo
		OPTION (HASH JOIN)
----------------------------------------------------------------------------
		open Cur_GMID
			Fetch Next From Cur_GMID Into @GMID
			While @@FETCH_STATUS = 0
			Begin
				if @N_GMID='' or @N_GMID is Null
					Begin
						Set @N_GMID=@GMID
					end
				else
					begin
						set @N_GMID=@N_GMID + '|'  + @GMID
					end
				
				Fetch Next From Cur_GMID Into @GMID
			end
		close Cur_GMID
		deallocate Cur_GMID 
		
	return @N_GMID 
	
END












GO
