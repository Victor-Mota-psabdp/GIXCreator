SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[spAXDailyReport_New_Rel] '08-01-215','08-31-215','A'
CREATE  Procedure [dbo].[spAXDailyReport_NEW_Rel] 
	@DataInicial	Datetime,
	@DataFinal		Datetime,
	@Tipo			Varchar(50)
	--@Num_proc Varcahr(16)
AS

If @Tipo = 'Month' 
	Begin
		Set @DataInicial= cast(year(getdate()-1)as varchar(4))+ '-' + cast(month(getdate()-1)as varchar(2))+'-01'
		SEt @DataFinal= getdate()-1
	End
	
If @Tipo = 'Year'
	Begin
		Set @DataInicial= cast(year(getdate()-1)as varchar(4))+ '-01'+'-01'
		SEt @DataFinal=getdate()-1
	End



declare @Temp table(
[System]	varchar(50),
[Type]	varchar(50),
Job	varchar(50),
Transaction_Dt	varchar(50),
Voucher	varchar(50),
AX_Charge_Code	varchar(50),
ATL_Charge_Description	varchar(50),
Ledger_Account	varchar(50),
Currency	varchar(50),
Value	decimal(18,2),
BRL_Value	decimal(18,2),
ATL_Charge_Code	varchar(50),
DC varchar(1),
AX_DOC	varchar(50),
Invoice	varchar(50),
Registered_On	varchar(50)
)

insert @Temp

select 
	'ATL' [System],
	'PURCHOPS' [Type],
	CC.Num_Proc_HIA Job,
	convert(varchar(50),convert(datetime,dt_ins_hia,103),101) [Transaction Dt], 
	''[Voucher],
	(
		CASE  
				When rfi.Doc_Number is null then cd_Ax_Repasse
				else cd_Ax_resultado
		End	
	)
	[AX Charge Code],
	Nome_Tp_Tx_Ing [ATL Charge Description],
	'' [Ledger Account],

	Case 
		when SPG.Vlr_Ref is null then
	Case
		when cc.cd_Tp_moeda='REL' then 'BRL'
		else cc.cd_tp_moeda
	End 
	else
		Case
			when SPG.cd_Tp_moeda='REL' then 'BRL'
			else SPG.cd_tp_moeda
		End
	End 
	Currency,
	Case 
		when SPG.Vlr_Ref is null then
			case
				when CC.DC_hia='D' then cast((abs(Vlr_Org_hia)*-1)-((abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1))	as decimal(10,2))
				else cast(abs(vlr_org_hia)-(abs(vlr_org_hia)*isnull(IRRF,0)/100)as decimal(10,2))
			End
	else
			case
				when CC.DC_hia='D' then cast((abs(Vlr_Ref)*-1)-((abs(Vlr_Ref)*-1)*isnull(Isnull(IRRF,0)/100,1))	as decimal(10,2))
				else cast(abs(Vlr_Ref)-(abs(Vlr_Ref)*isnull(IRRF,0)/100)as decimal(10,2))
			End
	End
	 Value,
	case
		when CC.DC_hia='D' then cast(((abs(Vlr_Org_hia)*-1)-((abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1)))*isnull(par.par_moeda,1) as  decimal(10,2))
		else cast((abs(vlr_org_hia)-(abs(vlr_org_hia)*isnull(Isnull(IRRF,0)/100,1)))*isnull(par.par_moeda,1)as decimal(10,2))
	End  [BRL Value],
	Upper(CC.Cd_Tp_TX) [ATL Charge Code],
	CC.DC_hia,
	AXD.id_AX [AX DOC],
	'' [Invoice],
	'Job Level' [Registered on]
	
From vwcta_cte CC with(nolock)
	INNER HASH JOIN vwcliente C with(nolock) on c.num_proc=CC.num_proc_hia
	Left HASH JOIN vwFaturasValidas F with(nolock) on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cc.cd_tp_Tx
	Left HASH JOIN Pessoa_ATL_AX AXP with(nolock) on AXP.Cd_Pes = CC.cd_cred_Dev_hia and AXP.Tipo = 'F'
	Left HASH JOIN dbo.AX_XML_Vendor_Recebido CR with(nolock) on CR.accountnum =AXP.cd_ax
	Left HASH JOIN Pessoa PS with(nolock) on PS.Cd_Pes = CC.cd_cred_Dev_hia 
	LEft HASH JOIN vwRegistroFinanceiroItem RFI with(nolock) on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx 
	Left HASH JOIN Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
	left HASH JOIN dbo.vwSolPgtoCtaCteAprovadas SPG with(nolock) on SPG.Num_Proc=CC.num_proc_hia and CC.cd_Tp_Tx=SPG.cd_tp_Tx and SPG.dc=CC.dc_hia 
	Left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
	Left HASH JOIN Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and CR.TaxGroup not in ('CUS SER 20','Exempt')
where
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null 
	and desp_org_hia='N' 
	and (CC.DC_hia = 'D' or CC.DC_hia ='C' and CC.Cd_Tp_Tx in ('XY0','XY1','D2D') or CC.DC_hia ='C' and SPG.Num_Proc is not null )	
	and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1')
	and vlr_org_hia <> 0  
	and ((PS.cd_tp_Ativ = 'AGT' and CC.DC_hia = 'D' and AXP.Tipo = 'F') or (PS.cd_tp_Ativ <> 'AGT' and AXP.Tipo = 'F')) 

Union all

select 
	'ATL' [System],
	'PURCHOPS' [Type],
	C.Num_Proc Job,
	convert(varchar(50),convert(datetime,dt_ins_hia,103),101), 
	'' [Voucher],
	(
		CASE  
				When RFI.num_registro is null then cd_Ax_Repasse
				else cd_Ax_resultado
		End	
	)
	[AX Charge Code],
	Nome_Tp_Tx_Ing [ATL Charge Description],
	'' [Ledger Account],
	Case
		when cc.cd_Tp_moeda='REL' then 'BRL'
		else cc.cd_tp_moeda
	End,

	case
		when CC.DC_hia='D' then cast(([dbo].[spRateio_Mas](c.num_proc)*abs(Vlr_Org_hia)*-1)-([dbo].[spRateio_Mas](c.num_proc)*abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1) as decimal(10,2))
		else cast([dbo].[spRateio_Mas](c.num_proc)*abs(vlr_org_hia)-([dbo].[spRateio_Mas](c.num_proc)*abs(Vlr_Org_hia))*isnull(Isnull(IRRF,0)/100,1)as decimal(10,2))
	End Value,
	case
		when CC.DC_hia='D' then cast((([dbo].[spRateio_Mas](c.num_proc)*abs(Vlr_Org_hia)*-1)-([dbo].[spRateio_Mas](c.num_proc)*abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1))*isnull(par.par_moeda,1) as decimal(10,2))
		else cast(([dbo].[spRateio_Mas](CC.num_Proc_hia)*abs(vlr_org_hia)-([dbo].[spRateio_Mas](CC.num_Proc_hia)*abs(Vlr_Org_hia))*isnull(Isnull(IRRF,0)/100,1))*isnull(par.par_moeda,1) as decimal(10,2))
	End [BRL Value],
	Upper(CC.Cd_Tp_TX) [ATL Charge Code],
	CC.DC_hia,
	AXD.id_AX [AX DOC],
	'' [Invoice],
	'Consolidated Level' [Registered on]
	
From vwcta_cte CC with(nolock)
	INNER HASH JOIN vwcliente C with(nolock) on c.master=CC.num_proc_hia
	Left HASH JOIN vwFaturasValidas F with(nolock) on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cc.cd_tp_Tx
	Left HASH JOIN Pessoa_ATL_AX AXP with(nolock) on AXP.Cd_Pes = CC.cd_cred_Dev_hia and AXP.Tipo = 'F'
	Left HASH JOIN dbo.AX_XML_Vendor_Recebido CR with(nolock) on CR.accountnum =AXP.cd_ax
	Left HASH JOIN Pessoa PS with(nolock) on PS.Cd_Pes = CC.cd_cred_Dev_hia 
	LEft HASH JOIN registro_financeiro_item RFI with(nolock) on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left HASH JOIN Registro_Financeiro RF with(nolock) on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left HASH JOIN Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
	Left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
	Left HASH JOIN Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and CR.TaxGroup not in ('CUS SER 20','Exempt')

where	
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and  cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null and desp_org_hia='N' and (CC.DC_hia = 'D' or CC.DC_hia ='C' and CC.Cd_Tp_Tx in ('XY0','XY1','D2D'))	
	and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1')
	and vlr_org_hia <> 0 
	and ((PS.cd_tp_Ativ = 'AGT' and CC.DC_hia = 'D' and AXP.Tipo = 'F')
	or (PS.cd_tp_Ativ <> 'AGT')) 

Union all

SELECT 
	'ATL' [System],
	'PURCHOPS',i.num_proc, 
	convert(varchar(50),convert(datetime,dt_Documento,103),101),
	'' [Voucher], 
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	'' [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when i.DC='D' then Valor*-1
		else Valor
	End [ Value], 
		case
		when i.DC='D' then Valor*paridade*-1
		else Valor*paridade
	End  [BRL Value],
	i.Cd_Tp_TX_ATL,
	i.DC,
	i.id_AX [AX DOC],
	'' [Invoice],
	'Job Level'

FROM 
	AX_DOC A with(nolock)
	INNER HASH JOIN AX_dOC_itEM i with(nolock) ON I.id_Ax=A.id_Ax
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=Cd_tp_Tx_ATL
	--left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_tp_Tx_ATL =AXD.cd_tp_Tx_ATL and AXD.dc=I.dc
WHERE 
	TIPO=2 AND A.DT_CANC IS NOT NULL
	and convert(datetime,convert(varchar,dt_ins,103),105) between @DataInicial and @Datafinal
	and Valor <> 0 and i.cd_tp_Tx <> '000.1'
Union all

SELECT 
	'ATL' [System],
	'PURCHOPS',i.num_proc, 
	convert(varchar(50),convert(datetime,A.dt_canc,103),101),
	'' [Voucher],
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	''  [Ledger Account],
	
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when i.DC='C' then (cast(((abs(Valor)*-1)*isnull(Isnull(abs(Porcentagem),0),1))/100 as decimal (10,2)) +Valor)*-1
		else cast(((abs(Valor)*-1)*isnull(Isnull(abs(Porcentagem),0),1))/100 as decimal(10,2))+valor
	End Value,
	case
		when i.DC='C' then cast(((cast(((abs(Valor)*-1)*isnull(Isnull(abs(Porcentagem),0),1)/100)as  decimal(10,2)) + Valor)*-1)*isnull(paridade,1) as  decimal(10,2))
		else cast((cast((((abs(Valor)*-1)*isnull(Isnull(abs(Porcentagem),0),1))/100)as decimal(10,2))+valor *isnull(paridade,1))  as  decimal(10,2))
	End  [BRL Value],
	I.Cd_Tp_TX_ATL,
	i.DC,
	i.id_AX [AX DOC],
	''[Invoice],
	'Void'
FROM 
	AX_DOC A with(nolock)
	INNER HASH JOIN AX_dOC_itEM i with(nolock) ON I.id_Ax=A.id_Ax
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=Cd_tp_Tx_ATL
	Left HASH JOIN Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=i.TaxGroup and i.TaxGroup not in ('CUS SER 20','Exempt')
	--left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_tp_Tx_ATL =AXD.cd_tp_Tx_ATL and AXD.dc=I.dc
WHERE TIPO=2 and convert(datetime,convert(varchar,A.DT_CANC,103),105) between @DataInicial and @Datafinal
	 and Valor <> 0 and i.cd_tp_Tx <> '000.1'
	 
union all


Select
	'ATL' [System],
	'SALESOPS' Type,
	I.Num_Proc Job,
	convert(varchar(50),convert(datetime,fatdtemissao,103),101),
	'' [Voucher],
	(
		CASE  
				When FI.ID_FAT is null then cd_Ax_repasse 
				else cd_ax_resultado
		End	
	) [AX Charge Code],
	(Nome_Tp_Tx_ing),
	'' [Ledger Account],
	Case
		when I.cd_Tp_moeda='REL' then 'BRL'
		else I.cd_tp_moeda
	End Currency,
	case
		when I.DC='D' then cast(((abs(Vlr_Org)*-1)*isnull(Isnull(abs(IRRF),0)/100,1))as decimal(10,2))-abs(Vlr_Org)
		else (cast((abs(vlr_org)*isnull(abs(IRRF),0)/100)as decimal(10,2))-abs(vlr_org))*-1
	End Value,
	case
		when I.DC='D' then cast(((cast(((abs(Vlr_Org)*-1)*isnull(Isnull(abs(IRRF),0)/100,1))as decimal(10,2))-abs(Vlr_Org)) *I.paridade) as decimal(10,2))

		else 
				cast(((cast((abs(vlr_org)*Isnull(abs(IRRF),0)/100)as decimal(10,2)) - abs(vlr_org))*I.paridade) as decimal(10,2)) *-1
	End  [BRL Value],	
	Upper(TT.cd_Tp_Tx) [ATL Charge Code],
	I.DC,
	AXD.id_AX [AX DOC],
	'' [Invoice],
	'Job Level'
From
	Fatura F with(nolock)
	INNER HASH JOIN Item_Fat I with(nolock) on I.fatcod=F.fatcod
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on Tt.cd_tp_Tx=I.cd_tp_Tx
	Left HASH JOIN vwFaturasValidasArg FI with(nolock) on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
	Left HASH JOIN Tipo_Taxa_AX AX with(nolock) on AX.Cd_Charge_AX = TT.Cd_AX 
	Left HASH JOIN Tipo_TAxa_AX AXPT with(nolock) on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
	Left HASH JOIN PEssoa_ATL_AX PPA with(nolock) on PPA.cd_pes=F.cd_pes and tipo='C'
	Left HASH JOIN dbo.AX_XML_Customer_Recebido AXC with(nolock) on AXC.AccountNum=PPA.cd_ax
	Left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=I.dc 
	Left HASH JOIN Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and AXC.TaxGroup not in ('CUS SER 20','Exempt')
Where 
	convert(Datetime,convert(varchar(10),fatdtemissao,105),103) between @Datainicial and @DataFinal and 
	F.dt_canc is  null
	and len(I.fatcod)=17
	and TT.cd_ax_Resultado <> '000.1'
	and vlr_org <> 0 

Union all

select 
	'ATL' System,
	'SALESOPS' [Type],
	CC.Num_Proc_HIA Job,
	convert(varchar(50),convert(datetime,dt_ins_hia,103),101),
	'' [Voucher], 
	cd_ax_repasse	[AX Charge Code],
	Nome_Tp_Tx_Ing [ATL Charge Description],
	'' [Ledger Account],
	Case
		when cc.cd_Tp_moeda='REL' then 'BRL'
		else cc.cd_tp_moeda
	End Currency,
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1
		else vlr_org_hia
	End Value,
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*isnull(par.par_moeda,1)
		else vlr_org_hia*isnull(par.par_moeda,1)
	End [BRL Value],
	Upper(CC.Cd_Tp_TX) [ATL Charge Code],
	CC.DC_HIA,
	AXD.id_AX [AX DOC],
	'' [Invoice],
	'Job Level' [Registered on]
	
From vwcta_cte CC with(nolock)
	INNER HASH JOIN vwcliente C with(nolock) on c.num_proc=CC.num_proc_hia
	Left HASH JOIN vwFaturasValidas F with(nolock) on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cc.cd_tp_Tx
	Left HASH JOIN Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
	Left HASH JOIN PEssoa_ATL_AX PPA with(nolock) on PPA.cd_pes=CC.cd_cred_Dev_hia and tipo='C'
	Left HASH JOIN dbo.AX_XML_Customer_Recebido AXC with(nolock) on AXC.AccountNum=PPA.cd_ax
	Left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
	Left HASH JOIN Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and AXC.TaxGroup not in ('CUS SER 20','Exempt')
where	
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal and  
	CC.dc_hia='C' and left(CC.cd_Tp_Tx,1) = 'X'
	and F.num_proc is null 
	and desp_org_hia='N'
	and nome_tp_Tx like 'Adian%'
	and TT.cd_ax_Resultado <> '000.1'
	and vlr_org_hia <> 0 
	and PPA.cd_ax is not null


Union all

SELECT 
	'ATL' System,
	'SALESOPS',i.num_proc, 
	convert(varchar(50),convert(datetime,dt_Documento,103),101),
	'' [Voucher],
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	'' [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when I.DC='D' then cast(((abs(Valor)*-1)*isnull(Isnull(abs(IRRF),0)/100,1))as decimal(10,2))-abs(Valor)
		else (cast((abs(Valor)*isnull(abs(IRRF),0)/100)as decimal(10,2))-abs(Valor))*-1
	End Value,
	case
		when I.DC='D' then cast(((cast(((abs(Valor)*-1)*isnull(Isnull(abs(IRRF),0)/100,1))as decimal(10,2))-abs(Valor)) *I.paridade) as decimal(10,2))

		else 
				cast(((cast((abs(Valor)*Isnull(abs(IRRF),0)/100)as decimal(10,2)) - abs(Valor))*I.paridade) as decimal(10,2)) *-1
	End  [BRL Value],	
	I.Cd_Tp_TX_ATL,
	I.DC,
	i.id_AX [AX DOC],
	'' [Invoice],
	'Job Level'
FROM 
	AX_DOC A with(nolock)
	INNER HASH JOIN AX_dOC_itEM i with(nolock) ON I.id_Ax=A.id_Ax
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=Cd_tp_Tx_ATL
	Left HASH JOIN Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=i.TaxGroup and i.TaxGroup not in ('CUS SER 20','Exempt')
--	left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_tp_Tx_ATL =AXD.cd_tp_Tx_ATL and AXD.dc=I.dc 
WHERE 
	TIPO<>2 AND A.dt_Canc IS NOT NULL
	and convert(datetime,convert(varchar,A.dt_ins,103),105) between @DataInicial and @DataFinal
	 and Valor <> 0 and i.cd_tp_Tx <> '000.1'


Union all

SELECT 

	'ATL' System,
	'SALESOPS',I.num_proc, 
	convert(varchar(50),convert(datetime,A.dt_canc,103),101),
	'' Voucher,
	I.CD_Tp_Tx [AX Charge Code],
	Nome_Tp_TX_Ing,
	'' [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when i.DC='C' then (cast(((abs(Valor)*-1)*isnull(Isnull(abs(IRRF),0),1))/100 as decimal (10,2)) +Valor)*-1
		else cast(((abs(Valor)*-1)*isnull(Isnull(abs(IRRF),0),1))/100 as decimal(10,2))+valor
	End Value,
	case
		when i.DC='C' then cast(((cast(((abs(Valor)*-1)*isnull(Isnull(abs(IRRF),0),1)/100) as  decimal(10,2)) + Valor)*-1)*isnull(paridade,1)as  decimal(10,2))
		else cast((cast((((abs(Valor)*-1)*isnull(Isnull(abs(IRRF),0),1))/100) as decimal(10,2))+valor)*isnull(paridade,1) as decimal(10,2))
	End  [BRL Value],
	I.Cd_Tp_TX_ATL,
	i.DC,
	i.ID_AX [AX DOC],
	''[Invoice],
	'Void'

	
FROM 
	AX_DOC A with(nolock)
	INNER HASH JOIN AX_dOC_itEM i with(nolock) ON I.id_Ax=A.id_Ax
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=Cd_tp_Tx_ATL
	Left HASH JOIN Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=i.TaxGroup and A.TaxGroup not in ('CUS SER 20','Exempt')
	---left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_tp_Tx_ATL =AXD.cd_tp_Tx_ATL and AXD.dc=I.dc
WHERE 
	TIPO<>2 and convert(datetime,convert(varchar,A.DT_CANC,103),105) between @Datainicial and @DataFinal 
	 and valor <> 0 and i.cd_tp_Tx <> '000.1'

Union All

Select
	'ATL' System,
	'SALESOPS' Type,
	C.Num_Proc Job,
	convert(varchar(50),convert(datetime,fatdtemissao,103),101),
	'' [Voucher],
	(
		CASE  
				When FI.ID_FAT is null then cd_Ax_repasse 
				else cd_ax_resultado
		End	
	) [AX Charge Code],
	(Nome_Tp_Tx_ing),
	'' [Ledger Account],
	Case
		when I.cd_Tp_moeda='REL' then 'BRL'
		else I.cd_tp_moeda
	End Currency,
	case
		when I.DC='D' then ([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1)-([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1)*isnull(Isnull(IRRF,0)/100,1)
		else [dbo].[spRateio_Mas](C.num_Proc)*abs(vlr_org)-([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org))*isnull(Isnull(IRRF,0)/100,1)
	End Value,
	case
		when I.DC='D' then (([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1)-([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1)*isnull(Isnull(IRRF,0)/100,1))*I.paridade
		else ([dbo].[spRateio_Mas](C.num_Proc)*abs(vlr_org)-([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org))*isnull(Isnull(IRRF,0)/100,1))*I.paridade
	End [BRL Value],
	TT.cd_Tp_Tx [ATL Charge Code],
	I.DC,
	AXD.id_AX [AX DOC],
	'' [Invoice],
	'Consolidated Level'
From
	Fatura F with(nolock)
	INNER HASH JOIN Item_Fat I with(nolock) on I.fatcod=F.fatcod
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on Tt.cd_tp_Tx=I.cd_tp_Tx
	Left HASH JOIN dbo.vwFaturasValidasArg FI with(nolock) on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
	INNER HASH JOIN vwcliente C with(nolock) on C.master=I.num_proc
	Left HASH JOIN Tipo_Taxa_AX AX with(nolock) on AX.Cd_Charge_AX = TT.Cd_AX 
	Left HASH JOIN Tipo_TAxa_AX AXPT with(nolock) on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
	Left HASH JOIN PEssoa_ATL_AX PPA with(nolock) on PPA.cd_pes=F.cd_pes and tipo='C'
	Left HASH JOIN dbo.AX_XML_Customer_Recebido AXC with(nolock) on AXC.AccountNum=PPA.cd_ax
	Left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=I.dc 
	Left HASH JOIN Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and AXC.TaxGroup not in ('CUS SER 20','Exempt')

Where
	convert(Datetime,convert(varchar(10),fatdtemissao,105),103) between @Datainicial and @DataFinal 
	and F.dt_canc is  null
	and len(I.fatcod)=15
	and TT.cd_ax_Resultado <> '000.1'
	and vlr_org <> 0 

union all
select 
	'ATL' [System],
	'SALESOPS' [Type],
	CC.Num_Proc_HIA Job,
	convert(varchar(50),convert(datetime,dt_ins_hia,103),101) [Transaction Dt], 
	''[Voucher],
	(
		CASE  
				When RFI.num_registro is null then cd_Ax_Repasse
				else cd_Ax_resultado
		End	
	)
	[AX Charge Code],
	Nome_Tp_Tx_Ing [ATL Charge Description],
	'' [Ledger Account],
	Case
		when cc.cd_Tp_moeda='REL' then 'BRL'
		else cc.cd_tp_moeda
	End 
	Currency,
	case
		when CC.DC_hia='D' then cast((abs(Vlr_Org_hia)*-1)-((abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1))	as decimal(10,2))
		else cast(abs(vlr_org_hia)-(abs(vlr_org_hia)*isnull(IRRF,0)/100)as decimal(10,2))
	End
	 Value,
	case
		when CC.DC_hia='D' then cast(((abs(Vlr_Org_hia)*-1)-((abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1)))*isnull(par.par_moeda,1) as  decimal(10,2))
		else cast((abs(vlr_org_hia)-(abs(vlr_org_hia)*isnull(Isnull(IRRF,0)/100,1)))*isnull(par.par_moeda,1)as decimal(10,2))
	End  [BRL Value],
	Upper(CC.Cd_Tp_TX) [ATL Charge Code],
	CC.DC_hia,
	'' [AX DOC],
	'' [Invoice],
	'Job Level' [Registered on]
	
From vwcta_cte CC with(nolock)
	INNER HASH JOIN vwcliente C with(nolock) on c.num_proc=CC.num_proc_hia
	Left HASH JOIN vwFaturasValidas F with(nolock) on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cc.cd_tp_Tx and TT.Nome_Tp_Tx not like 'Transf. Pro%'
	--HASH JOIN Pessoa_ATL_AX AXP with(nolock) on AXP.Cd_Pes = CC.cd_cred_Dev_hia and AXP.Tipo = 'C'
	--Left HASH JOIN dbo.AX_XML_Vendor_Recebido CR with(nolock) on CR.accountnum =AXP.cd_ax
	Left HASH JOIN Pessoa PS with(nolock) on PS.Cd_Pes = CC.cd_cred_Dev_hia 
	LEft HASH JOIN registro_financeiro_item RFI with(nolock) on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left HASH JOIN Registro_Financeiro RF with(nolock) on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left HASH JOIN Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
	Left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
	left HASH JOIN dbo.vwSolPgtoCtaCteAprovadas SPG with(nolock) on SPG.Num_Proc=CC.num_proc_hia and CC.cd_Tp_Tx=SPG.cd_tp_Tx and SPG.dc=CC.dc_hia 
	Left HASH JOIN Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group --and CR.TaxGroup not in ('CUS SER 20','Exempt')
where
	AXD.id_AX is null and
	SPG.Vlr_Ref is null and
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  --and cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null 
	and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1')
	and vlr_org_hia <> 0  
	and desp_org_hia='N' 

union all

select 
	'ATL' [System],
	'SALESOPS' [Type],
	CC.Num_Proc_HIA Job,
	convert(varchar(50),convert(datetime,dt_ins_hia,103),101) [Transaction Dt], 
	''[Voucher],
	(
		CASE  
				When RFI.num_registro is null then cd_Ax_Repasse
				else cd_Ax_resultado
		End	
	)
	[AX Charge Code],
	Nome_Tp_Tx_Ing [ATL Charge Description],
	'' [Ledger Account],
	Case
		when cc.cd_Tp_moeda='REL' then 'BRL'
		else cc.cd_tp_moeda
	End 
	Currency,
	case
		when CC.DC_hia='D' then cast((abs(Vlr_Org_hia)*-1)-((abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1))	as decimal(10,2))
		else cast(abs(vlr_org_hia)-(abs(vlr_org_hia)*isnull(IRRF,0)/100)as decimal(10,2))
	End
	 Value,
	case
		when CC.DC_hia='D' then cast(((abs(Vlr_Org_hia)*-1)-((abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1)))*isnull(par.par_moeda,1) as  decimal(10,2))
		else cast((abs(vlr_org_hia)-(abs(vlr_org_hia)*isnull(Isnull(IRRF,0)/100,1)))*isnull(par.par_moeda,1)as decimal(10,2))
	End  [BRL Value],
	Upper(CC.Cd_Tp_TX) [ATL Charge Code],
	CC.DC_hia,
	'' [AX DOC],
	'' [Invoice],
	'Consolidated Level' [Registered on]
	
From vwcta_cte CC with(nolock)
	INNER HASH JOIN vwcliente C with(nolock) on c.Master=CC.num_proc_hia
	Left HASH JOIN vwFaturasValidas F with(nolock) on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	INNER HASH JOIN Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cc.cd_tp_Tx  and TT.Nome_Tp_Tx not like 'Transf. Pro%'
	--HASH JOIN Pessoa_ATL_AX AXP with(nolock) on AXP.Cd_Pes = CC.cd_cred_Dev_hia and AXP.Tipo = 'C'
	--Left HASH JOIN dbo.AX_XML_Vendor_Recebido CR with(nolock) on CR.accountnum =AXP.cd_ax
	Left HASH JOIN Pessoa PS with(nolock) on PS.Cd_Pes = CC.cd_cred_Dev_hia 
	LEft HASH JOIN registro_financeiro_item RFI with(nolock) on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left HASH JOIN Registro_Financeiro RF with(nolock) on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left HASH JOIN Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
	Left HASH JOIN dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
	left HASH JOIN dbo.vwSolPgtoCtaCteAprovadas SPG with(nolock) on SPG.Num_Proc=CC.num_proc_hia and CC.cd_Tp_Tx=SPG.cd_tp_Tx and SPG.dc=CC.dc_hia 
	Left HASH JOIN Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group --and CR.TaxGroup not in ('CUS SER 20','Exempt')
	
where
	AXD.id_AX is null and
	SPG.Vlr_Ref is null and
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  --and cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null 
	and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1')
	and vlr_org_hia <> 0
	and desp_org_hia='N' 
update @Temp set Voucher = Num_Lcto from @Temp T
INNER HASH JOIN dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=T.JOB and T.ATL_Charge_Code=CXA.cd_tp_Tx and CXA.DC_HIA=T.dc
where Registered_On <> 'Void'

update @Temp set Ledger_Account = TTA.CC_Custo from @Temp T
INNER HASH JOIN Tipo_Taxa_AX TTA with(nolock) on 	AX_Charge_Code = TTA.Cd_Charge_AX
where [Type] = 'PURCHOPS'

update @Temp set Ledger_Account = TTA.CC_Receita from @Temp T
INNER HASH JOIN Tipo_Taxa_AX TTA with(nolock) on 	AX_Charge_Code = TTA.Cd_Charge_AX
where [Type] = 'SALESOPS' 

select [System],	
[Type],
Job,
Transaction_Dt,
Voucher,
AX_Charge_Code,
ATL_Charge_Description,
Ledger_Account,	
Currency,	
 Value,	
BRL_Value,	
ATL_Charge_Code,
AX_DOC,
Invoice,
Registered_On from @Temp

GO
