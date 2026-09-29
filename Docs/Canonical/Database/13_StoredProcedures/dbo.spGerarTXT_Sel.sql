SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from base_nota_fiscal where cd_status = '2'

--select * from status

--select * from site


CREATE Procedure [dbo].[spGerarTXT_Sel] --'2009-01-01','2009-06-02','A'

@DataInicial datetime,
@DataFinal datetime,
@Site varchar(1)

as


select distinct bn.ref_acesso,ps.cd_usuario,hea.cd_tp_tx,bn.aliq_iss_rps,ps.num_cpf_cnpj,bn.nota_fiscal,hea.vlr_pgto_nf_hea ValorItem,convert(varchar(10),bn.emissao,103)Data,bn.valor_total,bn.observ_NF,bn.cd_pes,bn.nota_fiscal
from base_nota_fiscal BN
join cta_cte_hou_exp_aer HEA on bn.nota_fiscal=hea.num_nf_hea
join endereco E on e.cd_pes=bn.cd_pes
join pessoa PS on ps.cd_pes=bn.cd_pes 
where emissao between @DataInicial and @DataFinal and e.cd_tp_end='COM' and bn.cd_status<>'2' and bn.ref_acesso=@Site

union

select distinct bn.ref_acesso,ps.cd_usuario,hem.cd_tp_tx,bn.aliq_iss,ps.num_cpf_cnpj,bn.nota_fiscal,hem.vlr_pgto_nf_hem ValorItem,convert(varchar(10),bn.emissao,103)Data,bn.valor_total,bn.observ_NF,bn.cd_pes,bn.nota_fiscal 
from base_nota_fiscal BN
join cta_cte_hou_exp_mar HEM on bn.nota_fiscal=hem.num_nf_hem
join endereco E on e.cd_pes=bn.cd_pes
join pessoa PS on ps.cd_pes=bn.cd_pes 
where emissao between @DataInicial and @DataFinal and e.cd_tp_end='COM' and bn.cd_status<>'2' and bn.ref_acesso=@Site

union

select distinct bn.ref_acesso,ps.cd_usuario,heo.cd_tp_tx,bn.aliq_iss,ps.num_cpf_cnpj,bn.nota_fiscal,heo.vlr_pgto_nf_heo ValorItem,convert(varchar(10),bn.emissao,103)Data,bn.valor_total,bn.observ_NF,bn.cd_pes,bn.nota_fiscal
from base_nota_fiscal BN
join cta_cte_hou_exp_out HEO on bn.nota_fiscal=heo.num_nf_heo
join endereco E on e.cd_pes=bn.cd_pes
join pessoa PS on ps.cd_pes=bn.cd_pes
where emissao between @DataInicial and @DataFinal and e.cd_tp_end='COM' and bn.cd_status<>'2' and bn.ref_acesso=@Site


union

select distinct bn.ref_acesso,ps.cd_usuario,hia.cd_tp_tx,bn.aliq_iss,ps.num_cpf_cnpj,bn.nota_fiscal,hia.vlr_pgto_nf_hia ValorItem,convert(varchar(10),bn.emissao,103)Data,bn.valor_total,bn.observ_NF,bn.cd_pes,bn.nota_fiscal
from base_nota_fiscal BN
join cta_cte_hou_imp_aer HIA on bn.nota_fiscal=hia.num_nf_hia
join endereco E on e.cd_pes=bn.cd_pes
join pessoa PS on ps.cd_pes=bn.cd_pes
where emissao between @DataInicial and @DataFinal and e.cd_tp_end='COM' and bn.cd_status<>'2' and bn.ref_acesso=@Site

union

select distinct bn.ref_acesso,ps.cd_usuario,him.cd_tp_tx,bn.aliq_iss,ps.num_cpf_cnpj,bn.nota_fiscal,him.vlr_pgto_nf_him ValorItem,convert(varchar(10),bn.emissao,103)Data,bn.valor_total,bn.observ_NF,bn.cd_pes,bn.nota_fiscal
from base_nota_fiscal BN
join cta_cte_hou_imp_mar HIM on bn.nota_fiscal=him.num_nf_him
join endereco E on e.cd_pes=bn.cd_pes
join pessoa PS on ps.cd_pes=bn.cd_pes
where emissao between @DataInicial and @DataFinal and e.cd_tp_end='COM' and bn.cd_status<>'2' and bn.ref_acesso=@Site

union

select distinct bn.ref_acesso,ps.cd_usuario,hio.cd_tp_tx,bn.aliq_iss,ps.num_cpf_cnpj,bn.nota_fiscal,hio.vlr_pgto_nf_hio ValorItem,convert(varchar(10),bn.emissao,103)Data,bn.valor_total,bn.observ_NF,bn.cd_pes,bn.nota_fiscal
from base_nota_fiscal BN
join cta_cte_hou_imp_out HIO on bn.nota_fiscal=hio.num_nf_hio
join endereco E on e.cd_pes=bn.cd_pes
join pessoa PS on ps.cd_pes=bn.cd_pes
where emissao between @DataInicial and @DataFinal and e.cd_tp_end='COM' and bn.cd_status<>'2' and bn.ref_acesso=@Site

union

select distinct bn.ref_acesso,ps.cd_usuario,mea.cd_tp_tx,bn.aliq_iss_rps,ps.num_cpf_cnpj,bn.nota_fiscal,mea.vlr_pgto_nf_mea ValorItem,convert(varchar(10),bn.emissao,103)Data,bn.valor_total,bn.observ_NF,bn.cd_pes,bn.nota_fiscal
from base_nota_fiscal BN
join cta_cte_mas_exp_aer MEA on bn.nota_fiscal=mea.num_nf_mea
join endereco E on e.cd_pes=bn.cd_pes
join pessoa PS on ps.cd_pes=bn.cd_pes 
where emissao between @DataInicial and @DataFinal and e.cd_tp_end='COM' and bn.cd_status<>'2' and bn.ref_acesso=@Site

union

select distinct bn.ref_acesso,ps.cd_usuario,mem.cd_tp_tx,bn.aliq_iss_rps,ps.num_cpf_cnpj,bn.nota_fiscal,mem.vlr_pgto_nf_mem ValorItem,convert(varchar(10),bn.emissao,103)Data,bn.valor_total,bn.observ_NF,bn.cd_pes,bn.nota_fiscal
from base_nota_fiscal BN
join cta_cte_mas_exp_mar MEM on bn.nota_fiscal=mem.num_nf_mem
join endereco E on e.cd_pes=bn.cd_pes
join pessoa PS on ps.cd_pes=bn.cd_pes 
where emissao between @DataInicial and @DataFinal and e.cd_tp_end='COM' and bn.cd_status<>'2' and bn.ref_acesso=@Site

union

select distinct bn.ref_acesso,ps.cd_usuario,mia.cd_tp_tx,bn.aliq_iss_rps,ps.num_cpf_cnpj,bn.nota_fiscal,mia.vlr_pgto_nf_mia ValorItem,convert(varchar(10),bn.emissao,103)Data,bn.valor_total,bn.observ_NF,bn.cd_pes,bn.nota_fiscal
from base_nota_fiscal BN
join cta_cte_mas_imp_aer MIA on bn.nota_fiscal=mia.num_nf_mia
join endereco E on e.cd_pes=bn.cd_pes
join pessoa PS on ps.cd_pes=bn.cd_pes 
where emissao between @DataInicial and @DataFinal and e.cd_tp_end='COM' and bn.cd_status<>'2' and bn.ref_acesso=@Site

union

select distinct bn.ref_acesso,ps.cd_usuario,mim.cd_tp_tx,bn.aliq_iss_rps,ps.num_cpf_cnpj,bn.nota_fiscal,mim.vlr_pgto_nf_mim ValorItem,convert(varchar(10),bn.emissao,103)Data,bn.valor_total,bn.observ_NF,bn.cd_pes,bn.nota_fiscal
from base_nota_fiscal BN
join cta_cte_mas_imp_mar MIM on bn.nota_fiscal=mim.num_nf_mim
join endereco E on e.cd_pes=bn.cd_pes
join pessoa PS on ps.cd_pes=bn.cd_pes 
where emissao between @DataInicial and @DataFinal and e.cd_tp_end='COM' and bn.cd_status<>'2' and bn.ref_acesso=@Site

order by bn.nota_fiscal













GO
