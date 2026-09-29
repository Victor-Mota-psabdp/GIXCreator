SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pOracle_Receivables_Del]
(
    @ID BIGINT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN           
            IF EXISTS(SELECT ID FROM Oracle_Receivables WHERE ID = @ID)
            BEGIN
                UPDATE 
                    Oracle_Receivables
                SET
                    IsActive=0
                WHERE
                    ID = @ID 
            END           
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        SELECT ERROR_MESSAGE() AS ReturnValue;
    END CATCH
END
GO
