SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_Tipo_Movimento_InsUpd]
(
    @Id                 INT,
    @Nome_Movimento     VARCHAR(300),
    @Cd_Usuario         VARCHAR(10),
    @Enable             BIT
)
AS
BEGIN

    BEGIN TRY
        
        BEGIN TRANSACTION;

        DECLARE @Id_New AS INT;

        -- Verifica se já existe
        IF EXISTS(SELECT 1 FROM Tipo_Movimento WHERE Id = @Id)
        BEGIN

            UPDATE Tipo_Movimento
            SET
                Nome_Movimento  = @Nome_Movimento,
                Cd_Usuario      = @Cd_Usuario,
                Enable          = @Enable,
                Dt_Updated      = GETDATE()
            WHERE
                Id = @Id;

            SET @Id_New = @Id;
        END
        ELSE
        BEGIN
            INSERT INTO Tipo_Movimento
            (
                Nome_Movimento,
                Cd_Usuario,
                Enable,
                Dt_Created
            )
            VALUES
            (
                @Nome_Movimento,
                @Cd_Usuario,
                @Enable,
                GETDATE()
            );

            SET @Id_New = SCOPE_IDENTITY();
        END

        SELECT @Id_New AS Retorno;

        COMMIT TRANSACTION;

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;

        SELECT ERROR_MESSAGE() AS Retorno;

    END CATCH

END

GO
