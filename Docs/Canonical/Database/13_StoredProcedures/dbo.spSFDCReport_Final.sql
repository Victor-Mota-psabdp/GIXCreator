SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spSFDCReport_Final

as

select SA.*,SFDC_ID,HAWB [House BL/AWB], MAWB [Master BL/AWB], Intl_Ref [INTL REF], replace(dbo.fBusca_TipoDocCliente('N',[JOB Number],1),';','-') [PO Number],replace(dbo.fBusca_TipoDocCliente('N',[JOB Number],1),';','-') [Sales Order  Number], IC_Number From TMP_Saida_SFDC SA 
LEft Join SFDC S on S.Num_Proc =  [Job Number] and S.Charge_Code =   [ATL Charge Code] and [Debit/Credit] = D_C and SA.[BDP Charge Dt]=BDPCharge_Dt
Join vwHouse_Imp H on H.Num_Proc = [Job Number] 

where
/*
[BDP Charge Dt] between '2015-09-20' and '2015-10-02'
OR
 [BDP Invoice Dt]  between '2015-09-20' and '2015-10-02'
or
 [BDP Invoice Dt]  between '2015-09-20' and '2015-10-02'
 or
   [Cash Application Dt] between '2015-09-20' and '2015-10-02'
   or
  */
   [Void Dt] is null 
   
   union 

select SA.*,SFDC_ID,HAWB [House BL/AWB], MAWB [Master BL/AWB], Intl_Ref [INTL REF], replace(dbo.fBusca_TipoDocCliente('N',[JOB Number],1),';','-') [PO Number],replace(dbo.fBusca_TipoDocCliente('N',[JOB Number],1),';','-') [Sales Order  Number], IC_Number From TMP_Saida_SFDC SA 
LEft Join SFDC S on S.Num_Proc =  [Job Number] and S.Charge_Code =   [ATL Charge Code] and [Debit/Credit] = D_C and SA.[BDP Charge Dt]=BDPCharge_Dt
Join vwHouse_exp H on H.Num_Proc = [Job Number] 

where
/*
[BDP Charge Dt] between '2015-09-20' and '2015-10-02'
OR
 [BDP Invoice Dt]  between '2015-09-20' and '2015-10-02'
or
 [BDP Invoice Dt]  between '2015-09-20' and '2015-10-02'
 or
   [Cash Application Dt] between '2015-09-20' and '2015-10-02'
   or
  */
   [Void Dt] is null 
/*   

Union 

select  case 
		when DC_CC = 'C' then 'SALESOP'
		else 'PURCHARSEOP'
		End Type,
		P.cd_ax CustomerVendorAX,
		Num_Proc_CC JobNumber,
		CONVERT(datetime,C.dt_ins,105)BDPChargeDt,
		Null BDPInvoiceDt,
		Null NotaFiscalNumber,
		null InvoiceNumber,
		Null GLAccount,
		ChargeListAXPT.Cd_Charge_AX ,
		c.cd_Tp_tx,
		Nome_Tp_Tx_Ing,
		Cd_Tp_Moeda,
		DC_CC,
		Vlr_Org ,
		Null ExchangeRate,
		null BRLAmount,
		null AXIDSent, 
		null CashApplicationDt,
		null CashApplliationReference,
		Nome_Usuario ,
		Nome_raz_Soc ,
		null Consol ,
		C.Data_CC,
		Null ,
		S.SFDC_ID ,
		HAWB [House BL/AWB], MAWB [Master BL/AWB], Intl_Ref [INTL REF], replace(dbo.fBusca_TipoDocCliente('N',Num_Proc_CC ,1),';','-') [PO Number],replace(dbo.fBusca_TipoDocCliente('N',Num_Proc_CC ,1),';','-') [Sales Order  Number] , Null 
	 From Log_Cta_Cte C
Join SFDC S on S.Num_Proc = C.Num_Proc_CC and S.Charge_Code = Cd_Tp_Tx and DC_CC = D_C and AX_SENT_ID is null  and  convert(datetime,C.Dt_Ins ,105)=BDPCharge_Dt
Left Join Pessoa_ATL_AX P with(nolock) on P.Cd_Pes = Cd_Cred_Dev and P.Tipo = 'C' and DC_CC='C' or P.Cd_Pes = Cd_Cred_Dev and P.Tipo = 'V' and DC_CC='D' 
Join Tipo_Taxa ChargeList with(nolock) on ChargeList.Cd_Tp_Tx = c.Cd_Tp_Tx 
	Join Tipo_Taxa_AX ChargeListAXPL with(nolock) on ChargeListAXPL.Cd_Charge_AX = ChargeList.CD_AX_Resultado 
	Join Tipo_Taxa_AX ChargeListAXPT with(nolock) on ChargeListAXPT.Cd_Charge_AX = ChargeList.Cd_AX_Repasse 
	Join Usuario U on U.Cd_Usuario = C.Cd_Usuario 
	Join Pessoa PP on pp.cd_pes=c.Cd_Cred_Dev 
	Join vwHouse_exp H on H.Num_Proc = Num_Proc_CC

where Data_CC > '09-20-2016' and Tp_Oper_CC = 'E'

Union 

select  case 
		when DC_CC = 'C' then 'SALESOP'
		else 'PURCHARSEOP'
		End Type,
		P.cd_ax CustomerVendorAX,
		Num_Proc_CC JobNumber,
		CONVERT(datetime,C.dt_ins,105)BDPChargeDt,
		Null BDPInvoiceDt,
		Null NotaFiscalNumber,
		null InvoiceNumber,
		Null GLAccount,
		ChargeListAXPT.Cd_Charge_AX ,
		c.cd_Tp_tx,
		Nome_Tp_Tx_Ing,
		Cd_Tp_Moeda,
		DC_CC,
		Vlr_Org ,
		Null ExchangeRate,
		null BRLAmount,
		null AXIDSent, 
		null CashApplicationDt,
		null CashApplliationReference,
		Nome_Usuario ,
		Nome_raz_Soc ,
		null Consol ,
		C.Data_CC,
		Null ,
		S.SFDC_ID ,
		HAWB [House BL/AWB], MAWB [Master BL/AWB], Intl_Ref [INTL REF], replace(dbo.fBusca_TipoDocCliente('N',Num_Proc_CC ,1),';','-') [PO Number],replace(dbo.fBusca_TipoDocCliente('N',Num_Proc_CC ,1),';','-') [Sales Order  Number] , Null 
	 From Log_Cta_Cte C
Join SFDC S on S.Num_Proc = C.Num_Proc_CC and S.Charge_Code = Cd_Tp_Tx and DC_CC = D_C and AX_SENT_ID is null  and  convert(datetime,C.Dt_Ins ,105)=BDPCharge_Dt
Left Join Pessoa_ATL_AX P with(nolock) on P.Cd_Pes = Cd_Cred_Dev and P.Tipo = 'C' and DC_CC='C' or P.Cd_Pes = Cd_Cred_Dev and P.Tipo = 'V' and DC_CC='D' 
Join Tipo_Taxa ChargeList with(nolock) on ChargeList.Cd_Tp_Tx = c.Cd_Tp_Tx 
	Join Tipo_Taxa_AX ChargeListAXPL with(nolock) on ChargeListAXPL.Cd_Charge_AX = ChargeList.CD_AX_Resultado 
	Join Tipo_Taxa_AX ChargeListAXPT with(nolock) on ChargeListAXPT.Cd_Charge_AX = ChargeList.Cd_AX_Repasse 
	Join Usuario U on U.Cd_Usuario = C.Cd_Usuario 
	Join Pessoa PP on pp.cd_pes=c.Cd_Cred_Dev 
	Join vwHouse_imp H on H.Num_Proc = Num_Proc_CC

where Data_CC > '09-20-2016' and Tp_Oper_CC = 'E'
*/
OPTION (HASH JOIN)
GO
