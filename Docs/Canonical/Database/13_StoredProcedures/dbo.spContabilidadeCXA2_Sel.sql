SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













--[spContabilidadeCXA2_Sel] '2009-12-01' ,'2009-12-31' 



CREATE procedure [dbo].[spContabilidadeCXA2_Sel] --[spContabilidadeCXA2_Sel] '01-01-2011','01-31-2011'
			@DataInicial	Datetime,
			@DataFinal		Datetime
as


--CABEÇALHO
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

union ALL

--SEM NF
select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, 
(
Case
	When RFI.num_registro is not null then 2708
	else ISNULL(tTc.CD_cTA_cTB_RED,3228) 

End
)
Conta_Debito, 



null Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + isnull(cxa.num_lcto,'') + ' -  '+ isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + isnull(TT.Nome_Tp_tx,'') + ' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx and Data<=@DataFinal
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso and emissao <=@DataFinal
Left Join Registro_Financeiro_Item RFI on Cxa.num_proc_hia=rfi.num_proc and cxa.dc_hia=RFI.dc and CXA.cd_tp_Tx=RFI.cd_Tp_Tx and exists(select * from registro_financeiro where rfi.ano=ano and RFI.mes=mes and rfi.num_registro=num_registro and ativo=1) and (rfi.mes<=month(@Datafinal) and RFI.ano=year(@DataFinal) or RFI.ano < year(@DataFinal))
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and PG.DC='d' and cxa.dc_hia='D'
	and emissao is null

union ALL


--COM NF

select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, 514 Conta_Debito, null Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + isnull(cxa.num_lcto,'') + ' -  '+ isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + isnull(TT.Nome_Tp_tx,'') + 'NF = ' + ISNULL(cast(CTA.NUM_NF_HIA as varchar(30)),'Não Informada') +  ' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
--LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso and emissao<=@DataFinal
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and DC='d' and cxa.dc_hia='D'
	and emissao is not null

Union all
--SEM NF

select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, null Conta_Debito, 
(
Case
	When RFI.num_registro is not null then 2708
	else ISNULL(tTc.CD_cTA_cTB_RED,3228) 

End
)

Conta_Credito,


vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + isnull(cxa.num_lcto,'') + '  -  '  + isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + isnull(tt.Nome_Tp_Tx ,'') + ' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa  from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx and Data<=@DataFinal
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso and emissao <=@DataFinal
Left Join Registro_Financeiro_Item RFI on Cxa.num_proc_hia=rfi.num_proc and cxa.dc_hia=RFI.dc and CXA.cd_tp_Tx=RFI.cd_Tp_Tx and exists(select * from registro_financeiro where rfi.ano=ano and RFI.mes=mes and rfi.num_registro=num_registro and ativo=1) and (rfi.mes<=month(@Datafinal) and RFI.ano=year(@DataFinal) or RFI.ano < year(@DataFinal))
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and PG.DC='d' and cxa.dc_hia='C'
	and emissao is null

Union all

--COM NF

select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, null Conta_Debito, iSNULL(TTC.CD_CTA_CTB_RED,514) Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + isnull(cxa.num_lcto,'') + '  -  '  + isnull(cxa.num_proc_hia,'') + 'NF:' + isnull(cast(cta.num_nf_hia as varchar(30)),'Não Informada') +    ' ' + isnull(tt.Nome_Tp_Tx,'') + ' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa  from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx AND TTC.CD_CTA_CTB_RED <> '8131' and Data<=@DataFinal
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso and emissao <=@DataFinal
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and DC='d' and cxa.dc_hia='C'
	and emissao is not null


UNION ALL


--LANCAMENTO A CREDITO

--CABEÇALHO
select  DISTINCT '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov,cd_cta_ctb_red  Conta_Debito,Null Conta_Credito,vlr_doc vlr_pgto_rcto_hia,212 Codigo_Historico,'"' + isnull(pg.num_lcto,'') + '  ' +  ' ' + isnull(Nome_Raz_Soc,'') + ' "' Hist_3,pg.num_lcto,null,null from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=pg.cd_pes
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and DC='C' 

UNION ALL
--SEM NF
select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, null Conta_Debito, Isnull(ttc.cd_cta_ctb_red,3228) Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + isnull(cxa.num_lcto,'') + ' -  ' + isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + isnull(TT.Nome_Tp_tx,'') + ' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa  from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx and Data<=@DataFinal
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso and emissao<=@DataFinal
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and DC='C' and cxa.dc_hia='C'
	and emissao is null

union ALL

--COM NF
select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, null Conta_Debito, Isnull(ttc.cd_cta_ctb_red,514) Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + isnull(cxa.num_lcto,'') + ' -  ' + isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + isnull(TT.Nome_Tp_tx,'') + 'NF: ' + cast(cta.num_nf_hia  as varchar(30)) +  ' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa  from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx 
LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx AND TTC.cd_cta_ctb_red <>'8131' and Data<=@DataFinal
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso and emissao <=@DataFinal
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and DC='C' and cxa.dc_hia='C'
	and emissao is not null

UNION ALL

--SEM NF

select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, isnull(TTC.cd_cta_ctb_red,3228) Conta_Debito, null Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + isnull(cxa.num_lcto,'') + ' -  ' + Isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + Isnull(TTC.Nome_Tp_tx,'') + ' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa  from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx and Data<=@DataFinal
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso and emissao <=@DataFinal

Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and DC='C' and cxa.dc_hia='D'
	AND EMISSAO IS NULL


UNION ALL

--COM NF

select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, isnull(TTC.cd_cta_ctb_red,514) Conta_Debito, null Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + isnull(cxa.num_lcto,'') + ' -  ' + Isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + Isnull(TTC.Nome_Tp_tx,'') + 'NF: ' + isnull(cast(cta.num_nf_hia as varchar(30)),'')  +' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa  from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx AND TTC.cd_cta_ctb_red<>'8131' and data <=@datafinal
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso and emissao <=@DataFinal

Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and DC='C' and cxa.dc_hia='D'
	AND EMISSAO IS NOT NULL




  




GO
