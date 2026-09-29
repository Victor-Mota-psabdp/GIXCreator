SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE FUNCTION fPO_Imp
(
@Processo	Varchar(16),
@Tipo		varchar(2)
)
RETURNS Varchar(400) 
AS  
BEGIN 
		Declare @NPO	VarChar(400)
		Declare @PO	varchar(400) 

if len(@Processo)=16 and left(@Processo,5) = 'IMCSR'

	Begin
		Declare Cur_PO cursor for 
			select 
				Numero_PO_HIM		
			from
				PO_HIM
			Where
				Num_Proc_HIM=@Processo and ID_DC = @Tipo
	End
Else
	BEGIN
		if len(@Processo)=16 and left(@Processo,5) = 'IACSR'
			Begin
				Declare Cur_PO cursor for 
				select 
					Numero_PO_HIA		
				from
					PO_HIA
				Where
					Num_Proc_HIA=@Processo and ID_DC = @Tipo
			END
	END
----------------------------------------------------------------------------
		open Cur_PO
			Fetch Next From Cur_PO Into @PO
			While @@FETCH_STATUS = 0
			Begin
				if @nPO='' or @nPO is Null
					Begin
						Set @nPO=@PO
					end
				else
					begin
						set @nPO=@nPO + ' - '  + @PO	
					end
				
				Fetch Next From Cur_PO Into @PO
			end
		close Cur_PO
		deallocate Cur_PO 
		
	return @nPO
	
END






GO
