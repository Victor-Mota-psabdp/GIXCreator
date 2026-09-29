SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE FUNCTION [dbo].[fGetDateUTC]()    
RETURNS DateTime AS      
    
BEGIN     
	declare @getdate as datetime    
    
	set @getdate = convert(datetime,switchoffset(GETUTCDATE(), '-03:00'))
    
	return @getdate    
    
END    

GO
