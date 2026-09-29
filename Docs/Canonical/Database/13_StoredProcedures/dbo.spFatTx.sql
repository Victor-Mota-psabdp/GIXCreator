SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE spFatTx
	
		@datainicial varchar(10),
		@datafinal  varchar(10)
as

SELECT 
	nome_tp_tx,cast(sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) as smallmoney) as Valor,month(emissao) as Mes FROM CTA_CTE_HOU_IMP_AER cta

inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_hia and nf.ref_acesso=ref_acesso_nf_hia)
inner join tipo_taxa tt on (tt.cd_tp_tx=cta.cd_tp_tx)

where 
	emissao between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)

group by nome_tp_tx,month(emissao)



UNION ALL



SELECT 
	nome_tp_tx,cast(sum(dbo.valor(cta.vlr_pgto_nf_mia,cta.dc_mia)) as smallmoney),month(emissao) 

FROM 
	CTA_CTE_mas_IMP_AER cta

inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_mia and nf.ref_acesso=ref_acesso_nf_mia)
inner join tipo_taxa tt on (tt.cd_tp_tx=cta.cd_tp_tx)

WHERE
	emissao between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)

group by nome_tp_tx,month(emissao)

union all

SELECT 
	nome_tp_tx,cast(sum(dbo.valor(cta.vlr_pgto_nf_him,cta.dc_him)) as smallmoney),month(emissao) FROM CTA_CTE_HOU_IMP_mar cta

inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_him and nf.ref_acesso=ref_acesso_nf_him)
inner join tipo_taxa tt on (tt.cd_tp_tx=cta.cd_tp_tx)

WHERE 

	emissao between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)

group by nome_tp_tx,month(emissao)

union all

SELECT 
	nome_tp_tx,cast(sum(dbo.valor(cta.vlr_pgto_nf_mim,cta.dc_mim)) as smallmoney),month(emissao) FROM CTA_CTE_mas_IMP_mar cta

inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_mim and nf.ref_acesso=ref_acesso_nf_mim)
inner join tipo_taxa tt on (tt.cd_tp_tx=cta.cd_tp_tx)

where 
	emissao between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)


group by nome_tp_tx,month(emissao)

union all


SELECT 
	nome_tp_tx,cast(sum(dbo.valor(cta.vlr_pgto_nf_hea,cta.dc_hea)) as smallmoney),month(emissao) FROM CTA_CTE_HOU_exp_AER cta

inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_hea and nf.ref_acesso=ref_acesso_nf_hea)
inner join tipo_taxa tt on (tt.cd_tp_tx=cta.cd_tp_tx)

where 
	emissao between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)

group by nome_tp_tx,month(emissao)

union all

SELECT 
	nome_tp_tx,cast(sum(dbo.valor(cta.vlr_pgto_nf_mea,cta.dc_mea)) as smallmoney),month(emissao) FROM CTA_CTE_mas_exp_AER cta

inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_mea and nf.ref_acesso=ref_acesso_nf_mea)
inner join tipo_taxa tt on (tt.cd_tp_tx=cta.cd_tp_tx)

where 
	emissao between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)


group by nome_tp_tx,month(emissao)


UNION ALL


SELECT 
	nome_tp_tx,cast(sum(dbo.valor(cta.vlr_pgto_nf_hem,cta.dc_hem)) as smallmoney),month(emissao) FROM CTA_CTE_HOU_exp_mar cta

inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_hem and nf.ref_acesso=ref_acesso_nf_hem)
inner join tipo_taxa tt on (tt.cd_tp_tx=cta.cd_tp_tx)

where 
	emissao between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)


group by nome_tp_tx,month(emissao)


UNION ALL

SELECT 
	nome_tp_tx,cast(sum(dbo.valor(cta.vlr_pgto_nf_mem,cta.dc_mem)) as smallmoney),month(emissao) 

FROM 
	CTA_CTE_mas_exp_mar cta

inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_mem and nf.ref_acesso=ref_acesso_nf_mem)
inner join tipo_taxa tt on (tt.cd_tp_tx=cta.cd_tp_tx)

where 
	emissao between convert(datetime, @datainicial,105) and convert(datetime, @datafinal,105)


group by nome_tp_tx,month(emissao)






GO
