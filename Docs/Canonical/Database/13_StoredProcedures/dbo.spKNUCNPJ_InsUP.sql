SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spKNUCNPJ_InsUP

(	
	@Num_CNPJ	varchar(20),
	@Atividade_Economica	varchar(100),
	@CEP		varchar(10),
	@Bairro	varchar(100),
	@Complemento	varchar(200),
	@IE				varchar(200),
	@Endereco		varchar(500),
	@Municipio		varchar(500),
	@Numero			varchar(500),
	@Razao			varchar(500),
	@UF			varchar(40)

)
as
Insert KNU_CNPJ
	(
		Num_CNPJ,
		Atividade_Economica,
		CEP,
		Bairro,
		Complemento,
		IE,
		Endereco,
		Municipio,
		Numero,
		Razao,
		UF
		)
		values
		(
		
		@Num_CNPJ,
		@Atividade_Economica,
		@CEP,
		@Bairro,
		@Complemento,
		@IE,
		@Endereco,
		@Municipio,
		@Numero,
		@Razao,
		@UF
		
		
		)
GO
