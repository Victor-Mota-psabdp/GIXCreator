SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu - 6/3 - incluida a sol_pgto_cta_cte_item
--02/04/2018 - 09:41 -incluido o BO
CREATE Procedure [dbo].[spAX_Adto2AX_SEL]
as

Select 
	 distinct 
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	--(
	--Case LEFT(cta.num_proc_hia,2) 
	--	when 'IM' then 221
	--	when 'IA' then 122 
	--	when 'EA' then 112
	--	when 'EM' then 216
	--	when 'EO' then 411
	--	when 'IO' then 421
	--End
	--) 
	NULL Dimensao_2,
	'' Dimensao_5,
	'BR1' Dimensao_6,
	Dimensao7 Dimensao_7,
	3 Tipo,
	nUM_PROC_HIA NumeroInternoAX,
	AX.cd_AX Cd_PessoA_AX,
	'Cust' AccountType,
	1 Aprovado,
	Null Aprovado_Por,
	getdate() Dt_Aprovacao,
	'BR1' Company,
	(convert(Datetime,dt_ins_hia,105)) Dt_Documento,
	Null Numero_Documento,
	max(convert(datetime,dt_prev_pgto_hia,105)) Dt_Vencimento,
	Cta.cd_Tp_Tx +'.'+cta.num_proc_hia Invoice_Number,
	AC.TaxGroup TaxGroup,
	null TaxItemGroup,
	(convert(Datetime,dt_ins_hia,105))   Dt_Ins,
	Null Dt_Envio_AX,
	NUM_PROC_HIA Obs_AX,
	1 Ativo,
	Getdate() Data_Aprovacao,
	Num_proc_hia,
	PP.Cd_PEs,
	Apelido,
	cta.cd_tp_Tx
  From vwcta_Cte cta
	  INNER HASH JOIN Pessoa PP on PP.Cd_Pes=cd_Cred_dev_hia
	  Left HASH JOIN Pessoa_LLP P on P.Cd_Pes=PP.Cd_Pes
	  Left HASH JOIN Grupo GRP on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
	  Left  JOIN Pessoa_ATL_AX AX on (cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and Tipo='C'
	  Left HASH JOIN vwcliente C on C.num_proc=cta.num_proc_hia
	  Left HASH JOIN Item_Fat I on cta.num_proc_hia=I.num_proc and cta.cd_tp_tx=I.cd_tp_tx and Cta.dc_hia=I.dc
	  left HASH Join dbo.AX_XML_Customer_Recebido AC on accountnum=cd_ax
	  INNER HASH Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_tx
	  Left HASH Join vwAXDocs AXDI on AXDI.num_proc=cta.num_proc_hia and AXDI.cd_tp_Tx_atl=cta.cd_tp_Tx and AXDI.dc=cta.dc_hia
	  Left HASH join dbo.sol_pgto_cta_cte_item S on S.num_proc=cta.num_proc_hia and S.cd_tp_Tx=cta.cd_tp_Tx and S.dc=cta.dc_hia
	  left HASH join LLP_BDP_OUT LBO on LBO.Num_Proc_LBO = cta.num_proc_hia
	  left HASH join JOB_HBO J on J.Num_Proc_HBO =LBO.Num_Proc_LBO 
  Where 
		cta.dc_hia='C' and left(cta.cd_Tp_Tx,1) = 'X'and
		(
		 month(convert(Datetime,dt_ins_hia,105))=month(getdate()-1) and 
		 year(convert(Datetime,dt_ins_hia,105))=year(getdate()-1) 
		 or
		 month(convert(Datetime,dt_ins_hia,105))=month(getdate()) and 
		 year(convert(Datetime,dt_ins_hia,105))=year(getdate()) 
		 )
		and ( nome_Tp_Tx like 'Adiantamento%' or nome_Tp_Tx like 'Adiant%') and AXDI.num_proc is null
	and axdi.num_proc is null
	and S.ID is null
	
	and
	(
		J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
		or
		J.Num_Proc is not null and LBO.Id_TP_Servico = 1		
	)
	group by Apelido,AC.TaxGroup,pp.cd_pes,cta.num_proc_hia,AX.cd_ax,(convert(datetime,dt_ins_hia,105)),dimensao7,
	cta.cd_tp_Tx

--Select 
--	 distinct 
--	'10001' Dimensao_1,
--	 '' Dimensao_3,
--		'BRSAO' Dimensao_4,
--	--(
--	--Case LEFT(cta.num_proc_hia,2) 
--	--	when 'IM' then 221
--	--	when 'IA' then 122 
--	--	when 'EA' then 112
--	--	when 'EM' then 216
--	--	when 'EO' then 411
--	--	when 'IO' then 421
--	--End
--	--) 
--	NULL Dimensao_2,
--	'' Dimensao_5,
--	'BR1' Dimensao_6,
--	Dimensao7 Dimensao_7,
--	3 Tipo,
--	nUM_PROC_HIA NumeroInternoAX,
--	AX.cd_AX Cd_PessoA_AX,
--	'Cust' AccountType,
--	1 Aprovado,
--	Null Aprovado_Por,
--	getdate() Dt_Aprovacao,
--	'BR1' Company,
--	(convert(Datetime,dt_ins_hia,105)) Dt_Documento,
--	Null Numero_Documento,
--	max(convert(datetime,dt_prev_pgto_hia,105)) Dt_Vencimento,
--	Cta.cd_Tp_Tx +'.'+cta.num_proc_hia Invoice_Number,
--	AC.TaxGroup TaxGroup,
--	null TaxItemGroup,
--	(convert(Datetime,dt_ins_hia,105))   Dt_Ins,
--	Null Dt_Envio_AX,
--	NUM_PROC_HIA Obs_AX,
--	1 Ativo,
--	Getdate() Data_Aprovacao,
--	Num_proc_hia,
--	PP.Cd_PEs,
--	Apelido,
--	cta.cd_tp_Tx
--  From vwcta_Cte cta
--	  INNER HASH JOIN Pessoa PP on PP.Cd_Pes=cd_Cred_dev_hia
--	  Left HASH JOIN Pessoa_LLP P on P.Cd_Pes=PP.Cd_Pes
--	  Left HASH JOIN Grupo GRP on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
--	  Left  JOIN Pessoa_ATL_AX AX on (cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and Tipo='C'
--	  Left HASH JOIN vwcliente C on C.num_proc=cta.num_proc_hia
--	  Left HASH JOIN Item_Fat I on cta.num_proc_hia=I.num_proc and cta.cd_tp_tx=I.cd_tp_tx and Cta.dc_hia=I.dc
--	  left HASH Join dbo.AX_XML_Customer_Recebido AC on accountnum=cd_ax
--	  INNER HASH Join Tipo_Taxa TT on tt.cd_tp_Tx=cta.cd_tp_tx
--	  Left HASH Join vwAXDocs AXDI on AXDI.num_proc=cta.num_proc_hia and AXDI.cd_tp_Tx_atl=cta.cd_tp_Tx and AXDI.dc=cta.dc_hia
--	  Left HASH join dbo.sol_pgto_cta_cte_item S on S.num_proc=cta.num_proc_hia and S.cd_tp_Tx=cta.cd_tp_Tx and S.dc=cta.dc_hia
--  Where 
--		cta.dc_hia='C' and left(cta.cd_Tp_Tx,1) = 'X'and
--		(
--		 month(convert(Datetime,dt_ins_hia,105))=month(getdate()-1) and 
--		 year(convert(Datetime,dt_ins_hia,105))=year(getdate()-1) 
--		 or
--		 month(convert(Datetime,dt_ins_hia,105))=month(getdate()) and 
--		 year(convert(Datetime,dt_ins_hia,105))=year(getdate()) 
--		 )
--		and ( nome_Tp_Tx like 'Adiantamento%' or nome_Tp_Tx like 'Adiant%') and AXDI.num_proc is null
--	and axdi.num_proc is null
--	and S.ID is null
--	group by Apelido,AC.TaxGroup,pp.cd_pes,cta.num_proc_hia,AX.cd_ax,(convert(datetime,dt_ins_hia,105)),dimensao7,
--	cta.cd_tp_Tx

	
GO
