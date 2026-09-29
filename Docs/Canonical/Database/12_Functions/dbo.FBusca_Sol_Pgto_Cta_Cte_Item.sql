SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--FBusca_Sol_Pgto_Cta_Cte_Item'8262036','Currency'
CREATE   function [dbo].[FBusca_Sol_Pgto_Cta_Cte_Item]
(
	@ID	bigint,
	@Tipo varchar(25)
)
RETURNS Varchar(1000) 

BEGIN
	Declare @nDOC	VarChar(1000)
	Declare @DOC	varchar(1000) 

	Declare @Tab table (campo varchar(100))

	if @Tipo = 'Currency'
		Begin			
			insert into @Tab
			select distinct SPI.Cd_Tp_Moeda campo from Sol_Pgto_Cta_Cte_Item SPI with(nolock) where SPI.ID = @ID
		End
	else
		Begin
			insert into @Tab
			select distinct cast(SPI.Par_Moeda as varchar(10)) campo from Sol_Pgto_Cta_Cte_Item SPI with(nolock) where SPI.ID = @ID			
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
					set @nDOC=@nDOC + '/'  + @DOC
				end
			
			Fetch Next From Cur_DOC Into @DOC
		end
	close Cur_DOC
	deallocate Cur_DOC 

	DELETE from @Tab

return @nDOC

END




GO
