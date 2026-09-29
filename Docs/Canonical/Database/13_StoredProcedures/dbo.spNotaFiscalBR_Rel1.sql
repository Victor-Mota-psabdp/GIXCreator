SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spNotaFiscalBR_Rel1] 

		@Tipo		char(1),
		@Numero		varchar(12)

as
select 
	Nota_Fiscal Num_NF,
	Ref_Acesso Ref_Acesso_NF,
	PS.apelido,
	Nome_Raz_Soc Razao_Social,
	ED.Rua Endereco,
	ED.Numero Numero, 
	ED.Cidade, 
	ED.UF,
	ED.Pais , 
	num_cpf_cnpj,
	num_rg_ie,
	Emissao, 
	cd_status,
	Valor_total, 
	Observ_nf, 
	Aliq_ISS, 
	Valor_ISS 
from 
	base_nota_fiscal BNF
left outer join Pessoa PS on BNF.cd_pes = PS.cd_pes
left outer join Endereco ED	on BNF.cd_Pes = PS.cd_pes
where ref_acesso = @Tipo and Nota_Fiscal = @Numero










GO
