SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














CREATE procedure [dbo].[spContabilidadeCXADA_Sel] --'01-01-2008','01-31-2008'
		@DataInicial	Datetime,
		@DataFinal		Datetime

as

--ITEM
select '1' filial,convert(datetime,DT_VCTO_DIV,105) data_mov,null conta_debito,cbd.cd_cta_ctb_red conta_credito,vlr_item vlr_pgto_Rcto_hia,778 codigo_historico,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') +  ' - ' + isnull(compl_hist,'') +  '"' Hist_3,Cd_Conta_C Centro_custo,cbd.ck_cm,'1-Select' Query from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where convert(datetime,DT_VCTO_DIV,105)  between @DataInicial and @DataFinal
and dc_item='C'
and dc_div='D'
and 
(
	(

	month(dt_emissao)=month(convert(Datetime,DT_VCTO_DIV,105))

	or
	
	cbd.cd_cta_ctb_red in ('3004','6706','3005','8438')

	)


)


union all


---ITEM

select '1',convert(datetime,DT_VCTO_DIV,105),cbd.cd_cta_ctb_red,null,vlr_item,778,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') +  ' - ' + isnull(compl_hist,'') + '"' Hist_3,Cd_Conta_C Centro_custo,cbd.ck_cm,'2-Select' Query from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where convert(datetime,DT_VCTO_DIV,105)  between @DataInicial and @DataFinal
and dc_item='D'
and dc_div='D'
and	(

	month(dt_emissao)=month(convert(Datetime,DT_VCTO_DIV,105))

	or
	
	cbd.cd_cta_ctb_red in ('3004','6706','3005','8438')

	)

UNION ALL

--ITEM

select '1' filial,convert(datetime,DT_VCTO_DIV,105) data_mov,null conta_debito,cbd.cd_cta_ctb_red conta_credito,vlr_item vlr_pgto_Rcto_hia,778 codigo_historico,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') +  ' - ' + isnull(compl_hist,'') + '"' Hist_3,Cd_Conta_C Centro_custo,cbd.ck_cm,'3-Select' Query from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where convert(datetime,DT_VCTO_DIV,105)  between @DataInicial and @DataFinal
and dc_item='C'
and dc_div='C'
and item.cd_Cta_ctb not in (select cd_Cta_ctb from cta_Cte)
and 
	(

	month(dt_emissao)=month(convert(Datetime,DT_VCTO_DIV,105))

	or
	
	cbd.cd_cta_ctb_red in ('3004','6706','3005','8438')

	)


union all


--ITEM
select '1',convert(datetime,DT_VCTO_DIV,105),cbd.cd_cta_ctb_red,null,vlr_item,778,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') + ' - ' + isnull(compl_hist,'') +  '"' Hist_3,Cd_Conta_C Centro_custo,cbd.ck_cm,'4-Select' Query from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where convert(datetime,DT_VCTO_DIV,105)  between @DataInicial and @DataFinal
and dc_item='D'
and dc_div='C'
and item.cd_Cta_ctb not in (select cd_Cta_ctb from cta_Cte)
	and (

	month(dt_emissao)=month(convert(Datetime,DT_VCTO_DIV,105))

	or
	
	cbd.cd_cta_ctb_red in ('3004','6706','3005','8438')

	)

Union All

--CABECALHO
select  '1' Filial,convert(datetime,DT_VCTO_DIV,105),

Case DC_ITEM
	When 'D' then null
	Else cb.cd_cta_ctb_red
End,
Case DC_ITEM
	When 'C' then null
	Else cb.cd_cta_ctb_red
End, vlr_item,778,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') + ' - ' + isnull(compl_hist,'') + ' - ' + isnull(compl_hist,'') +  '"'  Hist_3,null Centro_custo,cb.ck_cm,'5-Select' Query from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where convert(datetime,DT_VCTO_DIV,105)  between @DataInicial and @DataFinal
--and dc_item='D'
and dc_div='D'

Union  All

--Cabeçalho
select  
	'1',convert(datetime,DT_VCTO_DIV,105),

	Case DC_ITEM
		When 'D' then null
		Else cb.cd_cta_ctb_red
	End,
	Case DC_ITEM
		When 'C' then null
		Else cb.cd_cta_ctb_red
	End,
	
	vlr_item,778,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') + ' - ' + isnull(compl_hist,'') +  '"' Hist_3,null Centro_custo,cb.ck_cm,'6-Select' Query from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where convert(datetime,DT_VCTO_DIV,105)  between @DataInicial and @DataFinal
--and dc_item='D'
and dc_div='C'
and item.cd_Cta_ctb not in (select cd_Cta_ctb from cta_Cte)




Union All

--Reversao de provisão

--ITEM
select '1' filial,convert(datetime,DT_VCTO_DIV,105) data_mov,null conta_debito,2690  conta_credito,vlr_item vlr_pgto_Rcto_hia,778 codigo_historico,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') +  ' - ' + isnull(compl_hist,'') +  '"' Hist_3,Null Centro_custo,cbd.ck_cm,'7-Select' Query from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where convert(datetime,DT_VCTO_DIV,105)  between @DataInicial and @DataFinal
and dc_item='C'
and dc_div='D'
and 
(
	(

	month(dt_emissao)<>month(convert(Datetime,DT_VCTO_DIV,105))

	and
	
	cbd.cd_cta_ctb_red not in ('3004','6706','3005','8438')

	)


)


union all


---ITEM

select '1',convert(datetime,DT_VCTO_DIV,105),2690 ,null,vlr_item,778,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') +  ' - ' + isnull(compl_hist,'') + '"' Hist_3,Null Centro_custo,cbd.ck_cm,'8-Select' Query from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where convert(datetime,DT_VCTO_DIV,105)  between @DataInicial and @DataFinal
and dc_item='D'
and dc_div='D'
and	(

	month(dt_emissao)<>month(convert(Datetime,DT_VCTO_DIV,105))

	and
	
	cbd.cd_cta_ctb_red not in ('3004','6706','3005','8438')

	)

UNION ALL

--ITEM

select '1' filial,convert(datetime,DT_VCTO_DIV,105) data_mov,null conta_debito,2690  conta_credito,vlr_item vlr_pgto_Rcto_hia,778 codigo_historico,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') +  ' - ' + isnull(compl_hist,'') + '"' Hist_3,Null Centro_custo,cbd.ck_cm,'9-Select' Query from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where convert(datetime,DT_VCTO_DIV,105)  between @DataInicial and @DataFinal
and dc_item='C'
and dc_div='C'
and item.cd_Cta_ctb not in (select cd_Cta_ctb from cta_Cte)
and 
	(

	month(dt_emissao)<>month(convert(Datetime,DT_VCTO_DIV,105))

	and
	
	cbd.cd_cta_ctb_red not in ('3004','6706','3005','8438')

	)


union all


--ITEM
select '1',convert(datetime,DT_VCTO_DIV,105),2690 ,null,vlr_item,778,'"' + pg.num_lcto_div  + ' - ' + Isnull(Nome_Raz_soc,'') + ' - ' + isnull(compl_hist,'') +  '"' Hist_3,Null Centro_custo,cbd.ck_cm,'10-Select' Query from pgto_rcto_div PG
Join Pgto_Rcto_Div_Det Item on item.num_lcto_div=pg.num_lcto_div
Join cta_cte CTA on CTA.num_cta_cte=pg.num_cta_cte and pg.cd_agencia=cta.cd_agencia
Join Cta_ctb CB on CB.cd_Cta_ctb=cta.cd_cta_ctb
Join cta_ctb CBD on CBD.cd_Cta_Ctb=item.cd_Cta_ctb
Join Centro_Custo CC on Cc.cd_centro_custo=ITem.cd_centro_Custo
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where convert(datetime,DT_VCTO_DIV,105)  between @DataInicial and @DataFinal
and dc_item='D'
and dc_div='C'
and item.cd_Cta_ctb not in (select cd_Cta_ctb from cta_Cte)
and	(

	month(dt_emissao)<>month(convert(Datetime,DT_VCTO_DIV,105))

	and
	
	cbd.cd_cta_ctb_red not in ('3004','6706','3005','8438')

	)





GO
