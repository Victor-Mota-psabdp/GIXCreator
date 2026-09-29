SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[spRateio_Mas]
			(@Num_Proc varchar(16)
			)

returns
	Float
as
	Begin
		Declare @Qtd FLOAT
		Declare @Num_Master varchar(14)
		
		Set @Num_master =(select [master] from vwcliente with (nolock) where num_proc=@Num_Proc)
		if @Num_Master is null
			Begin			
				return 1
			End
		set @qtd= (select count(*) from vwcliente with (nolock) where master=@num_Master)
		if @QTD is null
			begin
				REturn 1
			End
		Else
			begin			
				return((1.00/@qtd))			
			End
		return 1
		End
		
		
		
GO
