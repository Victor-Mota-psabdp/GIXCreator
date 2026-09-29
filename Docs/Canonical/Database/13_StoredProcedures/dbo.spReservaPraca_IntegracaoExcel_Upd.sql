SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReservaPraca_IntegracaoExcel_Upd] 
(
	@Processo			VarChar(16),
	@DL_Draft_Lem		Datetime,	
	@DL_Cargo_Lem		Datetime,
	@DL_VGM_Lem			Datetime,
	@cd_usuario			varchar(10)
)
AS
BEGIN TRANSACTION		

	
	if exists(select Num_Proc_LEM from LLP_Exp_Mar where Num_Proc_LEM = @Processo)
		BEGIN
			Update 
				LLP_Exp_Mar
			Set 
				DL_Draft_Lem = @DL_Draft_Lem,
				DL_Cargo_Lem = @DL_Cargo_Lem,
				DL_VGM_Lem = @DL_VGM_Lem		
			Where
				Num_Proc_LEM = @Processo

		--Gera a Linha para atualizar Report Manager e Smart: Não existe trigger para a tabela JOB e LLP.
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus) 
			values (@Processo, getdate(), 0) 

		--Gera o Log
			insert into [Log_ReservaPraca_IntegracaoExcel]
			([Num_Proc_Lem],[DL_Draft_Lem],[DL_Cargo_Lem],[DL_VGM_Lem],[Cd_Usuario],[Dt_Ins])
			values
			(@Processo,@DL_Draft_Lem,@DL_Cargo_Lem,@DL_VGM_Lem,@cd_usuario,GETDATE())
		END

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END


COMMIT TRANSACTION












GO
