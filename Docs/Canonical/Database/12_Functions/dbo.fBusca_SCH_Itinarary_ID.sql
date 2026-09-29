SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	FUNCTION [dbo].[fBusca_SCH_Itinarary_ID]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400) 
AS
BEGIN 
	Declare @nDOC	VarChar(400)
	Declare @DOC	varchar(400) 

	Declare @Tab table (campo varchar(100))

	insert into @Tab
	select ITINERARY_ID from tmp_Rel_SCHCASS_JOB_ITINERARY_ID 
	with(nolock) where num_proc=@processo 

	

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
