SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNF_Fatura_Sel]--'90000001'
	@numero_fat varchar(9)
as
select 
	NF.ID,
	NF.Nota_Fiscal,
	ST.Cd_Site + ' - ' +ST.Nome_Site Ref_Acesso,
	PS.apelido,
	Nome_Raz_Soc Razao_Social,
	ED.Rua +', '+ ED.Numero Endereco, 
	ED.Cidade,
	ED.UF,
	ED.Pais, 
	NF.Emissao,
	NF.Vencimento,
	NF.cd_status,
	NF.Total_NF,
	NF.Total_FAT, 
	NF.Observ_nf, 
	NF.Aliq_ISS, 
	NF.Valor_ISS,
	NF.Habilita_Impostos,
	NF.Atencao,
	NF.cd_servico,NF.descricao,NF.item_lei,NF.CNAE,NF.IRRF_Tx,
	FatVendorInvoiceNumber, --Alessandra 19/05/2021 - AX10
	B.RPS_NFE	
	
from
	nf_fatura NF with(nolock)
	left outer join Pessoa PS with(nolock) on NF.cd_pes = PS.cd_pes
	left outer join Endereco ED with(nolock) on NF.cd_Pes = ED.cd_pes
	join Site ST with(nolock) on NF.Ref_Acesso = ST.Cd_Site
	left join Base_Nota_Fiscal B on B.Nota_Fiscal = NF.Nota_Fiscal and B.Ref_Acesso = NF.Ref_Acesso 
where
	numero_fat=@numero_fat 
--	and cd_status <> 2










GO
