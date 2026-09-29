SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spNotaFiscalBR_Sel]--'A','55377'
	@Tipo		char(1),
	@Numero		varchar(8)
as
select 
	PS.apelido,Nome_Raz_Soc Razao_Social,ED.Rua +', '+ ED.Numero Endereco, ED.Cidade, 
	ED.UF,ED.Pais , Emissao, cd_status,Valor_total, Observ_nf, BNF.Aliq_ISS, Valor_ISS ,
	 FA.paridade, FA.condicao_venda, M.nome_tp_Moeda, Habilita_Impostos,
	 BNF.cd_servico,BNF.descricao,BNF.item_lei,BNF.CNAE,BNF.IRRF_Tx,
	 BNF.RPS_NFE
from
	base_nota_fiscal BNF with(nolock)
	left outer join Pessoa PS with(nolock) on BNF.cd_pes = PS.cd_pes
	left outer join Endereco ED with(nolock)	on BNF.cd_Pes = ED.cd_pes
	join Fatura_ARG FA with(nolock) on FA.numero = BNF.nota_fiscal and FA.codigo = BNF.ref_acesso and FA.cd_pes=BNF.cd_pes 
	left outer join tipo_moeda M with(nolock) on M.cd_tp_moeda = FA.cd_tp_moeda
where
	ref_acesso = @Tipo and Nota_Fiscal = @Numero










GO
