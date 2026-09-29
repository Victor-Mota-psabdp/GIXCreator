SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu - incluido pra tratar casos master - len=14

CREATE Procedure [dbo].[spFaturaBDP_InsUpd]-- null,'IMVPF20100300101','01-20-2010','VILA PORTO'
		@FatCod 	VarChar(17),
		@JOB		Varchar(16),
		@FatDtVenc	Datetime,
		@Apelido	Varchar(50),
		@FatStatus	Char(1),
		@FatObs		Varchar(5000),
		@FatDtEmissao Datetime,
		@Fatura_PCN varchar(17) Output

AS

	declare @Fatura varchar(17)
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
					set @Fatura = (select TOP 1 Char(Ascii(right(Fatcod,1))+1) Proxima from fatura where left(fatcod,14)=@JOB order by fatcod desc)
				end
			else
				Begin			
					set @Fatura = (select TOP 1 Char(Ascii(right(Fatcod,1))+1) Proxima from fatura where left(fatcod,16)=@JOB order by fatcod desc)
				end
				
			--Erbson 01/11/2016: Não permite criar faturas após a letra Z
			Declare @UltFatura varchar(1)
			set @UltFatura = (select TOP 1 right(Fatcod,1) Proxima from fatura where left(fatcod,16)=@JOB order by fatcod desc)
			if @UltFatura = 'Z'
				BEGIN
					RETURN -2
				END
				
			Print @Fatura
			if @Fatura is null or @Fatura=''

				Begin
					set @Fatura = @JOB + 'A'

				End
			else
				set @Fatura = @JOB + @Fatura
			

			INSERT INTO FATURA
				(
				FatCod, Cd_Pes, FatDtVenc, FatObs, FatStatus, FatDtEmissao
				)
			VALUES
				(
				@Fatura, @Cd_Pes, @FatDtVenc, @FatObs, @FatStatus, @FatDtEmissao
				)
			set @Fatura_PCN = @Fatura
		END
	else
		BEGIN
			UPDATE
				FATURA
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
