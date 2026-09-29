SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  function valor(
			@VLR FLOAT, 
			@DC varchAR(1)
		)returns Decimal(15,2)
AS 

BEGIN
	
	if @DC='D'
		begin
			return @VLR*-1
		end
			return @VLR
	
END




GO
