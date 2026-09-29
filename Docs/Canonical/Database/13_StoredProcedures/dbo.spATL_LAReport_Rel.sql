SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido o nome da taxa, alex financeiro - 6/3/13 -cadu


CREATE procedure [dbo].[spATL_LAReport_Rel]--'01/01/2013', '04/01/2013', 'DOW BRASIL S 05031WQ','%'
				@datainicial	varchar(10),
				@datafinal	varchar(10),
				@Pessoa	varchar (30),
				@Nome_Tp_Tx varchar(50)
as

select Nome_Tp_Tx Taxa,sum(Vlr_Pgto_Rcto_Hia) Valor_Real, cxa.dc_hia DC  from vwcxas CXA with(nolock)
Join Pgto_Rcto PG with(nolock) on PG.num_lcto=CXA.num_lcto
Join vwcta_Cte CTA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP with(nolock) on pp.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cxa.cd_tp_Tx
Left Join Taxa_Grupo TXG with(nolock) on TXG.cd_tx_grp=ref_Ctb_Tx and cxa.dc_hia=TXG.dc
Where
	convert(Datetime,dt_pgto_rcto,105)  between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal,105)
--	and (apelido like @Pessoa or @Pessoa='%')
	and apelido like @Pessoa
	and Nome_Tp_Tx like @Nome_Tp_Tx
	and Vlr_Ref_Hia <> 0


group by Nome_Tp_Tx,cxa.dc_hia

order by cxa.dc_hia,Nome_Tp_Tx
GO
