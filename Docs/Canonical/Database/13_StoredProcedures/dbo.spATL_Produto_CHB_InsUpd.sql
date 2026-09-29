SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Produto_CHB_InsUpd]


	@Cd_Prod				INT,
	@Etiqueta_Produto		varchar(50),
	@Aprovado				char(1),
	@Descricao_Longa		varchar(max),
	@Dt_Pesquisa				Datetime,
	@Tipo_LI				varchar(3),
	@Import_License			Varchar(3),
	@Orgao_Anuente			varchar(50),
	@Cd_Pais				varchar(3),
	@Nome_Pais				varchar(50),
	@Concentracao			float
	
AS

Begin Transaction
		
	if @Cd_Pais is null
		begin
			set @Cd_Pais = (select Cd_Pais from Pais where Nome_Pais=@Nome_Pais)
		end		
		
	If exists (select cd_prod from Produto_CHB where cd_prod=@cd_prod)
		Begin
			Update
				Produto_chb
			Set
				Etiqueta_Produto=@Etiqueta_Produto,
				Aprovado=@Aprovado,
				Descricao_longa=@Descricao_Longa,
				Dt_Pesquisa=@Dt_Pesquisa,
				Tipo_LI=@Tipo_LI,
				Import_license=@Import_License,
				Orgao_Anuente=@Orgao_Anuente,
				Pais_Origem=@Cd_Pais,
				Concentracao=@Concentracao
			where
				cd_prod=@cd_prod
		End
	else
		Begin
			Insert Produto_chb(
					cd_prod,Etiqueta_Produto,Aprovado,Descricao_longa,Dt_Pesquisa,
					tipo_li,import_license,	orgao_anuente,Pais_origem,Concentracao)
			Values(
					@cd_prod,@Etiqueta_Produto,@Aprovado,@Descricao_Longa,@Dt_Pesquisa,
					@Tipo_LI,@Import_License,@Orgao_Anuente,@Cd_Pais,@Concentracao)
			End	
	
				
				
Commit Transaction

GO
