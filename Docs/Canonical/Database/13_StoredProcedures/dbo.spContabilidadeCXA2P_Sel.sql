SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









--[spContabilidadeCXA2_Sel] '2009-12-01' ,'2009-12-31' 






CREATE procedure [dbo].[spContabilidadeCXA2P_Sel]-- '03-01-2008','03-31-2008'
			@DataInicial	Datetime,
			@DataFinal		Datetime
as

select  dISTINCT '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov,NULL Conta_Debito, cd_cta_ctb_red Conta_Credito,vlr_doc vlr_pgto_rcto_hia,212 Codigo_Historico,'"' + isnull(pg.num_lcto,'') + '  ' +  ' ' + isnull(Nome_Raz_Soc,'') + ' "' Hist_3,pg.num_lcto,Null Job,null Taxa from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=pg.cd_pes
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and DC='d' 
	and cc.num_Cta_cte <>'007' and vlr_doc <> 0
	and nome_tp_TX like 'Serviços%'
union ALL

select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, ISNULL(tTc.CD_cTA_cTB_RED,3228) Conta_Debito, null Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + isnull(cxa.num_lcto,'') + ' -  '+ isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + isnull(TT.Nome_Tp_tx,'') + ' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and DC='d' and cxa.dc_hia='D'
	and cc.num_Cta_cte <>'007' and vlr_doc <> 0
	and tt.nome_tp_TX like 'Serviços%'








  

GO
