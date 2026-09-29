SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from fatura_draft
CREATE Procedure [dbo].[spFaturaBDP_Draft_InsUpd]-- null,'IMVPF20100300101','01-20-2010','VILA PORTO'
		@FatCod 	VarChar(19),
		@JOB		Varchar(16),
		@FatDtVenc	Datetime,
		@Apelido	Varchar(50),
		@FatStatus	Char(1),
		@FatObs		Varchar(1000),
		@FatDtEmissao Datetime,
		@cd_usuario varchar(6),
		@Fatura_PCN varchar(19) Output

AS

	declare @Fatura varchar(19)
	declare @cd_Pes varchar(10)

	set @cd_PEs = (Select cd_pes from pessoa with(nolock) where apelido = @Apelido)
	
		If @FatDtEmissao is NULL
		Begin
			set	@FatDtEmissao = getDate()
		End		

BEGIN TRANSACTION
	if @FatCod is null
		BEGIN
			if len(@JOB) = 14
				begin
					set @Fatura = (select TOP 1 Char(Ascii(right(Fatcod,1))+1) Proxima from fatura_draft where left(fatcod,14)=@JOB order by fatcod desc)
				end
			else
				Begin			
					set @Fatura = (select TOP 1 Char(Ascii(right(Fatcod,1))+1) Proxima from fatura_draft where left(fatcod,16)=@JOB order by fatcod desc)
				end
				
			Print @Fatura
			if @Fatura is null or @Fatura=''

				Begin
					set @Fatura = @JOB + '_D' + 'A'

				End
			else
				set @Fatura = @JOB + '_D' + @Fatura
			

			INSERT INTO FATURA_DRAFT
				(
				FatCod, Cd_Pes, FatDtVenc, FatObs, FatStatus, FatDtEmissao,cd_usuario,dt_ins
				)
			VALUES
				(
				@Fatura, @Cd_Pes, @FatDtVenc, @FatObs, @FatStatus, @FatDtEmissao,@cd_usuario,getdate()
				)
			set @Fatura_PCN = @Fatura
		END
	else
		BEGIN
			UPDATE
				FATURA_DRAFT
			SET
				FatDtVenc=@FatDtVenc,
				FatStatus=@FatStatus,
				FatObs=@FatObs,
				FatDtEmissao=getdate()
			WHERE
				FatCod=@FatCod
		END

	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION 
			RETURN -2
		END

COMMIT TRANSACTION













GO
