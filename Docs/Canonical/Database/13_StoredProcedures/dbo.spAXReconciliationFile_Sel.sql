SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAXReconciliationFile_Sel]
		@DataInicial	Datetime,
		@DataFinal		Datetime
AS


Select 'ATL' Company,
case
	when tipo=2 then 'PURCHOPS'
	else 'SALESOPS'
End
,num_proc,convert(varchar(10),dt_ins,105) [File Date],convert(varchar(10),Dt_Documento,105) [Invoice Date Created],convert(varchar(10),Dt_Documento,105)  [Invoice Date], '' Voucher,
cd_tp_TX [Charge Code],Descricao_ingles [Charge Code Text],I.Account_Number [Ledger Account],
case
	when Moeda='REL' then 'BRL'
	else Moeda
End
Moeda,
dbo.valor(valor,dc),
dbo.valor(valor*paridade,dc),
I.TAXGROUP


fRom 
	AX_DOC_ITem I
	Join AX_DOC A on A.id_Ax=I.id_Ax
	Join Tipo_Taxa_AX AX on AX.cd_Charge_Ax=cd_tp_Tx
Where 
month(dt_ins)=month(getdate()-1) and year(dt_ins)=year(getdate()-1)
and valor <> 0

Union all



Select 'ATL' Company,
case
	when tipo=2 then 'PURCHOPS-Void'
	else 'SALESOPS-Void'
End
,num_proc,convert(varchar(10),dt_canc,105) [File Date],convert(varchar(10),Dt_Documento,105) [Invoice Date Created],convert(varchar(10),Dt_Documento,105)  [Invoice Date], '' Voucher,
cd_tp_TX [Charge Code],Descricao_ingles [Charge Code Text],I.Account_Number [Ledger Account],
case
	when Moeda='REL' then 'BRL'
	else Moeda
End
Moeda,
dbo.valor(valor,dc)*-1,
dbo.valor(valor*paridade,dc)*-1,
I.TAXGROUP


fRom 
	AX_DOC_ITem I
	Join AX_DOC A on A.id_Ax=I.id_Ax
	Join Tipo_Taxa_AX AX on AX.cd_Charge_Ax=cd_tp_Tx
Where 
month(dt_canc)=month(getdate()-1) and year(dt_ins)=year(getdate()-1)
and valor <> 0


/*
union all


Select 'BR1' Company,'SALESOPS',num_proc,convert(varchar(10),dt_ins,105) [File Date],convert(varchar(10),Dt_Documento,105) [Invoice Date Created],convert(varchar(10),Dt_Documento,105)  [Invoice Date], '' Voucher,
'ISS'[Charge Code],cd_tp_TX [Charge Code],I.Account_Number [Ledger Account],
Moeda,dbo.valor(I.valor*(ISS/100),dc)*-1,I.TAXGROUP

fRom 
	AX_DOC_ITem I
	Join AX_DOC A on A.id_Ax=I.id_Ax
	Join Tipo_Taxa_AX AX on AX.cd_Charge_Ax=cd_tp_Tx
	Join Tipo_TAX_AX TX on TX.Cd_Tax_AX=I.TAXGROUP and I.TaxGRoup<>'Exempt'
Where tipo='2'and ISS>0 and dt_envio_ax is not null

union all



Select 'BR1' Company,'SALESOPS',num_proc,convert(varchar(10),dt_ins,105) [File Date],convert(varchar(10),Dt_Documento,105) [Invoice Date Created],convert(varchar(10),Dt_Documento,105)  [Invoice Date], '' Voucher,
'IRRF'[Charge Code],cd_tp_TX [Charge Code],I.Account_Number [Ledger Account],
Moeda,dbo.valor(I.valor*(IRRF/100),dc)*-1,I.TAXGROUP

fRom 
	AX_DOC_ITem I
	Join AX_DOC A on A.id_Ax=I.id_Ax
	Join Tipo_Taxa_AX AX on AX.cd_Charge_Ax=cd_tp_Tx
	Join Tipo_TAX_AX TX on TX.Cd_Tax_AX=I.TAXGROUP and I.TaxGRoup<>'Exempt'
Where tipo='2'and IRRF>0 and dt_envio_ax is not null
*/
GO
