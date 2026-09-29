SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE pCaixasOpos_rel
		@DataInicial	varchar (10),
		@DataFinal	varchar	(10)
as
select 
caixa.num_proc_hia as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_hia as DC,
cast(caixa.vlr_ref_hia as money) as ValorReferencia,
cast(caixa.par_moeda_hia as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_hia, 105) as Data,
cast(caixa.vlr_pgto_rcto_hia as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_hia as money) as OpostoRef,
cast(oposto.par_moeda_hia as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_hia, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_hia as money)as OpostoValor
from caixa_hou_imp_aer as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_hou_imp_aer as oposto on (
caixa.num_proc_hia = oposto.num_proc_hia and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_hia= 'C')
where 
convert(datetime, caixa.dt_pgto_rcto_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_hia = 'D' 
UNION
select 
caixa.num_proc_hia as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_hia as DC,
cast(caixa.vlr_ref_hia as money) as ValorReferencia,
cast(caixa.par_moeda_hia as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_hia, 105) as Data,
cast(caixa.vlr_pgto_rcto_hia as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_hia as money) as OpostoRef,
cast(oposto.par_moeda_hia as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_hia, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_hia as money)as OpostoValor
from caixa_hou_imp_aer as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_hou_imp_aer as oposto on (
caixa.num_proc_hia = oposto.num_proc_hia and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_hia= 'D')
where 
convert(datetime, caixa.dt_pgto_rcto_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_hia = 'C' 
UNION
select 
caixa.num_proc_mia as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_mia as DC,
cast(caixa.vlr_ref_mia as money) as ValorReferencia,
cast(caixa.par_moeda_mia as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_mia, 105) as Data,
cast(caixa.vlr_pgto_rcto_mia as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_mia as money) as OpostoRef,
cast(oposto.par_moeda_mia as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_mia, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_mia as money)as OpostoValor
from caixa_mas_imp_aer as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_mas_imp_aer as oposto on (
caixa.num_proc_mia = oposto.num_proc_mia and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_mia= 'C')
where 
convert(datetime, caixa.dt_pgto_rcto_mia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_mia = 'D'
UNION
select 
caixa.num_proc_mia as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_mia as DC,
cast(caixa.vlr_ref_mia as money) as ValorReferencia,
cast(caixa.par_moeda_mia as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_mia, 105) as Data,
cast(caixa.vlr_pgto_rcto_mia as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_mia as money) as OpostoRef,
cast(oposto.par_moeda_mia as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_mia, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_mia as money)as OpostoValor
from caixa_mas_imp_aer as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_mas_imp_aer as oposto on (
caixa.num_proc_mia = oposto.num_proc_mia and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_mia= 'D')
where 
convert(datetime, caixa.dt_pgto_rcto_mia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_mia = 'C' 
union
select 
caixa.num_proc_HEA as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_HEA as DC,
cast(caixa.vlr_ref_HEA as money) as ValorReferencia,
cast(caixa.par_moeda_HEA as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_HEA, 105) as Data,
cast(caixa.vlr_pgto_rcto_HEA as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_HEA as money) as OpostoRef,
cast(oposto.par_moeda_HEA as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_HEA, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_HEA as money)as OpostoValor
from caixa_hou_EXP_aer as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_hou_EXP_aer as oposto on (
caixa.num_proc_HEA = oposto.num_proc_HEA and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_HEA= 'C')
where 
convert(datetime, caixa.dt_pgto_rcto_HEA, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_HEA = 'D' 
UNION
select 
caixa.num_proc_HEA as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_HEA as DC,
cast(caixa.vlr_ref_HEA as money) as ValorReferencia,
cast(caixa.par_moeda_HEA as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_HEA, 105) as Data,
cast(caixa.vlr_pgto_rcto_HEA as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_HEA as money) as OpostoRef,
cast(oposto.par_moeda_HEA as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_HEA, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_HEA as money)as OpostoValor
from caixa_hou_EXP_aer as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_hou_EXP_aer as oposto on (
caixa.num_proc_HEA = oposto.num_proc_HEA and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_HEA= 'D')
where 
convert(datetime, caixa.dt_pgto_rcto_HEA, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_HEA = 'C'
UNION
select 
caixa.num_proc_MEA as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_MEA as DC,
cast(caixa.vlr_ref_MEA as money) as ValorReferencia,
cast(caixa.par_moeda_MEA as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_MEA, 105) as Data,
cast(caixa.vlr_pgto_rcto_MEA as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_MEA as money) as OpostoRef,
cast(oposto.par_moeda_MEA as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_MEA, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_MEA as money)as OpostoValor
from caixa_mas_EXP_aer as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_mas_EXP_aer as oposto on (
caixa.num_proc_MEA = oposto.num_proc_MEA and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_MEA= 'C')
where 
convert(datetime, caixa.dt_pgto_rcto_MEA, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_MEA = 'D' 
UNION
select 
caixa.num_proc_MEA as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_MEA as DC,
cast(caixa.vlr_ref_MEA as money) as ValorReferencia,
cast(caixa.par_moeda_MEA as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_MEA, 105) as Data,
cast(caixa.vlr_pgto_rcto_MEA as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_MEA as money) as OpostoRef,
cast(oposto.par_moeda_MEA as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_MEA, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_MEA as money)as OpostoValor
from caixa_mas_EXP_aer as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_mas_EXP_aer as oposto on (
caixa.num_proc_MEA = oposto.num_proc_MEA and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_MEA= 'D')
where 
convert(datetime, caixa.dt_pgto_rcto_MEA, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_MEA = 'C' 
UNION
select 
caixa.num_proc_him as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_him as DC,
cast(caixa.vlr_ref_him as money) as ValorReferencia,
cast(caixa.par_moeda_him as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_him, 105) as Data,
cast(caixa.vlr_pgto_rcto_him as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_him as money) as OpostoRef,
cast(oposto.par_moeda_him as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_him, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_him as money)as OpostoValor
from caixa_hou_imp_mar as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_hou_imp_mar as oposto on (
caixa.num_proc_him = oposto.num_proc_him and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_him= 'C')
where 
convert(datetime, caixa.dt_pgto_rcto_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_him = 'D' 
UNION
select 
caixa.num_proc_him as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_him as DC,
cast(caixa.vlr_ref_him as money) as ValorReferencia,
cast(caixa.par_moeda_him as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_him, 105) as Data,
cast(caixa.vlr_pgto_rcto_him as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_him as money) as OpostoRef,
cast(oposto.par_moeda_him as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_him, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_him as money)as OpostoValor
from caixa_hou_imp_mar as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_hou_imp_mar as oposto on (
caixa.num_proc_him = oposto.num_proc_him and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_him= 'D')
where 
convert(datetime, caixa.dt_pgto_rcto_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_him = 'C'
UNION
select 
caixa.num_proc_mim as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_mim as DC,
cast(caixa.vlr_ref_mim as money) as ValorReferencia,
cast(caixa.par_moeda_mim as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_mim, 105) as Data,
cast(caixa.vlr_pgto_rcto_mim as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_mim as money) as OpostoRef,
cast(oposto.par_moeda_mim as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_mim, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_mim as money)as OpostoValor
from caixa_mas_imp_mar as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_mas_imp_mar as oposto on (
caixa.num_proc_mim = oposto.num_proc_mim and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_mim= 'C')
where 
convert(datetime, caixa.dt_pgto_rcto_mim, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_mim = 'D'
UNION
select 
caixa.num_proc_mim as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_mim as DC,
cast(caixa.vlr_ref_mim as money) as ValorReferencia,
cast(caixa.par_moeda_mim as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_mim, 105) as Data,
cast(caixa.vlr_pgto_rcto_mim as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_mim as money) as OpostoRef,
cast(oposto.par_moeda_mim as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_mim, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_mim as money)as OpostoValor
from caixa_mas_imp_mar as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_mas_imp_mar as oposto on (
caixa.num_proc_mim = oposto.num_proc_mim and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_mim= 'D')
where 
convert(datetime, caixa.dt_pgto_rcto_mim, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_mim = 'C'
union
select 
caixa.num_proc_hem as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_hem as DC,
cast(caixa.vlr_ref_hem as money) as ValorReferencia,
cast(caixa.par_moeda_hem as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_hem, 105) as Data,
cast(caixa.vlr_pgto_rcto_hem as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_hem as money) as OpostoRef,
cast(oposto.par_moeda_hem as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_hem, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_hem as money)as OpostoValor
from caixa_hou_EXP_mar as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_hou_EXP_mar as oposto on (
caixa.num_proc_hem = oposto.num_proc_hem and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_hem= 'C')
where 
convert(datetime, caixa.dt_pgto_rcto_hem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_hem = 'D' 
UNION
select 
caixa.num_proc_hem as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_hem as DC,
cast(caixa.vlr_ref_hem as money) as ValorReferencia,
cast(caixa.par_moeda_hem as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_hem, 105) as Data,
cast(caixa.vlr_pgto_rcto_hem as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_hem as money) as OpostoRef,
cast(oposto.par_moeda_hem as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_hem, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_hem as money)as OpostoValor
from caixa_hou_EXP_mar as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_hou_EXP_mar as oposto on (
caixa.num_proc_hem = oposto.num_proc_hem and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_hem= 'D')
where 
convert(datetime, caixa.dt_pgto_rcto_hem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_hem = 'C'
UNION
select 
caixa.num_proc_mem as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_mem as DC,
cast(caixa.vlr_ref_mem as money) as ValorReferencia,
cast(caixa.par_moeda_mem as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_mem, 105) as Data,
cast(caixa.vlr_pgto_rcto_mem as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_mem as money) as OpostoRef,
cast(oposto.par_moeda_mem as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_mem, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_mem as money)as OpostoValor
from caixa_mas_EXP_mar as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_mas_EXP_mar as oposto on (
caixa.num_proc_mem = oposto.num_proc_mem and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_mem= 'C')
where 
convert(datetime, caixa.dt_pgto_rcto_mem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_mem = 'D' 
UNION
select 
caixa.num_proc_mem as Processo, 
caixa.cd_tp_tx as CodigoTaxa, 
nome_tp_tx as NomedaTaxa,
caixa.dc_mem as DC,
cast(caixa.vlr_ref_mem as money) as ValorReferencia,
cast(caixa.par_moeda_mem as money)as Paridade,
convert(datetime, caixa.dt_pgto_rcto_mem, 105) as Data,
cast(caixa.vlr_pgto_rcto_mem as money) as ValorPgtoRcto,
cast(oposto.vlr_ref_mem as money) as OpostoRef,
cast(oposto.par_moeda_mem as money)OpostoPar,
convert(datetime, oposto.dt_pgto_rcto_mem, 105)OpostoDt,
cast(oposto.vlr_pgto_rcto_mem as money)as OpostoValor
from caixa_mas_EXP_mar as caixa
left join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join caixa_mas_EXP_mar as oposto on (
caixa.num_proc_mem = oposto.num_proc_mem and
caixa.cd_tp_Tx=oposto.cd_tp_tx and
oposto.dc_mem= 'D')
where 
convert(datetime, caixa.dt_pgto_rcto_mem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.dc_mem = 'C' 



GO
