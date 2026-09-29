SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_Job_Justificativa_Status_InsUpd] 
--SELECT * FROM job_Justificativa_Status 
--sp_help job_Justificativa_Status
(
	@Num_Proc						varchar(16),
	@ID_Status						bigint,
	@Justificativa					nvarchar(max),
	@Destino						varchar(30),
	@Final_Destino					varchar(30),
	@Origem							varchar(30),
	@Final_Origem					varchar(30),
	@Cliente						varchar(100),
	@Notify							varchar(100),
	@Desbloqueado					bit,
	@Dt_Alter						datetime,
	@Cd_Usuario						varchar(10),
	@Dt_Ins							datetime

)
AS
BEGIN
    SET NOCOUNT ON;

--Cd_Pes Pessoa
Declare @Cd_Cliente varchar(10)
Declare @Cd_Notify varchar(10)
set @Cd_Cliente = (select Cd_Pes from Pessoa P with(nolock) where P.Apelido = @Cliente)  
set @Cd_Notify = (select Cd_Pes from Pessoa P with(nolock) where P.Apelido = @Notify)  

--Cd Localidade
Declare @Cd_Destino varchar(3)
Declare @Cd_Final_Destino varchar(3) 
Declare @Cd_Origem varchar(3) 
Declare @Cd_Final_Origem varchar(3) 
set @Cd_Destino = (select Cd_Local from Localidade L with(nolock) where L.Nome_Local = @Destino)  
set @Cd_Final_Destino = (select Cd_Local from Localidade L with(nolock) where L.Nome_Local = @Final_Destino)  
set @Cd_Origem = (select Cd_Local from Localidade L with(nolock) where L.Nome_Local = @Origem)  
set @Cd_Final_Origem = (select Cd_Local from Localidade L with(nolock) where L.Nome_Local = @Final_Origem)  

IF EXISTS (SELECT * FROM Job_Justificativa_Status WHERE Num_Proc = @Num_Proc)
    BEGIN
        UPDATE Job_Justificativa_Status
        SET ID_Status = @ID_Status,
            Justificativa = @Justificativa,
            Destino = @Cd_Destino,
            Final_Destino = @Cd_Final_Destino,
            Origem = @Cd_Origem,
            Final_Origem = @Cd_Final_Origem,
            Cliente = @Cd_Cliente,
            Notify = @Cd_Notify,
            Desbloqueado = @Desbloqueado,
            Dt_Alter = @Dt_Alter,
            Cd_Usuario = @Cd_Usuario,
            Dt_Ins = ISNULL(@Dt_Ins, Dt_Ins) -- Preserva o valor existente se @Dt_Ins for NULL
        WHERE Num_Proc = @Num_Proc;
    END
    ELSE
    BEGIN
        INSERT INTO Job_Justificativa_Status (
            Num_Proc, ID_Status, Justificativa, Destino, Final_Destino,
            Origem, Final_Origem, Cliente, Notify, Desbloqueado,
            Dt_Alter, Cd_Usuario, Dt_Ins
        )
        VALUES (
            @Num_Proc, @ID_Status, @Justificativa, @Cd_Destino, @Cd_Final_Destino,
            @Cd_Origem, @Cd_Final_Origem, @Cd_Cliente, @Cd_Notify, @Desbloqueado,
            @Dt_Alter, @Cd_Usuario, ISNULL(@Dt_Ins, GETDATE())
        );
    END
END

GO
