SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ATL_INT_FileUserDefinition_InsUpd]
(
    @ID           bigint,
    @CodUser      varchar(40),
    @FK_IdField   bigint
)
AS
BEGIN
	BEGIN TRY
 	   Declare @ID_New as bigint;
       BEGIN
  	      SET @ID_New =(SELECT ISNULL(MAX(ID),0) FROM ATL_INT.dbo.Layout_UserFieldDefinition 
		                WHERE  CodUser=@CodUser AND
				    	       FK_IdField=@FK_IdField)
 	      IF @ID_New = 0
			begin
				 Insert into ATL_INT.dbo.Layout_UserFieldDefinition(CodUser, FK_IdField) Values(@CodUser, @FK_IdField);
				 set @ID_New = @@IDENTITY
			end
	      ELSE
			begin
				 Update 
					ATL_INT.dbo.Layout_UserFieldDefinition 
				 set
						CodUser=@CodUser, FK_IdField=@FK_IdField 
				 WHERE ID = @ID_NEW;
			end
          END
          --SELECT MAX(ID) as Retorno FROM   ATL_INT.dbo.Layout_UserFieldDefinition;
		  Select @ID_New as Retorno;	
	   COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	
END

GO
