SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	FUNCTION [dbo].[fBusca_Docs_PO_Modal]
(
@Processo	Varchar(16),
@ID_DC		int
)
RETURNS Varchar(400) 
AS
BEGIN 
	Declare @nDOC	VarChar(400)
	Declare @DOC	varchar(400) 

	Declare @Tab table (campo varchar(100))

	IF len(@Processo) = 14
		Begin
			insert into @Tab
			select Numero_PO from PO_Master with(nolock) where num_proc_Master=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'EA'
		Begin
			insert into @Tab
			select distinct Numero_PO_HEA from PO_HEA  with(nolock)  where num_proc_hea=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'EM'
		Begin
			insert into @Tab
			select distinct Numero_PO_HEM from PO_HEM with(nolock)  where num_proc_hem=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'EO'
		Begin
			insert into @Tab
			select distinct Numero_PO_HEO from PO_HEO with(nolock)  where num_proc_heo=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'IA'
		Begin
			insert into @Tab
			select distinct  Numero_PO_HIA from PO_HIA with(nolock)  where num_proc_hia=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'IM'
		Begin
			insert into @Tab
			select distinct  Numero_PO_HIM from PO_HIM with(nolock)  where num_proc_him=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'IO'
		Begin
			insert into @Tab
			select distinct Numero_PO_HIO from PO_HIO with(nolock)  where num_proc_hio=@processo and ID_DC=@ID_DC
		End
		
	else IF left(@Processo,2) = 'BO'
		Begin
			insert into @Tab
			select distinct Numero_PO_HBO from PO_HBO with(nolock)  where Num_Proc_HBO=@processo and ID_DC=@ID_DC
		End

	Declare Cur_DOC cursor for 
		select campo from @Tab
	open Cur_DOC
		Fetch Next From Cur_DOC Into @DOC
		While @@FETCH_STATUS = 0
		Begin
			if @nDOC='' or @nDOC is Null
				Begin
					Set @nDOC=@DOC
				end
			else
				begin
					set @nDOC=@nDOC + ' - '  + @DOC
				end
			
			Fetch Next From Cur_DOC Into @DOC
		end
	close Cur_DOC
	deallocate Cur_DOC 

	DELETE from @Tab

return @nDOC
	
END








GO
