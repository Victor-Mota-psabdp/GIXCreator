SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--11-04-2018 - 09H - CADU INCLUIDO O BO
--inclui pra não trazer o q esteja com o (and num_lcto is null) como null dia 19/3/2012
--[spTaxasAberto_Rel] '01/01/2000', '19/03/2012', 'OFICINA DE NEGÓCIOS', '%', '%', '%'
CREATE   procedure [dbo].[spTaxasAberto_Rel] --'01/06/2011', '01/07/2011', '%', '%', '%', 'C'

		@datainicial	varchar(10),
		@datafinal	varchar(10),
		@pessoa		varchar (30),
		@TpTaxas	varchar(30),
		@TpPes		varchar(3),
		@DC		varchar(2)
	
AS

if @tpPes <> 'NAO'
	BEGIN
		--House Importação Aérea
		select 
			ATL.num_proc_hia Job_ATL, cta.num_proc_hia as Processo, nome_tp_tx as Taxa, cta.dc_hia, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hia, 105) as Data, cast(vlr_org_hia as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_Pgto_hia  Dt_Prev

		from 
			cta_cte_hou_imp_aer  as cta with(nolock)
			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_hia)
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
			--left outer join caixa_hou_imp_aer as  cxa with(nolock) on (cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
			Left Outer Join PO_HIA ATL with(nolock) on numero_po_hia=cta.num_proc_hia and id_dc=19
		where 
			left(cta.num_proc_hia,5) <> 'IAJOB' and desp_org_hia <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_hia like @DC
			and num_lcto is null
			
		group by 
			atl.num_proc_hia,cta.num_proc_hia, nome_tp_tx, cta.dc_hia, cd_tp_moeda, dt_ins_hia, vlr_org_hia, apelido, cta.Dt_Prev_Pgto_hia
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_hia

		UNION


--Master Importação Aérea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mia,19) ,cta.num_proc_mia as Processo, nome_tp_tx as Taxa, cta.dc_mia, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mia, 105) as Data, cast(vlr_org_mia as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_mia Dt_Prev

		from 
			cta_cte_mas_imp_aer as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_mia)
			--left outer join caixa_mas_imp_aer as cxa with(nolock) on (cta.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mia,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_mia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))

		where 
			desp_org_mia <> 'S' and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_mia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_mia like @DC
			and num_lcto is null

		group by 
			cta.num_proc_mia, nome_tp_tx, cta.dc_mia, cd_tp_moeda, dt_ins_mia, vlr_org_mia, apelido, cta.Dt_Prev_pgto_mia
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_mia

		union


--House Exportação Aerea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hea,19) ,cta.num_proc_hea as Processo, nome_tp_tx as Taxa, cta.dc_hea, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hea, 105) as Data, cast(vlr_org_hea as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_hea Dt_Prev

		from 
			cta_cte_hou_exp_aer as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_hea)
			--left outer join caixa_hou_exp_aer as cxa with(nolock) on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hea,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_hea=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))

		where 
			left(cta.num_proc_hea,5) <> 'EAJOB' and desp_dst_hea <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_hea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_hea like @DC
			and num_lcto is null

		group by 
			cta.num_proc_hea, nome_tp_tx, cta.dc_hea, cd_tp_moeda, dt_ins_hea, vlr_org_hea, apelido,cta.Dt_Prev_pgto_hea
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_hea

		UNION

--Master Exportação Aérea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mea,19) ,cta.num_proc_mea as Processo, nome_tp_tx as Taxa, cta.dc_mea, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mea, 105) as Data, cast(vlr_org_mea as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_mea Dt_Prev

		from 
			cta_cte_mas_exp_aer as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_mea)
			--left outer join caixa_mas_exp_aer as cxa with(nolock) on (cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mea,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_mea=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_mea,5) <> 'IAJOB' and desp_dst_mea <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_mea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_mea like @DC
			and num_lcto is null

		group by 
			cta.num_proc_mea, nome_tp_tx, cta.dc_mea, cd_tp_moeda, dt_ins_mea, vlr_org_mea, apelido, cta.Dt_Prev_pgto_mea
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_mea

		union

--House Importação Maritima
		select 
			atl.num_proc_him ,cta.num_proc_him as Processo, nome_tp_tx as Taxa, cta.dc_him, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_him, 105) as Data, cast(vlr_org_him as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_him Dt_Prev

		from 
			cta_cte_hou_imp_mar as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_him)
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_him=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
			--left outer join caixa_hou_imp_mar as cxa with(nolock) on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_him,105) <= convert(datetime, @datafinal, 105))
			Left Outer Join PO_HIM ATL with(nolock) on rtrim(numero_po_him)=cta.num_proc_him and id_dc=19

		where 
			left(cta.num_proc_him,5) <> 'IMJOB' and desp_org_him <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_him like @DC
			and num_lcto is null

		group by 
			atl.num_proc_him,cta.num_proc_him, nome_tp_tx, cta.dc_him, cd_tp_moeda, dt_ins_him, vlr_org_him, apelido, cta.Dt_Prev_pgto_him
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_him

		UNION

--Master Importação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mim,19) ,cta.num_proc_mim as Processo, nome_tp_tx as Taxa, cta.dc_mim, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mim, 105) as Data, cast(vlr_org_mim as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_mim Dt_Prev

		from 
			cta_cte_mas_imp_mar as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_mim)
			--left outer join caixa_mas_imp_mar as cxa with(nolock) on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mim,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_mim=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			desp_org_mim <> 'S' and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_mim, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_mim like @DC
			and num_lcto is null

		group by 
			cta.num_proc_mim, nome_tp_tx, cta.dc_mim, cd_tp_moeda, dt_ins_mim, vlr_org_mim, apelido, cta.Dt_Prev_pgto_mim
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_mim

		union

--House Exportação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hem,19) ,cta.num_proc_hem as Processo, nome_tp_tx as Taxa, cta.dc_hem, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hem, 105) as Data, cast(vlr_org_hem as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_hem Dt_Prev

		from 
			cta_cte_hou_exp_mar as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_hem)
			--left outer join caixa_hou_exp_mar as cxa with(nolock) on (cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hem,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_hem=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_hem,5) <> 'EMJOB' and desp_dst_hem <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_hem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_hem like @DC
			and num_lcto is null

		group by 
			cta.num_proc_hem, nome_tp_tx, cta.dc_hem, cd_tp_moeda, dt_ins_hem, vlr_org_hem, apelido, cta.Dt_Prev_pgto_hem
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_hem

		UNION

--Master Exportação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mem,19) ,cta.num_proc_mem as Processo, nome_tp_tx as Taxa, cta.dc_mem, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mem, 105) as Data, cast(vlr_org_mem as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_mem Dt_Prev

		from 
			cta_cte_mas_exp_mar as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_mem)
			--left outer join caixa_mas_exp_mar as cxa with(nolock) on (cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mem,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_mem=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			desp_dst_mem <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_mem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_mem like @DC
			and num_lcto is null
		
		group by 
			cta.num_proc_mem, nome_tp_tx, cta.dc_mem, cd_tp_moeda, dt_ins_mem, vlr_org_mem, apelido, cta.Dt_Prev_pgto_mem
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_mem

		union

--House Importação Out
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hio,19) Job_ATL ,
			cta.num_proc_hio as Processo, nome_tp_tx as Taxa, cta.dc_hio, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hio, 105) as Data, cast(vlr_org_hio as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_hio Dt_Prev
		from 
			cta_cte_hou_imp_out as cta with(nolock)
			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_hio)
			--left outer join caixa_hou_imp_out as cxa with(nolock) on (cta.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hio and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hio,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_hio=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where		
			left(cta.num_proc_hio,5) <> 'IOJOB' and desp_org_hio <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_hio, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_hio like @DC
			and num_lcto is null
		group by 
			cta.num_proc_hio, nome_tp_tx, cta.dc_hio, cd_tp_moeda, dt_ins_hio, vlr_org_hio, apelido, cta.Dt_Prev_pgto_hio
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_hio

		UNION
--House Exportação Out
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_heo,19) Job_ATL ,cta.num_proc_heo as Processo, nome_tp_tx as Taxa, cta.dc_heo, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_heo, 105) as Data, cast(vlr_org_heo as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_heo Dt_Prev

		from 
			cta_cte_hou_exp_out as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_heo)
			--left outer join caixa_hou_exp_out as cxa with(nolock) on (cta.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_heo,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_heo=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_heo,5) <> 'IOJOB' and desp_org_heo <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_heo, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_heo like @DC
			and num_lcto is null

		group by 
			cta.num_proc_heo, nome_tp_tx, cta.dc_heo, cd_tp_moeda, dt_ins_heo, vlr_org_heo, apelido, cta.Dt_Prev_pgto_heo
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_heo	

		UNION
--BDP OTHERS
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hBo,19) Job_ATL ,cta.num_proc_hBo as Processo, 
			nome_tp_tx as Taxa, cta.dc_hBo, cd_tp_moeda as Moeda,
			convert(datetime, Dt_Ins_HBO, 105) as Data, cast(Vlr_Org_HBO as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_Pgto_HBO Dt_Prev

		from 
			Cta_Cte_HOU_BDP_OUT as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_hBo)
			--left outer join caixa_hou_exp_out as cxa with(nolock) on (cta.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_heo,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.Num_Proc_HBO=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hBo=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_hBo,5) <> 'IOJOB' and desp_org_hBo <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_hBo, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_hBo like @DC
			and num_lcto is null

		group by 
			cta.num_proc_hBo, nome_tp_tx, cta.dc_hBo, cd_tp_moeda, Dt_Ins_HBO, Vlr_Org_HBO, apelido, cta.Dt_Prev_Pgto_HBO
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.Vlr_Org_HBO	

	END
ELSE

	BEGIN
		--House Importação Aérea
		select 
			atl.num_proc_hia Job_ATL ,cta.num_proc_hia as Processo, nome_tp_tx as Taxa, cta.dc_hia, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hia, 105) as Data, cast(vlr_org_hia as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_hia Dt_Prev

		from 
			cta_cte_hou_imp_aer as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_hia)
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
			--left outer join caixa_hou_imp_aer as cxa with(nolock) on (cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
			Left Outer Join PO_HIA ATL with(nolock) on numero_po_hia=cta.num_proc_hia

		where 
			left(cta.num_proc_hia,5) <> 'IAJOB' and desp_org_hia <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_hia like @DC
			and num_lcto is null

		group by 
			atl.num_proc_hia,cta.num_proc_hia, nome_tp_tx, cta.dc_hia, cd_tp_moeda, dt_ins_hia, vlr_org_hia, apelido, cta.Dt_Prev_pgto_hia
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_hia

		UNION


--Master Importação Aérea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mia,19) Job_ATL ,cta.num_proc_mia as Processo, nome_tp_tx as Taxa, cta.dc_mia, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mia, 105) as Data, cast(vlr_org_mia as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_mia Dt_Prev

		from 
			cta_cte_mas_imp_aer as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_mia)
			--left outer join caixa_mas_imp_aer as cxa with(nolock) on (cta.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mia,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_mia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			desp_org_mia <> 'S' and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_mia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_mia like @DC
			and num_lcto is null

		group by 
			cta.num_proc_mia, nome_tp_tx, cta.dc_mia, cd_tp_moeda, dt_ins_mia, vlr_org_mia, apelido, cta.Dt_Prev_pgto_mia
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_mia

		union


--House Exportação Aerea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hea,19) Job_ATL ,cta.num_proc_hea as Processo, nome_tp_tx as Taxa, cta.dc_hea, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hea, 105) as Data, cast(vlr_org_hea as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_hea Dt_Prev

		from 
			cta_cte_hou_exp_aer as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_hea)
			--left outer join caixa_hou_exp_aer as cxa with(nolock) on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hea,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_hea=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_hea,5) <> 'EAJOB' and desp_dst_hea <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_hea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_hea like @DC
			and num_lcto is null

		group by 
			cta.num_proc_hea, nome_tp_tx, cta.dc_hea, cd_tp_moeda, dt_ins_hea, vlr_org_hea, apelido, cta.Dt_Prev_pgto_hea
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_hea

		UNION

--Master Exportação Aérea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mea,19) Job_ATL ,cta.num_proc_mea as Processo, nome_tp_tx as Taxa, cta.dc_mea, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mea, 105) as Data, cast(vlr_org_mea as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_mea Dt_Prev

		from 
			cta_cte_mas_exp_aer as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_mea)
			--left outer join caixa_mas_exp_aer as cxa with(nolock) on (cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mea,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_mea=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_mea,5) <> 'IAJOB' and desp_dst_mea <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_mea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_mea like @DC
			and num_lcto is null

		group by 
			cta.num_proc_mea, nome_tp_tx, cta.dc_mea, cd_tp_moeda, dt_ins_mea, vlr_org_mea, apelido, cta.Dt_Prev_pgto_mea
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_mea

		union

--House Importação Maritima
		select 
			atl.num_proc_him Job_ATL ,cta.num_proc_him as Processo, nome_tp_tx as Taxa, cta.dc_him, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_him, 105) as Data, cast(vlr_org_him as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_him Dt_Prev

		from 
			cta_cte_hou_imp_mar as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_him)
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_him=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
			--left outer join caixa_hou_imp_mar as cxa with(nolock) on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_him,105) <= convert(datetime, @datafinal, 105))
			Left Outer Join PO_HIm ATL with(nolock) on rtrim(numero_po_him)=cta.num_proc_him and id_dc=19

		where 
			left(cta.num_proc_him,5) <> 'IMJOB' and desp_org_him <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_him like @DC
			and num_lcto is null

		group by 
			atl.num_proc_him,cta.num_proc_him, nome_tp_tx, cta.dc_him, cd_tp_moeda, dt_ins_him, vlr_org_him, apelido, cta.Dt_Prev_pgto_him
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_him

		UNION

--Master Importação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mim,19) Job_ATL ,cta.num_proc_mim as Processo, nome_tp_tx as Taxa, cta.dc_mim, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mim, 105) as Data, cast(vlr_org_mim as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_mim Dt_Prev

		from 
			cta_cte_mas_imp_mar as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_mim)
			--left outer join caixa_mas_imp_mar as cxa with(nolock) on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mim,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_mim=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			desp_org_mim <> 'S' and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_mim, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_mim like @DC
			and num_lcto is null

		group by 
			cta.num_proc_mim, nome_tp_tx, cta.dc_mim, cd_tp_moeda, dt_ins_mim, vlr_org_mim, apelido, cta.Dt_Prev_pgto_mim
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_mim

		union

--House Exportação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hem,19) Job_ATL ,cta.num_proc_hem as Processo, nome_tp_tx as Taxa, cta.dc_hem, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hem, 105) as Data, cast(vlr_org_hem as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_hem Dt_Prev

		from 
			cta_cte_hou_exp_mar as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_hem)
			--left outer join caixa_hou_exp_mar as cxa with(nolock) on (cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hem,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_hem=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_hem,5) <> 'EMJOB' and desp_dst_hem <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_hem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_hem like @DC
			and num_lcto is null

		group by 
			cta.num_proc_hem, nome_tp_tx, cta.dc_hem, cd_tp_moeda, dt_ins_hem, vlr_org_hem, apelido, cta.Dt_Prev_pgto_hem 
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_hem

		UNION

--Master Exportação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mem,19) Job_ATL ,cta.num_proc_mem as Processo, nome_tp_tx as Taxa, cta.dc_mem, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mem, 105) as Data, cast(vlr_org_mem as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago,cta.Dt_Prev_pgto_mem Dt_Prev

		from 
			cta_cte_mas_exp_mar as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_mem)
			--left outer join caixa_mas_exp_mar as cxa with(nolock) on (cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mem,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_mem=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			desp_dst_mem <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_mem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_mem like @DC
			and num_lcto is null

		group by 
			cta.num_proc_mem, nome_tp_tx, cta.dc_mem, cd_tp_moeda, dt_ins_mem, vlr_org_mem, apelido, cta.Dt_Prev_pgto_mem 
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_mem

union
--House Importação Out
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hio,19) Job_ATL ,
			cta.num_proc_hio as Processo, nome_tp_tx as Taxa, cta.dc_hio, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hio, 105) as Data, cast(vlr_org_hio as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_hio Dt_Prev
		from 
			cta_cte_hou_imp_out as cta with(nolock)
			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_hio)
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_hio=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
			--left outer join caixa_hou_imp_out as cxa with(nolock) on (cta.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hio and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hio,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_hio,5) <> 'IOJOB' and desp_org_hio <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_hio, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_hio like @DC
			and num_lcto is null
		group by 
			cta.num_proc_hio, nome_tp_tx, cta.dc_hio, cd_tp_moeda, dt_ins_hio, vlr_org_hio, apelido, cta.Dt_Prev_pgto_hio
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_hio

		UNION
--EXP OUT
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_heo,19) Job_ATL ,cta.num_proc_heo as Processo, nome_tp_tx as Taxa, cta.dc_heo, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_heo, 105) as Data, cast(vlr_org_heo as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_pgto_heo Dt_Prev

		from 
			cta_cte_hou_exp_out as cta with(nolock)
			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.cd_cred_dev_heo)
			--left outer join caixa_hou_exp_out as cxa with(nolock) on (cta.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_heo,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.num_proc_heo=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_heo,5) <> 'IOJOB' and desp_org_heo <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_heo, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_heo like @DC
			and num_lcto is null

		group by 
			cta.num_proc_heo, nome_tp_tx, cta.dc_heo, cd_tp_moeda, dt_ins_heo, vlr_org_heo, apelido, cta.Dt_Prev_pgto_heo 
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_heo
			
		
			
	UNION
--BDP OTHERS
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hBo,19) Job_ATL ,cta.num_proc_hBo as Processo, 
			nome_tp_tx as Taxa, cta.DC_HBO, cd_tp_moeda as Moeda,
			convert(datetime, Dt_Ins_HBO, 105) as Data, cast(vlr_org_hBo as money) as ValorOriginal,
			Apelido, sum(vlr_ref_hia) as ValorPago, cta.Dt_Prev_Pgto_HBO Dt_Prev

		from 
			Cta_Cte_HOU_BDP_OUT  as cta with(nolock)

			inner join tipo_taxa as tp with(nolock) on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp with(nolock) on (pp.cd_pes=cta.Cd_Cred_Dev_HBO)
			--left outer join caixa_hou_exp_out as cxa with(nolock) on (cta.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_heo,105) <= convert(datetime, @datafinal, 105))
			left outer join vwCXAS as  cxa with(nolock) on (cta.Num_Proc_HBO=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.DC_HBO=cxa.dc_hia and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.Num_Proc_HBO,5) <> 'IOJOB' and Desp_Org_HBO <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, Dt_Ins_HBO, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.DC_HBO like @DC
			and num_lcto is null

		group by 
			cta.Num_Proc_HBO, nome_tp_tx, cta.DC_HBO, cd_tp_moeda, Dt_Ins_HBO, Vlr_Org_HBO, apelido, cta.Dt_Prev_Pgto_HBO 
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.Vlr_Org_HBO


	END






GO
