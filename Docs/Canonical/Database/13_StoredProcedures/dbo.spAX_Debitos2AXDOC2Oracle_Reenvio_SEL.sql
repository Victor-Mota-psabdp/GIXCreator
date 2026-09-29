SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[spAX_Debitos2AXDOC2Oracle_Reenvio_SEL]

as
--Erbson 16-05-2013: Não Buscar caso não tenha paridade lançada no dia.

--if not exists(select Par_Moeda from Paridade where Cd_Tp_Moeda ='USD' and Cd_Tp_Par = 'OFC' and convert(datetime,Dt_Par,103) =convert(varchar,getdate(),111))
--Begin
--	RETURN -2
--End

Select 
	 distinct  
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	NULL Dimensao_2,
	'' Dimensao_5,	
	'BR1' Dimensao_6,
	Dimensao7 Dimensao_7,
	2 Tipo,
	nUM_PROC_HIA NumeroInternoAX,
	cd_AX Cd_PessoA_AX,
	'Vend' AccountType,
	1 Aprovado,
	Null Aprovado_Por,
	getdate() Dt_Aprovacao,
	'BR1' Company,
	(convert(Datetime,dt_ins_hia,105)) Dt_Documento,
	Null Numero_Documento,
	max(convert(datetime,dt_prev_pgto_hia,105)) Dt_Vencimento,
	Null Invoice_Number,
	AV.TaxGroup TaxGroup,
	null TaxItemGroup,
	(convert(Datetime,dt_ins_hia,105))   Dt_Ins,
	Null Dt_Envio_AX,
	NUM_PROC_HIA Obs_AX,
	1 Ativo,
	Getdate() Data_Aprovacao,
	Num_proc_hia,
	PP.Cd_PEs,
	Apelido,
	num_cpf_cnpj,
	CTA.cd_Tp_Tx Cd_TP_TX,
	CTA.dc_HIA DC
From vwcta_Cte cta with (nolock)
		Join Pessoa PP with (nolock) on PP.Cd_Pes=cd_Cred_dev_hia
		Left Join Pessoa_LLP P with (nolock) on P.Cd_Pes=PP.Cd_Pes
		Left Join Pessoa_ATL_AX AX with (nolock) on (AX.Cd_Pes = PP.Cd_Pes) and Tipo='F'
		Left Join vwcliente C with (nolock) on C.num_proc=cta.num_proc_hia
		Left Join vwFaturasValidas I with (nolock) on cta.num_proc_hia=I.num_proc and cta.cd_tp_tx=I.cd_tp_tx and Cta.dc_hia=I.dc
		left  Join dbo.AX_XML_Vendor_Recebido AV with (nolock) on accountnum=cd_ax
		Left Join vwAXDocs IC with (nolock) on (IC.num_proc=cta.num_proc_hia and len(numerointernoax)=16 or cta.num_proc_hia=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=cta.cd_Tp_Tx and IC.Dc=cta.dc_hia
		Left join dbo.sol_pgto_cta_cte_item S with (nolock) on S.num_proc=cta.num_proc_hia and S.cd_tp_Tx=cta.cd_tp_Tx and S.dc=cta.dc_hia
		
		left join LLP_BDP_OUT LBO with (nolock) on LBO.Num_Proc_LBO = cta.num_proc_hia
		left join JOB_HBO J with (nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO 
 Where 
		cta.num_proc_hia='IMATL202511048BR' and cta.cd_tp_Tx='Cr1' and cta.dc_hia='D'
				
		--(cta.dc_hia='D' or cta.DC_HIA='C' and CTA.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))and
		--(
		--	(month(convert(Datetime,dt_ins_hia,105))=month(getdate()-1)
		--	and year(convert(Datetime,dt_ins_hia,105))=year(getdate()-1))
		--or
		--	(month(convert(Datetime,dt_ins_hia,105))=month(getdate())
		--	and year(convert(Datetime,dt_ins_hia,105))=year(getdate()))
		--)  
		and desp_org_hia='N' 
		and i.num_proc is null and  (cd_cliente <> Cd_cred_dev_hia or cd_cliente is null)
		and AV.AccountNum is not null
		--and IC.num_proc is null
		and substring(CTA.num_proc_hia,3,3) <> 'REM'
		and S.ID is null
		--and convert(Datetime,dt_ins_hia,105) <= '2016-01-14'
		--	and (M.ID_AX is not null)-- or C.Dt_Criacao <='2016-01-14')
		
		and
		(
			J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
			or
			J.Num_Proc is not null and LBO.Id_TP_Servico = 1		
		)
group by CTA.dc_HIA,CTA.cd_Tp_Tx ,Apelido,AV.TaxGroup,pp.cd_pes,cta.num_proc_hia,AX.cd_ax,
(convert(datetime,dt_ins_hia,105)),dimensao7,num_cpf_cnpj,LEFT(J.Num_Proc,2)
--OPTION(HASH JOIN)
GO
