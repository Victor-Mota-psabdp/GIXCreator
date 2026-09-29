SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spAX_Debitos2AXDOC_DocRegister_SEL]
as



Select 
	 distinct 
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	(

	Case LEFT(cta.num_proc_hia,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
		
	
	End
	) Dimensao_2,
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
	num_cpf_cnpj
	
	
	

  From vwcta_Cte cta
  Join Pessoa PP on PP.Cd_Pes=cd_Cred_dev_hia
  Left Join Pessoa_LLP P on P.Cd_Pes=PP.Cd_Pes
  Left Join Grupo GRP on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
  Left Join Pessoa_ATL_AX AX on (cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and Tipo='F'

  Left Join vwcliente C on C.num_proc=cta.num_proc_hia
  Left Join Item_Fat I on cta.num_proc_hia=I.num_proc and cta.cd_tp_tx=I.cd_tp_tx and Cta.dc_hia=I.dc
 left  Join dbo.AX_XML_Vendor_Recebido AV on accountnum=cd_ax
	Left Join Ax_Doc_ITem IC on IC.num_proc=cta.num_proc_hia and IC.cd_tp_Tx_ATL=cta.cd_Tp_Tx and IC.Dc=cta.dc_hia
  Where 
		cta.dc_hia='D' ---and left(cta.cd_Tp_Tx,1)= 'X'
--		and AX_GRUPO is not null
		and convert(Datetime,dt_ins_hia,105) between '08-01-2013' and '10-25-2013'
		and desp_org_hia='N' --and num_proc_hia='IMVIX201304035'
		and i.num_proc is null and  (cd_cliente <> Cd_cred_dev_hia or cd_cliente is null)
		--and cta.num_proc_hia='IMEXO201307002BR'
	--	and left(cta.num_proc_hia,2)='IM'
		---and ax.cd_ax is null
		--and Cta.cd_tp_Tx='CTD'
		and len(cta.num_proc_hia)=16
		and IC.num_proc is null
		and cta.num_proc_hia in 
		(
select distinct numerointernoax From ax_doc  A
Left Join ax_doc_item I on I.id_Ax=A.id_ax

where I.id_Ax is null
)
	group by Apelido,AV.TaxGroup,pp.cd_pes,cta.num_proc_hia,AX.cd_ax,(convert(datetime,dt_ins_hia,105)),dimensao7,num_cpf_cnpj
	
GO
