SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from report_email

CREATE procedure [dbo].[spATL_ReportEmail_InsUpd]
	@ID_Alerta		int,
	@ID_Report		int,
	@Tipo			char(1),		-- 'D' = Diario, 'M' = Mensal, 'W' = Semanal
	@Mes_Semana		varchar(12),	-- Guardar o dia da semana formato Bit(0001000 =  quarta-feira) ou o mes(000010000000=Maio) ou (0) quando for Tipo = 'D'
	@Dias			varchar(31),	-- Guardar o dia formato Bit(0001000 = 04)
	@hr_Envio		int,
	@Email			varchar(max),
	@Cd_Usuario		varchar(50),
	@Parametros		varchar(max),
	@Disable		bit
AS

BEGIN TRANSACTION

	Set @Email = replace(@Email,'''','')
	Set @Email = replace(@Email,char(10),'')
	Set @Email = replace(@Email,char(13),'')
	Set @Email = replace(@Email,' ','')

	if @Email = '' or @Email is NULL
		begin
			set @Email = (select email from usuario where cd_usuario = @cd_usuario)
		end

	IF not exists (select * from Report_Email where Id_Alerta=@Id_Alerta)
		BEGIN
			INSERT INTO
				Report_Email
				(
					Id_Report,
					Tipo,
					Mes_Semana,
					Dia,
					hr_Envio,
					Email,
					Cd_Usuario,
					Parametros,
					[Disable]
				)
			VALUES
				(
					@Id_Report,
					@Tipo,
					@Mes_Semana,
					@Dias,
					@hr_Envio,
					@Email,
					@Cd_Usuario,
					@Parametros,
					@Disable
				)
		END
	ELSE
		Begin
			Update
				Report_Email
			Set
				Tipo = @Tipo, Mes_Semana=@Mes_Semana, Dia=@Dias, hr_Envio = @hr_Envio, Email = @Email, Parametros = @Parametros, [Disable] = @Disable
			Where
				Id_Alerta = @Id_Alerta
		End

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	


GO
