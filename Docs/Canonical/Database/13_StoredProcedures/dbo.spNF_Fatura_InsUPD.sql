SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from  
--sp_help NF_Fatura where Emissao > GETDATE() -1
--select * from NF_Fatura where Observ_NF is null
--alter table [dbo].NF_Fatura alter column [Observ_NF] varchar(5000) null

CREATE	Procedure [dbo].[spNF_Fatura_InsUPD] 
	@Seq			int = Null,
	@Numero_Fat		varchar(8) = Null,
	@Nota_Fiscal	varchar	(8),
	@Ref_Acesso		char(1),
	@Emissao		datetime,
	@Vencimento		datetime,
	@Nome_Pes		varchar	(50),
	@Cd_Status		int,
	@Total_NF		decimal	(9,2),
	@Total_FAT		decimal	(9,2),
	@Observ_NF		varchar	(5000),
	@Aliq_ISS		decimal	(9,2),
	@Valor_ISS		decimal	(9,2),
	@Habilita_Impostos bit,
	@cd_usuario		varchar(6),
	@Atencao		varchar(500),
	
	@cd_servico int, 
	@descricao [varchar](500),	
	@Item_lei varchar(50),
	@CNAE	varchar(25),
	@IRRF_Tx char(1),
	@FatVendorInvoiceNumber VarChar(17), --Alessandra 19/05/2021 - AX10
	
	@IDN			int	OUTPUT,
	@Numero_FatN	varchar(8) OUTPUT,
	@Nota_FiscalN	varchar	(8)	OUTPUT

AS

Declare @Cd_Cred_Dev	varchar(10)
Declare @Nome_Raz_Soc	varchar(35)
Declare @Endereco		varchar(50)
Declare @Numero			varchar(10)
Declare @CEP			varchar(8)
Declare @Cidade			varchar(30)
Declare @Bairro			varchar(100)
Declare @UF				varchar(2)
Declare @Pais			varchar(30)
Declare @IE				varchar(25)
Declare @CNPJ			varchar(30)

BEGIN TRANSACTION
	
	set @Cd_Cred_Dev = (select cd_pes from pessoa with(nolock) where apelido = @Nome_Pes)
	set @Nome_Raz_Soc = (select Nome_Raz_Soc from pessoa with(nolock) where apelido = @Nome_Pes)
	set @Endereco = (select rua from endereco with(nolock) where cd_pes = @Cd_Cred_Dev and Cd_Tp_End = 'COM')
	set @numero = (select numero from endereco with(nolock) where cd_pes = @Cd_Cred_Dev and Cd_Tp_End = 'COM')
	set @CEP = (select CEP from endereco with(nolock) where cd_pes = @Cd_Cred_Dev and Cd_Tp_End = 'COM')
	set @Cidade = (select Cidade from endereco with(nolock) where cd_pes = @Cd_Cred_Dev and Cd_Tp_End = 'COM')
	set @Bairro = (select Bairro from endereco with(nolock) where cd_pes = @Cd_Cred_Dev and Cd_Tp_End = 'COM')
	set @Pais = (select pais from endereco with(nolock) where cd_pes = @Cd_Cred_Dev and Cd_Tp_End = 'COM')
	set @UF = (select UF from endereco with(nolock) where cd_pes = @Cd_Cred_Dev and Cd_Tp_End = 'COM')
	set @IE = (select Num_RG_IE from pessoa with(nolock) where apelido = @Nome_Pes)
	set @CNPJ = (select Num_CPF_CNPJ from pessoa with(nolock) where apelido = @Nome_Pes)

	set @Seq = (select ID from NF_Fatura where Numero_Fat=@Numero_Fat)

--eu tinha criado isso pq pensei nesta stored primeiro
	--if @Total_NF <> 0 and @Nota_Fiscal is Null
	--	begin
	--		Set @Nota_Fiscal =(select Isnull(max(convert(int,Nota_Fiscal)),0)+1 from Base_nota_fiscal where Ref_Acesso = @Ref_Acesso) 
	--	end

	if @SEQ IS NULL
		BEGIN
			Set @SEQ =(select Isnull(max(ID),0) from NF_Fatura)+1
			IF @Numero_Fat IS NULL
				Begin					
					Set @Numero_Fat = (select Isnull(max(convert(int,Numero_Fat)),90000000) from NF_Fatura) + 1
				End
			INSERT INTO
				NF_Fatura
				(
					ID,Numero_Fat,Nota_Fiscal,Ref_Acesso,Emissao,Cd_Pes,Num_CPF_CNPJ,Num_RG_IE,Razao_Social,
					Endereco,Cidade,Pais,Prazo,cd_status,Total_NF,Total_FAT,Observ_NF,Aliq_ISS,Valor_ISS,
					RPS_Envio,Habilita_Impostos,cd_usuario,numero,cep,uf,bairro,Vencimento,Atencao,cd_servico,
					descricao,item_lei,CNAE,IRRF_Tx,FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				)
				VALUES
				(
					@Seq,@Numero_Fat,@Nota_Fiscal,@Ref_Acesso,@Emissao,@Cd_Cred_Dev,@CNPJ,@IE,@Nome_Raz_Soc,
					@Endereco,@Cidade,@Pais,@Emissao,0,@Total_NF,@Total_FAT,@Observ_NF,@Aliq_ISS,@Valor_ISS,
					0,@Habilita_Impostos,@cd_usuario,@numero,@cep,@uf,@bairro,@Vencimento,@Atencao,
					@cd_servico,@descricao,	@Item_lei,@CNAE,@IRRF_Tx,@FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				)
		END
	else
		BEGIN
			UPDATE
				NF_Fatura
			SET
				Total_NF	=	@Total_NF,
				Total_FAT	=	@Total_FAT,
				Observ_NF	=	@Observ_NF,
				Aliq_ISS	=	@Aliq_ISS,
				Valor_ISS	=	@Valor_ISS,
				Cd_Status	=	@Cd_Status,	
				Atencao		=	@Atencao,		
				Habilita_Impostos	=	@Habilita_Impostos,
				cd_servico = @cd_servico,
				descricao = @descricao ,				
				item_lei = @Item_lei,
				cnae = @CNAE,
				FatVendorInvoiceNumber =  @FatVendorInvoiceNumber, --Alessandra 19/05/2021 - AX10
				IRRF_Tx = @IRRF_Tx
			WHERE
				ID = @SEQ
		END
				
	set @IDN = @SEQ
	set @Numero_FatN = @Numero_Fat
	set @Nota_FiscalN = @Nota_Fiscal
	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION

GO
