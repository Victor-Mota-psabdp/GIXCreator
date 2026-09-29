SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE         procedure [dbo].[spPgtoRctoDiv_InsUpd]

	@NumLanc	varchar(12),
	@CdBanco	varchar(3),
	@CdAgencia	varchar(5),
	@NumConta	varchar(20),
	@DC		char(1),
	@Data		varchar(10),
	@Forma		varchar(10),
	@NumDoc		varchar(12),
	@Valor		decimal(10,2),
	@Pessoa		varchar(10),
	@DataVenc	varchar(10),
	@Conciliado	char(1),
	@Docs		char(1),
	@Processo	VarChar(12) OUTPUT

AS

Begin Transaction
--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
	if @Numlanc is null
		return 0
		
	Declare @Int as int

	if @Numlanc is null

	BEGIN
		Set @Processo='DA'+CAST(year(getdate()) AS Varchar(4))+right('0'+cast(month(getdate()) as VarChar),2)
		sET @INT=(Select isnull(max(right(Num_Lcto_Div,4)),0) from PGTO_RCTO_DIV where left(Num_Lcto_Div,8)=@processo)			
		SET @int=@int+1
		Set @processo=@processo+right('000'+Cast(@int as VarChar),4)
	
		Insert
		PGTO_RCTO_DIV(
			Num_Lcto_Div,
			Cd_Banco,
			Cd_Agencia,
			Num_Cta_Cte,
			DC_Div,
			Dt_Pgto_Rcto_Div,
			Forma_Pgto_Rcto_Div,
			Num_Doc_Div,
			Vlr_Doc_Div,
			Cd_Pes,
			Dt_Vcto_Div,
			Concil_Div,
			Ck_Doctos
			)
		Values
			(
			@Processo,
			@CdBanco,
			@CdAgencia,
			@NumConta,
			@DC,
			@Data,
			@Forma,
			@NumDoc,
			@Valor,
			@Pessoa,
			@DataVenc,
			@Conciliado,
			@Docs
			)
		
		Select @processo=@processo
	END
	ELSE
		BEGIN
			UPDATE
				PGTO_RCTO_DIV
			Set
				Cd_Banco = @CdBanco,
				Cd_Agencia = @CdAgencia,
				Num_Cta_Cte = @NumConta,
				DC_Div = @DC,
				Dt_Pgto_Rcto_Div = @Data,
				Forma_Pgto_Rcto_Div = @Forma,
				Num_Doc_Div = @NumDoc,
				Vlr_Doc_Div = @Valor,
				Cd_Pes = @Pessoa,
				Dt_Vcto_Div = @DataVenc,
				Concil_Div = @Conciliado,
				Ck_Doctos = @Docs

			Where
				Num_Lcto_Div = @NumLanc
				Set @Processo = @NumLanc
		END
		
Select @Processo 'Processo'
Commit Transaction











GO
