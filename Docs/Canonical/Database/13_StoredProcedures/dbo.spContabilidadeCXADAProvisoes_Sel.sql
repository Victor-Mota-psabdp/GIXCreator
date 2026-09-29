SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




























CREATE procedure [dbo].[spContabilidadeCXADAProvisoes_Sel] --'12-01-2011','12-31-2011'
		@DataInicial	Datetime,
		@DataFinal		Datetime

as


--ITEM
select '1' filial,dt_emissao data_mov,null conta_debito,cbd.cd_cta_ctb_red conta_credito,vlr_item vlr_pgto_Rcto_hia,405 codigo_historico,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') +  ' - ' + isnull(compl_hist,'') +  '"' Hist_3,Cd_Conta_C Centro_custo,cbd.ck_cm from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where
(Item.dt_emissao between @DataInicial and @DataFinal and month(dt_emissao)<>month(convert(Datetime,DT_VCTO_DIV,105)) and dt_emissao < (convert(Datetime,DT_VCTO_DIV,105)))
and dc_item='C'
and dc_div='D'
and cbd.cd_cta_ctb_red not in ('3004','6706','3005','8438')

union all


---ITEM

select '1',dt_emissao,cbd.cd_cta_ctb_red,null,vlr_item,405,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') +  ' - ' + isnull(compl_hist,'') + '"' Hist_3,Cd_Conta_C Centro_custo,cbd.ck_cm from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where 
		(Item.dt_emissao between @DataInicial and @DataFinal and month(dt_emissao)<>month(convert(Datetime,DT_VCTO_DIV,105)) and dt_emissao < (convert(Datetime,DT_VCTO_DIV,105)))
and dc_item='D'
and dc_div='D'
and cbd.cd_cta_ctb_red not in ('3004','6706','3005','8438')


UNION ALL

--ITEM

select '1' filial,dt_emissao data_mov,null conta_debito,cbd.cd_cta_ctb_red conta_credito,vlr_item vlr_pgto_Rcto_hia,405 codigo_historico,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') +  ' - ' + isnull(compl_hist,'') + '"' Hist_3,Cd_Conta_C Centro_custo,cbd.ck_cm from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where 
	(Item.dt_emissao between @DataInicial and @DataFinal and month(dt_emissao)<>month(convert(Datetime,DT_VCTO_DIV,105)) and dt_emissao < (convert(Datetime,DT_VCTO_DIV,105)))
and dc_item='C'
and dc_div='C'
and item.cd_Cta_ctb not in (select cd_Cta_ctb from cta_Cte)
and cbd.cd_cta_ctb_red not in ('3004','6706','3005','8438')



union all


--ITEM
select '1',dt_emissao,cbd.cd_cta_ctb_red,null,vlr_item,405,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') + ' - ' + isnull(compl_hist,'') +  '"' Hist_3,Cd_Conta_C Centro_custo,cbd.ck_cm from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where 
	(Item.dt_emissao between @DataInicial and @DataFinal and month(dt_emissao)<>month(convert(Datetime,DT_VCTO_DIV,105)) and dt_emissao < (convert(Datetime,DT_VCTO_DIV,105)))
and dc_item='D'
and dc_div='C'
and item.cd_Cta_ctb not in (select cd_Cta_ctb from cta_Cte)
and cbd.cd_cta_ctb_red not in ('3004','6706','3005','8438')


Union All


--CABECALHO
select  '1' filial,dt_emissao,null,2690,vlr_item,405,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') + ' - ' + isnull(compl_hist,'') + ' - ' + isnull(compl_hist,'') +  '"'  Hist_3,null Centro_custo,cb.ck_cm from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where 
	(Item.dt_emissao between @DataInicial and @DataFinal and month(dt_emissao)<>month(convert(Datetime,DT_VCTO_DIV,105)) and dt_emissao < (convert(Datetime,DT_VCTO_DIV,105)))
	--and dc_item='D'
	And dc_div='D'
and cbd.cd_cta_ctb_red not in ('3004','6706','3005','8438')
	
Union  All

--Cabeçalho
select  '1',dt_emissao,2690,null,vlr_item,405,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') + ' - ' + isnull(compl_hist,'') +  '"' Hist_3,null Centro_custo,cb.ck_cm from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where 

	(Item.dt_emissao between @DataInicial and @DataFinal and month(dt_emissao)<>month(convert(Datetime,DT_VCTO_DIV,105)) and dt_emissao < (convert(Datetime,DT_VCTO_DIV,105)))
	--and dc_item='D'
	And dc_div='C'
and cbd.cd_cta_ctb_red not in ('3004','6706','3005','8438')








GO
