SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--19/09 - incluido pra tirar o tab do produto description - cadu
--21-02-13 - incluido pra salvar o Business Description = @BusinessName
--19-04-17 - incluido pra salvar o Business Group = @@BusinessGroup
--incluido pra usar o mesmo InsUpd da tela de Produto Cliente - 24-09-2015

CREATE procedure [dbo].[spProdutoCHB_InsUpd]

	@Cd_Prod		int,
	@cd_Proc_Cliente varchar(30),
	@Etiqueta		varchar(50),
	@DataPesq		datetime,
	@Aprovado		char(1),
	@Trade			varchar(30),
	@Value			varchar(30),
	@LI				varchar(3),
	@Descrprod		varchar(100),
	@DescrprodL		varchar(max),
	@NCM			varchar(8),
	@Grupo			varchar(30),
	@DescrP			varchar(1000),
	@DescrS			varchar(1000),
	@Import			Varchar(3),
	@Orgao			varchar(50),
	@Pais			varchar(50),
	@BusinessName	varchar(40),
	@BusinessGroup	varchar(40),
	@Concentracao	float
AS

Begin Transaction
		
		Declare @CODPais varchar(50)
		set @CODPais=(select cd_pais from pais where nome_pais=@Pais)
		
		Declare @CODCLI varchar(10)
		set @CODCLI=(select cd_pes from pessoa where apelido=@Grupo)
		
		Declare @cd_prod_MAX int
		Set @cd_prod_MAX=(select max(cd_prod)+1 from produto_cliente)

		set @Descrprod = replace(@Descrprod,char(9),'')

--Incluido o mesmo insUpd da tela de Produto Cliente
		--If exists (select cd_prod from produto_cliente where cd_prod=@cd_prod)
		--	Begin
		--		Update 
		--			Produto_Cliente
		--		Set
		--			cd_proc_cliente=@cd_proc_cliente,
		--			cd_cliente=@CODCLI,
		--			produto_descr=@Descrprod,
		--			ncm_cliente=@NCM					
		--		where
		--			cd_prod=@cd_prod
		--	End
		--else
		--	Begin
		--		Insert Produto_Cliente(
		--					cd_prod,
		--					cd_proc_cliente,
		--					cd_cliente,
		--					produto_descr,
		--					ncm_cliente)
				
		--		Values(
		--				@cd_prod_MAX,
		--				@cd_Proc_Cliente,
		--				@CODCLI,
		--				@Descrprod,
		--				@NCM)

		--		set @cd_prod=@cd_prod_MAX

		--	End	
		
		if not exists (select cd_Proc_Cliente from produto_cliente where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@CODCLI)
		BEGIN
			if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Descrprod and cd_cliente=@CODCLI)
				begin
					set @Descrprod = @Descrprod + ' (' + @cd_Proc_Cliente + ')'
				end
			if NOT exists (select Produto_Descr from produto_cliente where Produto_Descr=@Descrprod and cd_cliente=@CODCLI)
				BEGIN
					Insert into
						Produto_cliente
							(
								cd_prod,
								cd_Proc_Cliente,
								cd_Cliente,
								Produto_Descr,
								NCM_Cliente
							)
						values
							(
								@cd_prod_MAX,
								@cd_Proc_Cliente,
								@CODCLI,
								@Descrprod,
								@NCM
							)
						set @cd_prod=@cd_prod_MAX
				END
		END
	Else
		BEGIN
			if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Descrprod and cd_cliente=@CODCLI)
					begin
						set @Descrprod = @Descrprod + ' (' + @cd_Proc_Cliente + ')'
					end
			BEGIN
				Update
					Produto_cliente
				Set
					Produto_Descr=@Descrprod,
					NCM_Cliente=@NCM
				Where
					cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@CODCLI
			END
		END
		
		
			

	If exists (select cd_prod from produto_chb where cd_prod=@cd_prod)
		Begin
			Update
				Produto_chb
			Set
				Etiqueta_Produto=@Etiqueta,
				Aprovado=@Aprovado,
				Descricao_longa=@Descrprodl,
				Dt_Pesquisa=@DataPesq,
				Tipo_LI=@LI,
				Import_license=@Import,
				Orgao_Anuente=@Orgao,
				Pais_Origem=@CODPais,
				Concentracao=@Concentracao
			where
				cd_prod=@cd_prod
		End
	else
		Begin
			Insert Produto_chb(
					cd_prod,
					Etiqueta_Produto,
					Aprovado,
					Descricao_longa,
					Dt_Pesquisa,
					tipo_li,
					import_license,
					orgao_anuente,
					Pais_origem,
					Concentracao)
			Values(
					@cd_prod,
					@Etiqueta,
					@Aprovado,
					@DescrprodL,
					@DataPesq,
					@LI,
					@Import,
					@Orgao,
					@CODPais,
					@Concentracao)
			End
	
	If exists (select GMID from de_para_produto where GMID=@cd_Proc_Cliente)
		Begin
			Update
				de_para_produto
			Set
				cd_cliente=@CODCLI,
				GMID_Descr_Curta=@Descrprod,
				Trade_Product_Code=@Trade,
				Value_center_code=@Value,
				P_Descricao=@DescrP,
				S_Descricao=@DescrS,
				business_descr = @BusinessName,
				Business_Group_Descr = @BusinessGroup
			where
				GMID=@cd_Proc_Cliente
			end
	
	else
		Begin
			Insert de_para_produto(
					cd_cliente,
					GMID,
					GMID_Descr_Curta,
					Trade_Product_Code,
					Value_Center_Code,
					P_Descricao,
					S_Descricao,
					business_descr,
					Business_Group_Descr)
			Values(
					@CODCLI,
					@cd_Proc_Cliente,
					@Descrprod,
					@Trade,
					@Value,
					@DescrP,
					@DescrS,
					@BusinessName,
					@BusinessGroup)
		End

				
				
Commit Transaction

--ALTER procedure [dbo].[spProdutoCHB_InsUpd]

--	@Cd_Prod		int,
--	@cd_Proc_Cliente varchar(30),
--	@Etiqueta		varchar(50),
--	@DataPesq		datetime,
--	@Aprovado		char(1),
--	@Trade			varchar(30),
--	@Value			varchar(30),
--	@LI				varchar(3),
--	@Descrprod		varchar(100),
--	@DescrprodL		varchar(max),
--	@NCM			varchar(8),
--	@Grupo			varchar(30),
--	@DescrP			varchar(1000),
--	@DescrS			varchar(1000),
--	@Import			Varchar(3),
--	@Orgao			varchar(50),
--	@Pais			varchar(50),
--	@BusinessName	varchar(40),
--	@Concentracao	float
--AS

--Begin Transaction
		
--		Declare @CODPais varchar(50)
--		set @CODPais=(select cd_pais from pais where nome_pais=@Pais)
		
--		Declare @CODCLI varchar(10)
--		set @CODCLI=(select cd_pes from pessoa where apelido=@Grupo)
		
--		Declare @cd_prod_MAX int
--		Set @cd_prod_MAX=(select max(cd_prod)+1 from produto_cliente)

--		set @Descrprod = replace(@Descrprod,char(9),'')

----Incluido o mesmo insUpd da tela de Produto Cliente
--		--If exists (select cd_prod from produto_cliente where cd_prod=@cd_prod)
--		--	Begin
--		--		Update 
--		--			Produto_Cliente
--		--		Set
--		--			cd_proc_cliente=@cd_proc_cliente,
--		--			cd_cliente=@CODCLI,
--		--			produto_descr=@Descrprod,
--		--			ncm_cliente=@NCM					
--		--		where
--		--			cd_prod=@cd_prod
--		--	End
--		--else
--		--	Begin
--		--		Insert Produto_Cliente(
--		--					cd_prod,
--		--					cd_proc_cliente,
--		--					cd_cliente,
--		--					produto_descr,
--		--					ncm_cliente)
				
--		--		Values(
--		--				@cd_prod_MAX,
--		--				@cd_Proc_Cliente,
--		--				@CODCLI,
--		--				@Descrprod,
--		--				@NCM)

--		--		set @cd_prod=@cd_prod_MAX

--		--	End	
		
--		if not exists (select cd_Proc_Cliente from produto_cliente where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@CODCLI)
--		BEGIN
--			if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Descrprod and cd_cliente=@CODCLI)
--				begin
--					set @Descrprod = @Descrprod + ' (' + @cd_Proc_Cliente + ')'
--				end
--			if NOT exists (select Produto_Descr from produto_cliente where Produto_Descr=@Descrprod and cd_cliente=@CODCLI)
--				BEGIN
--					Insert into
--						Produto_cliente
--							(
--								cd_prod,
--								cd_Proc_Cliente,
--								cd_Cliente,
--								Produto_Descr,
--								NCM_Cliente
--							)
--						values
--							(
--								@cd_prod_MAX,
--								@cd_Proc_Cliente,
--								@CODCLI,
--								@Descrprod,
--								@NCM
--							)
--						set @cd_prod=@cd_prod_MAX
--				END
--		END
--	Else
--		BEGIN
--			if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Descrprod and cd_cliente=@CODCLI)
--					begin
--						set @Descrprod = @Descrprod + ' (' + @cd_Proc_Cliente + ')'
--					end
--			BEGIN
--				Update
--					Produto_cliente
--				Set
--					Produto_Descr=@Descrprod,
--					NCM_Cliente=@NCM
--				Where
--					cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@CODCLI
--			END
--		END
		
		
			

--	If exists (select cd_prod from produto_chb where cd_prod=@cd_prod)
--		Begin
--			Update
--				Produto_chb
--			Set
--				Etiqueta_Produto=@Etiqueta,
--				Aprovado=@Aprovado,
--				Descricao_longa=@Descrprodl,
--				Dt_Pesquisa=@DataPesq,
--				Tipo_LI=@LI,
--				Import_license=@Import,
--				Orgao_Anuente=@Orgao,
--				Pais_Origem=@CODPais,
--				Concentracao=@Concentracao
--			where
--				cd_prod=@cd_prod
--		End
--	else
--		Begin
--			Insert Produto_chb(
--					cd_prod,
--					Etiqueta_Produto,
--					Aprovado,
--					Descricao_longa,
--					Dt_Pesquisa,
--					tipo_li,
--					import_license,
--					orgao_anuente,
--					Pais_origem,
--					Concentracao)
--			Values(
--					@cd_prod,
--					@Etiqueta,
--					@Aprovado,
--					@DescrprodL,
--					@DataPesq,
--					@LI,
--					@Import,
--					@Orgao,
--					@CODPais,
--					@Concentracao)
--			End
	
--	If exists (select GMID from de_para_produto where GMID=@cd_Proc_Cliente)
--		Begin
--			Update
--				de_para_produto
--			Set
--				cd_cliente=@CODCLI,
--				GMID_Descr_Curta=@Descrprod,
--				Trade_Product_Code=@Trade,
--				Value_center_code=@Value,
--				P_Descricao=@DescrP,
--				S_Descricao=@DescrS,
--				business_descr = @BusinessName
--			where
--				GMID=@cd_Proc_Cliente
--			end
	
--	else
--		Begin
--			Insert de_para_produto(
--					cd_cliente,
--					GMID,
--					GMID_Descr_Curta,
--					Trade_Product_Code,
--					Value_Center_Code,
--					P_Descricao,
--					S_Descricao,
--					business_descr)
--			Values(
--					@CODCLI,
--					@cd_Proc_Cliente,
--					@Descrprod,
--					@Trade,
--					@Value,
--					@DescrP,
--					@DescrS,
--					@BusinessName)
--		End

				
				
--Commit Transaction

GO
