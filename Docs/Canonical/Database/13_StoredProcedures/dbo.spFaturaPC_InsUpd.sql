SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table [dbo].[Fatura_CHB] alter column [Obs_PC] varchar(1000) null

CREATE Procedure [dbo].[spFaturaPC_InsUpd]
		@Fatura_PC 	VarChar(17),
		@Processo_PC	Varchar(16),
		@DI_RE_PC	VarChar(20),
		@Data_PC	Datetime,
		@cd_pes_PC	Varchar(10),
		@Status_PC	Char(1),
		@Obs_PC		Varchar(1000),
		@Cd_Tipo	Char(1),
		@BDP_Invoice 	VarChar(17)

AS

BEGIN TRANSACTION
	if not exists(select Fatura_PC from Fatura_CHB where fatura_PC=@fatura_PC)
		BEGIN
			INSERT INTO FATURA_CHB
				(
				Fatura_PC,Processo_PC,DI_RE_PC,Data_PC,cd_pes_PC,Status_PC,Obs_PC,cd_tipo,BDP_Invoice
				)
			VALUES
				(
				ltrim(rtrim(@Fatura_PC)),@Processo_PC,@DI_RE_PC,@Data_PC,@cd_pes_PC,@Status_PC,@Obs_PC,@cd_tipo,@BDP_Invoice
				)
		END
	else
		BEGIN
			UPDATE
				FATURA_CHB
			SET
				Processo_PC=@Processo_PC,
				DI_RE_PC=@DI_RE_PC,
				Data_PC=@Data_PC,
				cd_pes_PC=@cd_pes_PC,
				Status_PC=@Status_PC,
				Obs_PC=@Obs_PC,
				Cd_Tipo=@cd_Tipo
			WHERE
				FATURA_PC=@FATURA_PC
		END
	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION 
			RETURN -2
		END
COMMIT TRANSACTION





GO
