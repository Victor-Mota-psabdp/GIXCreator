SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spResumoNF
		@DataInicial	Char(10),
		@DataFinal		Char(10)

as

select left(num_proc_hia,2) Modal,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Valor from base_nota_fiscal
Join vwcta_Cte CTA on cta.num_nf_hia=nota_fiscal and cta.ref_acesso_nf_hia=ref_Acesso
where
	emissao between @DataInicial and @DataFinal and cd_tp_tx COLLATE Latin1_General_CI_AI not in (select * from taxas_despacho)
group by left(num_proc_hia,2)


UNION ALL



select 'CHB' Modal,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Valor from base_nota_fiscal
Join vwcta_Cte CTA on cta.num_nf_hia=nota_fiscal and cta.ref_acesso_nf_hia=ref_Acesso
where
	emissao between @DataInicial and @DataFinal and cd_tp_tx COLLATE Latin1_General_CI_AI  in (select * from taxas_despacho)  
--group by left(num_proc_hia,2)
GO
