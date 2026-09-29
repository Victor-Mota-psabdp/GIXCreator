SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spLog_Regiao_InsUpd]
(
	@ID_Log							bigint,
	@Dt_Alter						Datetime,
	@Cd_Regiao		     			varchar(3),
	@Nome_Regiao					varchar(50),
	@Cd_Usuario						varchar(10),
	@LocICS2						bit
)

AS

BEGIN
    BEGIN TRY
        -- Start a transaction
        BEGIN TRAN

        Declare @ID_New as bigint;
        BEGIN            
            IF NOT EXISTS (SELECT ID_Log FROM Log_Regiao WHERE ID_Log = @ID_Log)
            BEGIN
                INSERT INTO Log_Regiao 
                (                        
					Dt_Alter,
					Cd_Regiao,
					Nome_Regiao,
					Cd_Usuario,
					LocICS2
                )
                VALUES
                (            
                    Getdate(), 
					@Cd_Regiao,
					@Nome_Regiao,
					@Cd_Usuario,
					@LocICS2
				)
                SET @ID_New = @@IDENTITY
            END
         END    

        -- Commit transaction if everything goes well
        COMMIT TRAN
        SELECT @ID_New as Retorno;

    END TRY
    BEGIN CATCH
        -- Rollback transaction if there is an error
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRAN
        END
        SELECT ERROR_MESSAGE() as Retorno;
    END CATCH
END
GO
