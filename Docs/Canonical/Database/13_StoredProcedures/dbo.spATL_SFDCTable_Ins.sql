SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_SFDCTable_Ins 'IAATL201302046BR'

--spATL_SFDCTable_Ins 'EAGRU201601011','30342','1701688',NULL
CREATE Procedure [dbo].[spATL_SFDCTable_Ins] 
@Num_Proc varchar(16),
@IC	bigint,
@IdExc bigint,
@JobSFDCID Varchar(50)
as
--Declare @StartDt Datetime
--DEclare @EndDt Datetime

--Set @StartDt = '2001-01-01'
--Set @EndDt = '2015-12-31'

Declare @CSR_NAME Table --#CSR_Name 
	(
		Num_Proc	varchar(16),
		Name		Varchar(50)
		
	)

SET NOCOUNT ON
Declare @Saida table  
(
  [Type] Varchar(11), --OK
  [Customer/Vendor AX ID] int,
  [Customer/Vendor ATL ID] varchar(20),
  [Customer/Vendor Type] varchar(1), 
  [Job Number]Varchar(16),
  [BDP Charge Dt] Datetime,
  [BDP Invoice Dt] Datetime,
  [Nota Fiscal Number] Varchar(70),--OK
  [Invoice Number] Varchar(70),
  [GL Account] Varchar(35),
  [AX Charge Code] Varchar(50),
  [ATL Charge Code] Varchar(5),
  [Charge Description] Varchar(160),
  [Currency Code] Varchar(3),
  [Debit/Credit] Varchar(1),
  [Amount] Decimal(10,2),
  [Exchange Rate] Decimal(10,6),
  [BRL Amount] Decimal(10,2),
  [AX ID SENT] Varchar(30),
  [Cash Application Dt] Datetime,
  [Cash Application Reference] Varchar(100),
  [Customer/Vendor Name] Varchar(150),
  [Consol] Varchar(20),
  [Void Dt] Datetime,
  [NF Eletronic #] Varchar(30),
  [IC_Number] bigint,
  [JobSFDCID] Varchar(30)
)

insert into @Saida
select 
    Distinct ---Due the multiple vendors
	'SALESOP' [Type],
	C.cd_ax [Customer/Vendor AX ID],
	cta.Cd_Cred_Dev_HIA [Customer/Vendor ATL ID],
	'C' [Customer/Vendor Type],
	CTA.Num_Proc_HIA [Job Number],
	CONVERT(datetime,dt_ins_hia,105) [BDPCharge Date],
	BDPInvoicedata.FatDtEmissao [BDP Invoice Date],
	cast(NotaFiscalData.Numero as varchar(50))  [Nota Fiscal Number],
	BDPInvoiceData.FatCod [Invoice Number],
	Case 
		When NotaFiscalData.Numero IS Not Null Then ChargeListAXPL.CC_Receita --When we have Nota Fiscal - show the P&L GL
		When NotaFiscalData.Numero IS  Null Then ChargeListAXPT.CC_Receita --When we do NOT have Nota Fiscal - show the PT GL
	End
	GL_Account,
	Case 
		When NotaFiscalData.Numero IS Not Null Then ChargeList.CD_AX_Resultado   --When we have Nota Fiscal - show the P&L GL
		When NotaFiscalData.Numero IS  Null Then ChargeList.Cd_AX_Repasse  --When we do NOT have Nota Fiscal - show the PT GL
	End
	[AX Charge Code],
	CTA.Cd_Tp_Tx [ATL Charge Code],
	Nome_Tp_Tx_Ing  [Charge Description],
	CTA.Cd_Tp_Moeda [Currency Code],
	CTA.DC_HIA [Debit/Credit],
	Vlr_Org_HIA [Amount],
	cast(case 
		When Cta.Cd_Tp_Moeda = 'REL' then 1.0000  
	    else BDPInvoiceData.Paridade 
	End as Decimal(10,4))
	[Exchange Rate],
	cast(case 
		When Cta.Cd_Tp_Moeda = 'REL' then Isnull(BDPInvoiceData.Vlr_RS,Vlr_Org_HIA)   
	    else BDPInvoiceData.Vlr_RS
	End as Decimal(10,2))
	 [BRL Amount],
	AXSentID.id_Ax [AX ID SENT],
	CONVERT(datetime,CashApplication.Dt_Pgto_Rcto_HIA,105) [Cash Application Dt],
	CashApplication.Num_Lcto [Cash Application Reference],
	PP.Nome_Raz_Soc [Customer / Supllier Name],
	Null [Consol],
	Null [Void Dt],
	NF.RPS_NFE [Nota Fiscal Eletronic#],
	IC,
	@JobSFDCID [JobSFDCID]
	
from 
	vwcta_Cte cta with(nolock)
	Left Join vwFaturasValidasArg NotaFiscalData with(nolock) on  NotaFiscalData.Num_Proc =cta.Num_Proc_HIA and NotaFiscalData.Cd_Tp_Tx = cta.Cd_Tp_Tx and NotaFiscalData.DC = cta.DC_HIA 
	Left Join vwFaturasValidas BDPInvoiceData with(nolock) on  BDPInvoiceData.Num_Proc =cta.Num_Proc_HIA and BDPInvoiceData.Cd_Tp_Tx = cta.Cd_Tp_Tx and BDPInvoiceData.DC = cta.DC_HIA 
	Left Join vwCXAS  CashApplication with(nolock) on  CashApplication.Num_Proc_hia =cta.Num_Proc_HIA and CashApplication.Cd_Tp_Tx = cta.Cd_Tp_Tx and CashApplication.DC_hia = cta.DC_HIA 
	Left Join vwAXDocs AXSentID with(nolock) on  AXSentID.Num_Proc =cta.Num_Proc_HIA and AXSentID.cd_tp_tx_Atl  = cta.Cd_Tp_Tx and AXSentID.DC = cta.DC_HIA 
	Join Tipo_Taxa ChargeList with(nolock) on ChargeList.Cd_Tp_Tx = cta.Cd_Tp_Tx 
	Join Tipo_Taxa_AX ChargeListAXPL with(nolock) on ChargeListAXPL.Cd_Charge_AX = ChargeList.CD_AX_Resultado 
	Join Tipo_Taxa_AX ChargeListAXPT with(nolock) on ChargeListAXPT.Cd_Charge_AX = ChargeList.Cd_AX_Repasse 
	Join Pessoa_ATL_AX C with(nolock) on C.Cd_Pes = Cd_Cred_Dev_HIA and C.Tipo = 'C'
	Left Join Pessoa_ATL_AX V with(nolock)  on V.Cd_Pes=Cd_Cred_Dev_HIA and V.Tipo='F'
	--Join @CSR_Name CSR on CSR.num_proc = cta.Num_Proc_HIA 
	Join Pessoa PP with(nolock)  on pp.Cd_Pes=Cd_Cred_Dev_HIA
	Left Join Base_Nota_Fiscal NF with(nolock)  on NF.Nota_Fiscal = NotaFiscalData.Numero and NF.Ref_Acesso = NotaFiscalData.Ref_Accesso_Arg 
	
 Where 
	CTA.Num_Proc_HIA =@Num_Proc and 
	(CTA.DC_HIA='C' or  V.cd_ax is null ) 
	AND DESP_ORG_HIA='N'	
	and (ChargeList.CD_AX_Resultado <> '000.1' or ChargeList.Cd_AX_Repasse  <> '000.1')
	and LEN(cta.num_proc_hia)=16 and Vlr_Org_HIA <> 0
	and IC=@IC 



if not exists(select * From @Saida)
Begin
insert into @Saida



select 
	Distinct ---Due the multiple vendors
	'SALESOP' [Type],
	C.cd_ax [Customer/Vendor AX ID],
	cta.Cd_Cred_Dev_HIA [Customer/Vendor ATL ID],
	'C'[Customer/Vendor Type],
	CL.num_proc  [Job Number],
	CONVERT(datetime,dt_ins_hia,105) [BDPCharge Date],
	BDPInvoicedata.FatDtEmissao [BDP Invoice Date],
	cast(NotaFiscalData.Numero as varchar(50))  [Nota Fiscal Number],
	BDPInvoiceData.FatCod [Invoice Number],
	Case 
		When NotaFiscalData.Numero IS Not Null Then ChargeListAXPL.CC_Receita --When we have Nota Fiscal - show the P&L GL
		When NotaFiscalData.Numero IS  Null Then ChargeListAXPT.CC_Receita --When we do NOT have Nota Fiscal - show the PT GL
	End
	GL_Account,
	Case 
		When NotaFiscalData.Numero IS Not Null Then ChargeList.CD_AX_Resultado   --When we have Nota Fiscal - show the P&L GL
		When NotaFiscalData.Numero IS  Null Then ChargeList.Cd_AX_Repasse  --When we do NOT have Nota Fiscal - show the PT GL
	End
	[AX Charge Code],
	CTA.Cd_Tp_Tx [ATL Charge Code],
	Nome_Tp_Tx_Ing  [Charge Description],
	CTA.Cd_Tp_Moeda [Currency Code],
	CTA.DC_HIA [Debit/Credit],
	cast(Vlr_Org_HIA* [dbo].[spRateio_Mas](CL.num_proc) as Decimal(10,2))  [Amount],
	cast(case 
		When Cta.Cd_Tp_Moeda = 'REL' then 1.0000  
	    else BDPInvoiceData.Paridade 
	End as Decimal(10,4))
	[Exchange Rate],
	CAST(
	case 
		When Cta.Cd_Tp_Moeda = 'REL' then Isnull(BDPInvoiceData.Vlr_RS,Vlr_Org_HIA)* [dbo].[spRateio_Mas](CL.num_proc)   
	    else BDPInvoiceData.Vlr_RS* [dbo].[spRateio_Mas](CL.num_proc) 
	End as Decimal(10,2))
	 [BRL Amount],
	AXSentID.id_Ax [AX ID SENT],
	CONVERT(datetime,CashApplication.Dt_Pgto_Rcto_HIA,105) [Cash Application Dt],
	CashApplication.Num_Lcto [Cash Application Reference],
	PP.Nome_Raz_Soc [Customer / Supllier Name],
	CTA.Num_Proc_HIA [Consol],
	Null ,
	NF.RPS_NFE ,
	IC,
	J.SFDCID [JobSFDCID]
	
from 
	vwcta_Cte cta with(nolock)
	Join vwCliente CL with(nolock) on cL.Master=cta.num_proc_hia
	Left Join vwFaturasValidasArg NotaFiscalData with(nolock) on  NotaFiscalData.Num_Proc =cta.Num_Proc_HIA and NotaFiscalData.Cd_Tp_Tx = cta.Cd_Tp_Tx and NotaFiscalData.DC = cta.DC_HIA 
	Left Join vwFaturasValidas BDPInvoiceData with(nolock) on  BDPInvoiceData.Num_Proc =cta.Num_Proc_HIA and BDPInvoiceData.Cd_Tp_Tx = cta.Cd_Tp_Tx and BDPInvoiceData.DC = cta.DC_HIA 
	Left Join vwCXAS  CashApplication with(nolock) on  CashApplication.Num_Proc_hia =cta.Num_Proc_HIA and CashApplication.Cd_Tp_Tx = cta.Cd_Tp_Tx and CashApplication.DC_hia = cta.DC_HIA 
	Left Join vwAXDocs AXSentID with(nolock) on  AXSentID.Num_Proc =cta.Num_Proc_HIA and AXSentID.cd_tp_tx_Atl  = cta.Cd_Tp_Tx and AXSentID.DC = cta.DC_HIA 
	Join Tipo_Taxa ChargeList with(nolock) on ChargeList.Cd_Tp_Tx = cta.Cd_Tp_Tx 
	Join Tipo_Taxa_AX ChargeListAXPL with(nolock) on ChargeListAXPL.Cd_Charge_AX = ChargeList.CD_AX_Resultado 
	Join Tipo_Taxa_AX ChargeListAXPT with(nolock) on ChargeListAXPT.Cd_Charge_AX = ChargeList.Cd_AX_Repasse 
	Join Pessoa_ATL_AX C with(nolock) on C.Cd_Pes = Cd_Cred_Dev_HIA and C.Tipo = 'C'
	Left Join Pessoa_ATL_AX V with(nolock)  on V.Cd_Pes=Cd_Cred_Dev_HIA and V.Tipo='F'
	--Join @CSR_Name CSR on CSR.num_proc = CL.num_proc 
	Join Pessoa PP with(nolock)  on pp.Cd_Pes=Cd_Cred_Dev_HIA
	Left Join Base_Nota_Fiscal NF with(nolock) on NF.Nota_Fiscal = NotaFiscalData.Numero and NF.Ref_Acesso = NotaFiscalData.Ref_Accesso_Arg 
	Join dbo.Job_SFDC J with(nolock) on CL.num_proc=J.num_proc 
 Where 
	CTA.Num_Proc_HIA =@Num_Proc and 
	--CONVERT(datetime,cta.Dt_Ins_HIA,105)  between @StartDt  and @enddt and 
	(CTA.DC_HIA='C' or  V.cd_ax is null ) 
	AND DESP_ORG_HIA='N'	
	and (ChargeList.CD_AX_Resultado <> '000.1' or ChargeList.Cd_AX_Repasse  <> '000.1')
	and LEN(cta.num_proC_hia)=14 and Vlr_Org_HIA <> 0
	--	and cta.num_proc_hia = 'IAVAL201407001BR'
	and IC=@IC 

End
--
--Union All
--Purchase
/*
Union all
--Purchase
select distinct case 
			when A.Tipo=1 OR A.Tipo=3 then 'SALESOP'
				else 'PURCHARSEOP'
		End,
			A.Cd_Pessoa_AX,
			Num_Proc [Job Number],
		    Dt_Documento [BDP Charge Date],
		    Dt_Documento [BDP Invoice Date],
		    Null [Nota Fiscal Number],
		    Invoice_Number ,
		    Account_Number,
		    Item.Cd_Tp_TX,
		    cd_tp_Tx_ATL,
		    Nome_tp_Tx_Ing,
		    
		    ITEM.Moeda,
			Item.DC,

		    CAST(Valor as decimal(10,2)) ,
		    cast(Paridade  as decimal(10,4)),
		      cast(Valor*Paridade as decimal(10,2)),
		      Item.ID_AX,
		      Null,
		      Null,
		      ISNULL(AC.Name,AV.Name),
		      null ,
			  A.dt_canc_ax [Void Date],
			  Null ,
			  0
		    
			
   from AX_Doc_Item Item
Join AX_DOC A on A.ID_AX=ITEM.ID_AX
--Join Pessoa_ATL_AX AX on (AX.cd_ax=Cd_Pessoa_AX and A.AccountType='Vend' and AX.Tipo='F' or AX.cd_ax=Cd_Pessoa_AX and A.AccountType='Cust' and AX.Tipo='C')
--Join Pessoa PP on pp.Cd_Pes=AX.Cd_Pes
Join Tipo_Taxa TT on Tt.Cd_Tp_Tx=ITem.cd_tp_Tx_ATL 
Left Join dbo.AX_XML_Customer_Recebido AC on (A.AccountType='Cust' and AC.AccountNum = A.Cd_Pessoa_AX  )
Left Join dbo.AX_XML_Vendor_Recebido AV on (A.AccountType='Vend' and AV.AccountNum = A.Cd_Pessoa_AX)

where Item.Num_Proc = @Num_Proc--dt_canc_ax >='01-01-2016'  
	and ITem.Cd_Tp_TX <> '000.1' 
--and Item.Num_Proc = 'IAVAL201407001BR'
*/
if not exists(select * From @Saida)
Begin
insert into @Saida



select 
	Distinct  
 ---Due the multiple vendors
	'PURCHARSEOP' [Type],
	V.cd_ax [Customer/Vendor AX ID],
	cta.Cd_Cred_Dev_HIA [Customer/Vendor ATL ID],
	'F'[Customer/Vendor Type],
	CTA.Num_Proc_HIA [Job Number],
	CONVERT(datetime,dt_ins_hia,105) [BDPCharge Date],
	ISNULL(SupplierInvoice.Invoice_dt,CONVERT(datetime,dt_ins_hia,105))	 [BDP Invoice Date],
	SupplierInvoice.Doc_nUMBER 	   [Nota Fiscal Number],
	 CAST(AXSentID.id_Ax as Varchar(50))  [Invoice Number],
	Case 
		When SupplierInvoice.Doc_nUMBER iS Not Null Then ChargeListAXPL.CC_Custo  --When we have Nota Fiscal - show the P&L GL
		When SupplierInvoice.Doc_nUMBER iS  Null Then ChargeListAXPT.CC_Custo --When we do NOT have Nota Fiscal - show the PT GL
	End
	GL_Account,
	Case 
		When SupplierInvoice.Doc_nUMBER IS Not Null Then ChargeList.CD_AX_Resultado   --When we have Nota Fiscal - show the P&L GL
		When SupplierInvoice.Doc_nUMBER IS  Null Then ChargeList.Cd_AX_Repasse  --When we do NOT have Nota Fiscal - show the PT GL
	End
	[AX Charge Code],
	CTA.Cd_Tp_Tx [ATL Charge Code],
	Nome_Tp_Tx_Ing  [Charge Description],
	CTA.Cd_Tp_Moeda [Currency Code],
	CTA.DC_HIA [Debit/Creditor],
	Vlr_Org_HIA [Amount],
	CAST([dbo].[VerParidade](dt_ins_hia,cta.cd_tp_moeda,'OFC') as Decimal(10,4)) [Exchange Rate],
	
	 cast([dbo].[VerParidade](dt_ins_hia,cta.cd_tp_moeda,'OFC')*Vlr_Org_HIA as Decimal(10,2)) [BRL Amount],
	AXSentID.id_Ax [AX ID SENT],
	CONVERT(datetime,CashApplication.Dt_Pgto_Rcto_HIA,105) [Cash Application Dt],
	CashApplication.Num_Lcto [Cash Application Reference],
	PP.Nome_Raz_Soc [Customer / Supllier Name],
	Null [Consol],null,null,
	IC,
	@JobSFDCID [JobSFDCID]
		
	
from 
	vwcta_Cte cta with(nolock)
	Left Join vwRegistroFinanceiroItem SupplierInvoice with(nolock) on  SupplierInvoice.Num_Proc =cta.Num_Proc_HIA and SupplierInvoice.Cd_Tp_Tx = cta.Cd_Tp_Tx and SupplierInvoice.DC = cta.DC_HIA 
	--Left Join vwFaturasValidas BDPInvoiceData with(nolock) on  BDPInvoiceData.Num_Proc =cta.Num_Proc_HIA and BDPInvoiceData.Cd_Tp_Tx = cta.Cd_Tp_Tx and BDPInvoiceData.DC = cta.DC_HIA 
	Left Join vwCXAS  CashApplication with(nolock) on  CashApplication.Num_Proc_hia =cta.Num_Proc_HIA and CashApplication.Cd_Tp_Tx = cta.Cd_Tp_Tx and CashApplication.DC_hia = cta.DC_HIA 
	Left Join vwAXDocs AXSentID with(nolock) on  AXSentID.Num_Proc =cta.Num_Proc_HIA and AXSentID.cd_tp_tx_Atl  = cta.Cd_Tp_Tx and AXSentID.DC = cta.DC_HIA 
	Left Join Tipo_Taxa ChargeList with(nolock) on ChargeList.Cd_Tp_Tx = cta.Cd_Tp_Tx 
	Left Join Tipo_Taxa_AX ChargeListAXPL with(nolock) on ChargeListAXPL.Cd_Charge_AX = ChargeList.CD_AX_Resultado 
	Left Join Tipo_Taxa_AX ChargeListAXPT with(nolock) on ChargeListAXPT.Cd_Charge_AX = ChargeList.Cd_AX_Repasse 
	Join Pessoa_ATL_AX V  with(nolock) on V.Cd_Pes=Cd_Cred_Dev_HIA and V.Tipo='F'
	Left Join Pessoa_ATL_AX C with(nolock) on C.Cd_Pes = Cd_Cred_Dev_HIA and C.Tipo = 'C'
	--Join @CSR_Name CSR on CSR.num_proc = cta.Num_Proc_HIA 
	Join Pessoa PP  with(nolock) on pp.Cd_Pes=Cd_Cred_Dev_HIA 
 Where 
	 Cta.Num_Proc_HIA = @Num_Proc and
	 DESP_ORG_HIA='N' AND 
	--CONVERT(datetime,cta.Dt_Ins_HIA,105) between @StartDt  and @EndDt and 
	(cTA.DC_HIA='D' or  C.cd_ax is null  )
	
	and LEN(cta.Num_Proc_HIA)=16	
	and (ChargeList.CD_AX_Resultado <> '000.1' or ChargeList.Cd_AX_Repasse  <> '000.1')
	and Vlr_Org_HIA <> 0
	--and cta.Num_Proc_HIA = 'IMGVD201507063BR'
	and IC=@IC 
End

if not exists(select * From @Saida)
Begin



insert into @Saida



select 
Distinct ---Due the multiple vendors
	
	'PURCHARSEOP' [Type],
	V.cd_ax [Customer/Vendor AX ID],
	cta.Cd_Cred_Dev_HIA [Customer/Vendor ATL ID],
	'F' [Customer/Vendor Type],
	CL.Num_PRoc [Job Number],
	CONVERT(datetime,dt_ins_hia,105) [BDPCharge Date],
	ISNULL(SupplierInvoice.Invoice_dt,CONVERT(datetime,dt_ins_hia,105))	 [BDP Invoice Date],
	SupplierInvoice.Doc_nUMBER 	   [Nota Fiscal Number],
	 CAST(AXSentID.id_Ax as Varchar(50))  [Invoice Number],
	Case 
		When SupplierInvoice.Doc_nUMBER iS Not Null Then ChargeListAXPL.CC_Custo  --When we have Nota Fiscal - show the P&L GL
		When SupplierInvoice.Doc_nUMBER iS  Null Then ChargeListAXPT.CC_Custo --When we do NOT have Nota Fiscal - show the PT GL
	End
	GL_Account,
	Case 
		When SupplierInvoice.Doc_nUMBER IS Not Null Then ChargeList.CD_AX_Resultado   --When we have Nota Fiscal - show the P&L GL
		When SupplierInvoice.Doc_nUMBER IS  Null Then ChargeList.Cd_AX_Repasse  --When we do NOT have Nota Fiscal - show the PT GL
	End
	[AX Charge Code],
	CTA.Cd_Tp_Tx [ATL Charge Code],
	Nome_Tp_Tx_Ing  [Charge Description],
	CTA.Cd_Tp_Moeda [Currency Code],
	CTA.DC_HIA [Debit/Creditor],
	CAST(Vlr_Org_HIA*[dbo].[spRateio_Mas](CL.Num_PRoc)  as Decimal(10,2))  [Amount],
	CAST([dbo].[VerParidade](dt_ins_hia,cta.cd_tp_moeda,'OFC') as decimal(10,4)) [Exchange Rate],
	cast([dbo].[VerParidade](dt_ins_hia,cta.cd_tp_moeda,'OFC')*Vlr_Org_HIA*[dbo].[spRateio_Mas](CL.Num_PRoc)  as Decimal(10,2))   [BRL Amount],
	AXSentID.id_Ax [AX ID SENT],
	CONVERT(datetime,CashApplication.Dt_Pgto_Rcto_HIA,105) [Cash Application Dt],
	CashApplication.Num_Lcto [Cash Application Reference],
	PP.Nome_Raz_Soc [Customer / Supllier Name],
	CL.Master  [Consol],null,null ,
	IC,
	J.SFDCID [JobSFDCID]
from 
	vwcta_Cte cta with(nolock)
	Join vwCliente CL with(nolock) on CL.Master=cta.Num_Proc_HIA 
	Left Join vwRegistroFinanceiroItem SupplierInvoice with(nolock) on  SupplierInvoice.Num_Proc =cta.Num_Proc_HIA and SupplierInvoice.Cd_Tp_Tx = cta.Cd_Tp_Tx and SupplierInvoice.DC = cta.DC_HIA 
	--Left Join vwFaturasValidas BDPInvoiceData with(nolock) on  BDPInvoiceData.Num_Proc =cta.Num_Proc_HIA and BDPInvoiceData.Cd_Tp_Tx = cta.Cd_Tp_Tx and BDPInvoiceData.DC = cta.DC_HIA 
	Left Join vwCXAS  CashApplication with(nolock) on  CashApplication.Num_Proc_hia =cta.Num_Proc_HIA and CashApplication.Cd_Tp_Tx = cta.Cd_Tp_Tx and CashApplication.DC_hia = cta.DC_HIA 
	Left Join vwAXDocs AXSentID with(nolock) on  AXSentID.Num_Proc =cta.Num_Proc_HIA and AXSentID.cd_tp_tx_Atl  = cta.Cd_Tp_Tx and AXSentID.DC = cta.DC_HIA 
	Left Join Tipo_Taxa ChargeList with(nolock) on ChargeList.Cd_Tp_Tx = cta.Cd_Tp_Tx 
	Left Join Tipo_Taxa_AX ChargeListAXPL with(nolock) on ChargeListAXPL.Cd_Charge_AX = ChargeList.CD_AX_Resultado 
	Left Join Tipo_Taxa_AX ChargeListAXPT with(nolock) on ChargeListAXPT.Cd_Charge_AX = ChargeList.Cd_AX_Repasse 
	Join Pessoa_ATL_AX V  with(nolock) on V.Cd_Pes=Cd_Cred_Dev_HIA and V.Tipo='F'
	Left Join Pessoa_ATL_AX C  with(nolock) on C.Cd_Pes = Cd_Cred_Dev_HIA and C.Tipo = 'C'
	--Join @CSR_Name CSR   on CSR.num_proc = CL.num_proc 
	Join Pessoa PP  with(nolock) on pp.Cd_Pes=Cd_Cred_Dev_HIA 
	--Join ATL_Master_Per A on A.num_proc=CL.num_proc 
	Join dbo.Job_SFDC J with(nolock) on CL.num_proc=J.num_proc 
 Where 
	Cta.Num_Proc_HIA = @Num_Proc and
	DESP_ORG_HIA='N' AND 
	--CONVERT(datetime,cta.Dt_Ins_HIA,105) between @StartDt  and @EndDt and 
	(cTA.DC_HIA='D' or  C.cd_ax is null  )
	and LEN(cta.Num_Proc_HIA)=14	 and Vlr_Org_HIA <> 0
	--and (ChargeList.CD_AX_Resultado <> '000.1' or ChargeList.Cd_AX_Repasse  <> '000.1')
	--and CL.num_proc = 'IMGVD201507063BR'
	and IC=@IC 
--OPTION (HASH JOIN)
End

if not exists(select * from @Saida)

	Begin
		Update Exchange_Cta_Cte set Dt_Envio='01-01-2001' where ID=@IdExc
	
	End

If SUBSTRING(@Num_Proc,1,1)= 'I'
	Begin
		select S.[Type],
				S.[Customer/Vendor AX ID],
				S.[Job Number],
				S.[BDP Charge Dt],
				S.[BDP Invoice Dt],
				S.[Nota Fiscal Number],
				S.[Invoice Number],
				S.[GL Account],
				S.[AX Charge Code],
				S.[ATL Charge Code],
				UPPER(S.[Charge Description]) [Charge Description],
				(case when S.[Currency Code] = 'REL' then 'BRL' else S.[Currency Code] end) [Currency Code],
				S.[Debit/Credit],
				S.[Amount],
				Isnull(S.[Exchange Rate],0) [Exchange Rate],
				Isnull(S.[BRL Amount],0) [BRL Amount],
				S.[AX ID SENT],
				S.[Cash Application Dt],
				S.[Cash Application Reference],
				UPPER(S.[Customer/Vendor Name])[Customer/Vendor Name],
				S.[Consol],
				S.[Void Dt],
				S.[NF Eletronic #],
				S.[IC_Number],
				UPPER(U.Nome_Usuario) Name, 
				UPPER(dbo.FRemoveCaracteresEspeciais(HAWB)) [House BL/AWB], 
				UPPER(dbo.FRemoveCaracteresEspeciais(MAWB)) [Master BL/AWB], 
				Intl_Ref [INTL REF], 
				UPPER(replace(dbo.fBusca_TipoDocCliente('N',@Num_Proc,1),';','-')) [PO Number],
				UPPER(replace(dbo.fBusca_TipoDocCliente('N',@Num_Proc,1),';','-')) [Sales Order Number], 
				F.SFDCID, 
				A.SFDCID [Account],
				JobSFDCID [JobSFDCID],
				(case when S.[Debit/Credit] = 'C' then S.[Amount] else 0 end) RevenueValue,
				(case when S.[Debit/Credit] = 'C' then Isnull(S.[BRL Amount],0) else 0 end) RevenueBRL,
				(case when S.[Debit/Credit] = 'D' then S.[Amount] else 0 end) ExpenseValue,
				(case when S.[Debit/Credit] = 'D' then Isnull(S.[BRL Amount],0) else 0 end) ExpenseBRL,
				(case when S.[Debit/Credit] = 'D' then Isnull(S.[BRL Amount],0) else 0 end) ExpenseBRL,
				(case when right(S.[AX Charge Code],1)='1' then 'Y' else 'N' end) PT,
				NULL ControlNumber,
				NULL StatutoryInvoice,
				(case when S.[Void Dt] IS NULL then 'N' else 'Y' end) VoidCheck,
				(case when S.[Cash Application Dt] IS NULL then 'N' else 'Y' end) PayCheck,
				NULL CollectionStatus,
				@IdExc IDExc
			from 
				vwHouse_Imp HOU with(nolock)
				join Usuario U with(nolock) on HOU.Cd_Usuario = U.Cd_Usuario
				join @Saida S on HOU.Num_Proc = S.[Job Number]
				left join Financial_SFDC F with(nolock) on S.[Job Number] = F.Num_Proc and S.[IC_Number] = F.IC  
			--	join Exchange_Cta_Cte FCC on S.[Job Number] = FCC.Num_Proc and  S.[IC_Number] = FCC.IC  and Tipo_Oper in ('I','U')
				join Account_SFDC A with(nolock) on S.[Customer/Vendor AX ID] = A.Cd_AX  and S.[Customer/Vendor ATL ID] = A.cd_Pes and S.[Customer/Vendor Type] = A.Tipo and   A.SFDCID is not null
				--join Job_SFDC J with(nolock) on S.[Job Number] = J.Num_Proc and J.SFDCID is not null
	End
Else	
	Begin

		select S.[Type],
				S.[Customer/Vendor AX ID],
				S.[Job Number],
				S.[BDP Charge Dt],
				S.[BDP Invoice Dt],
				S.[Nota Fiscal Number],
				S.[Invoice Number],
				S.[GL Account],
				S.[AX Charge Code],
				S.[ATL Charge Code],
				UPPER(S.[Charge Description]) [Charge Description],
				(case when S.[Currency Code] = 'REL' then 'BRL' else S.[Currency Code] end) [Currency Code],
				S.[Debit/Credit],
				S.[Amount],
				Isnull(S.[Exchange Rate],0) [Exchange Rate],
				Isnull(S.[BRL Amount],0) [BRL Amount],
				S.[AX ID SENT],
				S.[Cash Application Dt],
				S.[Cash Application Reference],
				UPPER(S.[Customer/Vendor Name])[Customer/Vendor Name],
				S.[Consol],
				S.[Void Dt],
				S.[NF Eletronic #],
				S.[IC_Number],
				UPPER(U.Nome_Usuario) Name, 
				UPPER(dbo.FRemoveCaracteresEspeciais(HAWB)) [House BL/AWB], 
				UPPER(dbo.FRemoveCaracteresEspeciais(MAWB)) [Master BL/AWB], 
				Intl_Ref [INTL REF], 
				UPPER(dbo.FRemoveCaracteresEspeciais(replace(dbo.fBusca_TipoDocCliente('N',@Num_Proc,1),';','-'))) [PO Number],
				UPPER(dbo.FRemoveCaracteresEspeciais(replace(dbo.fBusca_TipoDocCliente('N',@Num_Proc,1),';','-'))) [Sales Order Number], 
				F.SFDCID, 
				A.SFDCID [Account],
				JobSFDCID [JobSFDCID],
				(case 
						when S.[Debit/Credit] = 'C' AND S.[Type]='SALESOP'  then S.[Amount] 
						when S.[Debit/Credit] = 'D' AND S.[Type]='SALESOP'  then S.[Amount]*-1 
						else 0 end
				) RevenueValue,
				(case 
					when S.[Debit/Credit] = 'C' AND S.[Type]='SALESOP' then Isnull(S.[BRL Amount],0) 
					when S.[Debit/Credit] = 'D' AND S.[Type]='SALESOP' then Isnull(S.[BRL Amount],0)*-1 										
					else 0 end
							
					
				) RevenueBRL,
				(
					case 
					when S.[Debit/Credit] = 'D' AND S.[Type]='PURCHARSEOP'  then S.[Amount] 
					 when S.[Debit/Credit] = 'C' AND S.[Type]='PURCHARSEOP'  then S.[Amount]*-1 
					
					else 0 end
				) ExpenseValue,
				(
					case 
						when S.[Debit/Credit] = 'D' and  S.[Type]='PURCHARSEOP' then Isnull(S.[BRL Amount],0) 
						when S.[Debit/Credit] = 'C' AND S.[Type]='PURCHARSEOP'  then S.[Amount]*-1 
				
				else 0 end) ExpenseBRL,
				
				--(case when S.[Debit/Credit] = 'D' then S.[BRL Amount] else 0 end) ExpenseBRL,
				(case when right(S.[AX Charge Code],1)='1' then 'Y' else 'N' end) PT,
				NULL ControlNumber,
				NULL StatutoryInvoice,
				(case when S.[Void Dt] IS NULL then 'N' else 'Y' end) VoidCheck,
				(case when S.[Cash Application Dt] IS NULL then 'N' else 'Y' end) PayCheck,
				NULL CollectionStatus,
				@IdExc IDExc
		from 
				vwHouse_Exp HOU with(nolock)
				join Usuario U with(nolock) on HOU.Cd_Usuario = U.Cd_Usuario
				join @Saida S on HOU.Num_Proc = S.[Job Number]
				left join Financial_SFDC F with(nolock) on S.[Job Number] = F.Num_Proc and S.[IC_Number] = F.IC  
				--join Exchange_Cta_Cte FCC on S.[Job Number] = FCC.Num_Proc and  S.[IC_Number] = FCC.IC  and Tipo_oper in ('I','U')
				join Account_SFDC A with(nolock) on S.[Customer/Vendor AX ID] = A.Cd_AX  and S.[Customer/Vendor ATL ID] = A.cd_Pes and S.[Customer/Vendor Type] = A.Tipo and  A.SFDCID is not null
				--join Job_SFDC J with(nolock) on S.[Job Number] = J.Num_Proc and J.SFDCID is not null
	End
--select * from Job_SFDC
--select * from Account_SFDC
GO
