SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[fGetDateBR]()  
RETURNS DateTime AS    
  
BEGIN   
declare @getdate as datetime  
  
 if right(SYSDATETIMEOFFSET(),6) = '-04:00'  
  SELECT @getdate = dateadd(hh,1,getdate()) 
 else if right(SYSDATETIMEOFFSET(),6) = '-05:00'  
  SELECT @getdate = dateadd(hh,2,getdate())  
 else  
  SELECT @getdate = getdate()  
  
 return @getdate  
  
END  
  
GO
