SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--select dbo.fbusca_docs_po_modal('EAIFI20090100101','10')

CREATE	FUNCTION [dbo].[fBusca_Docs_PO_Master]
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
			select Numero_PO from PO_Master where num_proc_Master=@processo and ID_DC=@ID_DC
			union
			select numero_po_hia from PO_HIA where id_Dc=@id_Dc and num_proc_hia in(select num_proc_hia from house_imp_Aer where num_proc_mia=@processo)
			union
			select numero_po_him from PO_HIm where id_Dc=@id_Dc and num_proc_him in(select num_proc_him from house_imp_mar where num_proc_mim=@processo)
			
		End
	else IF left(@Processo,2) = 'EA'
		Begin
			insert into @Tab
			select Numero_PO_HEA from PO_HEA where num_proc_hea=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'EM'
		Begin
			insert into @Tab
			select Numero_PO_HEM from PO_HEM where num_proc_hem=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'EO'
		Begin
			insert into @Tab
			select Numero_PO_HEO from PO_HEO where num_proc_heo=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'IA'
		Begin
			insert into @Tab
			select Numero_PO_HIA from PO_HIA where num_proc_hia=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'IM'
		Begin
			insert into @Tab
			select Numero_PO_HIM from PO_HIM where num_proc_him=@processo and ID_DC=@ID_DC
		End
	else IF left(@Processo,2) = 'IO'
		Begin
			insert into @Tab
			select Numero_PO_HIO from PO_HIO where num_proc_hio=@processo and ID_DC=@ID_DC
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
