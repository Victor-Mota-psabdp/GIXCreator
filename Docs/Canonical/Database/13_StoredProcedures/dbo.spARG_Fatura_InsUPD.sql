SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 20/01/2021 - retirado, pois cabe 5000 caracteres
--alter table Fatura_ARG alter column Obs varchar(5000) null
CREATE	Procedure [dbo].[spARG_Fatura_InsUPD] 
	@Seq			int = Null,
	@Num_Fatura		varchar(30) = Null,
	@Dt_Fatura		datetime,
	@Codigo			char(1),
	@Cred_Dev		varchar(30),
	@Condicao_Venda varchar(30),
	@Total			float,
	@Total_IVA		float,
	@Moeda			varchar(30),
	@Status			char(1),
	@Obs			varchar(5000),
	@Paridade		float,
	@Aliq_ISS		float,
	
	@cd_servico int, 
	@descricao [varchar](500),	
	@Item_lei varchar(50),
	@CNAE	varchar(25),
	@IRRF_Tx char(1),
	
	@ID_Fat			int	OUTPUT,
	@Fatura			varchar(30) OUTPUT
AS

Declare @Cd_Cred_Dev	varchar(10)
Declare @Nome_Raz_Soc	varchar(35)
Declare @Endereco		varchar(50)
Declare @Cidade			varchar(30)
Declare @Pais			varchar(30)
Declare @Insc_IVA		varchar(25)
Declare @CUIT			varchar(30)
Declare @Cd_tp_Moeda	varchar(3)

BEGIN TRANSACTION

	set @Cd_Tp_Moeda = (select Cd_Tp_Moeda from Tipo_moeda with(nolock) where Nome_Tp_Moeda = @Moeda)
	set @Cd_Cred_Dev = (select cd_pes from pessoa with(nolock) where apelido = @Cred_Dev)
	set @Nome_Raz_Soc = (select Nome_Raz_Soc from pessoa with(nolock) where apelido = @Cred_Dev)
	set @Endereco = (select rua + ', ' + numero + ' ' + compl_end + ' ' + CEP from endereco with(nolock) where cd_pes = @Cd_Cred_Dev and Cd_Tp_End = 'COM')
	set @Cidade = (select Cidade from endereco with(nolock) where cd_pes = @Cd_Cred_Dev and Cd_Tp_End = 'COM')
	set @Pais = (select pais from endereco with(nolock) where cd_pes = @Cd_Cred_Dev and Cd_Tp_End = 'COM')
	set @Insc_IVA = (select Num_RG_IE from pessoa with(nolock) where apelido = @Cred_Dev)
	set @CUIT = (select Num_CPF_CNPJ from pessoa with(nolock) where apelido = @Cred_Dev)
	set @Seq = (select ID_Fat from Fatura_ARG where Numero=@Num_Fatura and cd_pes=@Cd_Cred_Dev and codigo=@Codigo)

-- Erbson - 02-04-2014 - Observação cortada por campo suportar apenas 200 caracteres
--cadu 20/01/2021 - retirado, pois cabe 5000 caracteres
	--set @Obs = (Select left(@Obs,200))

--Erbson - 29/11/2013 - Atribui a data do dia para novas Faturas com o Mês diferente do atual.
	If @SEQ IS NULL
		Begin
			If cast(year(getdate()) as varchar(4)) + cast(month(getdate())as varchar(2)) <> cast(year(@Dt_Fatura) as varchar(4)) + cast(month(@Dt_Fatura)as varchar(2))
			Begin
				Set @Dt_Fatura = getdate()
			End
		End	

	if @SEQ IS NULL
		BEGIN
			Set @SEQ =(select Isnull(max(ID_Fat),0) from Fatura_ARG)+1
			IF @Num_Fatura IS NULL
				Begin
					Set @Num_Fatura = (select Isnull(max(Numero),0) from fatura_arg where codigo = @Codigo)+1
					Set @Num_Fatura='0000000'+@Num_Fatura
					Set @Num_Fatura=right(@Num_Fatura,8)
				End
			INSERT INTO
				Fatura_ARG
				(
					ID_Fat,Numero,Dt_Fatura,Codigo,Cd_Pes,Razao_Social,Endereco,Cidade,Pais,
					Condicao_Venda,Insc_IVA,CUIT,Total,Total_Iva,Cd_Tp_Moeda,Status,Obs,Paridade,Aliq_ISS,
					cd_servico,descricao,item_lei,CNAE,IRRF_Tx
				)
				VALUES
				(
					@Seq,@Num_Fatura,@Dt_Fatura,@Codigo,@Cd_Cred_Dev,@Nome_Raz_Soc,@Endereco,@Cidade,@Pais,
					@Condicao_Venda,@Insc_IVA,@CUIT,@Total,@Total_Iva,@Cd_Tp_Moeda,@Status,@Obs,@Paridade,@Aliq_ISS,
					@cd_servico,@descricao,@Item_lei,@CNAE,@IRRF_Tx
				)
		END
	else
		BEGIN
			UPDATE
				Fatura_ARG
			SET
					Dt_Fatura=@Dt_Fatura,Condicao_Venda=@Condicao_Venda,Total=@Total,
					Total_Iva=@Total_Iva,Cd_Tp_Moeda=@Cd_Tp_Moeda,Status=@Status,
					Obs=@Obs,Paridade=@Paridade, Aliq_ISS=@Aliq_ISS,
					cd_servico = @cd_servico,descricao = @descricao,item_lei = @Item_lei,
					cnae = @CNAE,IRRF_Tx = @IRRF_Tx
			WHERE
				Numero=@Num_Fatura and cd_pes=@Cd_Cred_Dev and codigo=@Codigo
		END
				
	set @ID_Fat = @SEQ
	set @Fatura = @Num_Fatura
	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION

GO
