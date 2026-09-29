SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP GTNEXUS_XML
CREATE procedure [dbo].[spGTNEXUS_XML_Upd]
(
	@num_proc VARCHAR(16),
	@Type VARCHAR(2),
	@ID_Smart bIGINT
)
AS

	update 
		GTNEXUS_XML 
	set 
		dt_envio =  GETDATE()
	where 
		num_proc =@num_proc 
		and [TYPE] = @Type
		AND ID_Smart = @ID_Smart
	

		
	

























GO
