SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  procedure [dbo].[spTaxasAberto_Teste2_Rel]--'01/10/2011', '03/10/2011', '%', '%', '%', '%'

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
			ATL.num_proc_hia Job_ATL, Apelido as Processo, nome_tp_tx as Taxa, cta.dc_hia, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hia, 105) as Data, cast(vlr_org_hia as money) as ValorOriginal,
			cta.num_proc_hia as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_hia) as ValorPago, cta.Dt_Prev_Pgto_hia  Dt_Prev

		from 
			cta_cte_hou_imp_aer as cta
			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_hia)
			left outer join caixa_hou_imp_aer as cxa on (cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
			Left Outer Join PO_HIA ATL on numero_po_hia=cta.num_proc_hia and id_dc=19
		where 
			left(cta.num_proc_hia,5) <> 'IAJOB' and desp_org_hia <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_hia like @DC
			
		group by 
			atl.num_proc_hia,cta.num_proc_hia, nome_tp_tx, cta.dc_hia, cd_tp_moeda, dt_ins_hia, vlr_org_hia, apelido, cta.Dt_Prev_Pgto_hia
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_hia

		UNION


--Master Importação Aérea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mia,19) ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_mia, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mia, 105) as Data, cast(vlr_org_mia as money) as ValorOriginal,
			cta.num_proc_mia as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_mia) as ValorPago, cta.Dt_Prev_pgto_mia Dt_Prev

		from 
			cta_cte_mas_imp_aer as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_mia)
			left outer join caixa_mas_imp_aer as cxa on (cta.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mia,105) <= convert(datetime, @datafinal, 105))

		where 
			desp_org_mia <> 'S' and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_mia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_mia like @DC

		group by 
			cta.num_proc_mia, nome_tp_tx, cta.dc_mia, cd_tp_moeda, dt_ins_mia, vlr_org_mia, apelido, cta.Dt_Prev_pgto_mia
	
		having
			sum(vlr_ref_mia) is null or sum(vlr_ref_mia) <> cta.vlr_org_mia

		union


--House Exportação Aerea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hea,19) ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_hea, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hea, 105) as Data, cast(vlr_org_hea as money) as ValorOriginal,
			cta.num_proc_hea as Apelido,([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_hea) as ValorPago, cta.Dt_Prev_pgto_hea Dt_Prev

		from 
			cta_cte_hou_exp_aer as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_hea)
			left outer join caixa_hou_exp_aer as cxa on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hea,105) <= convert(datetime, @datafinal, 105))

		where 
			left(cta.num_proc_hea,5) <> 'EAJOB' and desp_dst_hea <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_hea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_hea like @DC

		group by 
			cta.num_proc_hea, nome_tp_tx, cta.dc_hea, cd_tp_moeda, dt_ins_hea, vlr_org_hea, apelido,cta.Dt_Prev_pgto_hea
	
		having
			sum(vlr_ref_hea) is null or sum(vlr_ref_hea) <> cta.vlr_org_hea

		UNION

--Master Exportação Aérea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mea,19) ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_mea, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mea, 105) as Data, cast(vlr_org_mea as money) as ValorOriginal,
			cta.num_proc_mea as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_mea) as ValorPago, cta.Dt_Prev_pgto_mea Dt_Prev

		from 
			cta_cte_mas_exp_aer as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_mea)
			left outer join caixa_mas_exp_aer as cxa on (cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mea,105) <= convert(datetime, @datafinal, 105))

		where 
			left(cta.num_proc_mea,5) <> 'IAJOB' and desp_dst_mea <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_mea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_mea like @DC

		group by 
			cta.num_proc_mea, nome_tp_tx, cta.dc_mea, cd_tp_moeda, dt_ins_mea, vlr_org_mea, apelido, cta.Dt_Prev_pgto_mea
	
		having
			sum(vlr_ref_mea) is null or sum(vlr_ref_mea) <> cta.vlr_org_mea

		union

--House Importação Maritima
		select 
			atl.num_proc_him ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_him, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_him, 105) as Data, cast(vlr_org_him as money) as ValorOriginal,
			cta.num_proc_him as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_him) as ValorPago, cta.Dt_Prev_pgto_him Dt_Prev
		from 
			cta_cte_hou_imp_mar as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_him)
			left outer join caixa_hou_imp_mar as cxa on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_him,105) <= convert(datetime, @datafinal, 105))
			Left Outer Join PO_HIM ATL on rtrim(numero_po_him)=cta.num_proc_him and id_dc=19

		where 
			left(cta.num_proc_him,5) <> 'IMJOB' and desp_org_him <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_him like @DC

		group by 
			atl.num_proc_him,cta.num_proc_him, nome_tp_tx, cta.dc_him, cd_tp_moeda, dt_ins_him, vlr_org_him, apelido, cta.Dt_Prev_pgto_him
	
		having
			sum(vlr_ref_him) is null or sum(vlr_ref_him) <> cta.vlr_org_him

		UNION

--Master Importação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mim,19) ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_mim, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mim, 105) as Data, cast(vlr_org_mim as money) as ValorOriginal,
			cta.num_proc_mim as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_mim) as ValorPago, cta.Dt_Prev_pgto_mim Dt_Prev

		from 
			cta_cte_mas_imp_mar as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_mim)
			left outer join caixa_mas_imp_mar as cxa on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mim,105) <= convert(datetime, @datafinal, 105))

		where 
			desp_org_mim <> 'S' and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_mim, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_mim like @DC

		group by 
			cta.num_proc_mim, nome_tp_tx, cta.dc_mim, cd_tp_moeda, dt_ins_mim, vlr_org_mim, apelido, cta.Dt_Prev_pgto_mim
	
		having
			sum(vlr_ref_mim) is null or sum(vlr_ref_mim) <> cta.vlr_org_mim

		union

--House Exportação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hem,19) ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_hem, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hem, 105) as Data, cast(vlr_org_hem as money) as ValorOriginal,
			cta.num_proc_hem as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_hem) as ValorPago, cta.Dt_Prev_pgto_hem Dt_Prev

		from 
			cta_cte_hou_exp_mar as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_hem)
			left outer join caixa_hou_exp_mar as cxa on (cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hem,105) <= convert(datetime, @datafinal, 105))

		where 
			left(cta.num_proc_hem,5) <> 'EMJOB' and desp_dst_hem <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_hem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_hem like @DC

		group by 
			cta.num_proc_hem, nome_tp_tx, cta.dc_hem, cd_tp_moeda, dt_ins_hem, vlr_org_hem, apelido, cta.Dt_Prev_pgto_hem
	
		having
			sum(vlr_ref_hem) is null or sum(vlr_ref_hem) <> cta.vlr_org_hem

		UNION

--Master Exportação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mem,19) ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_mem, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mem, 105) as Data, cast(vlr_org_mem as money) as ValorOriginal,
			cta.num_proc_mem as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_mem) as ValorPago, cta.Dt_Prev_pgto_mem Dt_Prev

		from 
			cta_cte_mas_exp_mar as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_mem)
			left outer join caixa_mas_exp_mar as cxa on (cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mem,105) <= convert(datetime, @datafinal, 105))

		where 
			desp_dst_mem <> 'S'
			and apelido like @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_mem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_mem like @DC
		
		group by 
			cta.num_proc_mem, nome_tp_tx, cta.dc_mem, cd_tp_moeda, dt_ins_mem, vlr_org_mem, apelido, cta.Dt_Prev_pgto_mem
	
		having
			sum(vlr_ref_mem) is null or sum(vlr_ref_mem) <> cta.vlr_org_mem

		union

--House Importação Out
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hio,19) Job_ATL ,
			Apelido as Processo, nome_tp_tx as Taxa, cta.dc_hio, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hio, 105) as Data, cast(vlr_org_hio as money) as ValorOriginal,
			cta.num_proc_hio as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_hio) as ValorPago, cta.Dt_Prev_pgto_hio Dt_Prev
		from 
			cta_cte_hou_imp_out as cta
			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_hio)
			left outer join caixa_hou_imp_out as cxa on (cta.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hio and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hio,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_hio,5) <> 'IOJOB' and desp_org_hio <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_hio, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_hio like @DC
		group by 
			cta.num_proc_hio, nome_tp_tx, cta.dc_hio, cd_tp_moeda, dt_ins_hio, vlr_org_hio, apelido, cta.Dt_Prev_pgto_hio
		having
			sum(vlr_ref_hio) is null or sum(vlr_ref_hio) <> cta.vlr_org_hio
union
		--EXP OUT
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_heo,19) Job_ATL ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_heo, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_heo, 105) as Data, cast(vlr_org_heo as money) as ValorOriginal,
			cta.num_proc_heo as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_heo) as ValorPago, cta.Dt_Prev_pgto_heo Dt_Prev

		from 
			cta_cte_hou_exp_out as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_heo)
			left outer join caixa_hou_exp_out as cxa on (cta.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_heo,105) <= convert(datetime, @datafinal, 105))

		where 
			left(cta.num_proc_heo,5) <> 'IOJOB' and desp_org_heo <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ like @tpPes and
			convert(datetime, dt_ins_heo, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_heo like @DC

		group by 
			cta.num_proc_heo, nome_tp_tx, cta.dc_heo, cd_tp_moeda, dt_ins_heo, vlr_org_heo, apelido, cta.Dt_Prev_pgto_heo
	
		having
			sum(vlr_ref_heo) is null or sum(vlr_ref_heo) <> cta.vlr_org_heo	

	END
ELSE

	BEGIN
		--House Importação Aérea
		select 
			atl.num_proc_hia Job_ATL ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_hia, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hia, 105) as Data, cast(vlr_org_hia as money) as ValorOriginal,
			cta.num_proc_hia as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_hia) as ValorPago, cta.Dt_Prev_pgto_hia Dt_Prev

		from 
			cta_cte_hou_imp_aer as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_hia)
			left outer join caixa_hou_imp_aer as cxa on (cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hia,105) <= convert(datetime, @datafinal, 105))
			Left Outer Join PO_HIA ATL on numero_po_hia=cta.num_proc_hia

		where 
			left(cta.num_proc_hia,5) <> 'IAJOB' and desp_org_hia <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_hia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_hia like @DC

		group by 
			atl.num_proc_hia,cta.num_proc_hia, nome_tp_tx, cta.dc_hia, cd_tp_moeda, dt_ins_hia, vlr_org_hia, apelido, cta.Dt_Prev_pgto_hia
	
		having
			sum(vlr_ref_hia) is null or sum(vlr_ref_hia) <> cta.vlr_org_hia

		UNION


--Master Importação Aérea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mia,19) Job_ATL ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_mia, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mia, 105) as Data, cast(vlr_org_mia as money) as ValorOriginal,
			cta.num_proc_mia as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_mia) as ValorPago, cta.Dt_Prev_pgto_mia Dt_Prev

		from 
			cta_cte_mas_imp_aer as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_mia)
			left outer join caixa_mas_imp_aer as cxa on (cta.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mia,105) <= convert(datetime, @datafinal, 105))

		where 
			desp_org_mia <> 'S' and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_mia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_mia like @DC

		group by 
			cta.num_proc_mia, nome_tp_tx, cta.dc_mia, cd_tp_moeda, dt_ins_mia, vlr_org_mia, apelido, cta.Dt_Prev_pgto_mia
	
		having
			sum(vlr_ref_mia) is null or sum(vlr_ref_mia) <> cta.vlr_org_mia

		union


--House Exportação Aerea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hea,19) Job_ATL ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_hea, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hea, 105) as Data, cast(vlr_org_hea as money) as ValorOriginal,
			cta.num_proc_hea as Apelido,([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_hea) as ValorPago, cta.Dt_Prev_pgto_hea Dt_Prev

		from 
			cta_cte_hou_exp_aer as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_hea)
			left outer join caixa_hou_exp_aer as cxa on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hea,105) <= convert(datetime, @datafinal, 105))

		where 
			left(cta.num_proc_hea,5) <> 'EAJOB' and desp_dst_hea <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_hea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_hea like @DC

		group by 
			cta.num_proc_hea, nome_tp_tx, cta.dc_hea, cd_tp_moeda, dt_ins_hea, vlr_org_hea, apelido, cta.Dt_Prev_pgto_hea
	
		having
			sum(vlr_ref_hea) is null or sum(vlr_ref_hea) <> cta.vlr_org_hea

		UNION

--Master Exportação Aérea
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mea,19) Job_ATL ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_mea, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mea, 105) as Data, cast(vlr_org_mea as money) as ValorOriginal,
			cta.num_proc_mea as Apelido,([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_mea) as ValorPago, cta.Dt_Prev_pgto_mea Dt_Prev

		from 
			cta_cte_mas_exp_aer as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_mea)
			left outer join caixa_mas_exp_aer as cxa on (cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mea,105) <= convert(datetime, @datafinal, 105))

		where 
			left(cta.num_proc_mea,5) <> 'IAJOB' and desp_dst_mea <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_mea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_mea like @DC

		group by 
			cta.num_proc_mea, nome_tp_tx, cta.dc_mea, cd_tp_moeda, dt_ins_mea, vlr_org_mea, apelido, cta.Dt_Prev_pgto_mea
	
		having
			sum(vlr_ref_mea) is null or sum(vlr_ref_mea) <> cta.vlr_org_mea

		union

--House Importação Maritima
		select 
			atl.num_proc_him Job_ATL ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_him, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_him, 105) as Data, cast(vlr_org_him as money) as ValorOriginal,
			cta.num_proc_him as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_him) as ValorPago, cta.Dt_Prev_pgto_him Dt_Prev

		from 
			cta_cte_hou_imp_mar as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_him)
			left outer join caixa_hou_imp_mar as cxa on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_him,105) <= convert(datetime, @datafinal, 105))
			Left Outer Join PO_HIm ATL on rtrim(numero_po_him)=cta.num_proc_him and id_dc=19

		where 
			left(cta.num_proc_him,5) <> 'IMJOB' and desp_org_him <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_him like @DC

		group by 
			atl.num_proc_him,cta.num_proc_him, nome_tp_tx, cta.dc_him, cd_tp_moeda, dt_ins_him, vlr_org_him, apelido, cta.Dt_Prev_pgto_him
	
		having
			sum(vlr_ref_him) is null or sum(vlr_ref_him) <> cta.vlr_org_him

		UNION

--Master Importação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mim,19) Job_ATL ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_mim, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mim, 105) as Data, cast(vlr_org_mim as money) as ValorOriginal,
			cta.num_proc_mim as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_mim) as ValorPago, cta.Dt_Prev_pgto_mim Dt_Prev

		from 
			cta_cte_mas_imp_mar as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_mim)
			left outer join caixa_mas_imp_mar as cxa on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mim,105) <= convert(datetime, @datafinal, 105))

		where 
			desp_org_mim <> 'S' and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_mim, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_mim like @DC

		group by 
			cta.num_proc_mim, nome_tp_tx, cta.dc_mim, cd_tp_moeda, dt_ins_mim, vlr_org_mim, apelido, cta.Dt_Prev_pgto_mim
	
		having
			sum(vlr_ref_mim) is null or sum(vlr_ref_mim) <> cta.vlr_org_mim

		union

--House Exportação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hem,19) Job_ATL ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_hem, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hem, 105) as Data, cast(vlr_org_hem as money) as ValorOriginal,
			cta.num_proc_hem as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_hem) as ValorPago, cta.Dt_Prev_pgto_hem Dt_Prev

		from 
			cta_cte_hou_exp_mar as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_hem)
			left outer join caixa_hou_exp_mar as cxa on (cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hem,105) <= convert(datetime, @datafinal, 105))

		where 
			left(cta.num_proc_hem,5) <> 'EMJOB' and desp_dst_hem <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_hem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_hem like @DC

		group by 
			cta.num_proc_hem, nome_tp_tx, cta.dc_hem, cd_tp_moeda, dt_ins_hem, vlr_org_hem, apelido, cta.Dt_Prev_pgto_hem 
	
		having
			sum(vlr_ref_hem) is null or sum(vlr_ref_hem) <> cta.vlr_org_hem

		UNION

--Master Exportação Maritima
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_mem,19) Job_ATL ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_mem, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_mem, 105) as Data, cast(vlr_org_mem as money) as ValorOriginal,
			cta.num_proc_mem as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_mem) as ValorPago,cta.Dt_Prev_pgto_mem Dt_Prev

		from 
			cta_cte_mas_exp_mar as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_mem)
			left outer join caixa_mas_exp_mar as cxa on (cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mem,105) <= convert(datetime, @datafinal, 105))

		where 
			desp_dst_mem <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_mem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and CTA.dc_mem like @DC

		group by 
			cta.num_proc_mem, nome_tp_tx, cta.dc_mem, cd_tp_moeda, dt_ins_mem, vlr_org_mem, apelido, cta.Dt_Prev_pgto_mem 
	
		having
			sum(vlr_ref_mem) is null or sum(vlr_ref_mem) <> cta.vlr_org_mem

union
--House Importação Out
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_hio,19) Job_ATL ,
			Apelido as Processo, nome_tp_tx as Taxa, cta.dc_hio, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_hio, 105) as Data, cast(vlr_org_hio as money) as ValorOriginal,
			cta.num_proc_hio as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_hio) as ValorPago, cta.Dt_Prev_pgto_hio Dt_Prev
		from 
			cta_cte_hou_imp_out as cta
			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_hio)
			left outer join caixa_hou_imp_out as cxa on (cta.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hio and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hio,105) <= convert(datetime, @datafinal, 105))
		where 
			left(cta.num_proc_hio,5) <> 'IOJOB' and desp_org_hio <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_hio, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_hio like @DC
		group by 
			cta.num_proc_hio, nome_tp_tx, cta.dc_hio, cd_tp_moeda, dt_ins_hio, vlr_org_hio, apelido, cta.Dt_Prev_pgto_hio
		having
			sum(vlr_ref_hio) is null or sum(vlr_ref_hio) <> cta.vlr_org_hio

union
--EXP OUT
		select 
			dbo.fBusca_TipoDocCliente('N',cta.num_proc_heo,19) Job_ATL ,Apelido as Processo, nome_tp_tx as Taxa, cta.dc_heo, cd_tp_moeda as Moeda,
			convert(datetime, dt_ins_heo, 105) as Data, cast(vlr_org_heo as money) as ValorOriginal,
			cta.num_proc_heo as Apelido, ([dbo].[FConverterMoeda](cd_tp_moeda,'REL') * vlr_org_heo) as ValorPago, cta.Dt_Prev_pgto_heo Dt_Prev

		from 
			cta_cte_hou_exp_out as cta

			inner join tipo_taxa as tp on (tp.cd_tp_tx=cta.cd_tp_tx)
			inner join pessoa as pp on (pp.cd_pes=cta.cd_cred_dev_heo)
			left outer join caixa_hou_exp_out as cxa on (cta.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_heo,105) <= convert(datetime, @datafinal, 105))

		where 
			left(cta.num_proc_heo,5) <> 'IOJOB' and desp_org_heo <> 'S'
			and apelido LIKE @pessoa and cd_tp_ativ NOT LIKE 'AGT' and
			convert(datetime, dt_ins_heo, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
			and nome_tp_tx like @tpTaxas and cta.dc_heo like @DC

		group by 
			cta.num_proc_heo, nome_tp_tx, cta.dc_heo, cd_tp_moeda, dt_ins_heo, vlr_org_heo, apelido, cta.Dt_Prev_pgto_heo 
	
		having
			sum(vlr_ref_heo) is null or sum(vlr_ref_heo) <> cta.vlr_org_heo


	END






GO
