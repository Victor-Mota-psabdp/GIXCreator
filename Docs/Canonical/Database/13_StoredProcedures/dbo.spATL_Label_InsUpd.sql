SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spATL_Label_InsUpd
	
	 @ID	int,
	 @Descr_ING	varchar(50),
	 @Descr_PTG	 varchar(50),
	 @Descr_ESP	varchar	(50)

AS

Begin Transaction

		if exists(select * from ATL_Labels where ID = @ID)
			Begin
				Update
					ATL_Labels
				set
					Descr_ING = @Descr_ING,
					Descr_PTG = @Descr_PTG,
					Descr_ESP = @Descr_ESP
				where
					ID = @ID
			end
		else
			begin
				SET @ID =(SELECT ISNULL(MAX(ID),1) FROM ATL_Labels)+1
				insert into
						ATL_Labels
							(
							 ID,
							 Descr_ING,
							 Descr_PTG,
							 Descr_ESP
							)
				values
							(
							 @ID,
							 @Descr_ING,
							 @Descr_PTG,
							 @Descr_ESP
							 )
				end

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction
GO
