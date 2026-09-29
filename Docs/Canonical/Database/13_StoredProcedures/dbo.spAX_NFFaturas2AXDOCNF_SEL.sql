SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAX_NFFaturas2AXDOCNF_SEL]
as


Select 
	distinct 
	'10001' Dimensao_1,
	 C.Dimensao3 Dimensao_3,
		--'BRSAO' Dimensao_4,
		max(Site_AX) Dimensao_4,	
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
	--(CASE when isnull(FAT.FatVendorInvoiceNumber,FAT.FatCod) <> FAT.FatCod then FAT.FatVendorInvoiceNumber Else NULL End)  Numero_Documento,	
	FAT.FatCod Numero_Documento,	
	FatDtVenc Dt_Vencimento,
	FAT.FatCod Invoice_Number,
	C.TaxGroup TaxGroup,
	null TaxItemGroup,
	FatDtEmissao Dt_Ins,
	Null Dt_Envio_AX,
	Null Obs_AX,
	1 Ativo,
	Getdate() Data_Aprovacao,
	PP.CD_PES,
	fat.dt_canc
  From vwNF_Fatura_ALL  FAT with (nolock)
	Join Pessoa PP with (nolock) on PP.Cd_Pes=FAT.Cd_Pes_Fat
	left Join Pessoa_LLP P with (nolock) on P.Cd_Pes=PP.Cd_Pes
	Left Join Grupo GRP with (nolock) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
	Left Join Pessoa_ATL_AX AX with (nolock) on AX.Cd_Pes = PP.Cd_Pes  and Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with (nolock) on C.accountnum =AX.cd_ax
	left join vwFaturasValidasArg vwF with (nolock) on FAT.Num_Proc = vwF.Num_Proc and FAT.Cd_Tp_Tx = vwf.Cd_Tp_Tx and FAT.DC = vwF.DC
	left join Site S with(nolock) on vwf.Ref_Accesso_Arg = S.Cd_Site
	left join AX_DOC_Oracle AXD with (nolock) on AXD.invoice_number=fat.fatcod
	Left Join  vwRPS_Pendente with (nolock) on  FAT.Fatcod=FatcodRPS
		
	left join LLP_BDP_OUT LBO with (nolock) on LBO.Num_Proc_LBO = LEFT(FAT.Fatcod,16)
	left join JOB_HBO J with (nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO 
  Where
	--FAT.fatcod in ('90172726','90172520','90172505','90172518') and
	--FAT.fatcod in ('90175146','90174869') and
	--FAT.fatcod = '90175167' and
	 --FAT.fatcod not in ('90174638') and
	 --FAT.FatDtEmissao between '2026-01-01'  and '2026-01-31' -- AND
	  FAT.FatDtEmissao >= '2026-01-01'
	----FAT.ID in (173762,173753,174388,174392) and
	--(
	--	(month(FAT.FatDtEmissao)>=month(getdate()-2) and year(FAT.FatDtEmissao)=year(getdate()-2))
	--	or (FAT.dt_canc >='12-01-2013' and FAT.FatDtEmissao <'12-01-2013') 
	--	or convert(Datetime,FAT.FatDtEmissao,105) >= '2026-01-01' 			
	--)	
	and axd.invoice_number is null
	and AX.Cd_Pes  is not null  and FatcodRPS is null
	and
	(
		J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
		or
		J.Num_Proc is not null and LBO.Id_TP_Servico = 1		
	)	
group by
	 C.Dimensao3,cd_ax,FAT.FatDtEmissao,FAT.FatDtVenc,FAT.FatCod,C.TaxGroup,PP.CD_PES,FAT.dt_canc,FAT.FatVendorInvoiceNumber
Order by
	22
	

GO
