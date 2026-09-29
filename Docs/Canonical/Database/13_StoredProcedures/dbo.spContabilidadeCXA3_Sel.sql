SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
















--[spContabilidadeCXA2_Sel] '2009-12-01' ,'2009-12-31' 

--[dbo].[spContabilidadeCXA3_Sel] '04-01-2012','04-30-2012'



CREATE procedure [dbo].[spContabilidadeCXA3_Sel] --[dbo].[spContabilidadeCXA3_Sel] '08-01-2012','08-31-2012'
			@DataInicial	Datetime,
			@DataFinal		Datetime
as

SET NOCOUNT ON;

Declare @mes int
Declare @ano int

SEt @mes=month(@datafinal)
SEt @ano=year(@Datafinal)

exec spGeraValoresReaisCont_Upd @mes,@ano
/*
	REGRA: DOC REGISTER DO MES E PAGAMENTO EFETUADO NO MESMO MES

*/

Select  
		'1' Filial, case 
						When Dt_Ins < @DataInicial then @DataInicial
						else Dt_Ins
					End

			Data_Mov, 
		(	
			Case
				When RFI.DC='C' then Null
				When left(Upper(RFI.num_proc),2)='EA' then '8094'
				When left(Upper(RFI.num_proc),2)='EM' then '8102'
				When left(Upper(RFI.num_proc),2)='IM' then '8088'
				When left(Upper(RFI.num_proc),2)='IA' then '8071'
				else '8119'
			End
		) Conta_Debito, 
		(
			Case 
				When RFI.DC='D' then Null
				When left(Upper(RFI.num_proc),2)='EA' then '8094'
				When left(Upper(RFI.num_proc),2)='EM' then '8102'
				When left(Upper(RFI.num_proc),2)='IM' then '8088'
				When left(Upper(RFI.num_proc),2)='IA' then '8071'
				else '8119'
			End
			)	Conta_Credito, 
			(
				Case 
					When Cd_tp_moeda='REL' then RFI.Valor_Total
					else RFI.Valor_Total_Moeda_Local
				End 
			)
			
				 Vlr_Pgto_Rcto_HIA,


				778 Codigo_Historico, '"' + 'Fatura/NF Fornecedor:' + Nome_Raz_Soc + 'N. ' + Rf.Doc_Number + ' -  '+ isnull(RFI.num_proc,'') + '  ' +  ' ' + isnull(TT.Nome_Tp_tx,'') + ' "' Hist_3,
		Null Num_Lcto,RFI.num_Proc Job,RFI.cd_tp_Tx Taxa,apelido,1 REGRA
From 
	Registro_Financeiro RF
	Join Registro_Financeiro_Item RFI on RF.mes=RFI.mes and RF.ano=RFI.ano and RF.num_registro=RFI.num_registro

	Join Pessoa P on P.cd_pes=RF.cd_pes
	--Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
	Join Tipo_Taxa TT on TT.cd_tp_tx=RFI.cd_Tp_TX
Where
		month(@DataInicial)=RF.mes and year(@DataInicial)=rf.ano
--		AND RF.CD_TP_MOEDA = 'REL'
		And RF.Ativo='1'


Union All


Select 
		Distinct '1' Filial, 

		case 
			When Dt_Ins < @DataInicial then @DataInicial
			else Dt_Ins
		End

			Data_Mov, 
		Null Conta_Debito, 
		'2708' Conta_Credito,
			(
				Case 
					When Cd_tp_moeda='REL' then RF.Total_Doc
					else RF.Valor_Total_Moeda_Local
				End 
			)
			
				 Vlr_Pgto_Rcto_HIA
			,


		778 Codigo_Historico, '"' + 'Faturamento/NF - Fornecedor :' + Nome_Raz_Soc + ' - ' + Doc_Number   +   ' "' Hist_3,
		Null ,'CXA'  Job,'CXA' Taxa,apelido, 2 REGRA
From 
	Registro_Financeiro RF
	Join Registro_Financeiro_Item RFI on RF.mes=RFI.mes and RF.ano=RFI.ano and RF.num_registro=RFI.num_registro
	Join Pessoa P on P.cd_pes=RF.cd_pes
	Join Tipo_Taxa TT on TT.cd_tp_tx=RFI.cd_Tp_TX
Where
		month(@DataInicial)=RF.mes and year(@DataInicial)=rf.ano
--		and Cd_tp_moeda ='REL'
		And RF.Ativo='1'

/*

Union all


select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, 5552  Conta_Debito, 514 Conta_Credito,abs(vlr_pgto_rcto_hia - vlr_pgto_nf_hia),778 Codigo_Historico,'" Variação: ' + isnull(cast(cxa.num_lcto as varchar(30)),'') + ' -  '+ isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + isnull(TT.Nome_Tp_tx,'') +'   ' + 'NF:' +  isnull(cast(cta.num_nf_hia as varchar(30)),'') + ' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa,apelido,3 from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cta.cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='C'
	and cc.num_Cta_cte <>'007' and vlr_doc <> 0
	and emissao is not null
	and vlr_pgto_rcto_hia < vlr_pgto_nf_hia
and cta.cd_Tp_tx <> 'ISR'

Union all

select '1' Filial,convert(Datetime,DT_VCTO,105) Data_Mov, 514 Conta_Debito, 6646 Conta_Credito,abs(vlr_pgto_rcto_hia - vlr_pgto_nf_hia),778 Codigo_Historico,'" Variação: ' + isnull(cast(cxa.num_lcto as varchar(30)),'') + ' -  '+ isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + isnull(TT.Nome_Tp_tx,'') +'   ' + 'NF:' +  isnull(cast(cta.num_nf_hia as varchar(30)),'') + ' "' Hist_3,pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa,apelido,3 from vwcxas CXA
Join Pgto_rcto PG on PG.num_lcto=CXa.num_lcto
Join Cta_Cte CC on CC.num_cta_cte=pg.num_cta_cte
Join Cta_ctb CTB on CTb.cd_cta_ctb=cc.cd_cta_ctb
Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on PP.cd_pes=cta.cd_cred_dev_hia
Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
LEft Join Tipo_Taxa_Contabilidade_Impostos TTC on TTC.cd_tp_Tx=cta.cd_Tp_Tx
Left Join Base_Nota_Fiscal NF on CTA.num_nf_hia=NF.nota_fiscal and CTA.ref_Acesso_NF_hia=ref_acesso
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and cxa.dc_hia='C'
	and cc.num_Cta_cte <>'007' and vlr_doc <> 0
	and emissao is not null
	and vlr_pgto_rcto_hia > vlr_pgto_nf_hia
	and cta.cd_Tp_tx <> 'ISR'


Union All

Select
		'1' Filial,convert(datetime,dt_vcto,105) Data,
		(
			Case 
				when RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' then 2708
				when RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C' then 2708	
				When left(Upper(RFI.num_proc),2)='EA' and (RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' or RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C' ) then '8094'
				When left(Upper(RFI.num_proc),2)='EM' and (RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' or RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C' ) then '8102'
				When left(Upper(RFI.num_proc),2)='IM' and (RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' or RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C' ) then '8088'
				When left(Upper(RFI.num_proc),2)='IA' and (RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' or RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C' ) then '8071'

--				when RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C' then 514
	--			when RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' then 514

			End
		) Conta_Debito,
		(
			Case 
				when RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C' then 2708
				when RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' then 2708
				When left(Upper(RFI.num_proc),2)='EA' and (RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' or RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C') then '8094'
				When left(Upper(RFI.num_proc),2)='EM' and (RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' or RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C') then '8102'
				When left(Upper(RFI.num_proc),2)='IM' and (RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' or RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C') then '8088'
				When left(Upper(RFI.num_proc),2)='IA' and (RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D' or RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C') then '8071'
				--	when (RFI.Valor_Total_Moeda_Local > Vlr_Pgto_Rcto_Hia and cxa.dc_hia='D') then 514
				--	when RFI.Valor_Total_Moeda_Local < Vlr_Pgto_Rcto_Hia and cxa.dc_hia='C' then 514	
			


			End
		) Conta_Debito,
		abs(RFI.Valor_Total_Moeda_Local-Vlr_Pgto_Rcto_Hia),
		778 Codigo_Historico, 
		'" Variação de Provisão: ' + isnull(cast(cxa.num_lcto as varchar(30)),'') + ' -  '+ isnull(cxa.num_proc_hia,'') + '  ' +  ' ' + isnull(TT.Nome_Tp_tx,'') +'   ' + 'NF/Fatura:' +  isnull(cast(Doc_Number as varchar(30)),'') + ' "' ,
		pg.num_lcto,cxa.num_proc_hia Job,cxa.cd_tp_Tx Taxa,null,4 
from 
	vwcxas CXA
	Join Registro_Financeiro_Item RFI on RFI.num_proc=CXA.num_proc_hia and RFI.cd_tp_Tx=cxa.cd_Tp_Tx and RFI.dc=cxa.dc_hia
	Join Registro_Financeiro RF on RF.ano=RFI.ano and RF.mes=RFI.mes and RF.num_registro=RFI.num_registro
	Join Tipo_Taxa TT on TT.cd_tp_TX=cxa.cd_Tp_TX 
	Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Where
	convert(Datetime,DT_VCTO,105) between @DataInicial and @DataFinal
	and RF.Cd_Tp_Moeda <> 'REL'

*/




GO
