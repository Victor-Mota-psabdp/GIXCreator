SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Log_Pessoa_New_InsUpd]
(
	@Id_Log			int,
	@Dt_Alter		Datetime,
	@Tp_Oper		char(1),
	@Cd_Pes			varchar(10),
	@Apelido		varchar(20),
	@Nome_Raz_Soc	varchar(60),
	@Num_CPF_CNPJ	varchar(16),
	@Cd_Tp_Ativ		char(3),
	@Cd_Tp_Grupo	char(3),
	@Cd_Usuario		VarChar(15),
	@Dt_Cad			char(10),
	@Desat_Pes		char(1),
	@Obs_Pes		varchar(2000),
	@Num_RG_IE		varchar(16),
	@Num_Insc_Munic		varchar(20)

)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Log_Pessoa_New
	BEGIN TRY
		Declare @ID_New as varchar(10);		
		
		BEGIN		  	
	   		Insert into Log_Pessoa_New
				(Cd_Usuario, Dt_Ins, Tp_Oper, Cd_Pes, Apelido, Nome_Raz_Soc, Num_CPF_CNPJ, Num_RG_IE, cd_Tp_Ativ,Cd_Tp_Grupo, Dt_Cad, Desat_Pes, Obs_Pes,PgtoRcto,Num_Insc_Munic)		
			Values 
				(@Cd_Usuario, GetDate(),@Tp_Oper ,@Cd_Pes, @Apelido, @Nome_Raz_Soc, @Num_CPF_CNPJ, @Num_RG_IE,@Cd_Tp_Ativ, @Cd_Tp_Grupo,@Dt_Cad, @Desat_Pes,@Obs_Pes,1,@Num_Insc_Munic)

			set @ID_New = @@IDENTITY;
		END	
		
		Select @Cd_Pes as Retorno;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
