SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure spFaturamentoIA_Rel 
			@DataInicial varchar(10),
			@DataFinal   varchar(10)

AS


select 
	'IA' Modal, month(emissao) Mes, sum(dbo.valor(vlr_pgto_nf_hia,cta.dc_hia)) NF 

from 
	cta_cte_hou_imp_aer cta
	Join base_nota_fiscal NF on nf.nota_fiscal=num_nf_hia and nf.ref_acesso= Ref_Acesso_NF_HIA

Where
	emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

Group by  

	month(emissao)


UNION ALL

select 
	'IA' Modal, month(emissao) Mes, sum(dbo.valor(vlr_pgto_nf_mia,cta.dc_mia)) NF 

from 
	cta_cte_mas_imp_aer cta
	Join base_nota_fiscal NF on nf.nota_fiscal=num_nf_mia and nf.ref_acesso= Ref_Acesso_NF_mia

Where
	emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

Group by  

	month(emissao)




GO
