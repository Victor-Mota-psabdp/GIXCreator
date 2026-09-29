SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE procedure [dbo].[spContabilidadeRemessas_Sel]-- '05-01-2011','05-05-2011'
		
		@DataInicial	Datetime,
		@DataFinal		Datetime

as

--REMESSA AEREA

select '1' Filial,convert(Datetime,dt_ra,105) Data_Mov,NULL Conta_Debito, cd_cta_ctb_red Conta_Credito,abs(Vlr_Tot_RA) vlr_pgto_rcto_hia,212 Codigo_Historico,'"' + pg.num_ref_ra + '  ' +  ' ' + Nome_Raz_Soc + ' "' Hist_3, null Job from Remessa_Aer PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_ra
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=pg.cd_pes
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Where
	convert(Datetime,dt_ra,105) between @DataInicial and @DataFinal
	and vlr_tot_ra >0




union

--SEM NF
select '1' Filial,convert(Datetime,dt_ra,105) Data_Mov, 3228 Conta_Debito, null Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Aer PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_ra
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso
Where
	convert(Datetime,dt_ra,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='D'
	and emissao is null
Union

-- COM NF

select '1' Filial,convert(Datetime,dt_ra,105) Data_Mov, 515 Conta_Debito, null Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + 'NF: ' + cast(num_nf_hia as varchar(20))+ '  Processo: ' + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Aer PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_ra
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso
Where
	convert(Datetime,dt_ra,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='D'


union

--SEM NF
select '1' Filial,convert(Datetime,dt_ra,105) Data_Mov, null Conta_Debito, 3228 Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_Tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Aer PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_ra
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso
Where
	convert(Datetime,dt_ra,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='C'
	and emissao is null

Union 

--COM NF
select '1' Filial,convert(Datetime,dt_ra,105) Data_Mov, null Conta_Debito, 515 Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"'+ 'NF: ' + cast(num_nf_hia as varchar(20)) + '   Processo: '  + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_Tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Aer PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_ra
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso
Where
	convert(Datetime,dt_ra,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='C'
	and emissao is not null


UNION


--LANCAMENTO A CREDITO
select '1' Filial,convert(Datetime,dt_Ra,105) Data_Mov,cd_cta_ctb_red  Conta_Debito,Null Conta_Credito,abs(vlr_tot_ra) vlr_pgto_rcto_hia,212 Codigo_Historico,'"' + pg.num_ref_ra + '  ' +  ' ' + Nome_Raz_Soc + ' "' Hist_3,null Job from Remessa_Aer PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_ra
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=pg.cd_pes
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso
Where
	convert(Datetime,dt_ra,105) between @DataInicial and @DataFinal
	and vlr_tot_ra <0



union


--remessa maritima



select '1' Filial,convert(Datetime,dt_rm,105) Data_Mov,NULL Conta_Debito, cd_cta_ctb_red Conta_Credito,abs(Vlr_Tot_rm) vlr_pgto_rcto_hia,212 Codigo_Historico,'"' + pg.num_ref_rm + '  ' +  ' ' + Nome_raz_Soc + ' "' Hist_3,null JOB from Remessa_Mar PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_rm
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=pg.cd_pes
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Where
	convert(Datetime,dt_rm,105) between @DataInicial and @DataFinal
	and vlr_tot_rm >0




union

--SEM NF
select '1' Filial,convert(Datetime,dt_rm,105) Data_Mov, 3228 Conta_Debito, null Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Mar PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_rm
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso
Where
	convert(Datetime,dt_rm,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='D'
	and emissao is null
Union 
--Com NF

select '1' Filial,convert(Datetime,dt_rm,105) Data_Mov, 515 Conta_Debito, null Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + 'NF: ' + cast(num_nf_hia as varchar(20)) + '  Processo: '  + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Mar PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_rm
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso
Where
	convert(Datetime,dt_rm,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='D'
	and emissao is not null


union
--SEM NF
select '1' Filial,convert(Datetime,dt_rm,105) Data_Mov, null Conta_Debito, 3228 Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_Tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Mar PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_rm
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso

Where
	convert(Datetime,dt_rm,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='C'
	and emissao is null

UNION

--COM NF
select '1' Filial,convert(Datetime,dt_rm,105) Data_Mov, null Conta_Debito, 515 Conta_Credito,vlr_pgto_rcto_hia,778 Codigo_Historico,'"' + ' NF: ' + cast(num_nf_hia as varchar(20)) + '  Processo: ' + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_Tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Mar PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_rm
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso

Where
	convert(Datetime,dt_rm,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='C'
	and emissao is not null

Union 

--LANCAMENTO A CREDITO
select '1' Filial,convert(Datetime,dt_rm,105) Data_Mov,cd_cta_ctb_red  Conta_Debito,Null Conta_Credito,abs(vlr_tot_rm) vlr_pgto_rcto_hia,212 Codigo_Historico,'"' + pg.num_ref_rm + '  ' +  ' ' + Nome_raz_Soc + ' "' Hist_3,Null Job  from Remessa_Mar PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_rm
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=pg.cd_pes
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Where
	convert(Datetime,dt_rm,105) between @DataInicial and @DataFinal
	and vlr_tot_rm <0




Union 


--COM NF
select '1' Filial,convert(Datetime,dt_rm,105) Data_Mov, 515 Conta_Debito, 6646 Conta_Credito,abs(vlr_pgto_rcto_hia - vlr_pgto_nf_hia),778 Codigo_Historico,'"' + 'VARIACAO NF: ' + cast(num_nf_hia as varchar(20)) + '  Processo: ' + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_Tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Mar PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_rm
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso

Where
	convert(Datetime,dt_rm,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='C'
	and emissao is not null
	and vlr_pgto_rcto_hia > vlr_pgto_nf_hia


Union 


select '1' Filial,convert(Datetime,dt_rm,105) Data_Mov, 5552 Conta_Debito, 515 Conta_Credito,abs(vlr_pgto_rcto_hia - vlr_pgto_nf_hia),778 Codigo_Historico,'"' + 'VARIACAO NF: ' + cast(num_nf_hia as varchar(20)) + '  Processo: ' + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_Tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Mar PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_rm
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso

Where
	convert(Datetime,dt_rm,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='C'
	and emissao is not null
	and vlr_pgto_rcto_hia < vlr_pgto_nf_hia


Union 

--COM NF
select '1' Filial,convert(Datetime,dt_ra,105) Data_Mov, 515 Conta_Debito, 6646 Conta_Credito,abs(vlr_pgto_rcto_hia - vlr_pgto_nf_hia),778 Codigo_Historico,'"' + 'VARIACAO NF: ' + cast(num_nf_hia as varchar(20)) + '  Processo: ' + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_Tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_Aer PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_ra
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso

Where
	convert(Datetime,dt_ra,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='C'
	and emissao is not null
	and vlr_pgto_rcto_hia > vlr_pgto_nf_hia


Union 


select '1' Filial,convert(Datetime,dt_ra,105) Data_Mov, 5552 Conta_Debito, 515 Conta_Credito,abs(vlr_pgto_rcto_hia - vlr_pgto_nf_hia),778 Codigo_Historico,'"' + 'VARIACAO NF: ' + cast(num_nf_hia as varchar(20)) + '  Processo: ' + cxa.num_proc_hia + '  ' +  ' ' + Nome_Tp_Tx + ' "' Hist_3,cxa.num_proc_hia Job from Remessa_aer PG
Join vwcxas CXA on CXA.num_rcb_hia=pg.num_ref_ra
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso

Where
	convert(Datetime,dt_ra,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='C'
	and emissao is not null
	and vlr_pgto_rcto_hia < vlr_pgto_nf_hia




GO
