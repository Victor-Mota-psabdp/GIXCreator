SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spE_MIX_XML_Reprocessa_Upd]
	(		
		@retorno_erro		Varchar(400),	
		@ID					BigInt
		
	)
as
Begin	

	if exists(select dt_retorno from dbo.E_MIX_XML where id=@ID and Dt_Retorno is not null)
		BEGIN
			Update 
				dbo.E_MIX_XML 
			set 
				dt_retorno=null, 
				retorno_erro=null		
			where 
				id=@ID
		END
End


GO
