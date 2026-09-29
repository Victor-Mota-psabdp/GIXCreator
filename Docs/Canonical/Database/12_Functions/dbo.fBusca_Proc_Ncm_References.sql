SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fBusca_Proc_Ncm_References]
(
@Processo	Varchar(16)
)
RETURNS Varchar(3000) 
AS
BEGIN 
	Declare @nDOC	VarChar(3000)
	Declare @DOC	varchar(3000) 

	Declare @Tab table (campo varchar(3000))

	IF len(@Processo) = 16
		Begin
			Insert into @Tab
				--select 'Ncm:' + [NCM Code] +
				--    ' ' + [NCM Description] +
				-- '   HS:' + left([NCM Code],6)  [NatureGoods]
				select 'HS:' + left([NCM Code],6)  [NatureGoods]
			from vwProc_NCM_Sel p
			where p.JOB =@Processo
	    End
    else
		begin 
			Insert into @Tab
			select 'HS:' + left(NCM.[NCM Code],6)  [NatureGoods]
			from
				vwHouse_Exp HE with(nolock)
				left JOIN  vwProc_NCM_Sel  NCM with(nolock)	ON NCM.JOB = HE.Num_Proc
			where
				HE.num_proc in(select Num_Proc from vwHouse_Exp HE with(nolock) where HE.Master =@Processo)
		end 

	Declare Cur_DOC cursor for 
		select campo from @Tab
	open Cur_DOC
		Fetch Next From Cur_DOC Into @DOC
		While @@FETCH_STATUS = 0
		Begin
			if @nDOC='|' or @nDOC is Null
				Begin
					Set @nDOC=@DOC
				end
			else
				begin
					set @nDOC=@nDOC + '  '  + @DOC
				end
			
			Fetch Next From Cur_DOC Into @DOC
		end
	close Cur_DOC
	deallocate Cur_DOC 

	DELETE from @Tab

return @nDOC
	
END








GO
