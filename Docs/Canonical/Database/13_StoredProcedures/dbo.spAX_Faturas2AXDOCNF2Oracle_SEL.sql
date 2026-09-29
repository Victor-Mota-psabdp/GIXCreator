SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spAX_Faturas2AXDOCNF2Oracle_SEL]
as
----1948

Select 	distinct 
	'10001'				Dimensao_1,
	C.Dimensao3			Dimensao_3,
	max(Site_AX)		Dimensao_4,	
	null				Dimensao_2,
	''					Dimensao_5,	
	'BR1'				Dimensao_6,
	Null				Dimensao_7,
	1					Tipo,
	Null				NumeroInternoAX,
	cd_ax				Cd_PessoA_AX,
	'Cust'				AccountType,
	1					Aprovado,
	Null				Aprovado_Por,
	getdate()			Dt_Aprovacao,
	'BR1'				Company,
	FAT.FatDtEmissao	Dt_Documento,
	(CASE when isnull(FAT.FatVendorInvoiceNumber,FAT.FatCod) <> FAT.FatCod then FAT.FatVendorInvoiceNumber Else NULL End)  Numero_Documento,	
	FAT.FatDtVenc		Dt_Vencimento,
	FAT.FatCod			Invoice_Number,
	C.TaxGroup			TaxGroup,
	null				TaxItemGroup,
	FAT.FatDtEmissao	Dt_Ins,
	Null				Dt_Envio_AX,
	Null				Obs_AX,
	1					Ativo,
	Getdate()			Data_Aprovacao,
	PP.CD_PES,
	fat.dt_canc
	--,AXD.invoice_number AXDinvoice_number,XM.ID_AX

	--,FAT.CreatedDate
	--,DATEADD (hour,2,FAT.CreatedDate)
	--,getdate()
	From Fatura  FAT with (nolock)
		Join Pessoa PP with (nolock) on PP.Cd_Pes=FAT.cd_pes
		--left Join Pessoa_LLP P with (nolock) on P.Cd_Pes=PP.Cd_Pes
		--Left Join Grupo GRP with (nolock) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
		Join Pessoa_ATL_AX AX with (nolock) on AX.Cd_Pes = PP.Cd_Pes  and Tipo='C'
		Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =AX.cd_ax
		Join Item_Fat I with (nolock) on I.fatcod=fat.fatcod
		join AX_DOC AXD with (nolock) on AXD.invoice_number=fat.fatcod
		Left join AX_DOC_XML_Oracle XM with (nolock) on AXD.ID_AX = XM.ID_AX and XM.Cancel = 0
		left join vwFaturasValidasArg vwF with (nolock) on I.Num_Proc = vwF.Num_Proc and I.Cd_Tp_Tx = vwf.Cd_Tp_Tx and I.DC = vwF.DC
		left join vwNF_FaturaValidas NF_Fatura with (nolock) on I.Num_Proc = NF_Fatura.Num_Proc and I.Cd_Tp_Tx = NF_Fatura.Cd_Tp_Tx and I.DC = NF_Fatura.DC	
	
		left join Site S with(nolock) on vwf.Ref_Accesso_Arg = S.Cd_Site
		
		left join AX_DOC_Oracle ADO with (nolock) on ADO.invoice_number=fat.fatcod		
		Left Join  vwRPS_Pendente with (nolock) on  FAT.Fatcod=FatcodRPS
		
		left join LLP_BDP_OUT LBO with (nolock) on LBO.Num_Proc_LBO = LEFT(FAT.Fatcod,16)
		left join JOB_HBO J with (nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO 
	Where 
		--FAT.fatcod in ('EAATL202511006BRB','EAATL202511013BRB')  and
		--(
		--	(month(FAT.fatdtemissao)>=month(getdate()-1) and year(FAT.fatdtemissao)=year(getdate()-1))
		--	or (FAT.dt_canc >='12-01-2013' and FAT.fatdtemissao <'12-01-2013') 
		--	or convert(Datetime,FAT.fatdtemissao,105) >= getdate()-5 			
		--)
		FAT.fatdtemissao >='2026-01-01' -- between  '2026-01-01' and '2026-03-31'
		AND ( len(fat.fatcod)=17 or len(fat.fatcod)=15)
		--AND axd.invoice_number is null
		AND ADO.invoice_number is null
		AND XM.ID_AX is null
		AND AX.Cd_Pes  is not null  and FatcodRPS is null
		AND
		(
			J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
			or
			J.Num_Proc is not null and LBO.Id_TP_Servico = 1		
		)

		AND NF_Fatura.ID is null

		AND getdate() > DATEADD (hour,2,isnull(FAT.CreatedDate,getdate() -1))  

		--AND AXD.ID_AX not in (
		--1816444,1818638,1818266,1820912,1816330,1816443,1814917,1814919,1814918,1814920,1818787,1818788
		--,1822182,1822187,1822262,1822263
		--,1828082,1829306	)

	group by
		C.Dimensao3,cd_ax,FAT.FatDtEmissao,FAT.FatDtVenc,fat.FatCod,C.TaxGroup,PP.CD_PES,fat.dt_canc,FAT.FatVendorInvoiceNumber
		--,FAT.CreatedDate
		--,AXD.invoice_number,XM.ID_AX
	--HAVING   2026-03-30     
	--	abs(sum(dbo.valor(abs(I.Vlr_org),I.DC)))>0.00  

	Order by 19


GO
