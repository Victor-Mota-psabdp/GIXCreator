SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spLog_Pais_InsUpd]
(
	@ID_Log							bigint,
	@Dt_Alter						Datetime,
	@Tp_Oper						char(1),

	@Cd_Pais						varchar(2),
	@Nome_Pais						varchar(50),
	@FORM_A							char(1),
	@Nome_Pais_PT					varchar(200), 
	@Paraiso_Fiscal					bit,
	@HTS							bit,
	@Proibido						bit,
	@Cd_Usuario						varchar(10),
	@Bloqueado						bit,
	@Cd_Pais_IBGE					varchar(5),
	@Cd_M49							varchar(5),
	@Ativo							bit
)

AS

BEGIN
    BEGIN TRY
        -- Start a transaction
        BEGIN TRAN

        Declare @ID_New as bigint;
        BEGIN            
            IF NOT EXISTS (SELECT ID_Log FROM Log_Pais WHERE ID_Log = @ID_Log)
            BEGIN
                INSERT INTO Log_Pais
                (                        
                    [Dt_Alter],[Tp_Oper],
                    Cd_Pais, Nome_Pais, FORM_A, Nome_Pais_PT, Paraiso_Fiscal, HTS, Proibido, Cd_Usuario, Bloqueado, Cd_Pais_IBGE, Cd_M49, Ativo
                )
                VALUES
                (            
                    Getdate(), @Tp_Oper,
                    @Cd_Pais, @Nome_Pais, @FORM_A, @Nome_Pais_PT, @Paraiso_Fiscal, @HTS, @Proibido, @Cd_Usuario, @Bloqueado, @Cd_Pais_IBGE, @Cd_M49, @Ativo
                )
                SET @ID_New = @@IDENTITY
            END
            ELSE
            BEGIN
                UPDATE Log_Pais
                SET
                    Cd_Pais = @Cd_Pais,
                    Nome_Pais = @Nome_Pais, 
                    FORM_A = @FORM_A,
                    Nome_Pais_PT = @Nome_Pais_PT,
                    Paraiso_Fiscal = @Paraiso_Fiscal,
                    HTS = @HTS,
                    Proibido = @Proibido,
                    Cd_Usuario = @Cd_Usuario,
                    Bloqueado = @Bloqueado,
					Cd_Pais_IBGE = @Cd_Pais_IBGE,
					Cd_M49 = @Cd_M49,
                    Ativo = @Ativo
                WHERE
                    ID_Log = @ID_Log
                SET @ID_New = @ID_Log
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
