SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[SP_SEL_CTA_CTES] --'01/06/2011','15/06/2011','%','%'
				@datainicial	varchar(10),
				@datafinal	varchar(10),
				@pessoa 	varchar(25),
				@taxa		varchar(30)
AS
Select 
	dbo.fBusca_TipoDocCliente('N',cxa.num_proc_hia,19) Job_ATL,
	CTA.num_proc_hia  Processo, Nome_tp_tx  Taxa, CTA.dc_hia DebitoCredito,
	Convert(DateTime,dt_ins_hia,105)  Data, Cd_tp_moeda Moeda,cast(Vlr_org_hia as Money) as ValorOriginal,
	Apelido,0 ValorPago, CTA.Dt_Prev_Pgto_HIA	Dt_PRev
From
	vwCta_Cte CTA
	Left Join vwcxas CXA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and upper(num_lcto) <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hia,105)<=convert(datetime,@datafinal,105)
	Join Pessoa PP on PP.cd_pes=cd_cred_Dev_hia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_Tp_tx
Where
	num_lcto is null and
	apelido like @pessoa 
	and Nome_Tp_tx like @Taxa
	and convert(datetime,dt_ins_hia,105) between convert(Datetime,@datainicial,105) and convert(Datetime,@DataFinal,105)
order by 
	 convert(datetime,CTA.Dt_Prev_Pgto_HIA,103) 
/*
select 
num_proc_hia AS PROCESSO,
nome_tp_tx AS TAXA,
dc_hia DEBITOCREDITO,
convert(datetime, dt_ins_hia, 105) as DATA,
cd_tp_moeda AS MOEDA,
cast(vlr_org_hia as money) as VALORORIGINAL,
apelido AS APELIDO,
(
select sum(cast(vlr_ref_hia as money)) 
from caixa_hou_imp_aer 
where  
cta_cte_hou_imp_aer.num_proc_hia=caixa_hou_imp_aer.num_proc_hia and
cta_cte_hou_imp_aer.cd_tp_tx=caixa_hou_imp_aer.cd_tp_tx and
cta_cte_hou_imp_aer.dc_hia=caixa_hou_imp_aer.dc_hia and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hia,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) as ValorPago
from cta_cte_hou_imp_aer
join pessoa on
pessoa.cd_pes=cta_cte_hou_imp_aer.cd_cred_dev_hia
join tipo_taxa on
tipo_taxa.cd_tp_tx=cta_cte_hou_imp_aer.cd_tp_tx
where 
cast(vlr_org_hia as money)<>
(
select sum(cast(vlr_ref_hia as money)) 
from caixa_hou_imp_aer 
where  
cta_cte_hou_imp_aer.num_proc_hia=caixa_hou_imp_aer.num_proc_hia and
cta_cte_hou_imp_aer.cd_tp_tx=caixa_hou_imp_aer.cd_tp_tx and
cta_cte_hou_imp_aer.dc_hia=caixa_hou_imp_aer.dc_hia and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hia,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) and
desp_org_hia = 'N' and
org_ins_hia <> 'RATEIO' and
convert(datetime, dt_ins_hia, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
or
(
select sum(cast(vlr_ref_hia as money)) 
from caixa_hou_imp_aer 
where  
cta_cte_hou_imp_aer.num_proc_hia=caixa_hou_imp_aer.num_proc_hia and
cta_cte_hou_imp_aer.cd_tp_tx=caixa_hou_imp_aer.cd_tp_tx and
cta_cte_hou_imp_aer.dc_hia=caixa_hou_imp_aer.dc_hia and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hia,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) is null and 
desp_org_hia = 'N' and
org_ins_hia <> 'RATEIO' and
convert(datetime, dt_ins_hia, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
union
select 
num_proc_mia AS PROCESSO,
nome_tp_tx AS TAXA,
dc_mia DEBITOCREDITO,
convert(datetime, dt_ins_mia, 105) as DATA,
cd_tp_moeda AS MOEDA,
cast(vlr_org_mia as money) as VALORORIGINAL,
apelido AS APELIDO,
(
select sum(cast(vlr_ref_mia as money)) 
from caixa_mas_imp_aer 
where  
cta_cte_mas_imp_aer.num_proc_mia=caixa_mas_imp_aer.num_proc_mia and
cta_cte_mas_imp_aer.cd_tp_tx=caixa_mas_imp_aer.cd_tp_tx and
cta_cte_mas_imp_aer.dc_mia=caixa_mas_imp_aer.dc_mia and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mia,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) as ValorPago
from cta_cte_mas_imp_aer
join pessoa on
pessoa.cd_pes=cta_cte_mas_imp_aer.cd_cred_dev_mia
join tipo_taxa on
tipo_taxa.cd_tp_tx=cta_cte_mas_imp_aer.cd_tp_tx
where 
cast(vlr_org_mia as money)<>
(
select sum(cast(vlr_ref_mia as money)) 
from caixa_mas_imp_aer 
where  
cta_cte_mas_imp_aer.num_proc_mia=caixa_mas_imp_aer.num_proc_mia and
cta_cte_mas_imp_aer.cd_tp_tx=caixa_mas_imp_aer.cd_tp_tx and
cta_cte_mas_imp_aer.dc_mia=caixa_mas_imp_aer.dc_mia and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mia,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) and
desp_org_mia = 'N' and
org_ins_mia <> 'RATEIO' and
convert(datetime, dt_ins_mia, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
or
(
select sum(cast(vlr_ref_mia as money)) 
from caixa_mas_imp_aer 
where  
cta_cte_mas_imp_aer.num_proc_mia=caixa_mas_imp_aer.num_proc_mia and
cta_cte_mas_imp_aer.cd_tp_tx=caixa_mas_imp_aer.cd_tp_tx and
cta_cte_mas_imp_aer.dc_mia=caixa_mas_imp_aer.dc_mia and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mia,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) is null and 
desp_org_mia = 'N' and
org_ins_mia <> 'RATEIO' and
convert(datetime, dt_ins_mia, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105) 
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
union
select 
num_proc_hea AS PROCESSO,
nome_tp_tx AS TAXA,
dc_hea DEBITOCREDITO,
convert(datetime, dt_ins_hea, 105) as DATA,
cd_tp_moeda AS MOEDA,
cast(vlr_org_hea as money) as VALORORIGINAL,
apelido AS APELIDO,
(
select sum(cast(vlr_ref_hea as money)) 
from caixa_hou_exp_aer 
where  
cta_cte_hou_exp_aer.num_proc_hea=caixa_hou_exp_aer.num_proc_hea and
cta_cte_hou_exp_aer.cd_tp_tx=caixa_hou_exp_aer.cd_tp_tx and
cta_cte_hou_exp_aer.dc_hea=caixa_hou_exp_aer.dc_hea and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hea,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) as ValorPago
from cta_cte_hou_exp_aer
join pessoa on
pessoa.cd_pes=cta_cte_hou_exp_aer.cd_cred_dev_hea
join tipo_taxa on
tipo_taxa.cd_tp_tx=cta_cte_hou_exp_aer.cd_tp_tx
where 
cast(vlr_org_hea as money)<>
(
select sum(cast(vlr_ref_hea as money)) 
from caixa_hou_exp_aer 
where  
cta_cte_hou_exp_aer.num_proc_hea=caixa_hou_exp_aer.num_proc_hea and
cta_cte_hou_exp_aer.cd_tp_tx=caixa_hou_exp_aer.cd_tp_tx and
cta_cte_hou_exp_aer.dc_hea=caixa_hou_exp_aer.dc_hea and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hea,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) and
desp_dst_hea = 'N' and
org_ins_hea <> 'RATEIO' and
convert(datetime, dt_ins_hea, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
or
(
select sum(cast(vlr_ref_hea as money)) 
from caixa_hou_exp_aer 
where  
cta_cte_hou_exp_aer.num_proc_hea=caixa_hou_exp_aer.num_proc_hea and
cta_cte_hou_exp_aer.cd_tp_tx=caixa_hou_exp_aer.cd_tp_tx and
cta_cte_hou_exp_aer.dc_hea=caixa_hou_exp_aer.dc_hea and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hea,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) is null and 
desp_dst_hea = 'N' and
org_ins_hea <> 'RATEIO' and
convert(datetime, dt_ins_hea, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
UNION
select 
num_proc_mea AS PROCESSO,
nome_tp_tx AS TAXA,
dc_mea DEBITOCREDITO,
convert(datetime, dt_ins_mea, 105) as DATA,
cd_tp_moeda AS MOEDA,
cast(vlr_org_mea as money) as VALORORIGINAL,
apelido AS APELIDO,
(
select sum(cast(vlr_ref_mea as money)) 
from caixa_mas_exp_aer 
where  
cta_cte_mas_exp_aer.num_proc_mea=caixa_mas_exp_aer.num_proc_mea and
cta_cte_mas_exp_aer.cd_tp_tx=caixa_mas_exp_aer.cd_tp_tx and
cta_cte_mas_exp_aer.dc_mea=caixa_mas_exp_aer.dc_mea and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mea,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) as ValorPago
from cta_cte_mas_exp_aer
join pessoa on
pessoa.cd_pes=cta_cte_mas_exp_aer.cd_cred_dev_mea
join tipo_taxa on
tipo_taxa.cd_tp_tx=cta_cte_mas_exp_aer.cd_tp_tx
where 
cast(vlr_org_mea as money)<>
(
select sum(cast(vlr_ref_mea as money)) 
from caixa_mas_exp_aer 
where  
cta_cte_mas_exp_aer.num_proc_mea=caixa_mas_exp_aer.num_proc_mea and
cta_cte_mas_exp_aer.cd_tp_tx=caixa_mas_exp_aer.cd_tp_tx and
cta_cte_mas_exp_aer.dc_mea=caixa_mas_exp_aer.dc_mea and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mea,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) and
desp_DST_mea = 'N' and
org_ins_mea <> 'RATEIO' and
convert(datetime, dt_ins_mea, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
or
(
select sum(cast(vlr_ref_mea as money)) 
from caixa_mas_exp_aer 
where  
cta_cte_mas_exp_aer.num_proc_mea=caixa_mas_exp_aer.num_proc_mea and
cta_cte_mas_exp_aer.cd_tp_tx=caixa_mas_exp_aer.cd_tp_tx and
cta_cte_mas_exp_aer.dc_mea=caixa_mas_exp_aer.dc_mea and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mea,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) is null and 
desp_DST_mea = 'N' and
org_ins_mea <> 'RATEIO' and
convert(datetime, dt_ins_mea, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
UNION
select 
num_proc_hem AS PROCESSO,
nome_tp_tx AS TAXA,
dc_hem DEBITOCREDITO,
convert(datetime, dt_ins_hem, 105) as DATA,
cd_tp_moeda AS MOEDA,
cast(vlr_org_hem as money) as VALORORIGINAL,
apelido AS APELIDO,
(
select sum(cast(vlr_ref_hem as money)) 
from caixa_hou_exp_mar 
where  
cta_cte_hou_exp_mar.num_proc_hem=caixa_hou_exp_mar.num_proc_hem and
cta_cte_hou_exp_mar.cd_tp_tx=caixa_hou_exp_mar.cd_tp_tx and
cta_cte_hou_exp_mar.dc_hem=caixa_hou_exp_mar.dc_hem and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hem,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) as ValorPago
from cta_cte_hou_exp_mar
join pessoa on
pessoa.cd_pes=cta_cte_hou_exp_mar.cd_cred_dev_hem
join tipo_taxa on
tipo_taxa.cd_tp_tx=cta_cte_hou_exp_mar.cd_tp_tx
where 
cast(vlr_org_hem as money)<>
(
select sum(cast(vlr_ref_hem as money)) 
from caixa_hou_exp_mar 
where  
cta_cte_hou_exp_mar.num_proc_hem=caixa_hou_exp_mar.num_proc_hem and
cta_cte_hou_exp_mar.cd_tp_tx=caixa_hou_exp_mar.cd_tp_tx and
cta_cte_hou_exp_mar.dc_hem=caixa_hou_exp_mar.dc_hem and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hem,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) and
desp_dst_hem = 'N' and
org_ins_hem <> 'RATEIO' and
convert(datetime, dt_ins_hem, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
or
(
select sum(cast(vlr_ref_hem as money)) 
from caixa_hou_exp_mar 
where  
cta_cte_hou_exp_mar.num_proc_hem=caixa_hou_exp_mar.num_proc_hem and
cta_cte_hou_exp_mar.cd_tp_tx=caixa_hou_exp_mar.cd_tp_tx and
cta_cte_hou_exp_mar.dc_hem=caixa_hou_exp_mar.dc_hem and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hem,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) is null and 
desp_dst_hem = 'N' and
org_ins_hem <> 'RATEIO' and
convert(datetime, dt_ins_hem, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
union
select 
num_proc_mem AS PROCESSO,
nome_tp_tx AS TAXA,
dc_mem DEBITOCREDITO,
convert(datetime, dt_ins_mem, 105) as DATA,
cd_tp_moeda AS MOEDA,
cast(vlr_org_mem as money) as VALORORIGINAL,
apelido AS APELIDO,
(
select sum(cast(vlr_ref_mem as money)) 
from caixa_mas_exp_mar 
where  
cta_cte_mas_exp_mar.num_proc_mem=caixa_mas_exp_mar.num_proc_mem and
cta_cte_mas_exp_mar.cd_tp_tx=caixa_mas_exp_mar.cd_tp_tx and
cta_cte_mas_exp_mar.dc_mem=caixa_mas_exp_mar.dc_mem and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mem,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) as ValorPago
from cta_cte_mas_exp_mar
join pessoa on
pessoa.cd_pes=cta_cte_mas_exp_mar.cd_cred_dev_mem
join tipo_taxa on
tipo_taxa.cd_tp_tx=cta_cte_mas_exp_mar.cd_tp_tx
where 
cast(vlr_org_mem as money)<>
(
select sum(cast(vlr_ref_mem as money)) 
from caixa_mas_exp_mar 
where  
cta_cte_mas_exp_mar.num_proc_mem=caixa_mas_exp_mar.num_proc_mem and
cta_cte_mas_exp_mar.cd_tp_tx=caixa_mas_exp_mar.cd_tp_tx and
cta_cte_mas_exp_mar.dc_mem=caixa_mas_exp_mar.dc_mem and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mem,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) and
desp_dst_mem = 'N' and
org_ins_mem <> 'RATEIO' and
convert(datetime, dt_ins_mem, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
or
(
select sum(cast(vlr_ref_mem as money)) 
from caixa_mas_exp_mar 
where  
cta_cte_mas_exp_mar.num_proc_mem=caixa_mas_exp_mar.num_proc_mem and
cta_cte_mas_exp_mar.cd_tp_tx=caixa_mas_exp_mar.cd_tp_tx and
cta_cte_mas_exp_mar.dc_mem=caixa_mas_exp_mar.dc_mem and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mem,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) is null and 
desp_dst_mem = 'N' and
org_ins_mem <> 'RATEIO' and
convert(datetime, dt_ins_mem, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
UNION
select 
num_proc_him AS PROCESSO,
nome_tp_tx AS TAXA,
dc_him DEBITOCREDITO,
convert(datetime, dt_ins_him, 105) as DATA,
cd_tp_moeda AS MOEDA,
cast(vlr_org_him as money) as VALORORIGINAL,
apelido AS APELIDO,
(
select sum(cast(vlr_ref_him as money)) 
from caixa_hou_imp_mar 
where  
cta_cte_hou_imp_mar.num_proc_him=caixa_hou_imp_mar.num_proc_him and
cta_cte_hou_imp_mar.cd_tp_tx=caixa_hou_imp_mar.cd_tp_tx and
cta_cte_hou_imp_mar.dc_him=caixa_hou_imp_mar.dc_him and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_him,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) as ValorPago
from cta_cte_hou_imp_mar
join pessoa on
pessoa.cd_pes=cta_cte_hou_imp_mar.cd_cred_dev_him
join tipo_taxa on
tipo_taxa.cd_tp_tx=cta_cte_hou_imp_mar.cd_tp_tx
where 
cast(vlr_org_him as money)<>
(
select sum(cast(vlr_ref_him as money)) 
from caixa_hou_imp_mar 
where  
cta_cte_hou_imp_mar.num_proc_him=caixa_hou_imp_mar.num_proc_him and
cta_cte_hou_imp_mar.cd_tp_tx=caixa_hou_imp_mar.cd_tp_tx and
cta_cte_hou_imp_mar.dc_him=caixa_hou_imp_mar.dc_him and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_him,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) and
desp_org_him = 'N' and
org_ins_him <> 'RATEIO' and
convert(datetime, dt_ins_him, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
or
(
select sum(cast(vlr_ref_him as money)) 
from caixa_hou_imp_mar 
where  
cta_cte_hou_imp_mar.num_proc_him=caixa_hou_imp_mar.num_proc_him and
cta_cte_hou_imp_mar.cd_tp_tx=caixa_hou_imp_mar.cd_tp_tx and
cta_cte_hou_imp_mar.dc_him=caixa_hou_imp_mar.dc_him and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_him,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) is null and 
desp_org_him = 'N' and
org_ins_him <> 'RATEIO' and
convert(datetime, dt_ins_him, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
union

select 
num_proc_mim AS PROCESSO,
nome_tp_tx AS TAXA,
dc_mim DEBITOCREDITO,
convert(datetime, dt_ins_mim, 105) as DATA,
cd_tp_moeda AS MOEDA,
cast(vlr_org_mim as money) as VALORORIGINAL,
apelido AS APELIDO,
(
select sum(cast(vlr_ref_mim as money)) 
from caixa_mas_imp_mar 
where  
cta_cte_mas_imp_mar.num_proc_mim=caixa_mas_imp_mar.num_proc_mim and
cta_cte_mas_imp_mar.cd_tp_tx=caixa_mas_imp_mar.cd_tp_tx and
cta_cte_mas_imp_mar.dc_mim=caixa_mas_imp_mar.dc_mim and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mim,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) as ValorPago
from cta_cte_mas_imp_mar
join pessoa on
pessoa.cd_pes=cta_cte_mas_imp_mar.cd_cred_dev_mim
join tipo_taxa on
tipo_taxa.cd_tp_tx=cta_cte_mas_imp_mar.cd_tp_tx
where 
cast(vlr_org_mim as money)<>
(
select sum(cast(vlr_ref_mim as money)) 
from caixa_mas_imp_mar 
where  
cta_cte_mas_imp_mar.num_proc_mim=caixa_mas_imp_mar.num_proc_mim and
cta_cte_mas_imp_mar.cd_tp_tx=caixa_mas_imp_mar.cd_tp_tx and
cta_cte_mas_imp_mar.dc_mim=caixa_mas_imp_mar.dc_mim and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mim,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) and
desp_org_mim = 'N' and
org_ins_mim <> 'RATEIO' and
convert(datetime, dt_ins_mim, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
or
(
select sum(cast(vlr_ref_mim as money)) 
from caixa_mas_imp_mar 
where  
cta_cte_mas_imp_mar.num_proc_mim=caixa_mas_imp_mar.num_proc_mim and
cta_cte_mas_imp_mar.cd_tp_tx=caixa_mas_imp_mar.cd_tp_tx and
cta_cte_mas_imp_mar.dc_mim=caixa_mas_imp_mar.dc_mim and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_mim,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) is null and 
desp_org_mim = 'N' and
org_ins_mim <> 'RATEIO' and
convert(datetime, dt_ins_mim, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'



union


select 
num_proc_hio AS PROCESSO,
nome_tp_tx AS TAXA,
dc_hio DEBITOCREDITO,
convert(datetime, dt_ins_hio, 105) as DATA,
cd_tp_moeda AS MOEDA,
cast(vlr_org_hio as money) as VALORORIGINAL,
apelido AS APELIDO,
(
select sum(cast(vlr_ref_hio as money)) 
from caixa_hou_imp_Out 
where  
cta_cte_hou_imp_Out.num_proc_hio=caixa_hou_imp_Out.num_proc_hio and
cta_cte_hou_imp_Out.cd_tp_tx=caixa_hou_imp_Out.cd_tp_tx and
cta_cte_hou_imp_Out.dc_hio=caixa_hou_imp_Out.dc_hio and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hio,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) as ValorPago
from cta_cte_hou_imp_Out
join pessoa on
pessoa.cd_pes=cta_cte_hou_imp_Out.cd_cred_dev_hio
join tipo_taxa on
tipo_taxa.cd_tp_tx=cta_cte_hou_imp_Out.cd_tp_tx
where 
cast(vlr_org_hio as money)<>
(
select sum(cast(vlr_ref_hio as money)) 
from caixa_hou_imp_Out 
where  
cta_cte_hou_imp_Out.num_proc_hio=caixa_hou_imp_Out.num_proc_hio and
cta_cte_hou_imp_Out.cd_tp_tx=caixa_hou_imp_Out.cd_tp_tx and
cta_cte_hou_imp_Out.dc_hio=caixa_hou_imp_Out.dc_hio and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hio,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) and
desp_org_hio = 'N' and
org_ins_hio <> 'RATEIO' and
convert(datetime, dt_ins_hio, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
or
(
select sum(cast(vlr_ref_hio as money)) 
from caixa_hou_imp_Out 
where  
cta_cte_hou_imp_Out.num_proc_hio=caixa_hou_imp_Out.num_proc_hio and
cta_cte_hou_imp_Out.cd_tp_tx=caixa_hou_imp_Out.cd_tp_tx and
cta_cte_hou_imp_Out.dc_hio=caixa_hou_imp_Out.dc_hio and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_hio,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) is null and 
desp_org_hio = 'N' and
org_ins_hio <> 'RATEIO' and
convert(datetime, dt_ins_hio, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'



union


select 
num_proc_heo AS PROCESSO,
nome_tp_tx AS TAXA,
dc_heo DEBITOCREDITO,
convert(datetime, dt_ins_heo, 105) as DATA,
cd_tp_moeda AS MOEDA,
cast(vlr_org_heo as money) as VALORORIGINAL,
apelido AS APELIDO,
(
select sum(cast(vlr_ref_heo as money)) 
from caixa_hou_exp_Out 
where  
cta_cte_hou_exp_Out.num_proc_heo=caixa_hou_exp_Out.num_proc_heo and
cta_cte_hou_exp_Out.cd_tp_tx=caixa_hou_exp_Out.cd_tp_tx and
cta_cte_hou_exp_Out.dc_heo=caixa_hou_exp_Out.dc_heo and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_heo,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) as ValorPago
from cta_cte_hou_exp_Out
join pessoa on
pessoa.cd_pes=cta_cte_hou_exp_Out.cd_cred_dev_heo
join tipo_taxa on
tipo_taxa.cd_tp_tx=cta_cte_hou_exp_Out.cd_tp_tx
where 
cast(vlr_org_heo as money)<>
(
select sum(cast(vlr_ref_heo as money)) 
from caixa_hou_exp_Out 
where  
cta_cte_hou_exp_Out.num_proc_heo=caixa_hou_exp_Out.num_proc_heo and
cta_cte_hou_exp_Out.cd_tp_tx=caixa_hou_exp_Out.cd_tp_tx and
cta_cte_hou_exp_Out.dc_heo=caixa_hou_exp_Out.dc_heo and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_heo,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) and
desp_org_heo = 'N' and
org_ins_heo <> 'RATEIO' and
convert(datetime, dt_ins_heo, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'
or
(
select sum(cast(vlr_ref_heo as money)) 
from caixa_hou_exp_Out 
where  
cta_cte_hou_exp_Out.num_proc_heo=caixa_hou_exp_Out.num_proc_heo and
cta_cte_hou_exp_Out.cd_tp_tx=caixa_hou_exp_Out.cd_tp_tx and
cta_cte_hou_exp_Out.dc_heo=caixa_hou_exp_Out.dc_heo and
num_lcto <> 'PROVISÓRIO' and
convert(datetime, dt_pgto_rcto_heo,105) between
convert(datetime, @datainicial,105) and
convert(datetime, @datafinal,105)
) is null and 
desp_org_heo = 'N' and
org_ins_heo <> 'RATEIO' and
convert(datetime, dt_ins_heo, 105) between
convert(datetime, @datainicial, 105) and
convert(datetime, @datafinal, 105)
and apelido like @pessoa
and nome_tp_tx like @taxa
AND apelido <> 'RATEIO'




*/
GO
