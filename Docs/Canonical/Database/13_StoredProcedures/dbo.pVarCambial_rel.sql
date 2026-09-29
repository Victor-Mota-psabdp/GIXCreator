SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE pVarCambial_rel
			@datainicial as varchar (10), 
			@datafinal as varchar(10)
as
select caixa.num_proc_hia as Processo, nome_tp_tx,  caixa.cd_tp_tx as TPTX ,cta_cte.cd_tp_moeda as Moeda, caixa.dc_hia as DC, caixa.num_lcto as Lanc, cast(caixa.vlr_ref_hia as money) as ValorRef,
cast(caixa.par_moeda_hia as money) as Paridade, cast(caixa.vlr_pgto_rcto_hia as money) as ValorPgtoRcto, caixa.num_rcb_hia as Rcb, convert(datetime, CAIXA.dt_pgto_rcto_hia, 105) as Data,
convert(datetime, hOposto.dt_pgto_rcto_hia, 105) as DtOposto, cta_Oposto.cd_tp_moeda as MoedaHOposto, cast( hOposto.Par_Moeda_hia as money)as ParhOposto, cast(hOposto.vlr_pgto_rcto_hia as money) as ValorOposto,
convert(datetime, mOposto.dt_pgto_rcto_mia, 105) as DtMasOp, cta_master.cd_tp_moeda, cast(mOposto.par_moeda_mia as money) as ParMoposto, cast(MOposto.vlr_pgto_rcto_mia as money) as ValorMoposto
from caixa_hou_imp_aer as caixa
left join caixa_hou_imp_aer as  hOposto on
caixa.num_proc_hia = hOposto.num_proc_hia and 
caixa.cd_tp_tx = hOposto.cd_tp_Tx  and
HOposto.dc_hia = 'C'
and caixa.dc_hia = 'D'
left join caixa_mas_imp_aer as mOposto on
left(caixa.num_proc_hia,14) = MOposto.num_proc_mia and 
caixa.cd_tp_tx = MOposto.cd_tp_Tx and
MOposto.dc_mia = 'C' and
caixa.dc_hia = 'D'
join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join cta_cte_hou_imp_aer as cta_cte on 
caixa.num_proc_hia = cta_cte.num_proc_hia and
caixa.cd_tp_Tx = cta_cte.cd_tp_tx and
caixa.dc_hia = cta_cte.dc_hia
left join cta_cte_hou_imp_aer as cta_Oposto on
HOposto.num_proc_hia = cta_Oposto.num_proc_hia and
HOposto.cd_tp_Tx = cta_Oposto.cd_tp_tx and
HOPosto.dc_hia = Cta_oposto.dc_hia
left join cta_cte_mas_imp_aer as cta_Master on
Moposto.num_proc_mia = cta_master.num_proc_mia and
mOposto.cd_tp_tx = cta_master.cd_tp_tx and
mOposto.dc_mia = cta_master.dc_mia
where 
convert(datetime, CAIXA.dt_pgto_rcto_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and 
caixa.num_lcto = 'REMESSA'
UNION
select caixa.num_proc_hia as Processo, nome_tp_tx,  caixa.cd_tp_tx as TPTX ,cta_cte.cd_tp_moeda as Moeda, caixa.dc_hia as DC, caixa.num_lcto as Lanc, cast(caixa.vlr_ref_hia as money) as ValorRef,
cast(caixa.par_moeda_hia as money) as Paridade, cast(caixa.vlr_pgto_rcto_hia as money) as ValorPgtoRcto, caixa.num_rcb_hia as Rcb, convert(datetime, CAIXA.dt_pgto_rcto_hia, 105) as Data,
convert(datetime, hOposto.dt_pgto_rcto_hia, 105) as DtOposto, cta_Oposto.cd_tp_moeda as MoedaHOposto, cast( hOposto.Par_Moeda_hia as money)as ParhOposto, cast(hOposto.vlr_pgto_rcto_hia as money) as ValorOposto,
convert(datetime, mOposto.dt_pgto_rcto_mia, 105) as DtMasOp, cta_master.cd_tp_moeda, cast(mOposto.par_moeda_mia as money) as ParMoposto, cast(MOposto.vlr_pgto_rcto_mia as money) as ValorMoposto
from caixa_hou_imp_aer as caixa
left join caixa_hou_imp_aer as  hOposto on
caixa.num_proc_hia = hOposto.num_proc_hia and 
caixa.cd_tp_tx = hOposto.cd_tp_Tx  and
HOposto.dc_hia = 'D' and
caixa.dc_hia = 'C'
left join caixa_mas_imp_aer as mOposto on
left(caixa.num_proc_hia,14) = MOposto.num_proc_mia and 
caixa.cd_tp_tx = MOposto.cd_tp_Tx and
MOposto.dc_mia = 'D' and
caixa.dc_hia = 'C'
join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
join cta_cte_hou_imp_aer as cta_cte on 
caixa.num_proc_hia = cta_cte.num_proc_hia and
caixa.cd_tp_Tx = cta_cte.cd_tp_tx and
caixa.dc_hia = cta_cte.dc_hia
join cta_cte_hou_imp_aer as cta_Oposto on
HOposto.num_proc_hia = cta_Oposto.num_proc_hia and
HOposto.cd_tp_Tx = cta_Oposto.cd_tp_tx and
HOPosto.dc_hia = Cta_oposto.dc_hia
left join cta_cte_mas_imp_aer as cta_Master on
Moposto.num_proc_mia = cta_master.num_proc_mia and
mOposto.cd_tp_tx = cta_master.cd_tp_tx and
mOposto.dc_mia = cta_master.dc_mia
where
convert(datetime, CAIXA.dt_pgto_rcto_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.num_lcto = 'REMESSA'
UNION
select caixa.num_proc_hea as Processo, nome_tp_tx,  caixa.cd_tp_tx as TPTX ,cta_cte.cd_tp_moeda as Moeda, caixa.dc_hea as DC, caixa.num_lcto as Lanc, cast(caixa.vlr_ref_hea as money) as ValorRef,
cast(caixa.par_moeda_hea as money) as Paridade, cast(caixa.vlr_pgto_rcto_hea as money) as ValorPgtoRcto, caixa.num_rcb_hea as Rcb, convert(datetime, CAIXA.dt_pgto_rcto_hea, 105) as Data,
convert(datetime, hOposto.dt_pgto_rcto_hea, 105) as DtOposto, cta_Oposto.cd_tp_moeda as MoedaHOposto, cast( hOposto.Par_Moeda_hea as money)as ParhOposto, cast(hOposto.vlr_pgto_rcto_hea as money) as ValorOposto,
convert(datetime, mOposto.dt_pgto_rcto_mea, 105) as DtMasOp, cta_master.cd_tp_moeda, cast(mOposto.par_moeda_mea as money) as ParMoposto, cast(MOposto.vlr_pgto_rcto_mea as money) as ValorMoposto
from caixa_hou_exp_aer as caixa
left join caixa_hou_exp_aer as  hOposto on
caixa.num_proc_hea = hOposto.num_proc_hea and 
caixa.cd_tp_tx = hOposto.cd_tp_Tx  and
HOposto.dc_hea = 'C'
and caixa.dc_hea = 'D'
left join caixa_mas_exp_aer as mOposto on
left(caixa.num_proc_hea,14) = MOposto.num_proc_mea and 
caixa.cd_tp_tx = MOposto.cd_tp_Tx and
MOposto.dc_mea = 'C' and
caixa.dc_hea = 'D'
join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join cta_cte_hou_exp_aer as cta_cte on 
caixa.num_proc_hea = cta_cte.num_proc_hea and
caixa.cd_tp_Tx = cta_cte.cd_tp_tx and
caixa.dc_hea = cta_cte.dc_hea
left join cta_cte_hou_exp_aer as cta_Oposto on
HOposto.num_proc_hea = cta_Oposto.num_proc_hea and
HOposto.cd_tp_Tx = cta_Oposto.cd_tp_tx and
HOPosto.dc_hea = Cta_oposto.dc_hea
left join cta_cte_mas_exp_aer as cta_Master on
Moposto.num_proc_mea = cta_master.num_proc_mea and
mOposto.cd_tp_tx = cta_master.cd_tp_tx and
mOposto.dc_mea = cta_master.dc_mea
where 
convert(datetime, CAIXA.dt_pgto_rcto_hea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and 
caixa.num_lcto = 'REMESSA'
UNION
select caixa.num_proc_hea as Processo, nome_tp_tx,  caixa.cd_tp_tx as TPTX ,cta_cte.cd_tp_moeda as Moeda, caixa.dc_hea as DC, caixa.num_lcto as Lanc, cast(caixa.vlr_ref_hea as money) as ValorRef,
cast(caixa.par_moeda_hea as money) as Paridade, cast(caixa.vlr_pgto_rcto_hea as money) as ValorPgtoRcto, caixa.num_rcb_hea as Rcb, convert(datetime, CAIXA.dt_pgto_rcto_hea, 105) as Data,
convert(datetime, hOposto.dt_pgto_rcto_hea, 105) as DtOposto, cta_Oposto.cd_tp_moeda as MoedaHOposto, cast( hOposto.Par_Moeda_hea as money)as ParhOposto, cast(hOposto.vlr_pgto_rcto_hea as money) as ValorOposto,
convert(datetime, mOposto.dt_pgto_rcto_mea, 105) as DtMasOp, cta_master.cd_tp_moeda, cast(mOposto.par_moeda_mea as money) as ParMoposto, cast(MOposto.vlr_pgto_rcto_mea as money) as ValorMoposto
from caixa_hou_exp_aer as caixa
left join caixa_hou_exp_aer as  hOposto on
caixa.num_proc_hea = hOposto.num_proc_hea and 
caixa.cd_tp_tx = hOposto.cd_tp_Tx  and
HOposto.dc_hea = 'D' and
caixa.dc_hea = 'C'
left join caixa_mas_exp_aer as mOposto on
left(caixa.num_proc_hea,14) = MOposto.num_proc_mea and 
caixa.cd_tp_tx = MOposto.cd_tp_Tx and
MOposto.dc_mea = 'D' and
caixa.dc_hea = 'C'
join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
join cta_cte_hou_exp_aer as cta_cte on 
caixa.num_proc_hea = cta_cte.num_proc_hea and
caixa.cd_tp_Tx = cta_cte.cd_tp_tx and
caixa.dc_hea = cta_cte.dc_hea
join cta_cte_hou_exp_aer as cta_Oposto on
HOposto.num_proc_hea = cta_Oposto.num_proc_hea and
HOposto.cd_tp_Tx = cta_Oposto.cd_tp_tx and
HOPosto.dc_hea = Cta_oposto.dc_hea
left join cta_cte_mas_exp_aer as cta_Master on
Moposto.num_proc_mea = cta_master.num_proc_mea and
mOposto.cd_tp_tx = cta_master.cd_tp_tx and
mOposto.dc_mea = cta_master.dc_mea
where
convert(datetime, CAIXA.dt_pgto_rcto_hea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.num_lcto = 'REMESSA'
UNION
select caixa.num_proc_him as Processo, nome_tp_tx,  caixa.cd_tp_tx as TPTX ,cta_cte.cd_tp_moeda as Moeda, caixa.dc_him as DC, caixa.num_lcto as Lanc, cast(caixa.vlr_ref_him as money) as ValorRef,
cast(caixa.par_moeda_him as money) as Paridade, cast(caixa.vlr_pgto_rcto_him as money) as ValorPgtoRcto, caixa.num_rcb_him as Rcb, convert(datetime, CAIXA.dt_pgto_rcto_him, 105) as Data,
convert(datetime, hOposto.dt_pgto_rcto_him, 105) as DtOposto, cta_Oposto.cd_tp_moeda as MoedaHOposto, cast( hOposto.Par_Moeda_him as money)as ParhOposto, cast(hOposto.vlr_pgto_rcto_him as money) as ValorOposto,
convert(datetime, mOposto.dt_pgto_rcto_mim, 105) as DtMasOp, cta_master.cd_tp_moeda, cast(mOposto.par_moeda_mim as money) as ParMoposto, cast(MOposto.vlr_pgto_rcto_mim as money) as ValorMoposto
from caixa_hou_imp_mar as caixa
left join caixa_hou_imp_mar as  hOposto on
caixa.num_proc_him = hOposto.num_proc_him and 
caixa.cd_tp_tx = hOposto.cd_tp_Tx  and
HOposto.dc_him = 'C'
and caixa.dc_him = 'D'
left join caixa_mas_imp_mar as mOposto on
left(caixa.num_proc_him,14) = MOposto.num_proc_mim and 
caixa.cd_tp_tx = MOposto.cd_tp_Tx and
MOposto.dc_mim = 'C' and
caixa.dc_him = 'D'
join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join cta_cte_hou_imp_mar as cta_cte on 
caixa.num_proc_him = cta_cte.num_proc_him and
caixa.cd_tp_Tx = cta_cte.cd_tp_tx and
caixa.dc_him = cta_cte.dc_him
left join cta_cte_hou_imp_mar as cta_Oposto on
HOposto.num_proc_him = cta_Oposto.num_proc_him and
HOposto.cd_tp_Tx = cta_Oposto.cd_tp_tx and
HOPosto.dc_him = Cta_oposto.dc_him
left join cta_cte_mas_imp_mar as cta_Master on
Moposto.num_proc_mim = cta_master.num_proc_mim and
mOposto.cd_tp_tx = cta_master.cd_tp_tx and
mOposto.dc_mim = cta_master.dc_mim
where 
convert(datetime, CAIXA.dt_pgto_rcto_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and 
caixa.num_lcto = 'REMESSA'
UNION
select caixa.num_proc_him as Processo, nome_tp_tx,  caixa.cd_tp_tx as TPTX ,cta_cte.cd_tp_moeda as Moeda, caixa.dc_him as DC, caixa.num_lcto as Lanc, cast(caixa.vlr_ref_him as money) as ValorRef,
cast(caixa.par_moeda_him as money) as Paridade, cast(caixa.vlr_pgto_rcto_him as money) as ValorPgtoRcto, caixa.num_rcb_him as Rcb, convert(datetime, CAIXA.dt_pgto_rcto_him, 105) as Data,
convert(datetime, hOposto.dt_pgto_rcto_him, 105) as DtOposto, cta_Oposto.cd_tp_moeda as MoedaHOposto, cast( hOposto.Par_Moeda_him as money)as ParhOposto, cast(hOposto.vlr_pgto_rcto_him as money) as ValorOposto,
convert(datetime, mOposto.dt_pgto_rcto_mim, 105) as DtMasOp, cta_master.cd_tp_moeda, cast(mOposto.par_moeda_mim as money) as ParMoposto, cast(MOposto.vlr_pgto_rcto_mim as money) as ValorMoposto
from caixa_hou_imp_mar as caixa
left join caixa_hou_imp_mar as  hOposto on
caixa.num_proc_him = hOposto.num_proc_him and 
caixa.cd_tp_tx = hOposto.cd_tp_Tx  and
HOposto.dc_him = 'D' and
caixa.dc_him = 'C'
left join caixa_mas_imp_mar as mOposto on
left(caixa.num_proc_him,14) = MOposto.num_proc_mim and 
caixa.cd_tp_tx = MOposto.cd_tp_Tx and
MOposto.dc_mim = 'D' and
caixa.dc_him = 'C'
join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
join cta_cte_hou_imp_mar as cta_cte on 
caixa.num_proc_him = cta_cte.num_proc_him and
caixa.cd_tp_Tx = cta_cte.cd_tp_tx and
caixa.dc_him = cta_cte.dc_him
join cta_cte_hou_imp_mar as cta_Oposto on
HOposto.num_proc_him = cta_Oposto.num_proc_him and
HOposto.cd_tp_Tx = cta_Oposto.cd_tp_tx and
HOPosto.dc_him = Cta_oposto.dc_him
left join cta_cte_mas_imp_mar as cta_Master on
Moposto.num_proc_mim = cta_master.num_proc_mim and
mOposto.cd_tp_tx = cta_master.cd_tp_tx and
mOposto.dc_mim = cta_master.dc_mim
where
convert(datetime, CAIXA.dt_pgto_rcto_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.num_lcto = 'REMESSA'
UNION
select caixa.num_proc_hem as Processo, nome_tp_tx,  caixa.cd_tp_tx as TPTX ,cta_cte.cd_tp_moeda as Moeda, caixa.dc_hem as DC, caixa.num_lcto as Lanc, cast(caixa.vlr_ref_hem as money) as ValorRef,
cast(caixa.par_moeda_hem as money) as Paridade, cast(caixa.vlr_pgto_rcto_hem as money) as ValorPgtoRcto, caixa.num_rcb_hem as Rcb, convert(datetime, CAIXA.dt_pgto_rcto_hem, 105) as Data,
convert(datetime, hOposto.dt_pgto_rcto_hem, 105) as DtOposto, cta_Oposto.cd_tp_moeda as MoedaHOposto, cast( hOposto.Par_Moeda_hem as money)as ParhOposto, cast(hOposto.vlr_pgto_rcto_hem as money) as ValorOposto,
convert(datetime, mOposto.dt_pgto_rcto_mem, 105) as DtMasOp, cta_master.cd_tp_moeda, cast(mOposto.par_moeda_mem as money) as ParMoposto, cast(MOposto.vlr_pgto_rcto_mem as money) as ValorMoposto
from caixa_hou_exp_mar as caixa
left join caixa_hou_exp_mar as  hOposto on
caixa.num_proc_hem = hOposto.num_proc_hem and 
caixa.cd_tp_tx = hOposto.cd_tp_Tx  and
HOposto.dc_hem = 'C'
and caixa.dc_hem = 'D'
left join caixa_mas_exp_mar as mOposto on
left(caixa.num_proc_hem,14) = MOposto.num_proc_mem and 
caixa.cd_tp_tx = MOposto.cd_tp_Tx and
MOposto.dc_mem = 'C' and
caixa.dc_hem = 'D'
join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
left join cta_cte_hou_exp_mar as cta_cte on 
caixa.num_proc_hem = cta_cte.num_proc_hem and
caixa.cd_tp_Tx = cta_cte.cd_tp_tx and
caixa.dc_hem = cta_cte.dc_hem
left join cta_cte_hou_exp_mar as cta_Oposto on
HOposto.num_proc_hem = cta_Oposto.num_proc_hem and
HOposto.cd_tp_Tx = cta_Oposto.cd_tp_tx and
HOPosto.dc_hem = Cta_oposto.dc_hem
left join cta_cte_mas_exp_mar as cta_Master on
Moposto.num_proc_mem = cta_master.num_proc_mem and
mOposto.cd_tp_tx = cta_master.cd_tp_tx and
mOposto.dc_mem = cta_master.dc_mem
where 
convert(datetime, CAIXA.dt_pgto_rcto_hem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and 
caixa.num_lcto = 'REMESSA'
UNION
select caixa.num_proc_hem as Processo, nome_tp_tx,  caixa.cd_tp_tx as TPTX ,cta_cte.cd_tp_moeda as Moeda, caixa.dc_hem as DC, caixa.num_lcto as Lanc, cast(caixa.vlr_ref_hem as money) as ValorRef,
cast(caixa.par_moeda_hem as money) as Paridade, cast(caixa.vlr_pgto_rcto_hem as money) as ValorPgtoRcto, caixa.num_rcb_hem as Rcb, convert(datetime, CAIXA.dt_pgto_rcto_hem, 105) as Data,
convert(datetime, hOposto.dt_pgto_rcto_hem, 105) as DtOposto, cta_Oposto.cd_tp_moeda as MoedaHOposto, cast( hOposto.Par_Moeda_hem as money)as ParhOposto, cast(hOposto.vlr_pgto_rcto_hem as money) as ValorOposto,
convert(datetime, mOposto.dt_pgto_rcto_mem, 105) as DtMasOp, cta_master.cd_tp_moeda, cast(mOposto.par_moeda_mem as money) as ParMoposto, cast(MOposto.vlr_pgto_rcto_mem as money) as ValorMoposto
from caixa_hou_exp_mar as caixa
left join caixa_hou_exp_mar as  hOposto on
caixa.num_proc_hem = hOposto.num_proc_hem and 
caixa.cd_tp_tx = hOposto.cd_tp_Tx  and
HOposto.dc_hem = 'D' and
caixa.dc_hem = 'C'
left join caixa_mas_exp_mar as mOposto on
left(caixa.num_proc_hem,14) = MOposto.num_proc_mem and 
caixa.cd_tp_tx = MOposto.cd_tp_Tx and
MOposto.dc_mem = 'D' and
caixa.dc_hem = 'C'
join tipo_taxa on
caixa.cd_tp_tx = tipo_taxa.cd_tp_Tx
join cta_cte_hou_exp_mar as cta_cte on 
caixa.num_proc_hem = cta_cte.num_proc_hem and
caixa.cd_tp_Tx = cta_cte.cd_tp_tx and
caixa.dc_hem = cta_cte.dc_hem
join cta_cte_hou_exp_mar as cta_Oposto on
HOposto.num_proc_hem = cta_Oposto.num_proc_hem and
HOposto.cd_tp_Tx = cta_Oposto.cd_tp_tx and
HOPosto.dc_hem = Cta_oposto.dc_hem
left join cta_cte_mas_exp_mar as cta_Master on
Moposto.num_proc_mem = cta_master.num_proc_mem and
mOposto.cd_tp_tx = cta_master.cd_tp_tx and
mOposto.dc_mem = cta_master.dc_mem
where
convert(datetime, CAIXA.dt_pgto_rcto_hem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
and caixa.num_lcto = 'REMESSA'



GO
