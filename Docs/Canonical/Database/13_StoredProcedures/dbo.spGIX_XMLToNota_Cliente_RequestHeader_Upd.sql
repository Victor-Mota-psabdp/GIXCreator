SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGIX_XMLToNota_Cliente_RequestHeader_Upd] 

		@ID_Req							Bigint,
		@Num_Proc						Varchar(16),
		@Utilizado						bit
		
AS
Begin Transaction

	update ATL_INT.dbo.GIX_Request_Header 
		set 
			[DT_INS_Nota_Cliente] = getdate(),
			[Num_Proc] = @Num_Proc,
			[Utilizado] = @Utilizado		 
	where 
		[ID_Req] = @ID_Req
	
	--IF @@Error <> 0
	--	BEGIN
	--		ROLLBACK TRANSACTION
	--		RETURN -1
	--	END

Commit Transaction


GO
