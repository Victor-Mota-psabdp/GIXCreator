SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table Base_Nota_Fiscal alter column Observ_NF varchar(5000) null
CREATE	Procedure [dbo].[spNotaFiscalBR_InsUpd] 

	@Nota_Fiscal	varchar	(8),
	@Ref_Acesso		char	(1),
	@Emissao		datetime,
	@Nome_Pes		varchar	(50),
	@Cd_Status		int,
	@Valor_Total	decimal	(9,2),
	@Observ_NF		varchar	(5000),
	@Aliq_ISS		decimal	(9,2),
	@Valor_ISS		decimal	(9,2),
	@Habilita_Impostos bit,
	@cd_usuario		Varchar(10),
	
	@cd_servico int, 
	@descricao [varchar](500),	
	@Item_lei varchar(50),
	@CNAE	varchar(25),
	@IRRF_Tx char(1),
	
	@Num_NF			varchar(8) OUTPUT
AS

Declare @Cd_Pes	varchar(10)

BEGIN TRANSACTION

	set @Cd_Pes = (select cd_pes from pessoa where apelido = @Nome_Pes)
--	set @Nome_Raz_Soc = (select Nome_Raz_Soc from pessoa where apelido = @Nome_Pes)
--	set @Endereco = (select rua + ', ' + numero + ' ' + compl_end + ' ' + CEP from endereco where cd_pes = @Cd_Pes)
--	set @Cidade = (select Cidade from endereco where cd_pes = @Cd_Pes)
--	set @Pais = (select pais from endereco where cd_pes = @Cd_Pes)
--	set @CUIT = (select Num_CPF_CNPJ from pessoa where apelido = @Nome_Pes)

--Erbson - 29/11/2013 - Atribui a data do dia para novas NF com o Mês diferente do atual.
	If @Nota_Fiscal IS NULL
		Begin
			If cast(year(getdate()) as varchar(4)) + cast(month(getdate())as varchar(2)) <> cast(year(@Emissao) as varchar(4)) + cast(month(@Emissao)as varchar(2))
			Begin
				Set @Emissao = getdate()
			End
		End	
	
	if @Nota_Fiscal IS NULL
		BEGIN
			Set @Nota_Fiscal =(select Isnull(max(convert(int,Nota_Fiscal)),0)+1 from Base_nota_fiscal where Ref_Acesso = @Ref_Acesso)
--			Set @Nota_Fiscal ='00000000'+@Nota_fiscal
--			Set @Nota_Fiscal =right(@Nota_Fiscal,8)
			INSERT INTO
				Base_Nota_Fiscal
				(
					Nota_Fiscal,
					Ref_Acesso,
					Emissao,
					Cd_Pes,
					Tipo_Serv,
					Condicoes,
					Prazo,
					Cd_Status,
					Valor_Total,
					Observ_NF,
					Aliq_ISS,
					Valor_ISS,
					ISS_Retido,
					RPS_Data,
					RPS_NFE,
					RPS_NFE_Verif,
					CdsId,
					SitId,
					Aliq_ISS_Rps,
					RPS_Envio,
					Habilita_Impostos,
					cd_usuario,
					
					cd_servico,
					descricao,					
					item_lei,
					CNAE,
					IRRF_Tx
					)
				VALUES
				(
					@Nota_Fiscal,
					@Ref_Acesso,
					@Emissao,
					@Cd_Pes,
					'',
					'',
					@Emissao,
					0,
					@Valor_Total,
					@Observ_NF,
					@Aliq_ISS,
					@Valor_ISS,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					0,
					@Habilita_Impostos,
					@cd_usuario,
					@cd_servico,
					@descricao,					
					@Item_lei,
					@CNAE,
					@IRRF_Tx
				)
			set @Num_NF = @Nota_Fiscal				
			
		END
	else
		BEGIN
			UPDATE
				Base_Nota_Fiscal
			SET
				Cd_Status = @Cd_Status,
				Valor_Total=@Valor_Total,
				Observ_NF = @Observ_NF,
				Aliq_ISS = @Aliq_ISS,
				Valor_ISS = @Valor_ISS,
				Habilita_Impostos = @Habilita_Impostos,
				cd_usuario=@cd_usuario,
				
				cd_servico = @cd_servico,
				descricao = @descricao ,				
				item_lei = @Item_lei,
				cnae = @CNAE,
				IRRF_Tx = @IRRF_Tx
			WHERE
				Nota_Fiscal = @Nota_Fiscal and Ref_Acesso = @Ref_Acesso
		END
				
	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION











GO
