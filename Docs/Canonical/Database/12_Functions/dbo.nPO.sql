SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE  FUNCTION nPO
(
@Processo	Varchar(14)
)
RETURNS Varchar(200) 
AS  
	BEGIN 
		Declare @nPO 		Varchar(200)
		Declare @PO		varchar(200) 
		Declare Cur_nPO cursor for 
			select 
				Cast(Numero_po_hem as varchar(20))		
			from
				PO_HEM
			Where
				Num_proc_hem=@Processo
		open Cur_nPO
			Fetch Next From Cur_nPO Into @PO
			While @@FETCH_STATUS = 0
			Begin
				if @nPO='' or @nPO=Null
					Begin
						Set @nPO=@PO
					end
				else
					begin
						set @nPO=@nPO + ' - ' + @PO
					end
				Fetch Next From Cur_nPO Into @PO
			end
		close Cur_nPO
		deallocate Cur_nPO 
		return @nPO
		

	END



GO
