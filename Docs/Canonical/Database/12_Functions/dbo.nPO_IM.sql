SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE       FUNCTION nPO_IM
(
@Processo	Varchar(16)
)
RETURNS Varchar(200) 
AS  
	BEGIN 
		Declare @nPO 		Varchar(200)
		Declare @PO		varchar(200) 
		IF LEFT(@PROCESSO,2)='IM'  
		BEGIN
		Declare Cur_nPO cursor for 
			select 
				Cast(Numero_po_him as varchar(20))		
			from
				PO_HiM
			Where
				Num_proc_him=@Processo
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
		return @nPO
		close Cur_nPO
		deallocate Cur_nPO 
		END		
		ELSE
		BEGIN
		Declare Cur_nPO cursor for 
			select 
				Cast(Numero_po_hia as varchar(20))		
			from
				PO_Hia
			Where
				Num_proc_hia=@Processo
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
		return @nPO
		close Cur_nPO
		deallocate Cur_nPO 
		END		
		return @nPO
	END








GO
