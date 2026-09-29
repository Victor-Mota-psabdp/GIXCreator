SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pAekContPendCtaCte_Sel(
@Mes		varchar(2),
@Ano		varchar(4)
)
 AS
Declare @DtRef	varchar(12) 
Set @DtRef = @ano + '-' + @Mes + '-01' 

select cte.num_proc_him , cte.cd_tp_Tx, cte.dc_him from cta_cte_hou_imp_mar cte join caixa_hou_imp_mar cxa
on cxa.num_proc_him = cte.num_proc_him and cxa.dc_him = cte.dc_him and cxa.cd_Tp_tx = cte.cd_Tp_tx 
where month(convert(datetime, dt_pgto_rcto_him , 105)) = @Mes   and  left(cte.cd_tp_tx, 1) <> 'X' and 
year(convert(datetime, dt_pgto_rcto_him , 105)) = @Ano   and 
convert(datetime, dt_ins_him , 105) < @DtRef  and 
(val_con_comp is null or val_con_comp = 0 )
union
select cte.num_proc_hem , cte.cd_tp_Tx, cte.dc_hem from cta_cte_hou_exp_mar cte join caixa_hou_exp_mar cxa
on cxa.num_proc_hem = cte.num_proc_hem and cxa.dc_hem = cte.dc_hem and cxa.cd_Tp_tx = cte.cd_Tp_tx 
where month(convert(datetime, dt_pgto_rcto_hem , 105)) = @Mes   and left(cte.cd_tp_tx, 1) <> 'X' and 
year(convert(datetime, dt_pgto_rcto_hem , 105)) = @Ano   and 
convert(datetime, dt_ins_hem , 105) < @DtRef  and 
(val_con_comp is null or val_con_comp = 0 )
union
select cte.num_proc_hia , cte.cd_tp_Tx, cte.dc_hia from cta_cte_hou_imp_aer cte join caixa_hou_imp_aer cxa
on cxa.num_proc_hia = cte.num_proc_hia and cxa.dc_hia = cte.dc_hia and cxa.cd_Tp_tx = cte.cd_Tp_tx 
where month(convert(datetime, dt_pgto_rcto_hia , 105)) = @Mes   and left(cte.cd_tp_tx, 1) <> 'X' and 
year(convert(datetime, dt_pgto_rcto_hia , 105)) = @Ano   and 
convert(datetime, dt_ins_hia , 105) < @DtRef  and 
(val_con_comp is null or val_con_comp = 0 )
union
select cte.num_proc_hea , cte.cd_tp_Tx, cte.dc_hea from cta_cte_hou_exp_aer cte join caixa_hou_exp_aer cxa
on cxa.num_proc_hea = cte.num_proc_hea and cxa.dc_hea = cte.dc_hea and cxa.cd_Tp_tx = cte.cd_Tp_tx 
where month(convert(datetime, dt_pgto_rcto_hea , 105)) = @Mes   and left(cte.cd_tp_tx, 1) <> 'X' and 
year(convert(datetime, dt_pgto_rcto_hea , 105)) = @Ano   and 
convert(datetime, dt_ins_hea , 105) < @DtRef  and 
(val_con_comp is null or val_con_comp = 0 )
union
select cte.num_proc_mim , cte.cd_tp_Tx, cte.dc_mim from cta_cte_mas_imp_mar cte join caixa_mas_imp_mar cxa
on cxa.num_proc_mim = cte.num_proc_mim and cxa.dc_mim = cte.dc_mim and cxa.cd_Tp_tx = cte.cd_Tp_tx 
where month(convert(datetime, dt_pgto_rcto_mim , 105)) = @Mes   and left(cte.cd_tp_tx, 1) <> 'X' and 
year(convert(datetime, dt_pgto_rcto_mim , 105)) = @Ano   and 
convert(datetime, dt_ins_mim , 105) < @DtRef  and 
(val_con_comp is null or val_con_comp = 0 )
union
select cte.num_proc_mem , cte.cd_tp_Tx, cte.dc_mem from cta_cte_mas_exp_mar cte join caixa_mas_exp_mar cxa
on cxa.num_proc_mem = cte.num_proc_mem and cxa.dc_mem = cte.dc_mem and cxa.cd_Tp_tx = cte.cd_Tp_tx 
where month(convert(datetime, dt_pgto_rcto_mem , 105)) = @Mes   and left(cte.cd_tp_tx, 1) <> 'X' and 
year(convert(datetime, dt_pgto_rcto_mem , 105)) = @Ano   and 
convert(datetime, dt_ins_mem , 105) < @DtRef  and 
(val_con_comp is null or val_con_comp = 0 )
union
select cte.num_proc_mia , cte.cd_tp_Tx, cte.dc_mia from cta_cte_mas_imp_aer cte join caixa_mas_imp_aer cxa
on cxa.num_proc_mia = cte.num_proc_mia and cxa.dc_mia = cte.dc_mia and cxa.cd_Tp_tx = cte.cd_Tp_tx 
where month(convert(datetime, dt_pgto_rcto_mia , 105)) = @Mes   and left(cte.cd_tp_tx, 1) <> 'X' and 
year(convert(datetime, dt_pgto_rcto_mia , 105)) = @Ano   and 
convert(datetime, dt_ins_mia , 105) < @DtRef  and 
(val_con_comp is null or val_con_comp = 0 )
union
select cte.num_proc_mea , cte.cd_tp_Tx, cte.dc_mea from cta_cte_mas_exp_aer cte join caixa_mas_exp_aer cxa
on cxa.num_proc_mea = cte.num_proc_mea and cxa.dc_mea = cte.dc_mea and cxa.cd_Tp_tx = cte.cd_Tp_tx 
where month(convert(datetime, dt_pgto_rcto_mea , 105)) = @Mes   and left(cte.cd_tp_tx, 1) <> 'X' and 
year(convert(datetime, dt_pgto_rcto_mea , 105)) = @Ano   and 
convert(datetime, dt_ins_mea , 105) < @DtRef  and 
(val_con_comp is null or val_con_comp = 0 )
GO
