SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido o BO - 02/04/2018 - 10:08
--11/05/2016 Alterado por Erbson - Envio do Site na Dimensão 4
CREATE  Procedure [dbo].[spAX_Faturas2AXDOCNF_SEL_DEBUG]
as
--1948

Select 
	distinct 
	'10001' Dimensao_1,
	 C.Dimensao3 Dimensao_3,
		--'BRSAO' Dimensao_4,
		max(Site_AX) Dimensao_4,
	--(
	--Case LEFT(fat.fatcod,2) 	
	--	when 'IM' then 221
	--	when 'IA' then 122 
	--	when 'EA' then 112
	--	when 'EM' then 216
	--	when 'EO' then 411
	--	when 'IO' then 421
	--	when 'BO' then 
	--	(case LEFT(J.Num_Proc,2) 
	--		when 'IM' then 221
	--		when 'IA' then 122 
	--		when 'EA' then 112
	--		when 'EM' then 216
	--		when 'EO' then 411
	--		when 'IO' then 421
	--		else 800
	--	End)
	--End
	--) Dimensao_2,
	null Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	Null Dimensao_7,
	1 Tipo,
	Null NumeroInternoAX,
	cd_ax Cd_PessoA_AX,
	'Cust' AccountType,
	1 Aprovado,
	Null Aprovado_Por,
	getdate() Dt_Aprovacao,
	'BR1' Company,
	FatDtEmissao Dt_Documento,
	Null Numero_Documento,
	FatDtVenc Dt_Vencimento,
		fat.FatCod Invoice_Number,
	C.TaxGroup TaxGroup,
	null TaxItemGroup,
	FatDtEmissao Dt_Ins,
	Null Dt_Envio_AX,
	Null Obs_AX,
	1 Ativo,
	Getdate() Data_Aprovacao,PP.CD_PES,
	fat.dt_canc
  From Fatura  FAT with (nolock)
	Join Pessoa PP with (nolock) on PP.Cd_Pes=FAT.cd_pes
	left Join Pessoa_LLP P with (nolock) on P.Cd_Pes=PP.Cd_Pes
	Left Join Grupo GRP with (nolock) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
	Left Join Pessoa_ATL_AX AX with (nolock) on AX.Cd_Pes = PP.Cd_Pes  and Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =AX.cd_ax
	Join Item_Fat I with (nolock) on I.fatcod=fat.fatcod
	left join vwFaturasValidasArg vwF with (nolock) on I.Num_Proc = vwF.Num_Proc and I.Cd_Tp_Tx = vwf.Cd_Tp_Tx and I.DC = vwF.DC
	left join Site S with(nolock) on vwf.Ref_Accesso_Arg = S.Cd_Site
	left join ax_doc AXD with (nolock) on AXD.invoice_number=fat.fatcod
	Left Join  vwRPS_Pendente with (nolock) on  FAT.Fatcod=FatcodRPS
		
	left join LLP_BDP_OUT LBO with (nolock) on LBO.Num_Proc_LBO = LEFT(FAT.Fatcod,16)
	left join JOB_HBO J with (nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO 
  Where 	
	--	(
	--		(month(fatdtemissao)>=month(getdate()-1) and year(fatdtemissao)=year(getdate()-1))
	--		or (FAT.dt_canc >='12-01-2013' and fatdtemissao <'12-01-2013') 
	--		or convert(Datetime,fatdtemissao,105) >= getdate()-5			
	--	)
	--AND 
	--( len(fat.fatcod)=17 or len(fat.fatcod)=15) and
	-- axd.invoice_number is null
	--and AX.Cd_Pes  is not null  and FatcodRPS is null
	--and
	(
		J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
		or
		J.Num_Proc is not null and LBO.Id_TP_Servico = 1		
	)

	and fat.FatCod like 'IAATL202004032BR%'
	
group by
	 C.Dimensao3,cd_ax,FatDtEmissao,FatDtVenc,fat.FatCod,C.TaxGroup,PP.CD_PES,fat.dt_canc

--Select 
--	distinct 
--	'10001' Dimensao_1,
--	 C.Dimensao3 Dimensao_3,
--	max(Site_AX) Dimensao_4,
--	--(
--	--Case LEFT(fat.fatcod,2) 
	
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
--	Null Dimensao_7,
--	1 Tipo,
--	Null NumeroInternoAX,
--	cd_ax Cd_PessoA_AX,
--	'Cust' AccountType,
--	1 Aprovado,
--	Null Aprovado_Por,
--	getdate() Dt_Aprovacao,
--	'BR1' Company,
--	FatDtEmissao Dt_Documento,
--	Null Numero_Documento,
--	FatDtVenc Dt_Vencimento,
--		fat.FatCod Invoice_Number,
--	C.TaxGroup TaxGroup,
--	null TaxItemGroup,
--	FatDtEmissao Dt_Ins,
--	Null Dt_Envio_AX,
--	Null Obs_AX,
--	1 Ativo,
--	Getdate() Data_Aprovacao,PP.CD_PES,
--	fat.dt_canc
--  From Fatura  FAT with (nolock)
--	Join Pessoa PP with (nolock) on PP.Cd_Pes=FAT.cd_pes
--	left Join Pessoa_LLP P with (nolock) on P.Cd_Pes=PP.Cd_Pes
--	Left Join Grupo GRP with (nolock) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
--	Left Join Pessoa_ATL_AX AX with (nolock) on AX.Cd_Pes = PP.Cd_Pes  and Tipo='C'
--	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =AX.cd_ax
--	Join Item_Fat I with (nolock) on I.fatcod=fat.fatcod
--	left join vwFaturasValidasArg vwF with (nolock) on I.Num_Proc = vwF.Num_Proc and I.Cd_Tp_Tx = vwf.Cd_Tp_Tx and I.DC = vwF.DC
--	left join Site S with(nolock) on vwf.Ref_Accesso_Arg = S.Cd_Site
--	left join ax_doc AXD with (nolock) on AXD.invoice_number=fat.fatcod
--	Left Join  vwRPS_Pendente with (nolock) on  FAT.Fatcod=FatcodRPS
--  Where 	
--		(
--			(month(fatdtemissao)>=month(getdate()-1) and year(fatdtemissao)=year(getdate()-1))
--			or (FAT.dt_canc >='12-01-2013' and fatdtemissao <'12-01-2013') 
--			or convert(Datetime,fatdtemissao,105) >= getdate()-5
--			--or FAT.fatcod in ('IACSR201608011BRD')
--			--or FAT.fatcod in ('EOCSR201210005BRA',
--			--	'EOCSR201110003BRB',
--			--	'EOCSR201110001BRB',
--			--	'EOSTB201410003BRA',
--			--	'IMKRY201507019BRB',
--			--	'EMATL201603001BRC')			
--		)
--	AND ( len(fat.fatcod)=17 or len(fat.fatcod)=15)
--	and axd.invoice_number is null
--	and AX.Cd_Pes  is not null  and FatcodRPS is null
--group by
--	 C.Dimensao3,cd_ax,FatDtEmissao,FatDtVenc,fat.FatCod,C.TaxGroup,PP.CD_PES,fat.dt_canc
GO
