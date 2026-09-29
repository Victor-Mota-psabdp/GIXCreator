SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[spAXDailyReport_Rel] --[dbo].[spAXDailyReport_Rel] '06-10-215','06-10-215','A'
	@DataInicial	Datetime,
	@DataFinal		Datetime,
	@Tipo			Varchar(50)
	--@Num_proc Varcahr(16)
AS

If @Tipo = 'Month' 
	Begin
		Set @DataInicial= cast(year(getdate()-1)as varchar(4))+ '-' + cast(month(getdate()-1)as varchar(2))+'-01'
		SEt @DataFinal= getdate()-1
		
		--Set @DataInicial= '2014-07-01'
		--SEt @DataFinal= '2014-07-31'
	End
	
If @Tipo = 'Year'
	Begin
		Set @DataInicial= cast(year(getdate()-1)as varchar(4))+ '-01'+'-01'
		SEt @DataFinal=getdate()-1
	End

--Set @DataInicial= cast(year(getdate()-1)as varchar(4))+ '-' + cast(month(getdate()-1)as varchar(2))+'-01'
--SEt @DataFinal=getdate()


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
				When RFI.num_registro is null then cd_Ax_Repasse
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
		/*
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1
		else vlr_org_hia
	End Value,
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*isnull(par.par_moeda,1)
		else vlr_org_hia*isnull(par.par_moeda,1)
	End  [BRL Amount],
	*/
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
	Invoice_AX [Invoice],
	'Job Level' [Registered on]
	
From vwcta_cte CC with(nolock)
	Join vwcliente C with(nolock) on c.num_proc=CC.num_proc_hia
	Left Join vwFaturasValidas F with(nolock) on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cc.cd_tp_Tx
--	Left Join Tipo_Taxa_AX AXR on AX.Cd_Charge_AX = Cd_AX_Resultado 
--	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=cd_Ax_Repasse
	Left Join Pessoa_ATL_AX AXP with(nolock) on AXP.Cd_Pes = CC.cd_cred_Dev_hia and AXP.Tipo = 'F'
	Left Join dbo.AX_XML_Vendor_Recebido CR with(nolock) on CR.accountnum =AXP.cd_ax
	Left Join Pessoa PS with(nolock) on PS.Cd_Pes = CC.cd_cred_Dev_hia 
	LEft Join registro_financeiro_item RFI with(nolock) on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF with(nolock) on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left Join Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
--Adicionado em 27-06-2014
	Left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
	left Join dbo.vwSolPgtoCtaCteAprovadas SPG with(nolock) on SPG.Num_Proc=CC.num_proc_hia and CC.cd_Tp_Tx=SPG.cd_tp_Tx and SPG.dc=CC.dc_hia 
	Left Join Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and CR.TaxGroup not in ('CUS SER 20','Exempt')
	--left Join dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=CC.num_proc_hia and CC.cd_Tp_Tx=CXA.cd_tp_Tx and CXA.DC_HIA=CC.dc_hia 
	--join Tipo_Taxa_AX TTA with(nolock) on 	(CASE When RFI.num_registro is null then cd_Ax_Repasse else cd_Ax_resultado End ) = TTA.Cd_Charge_AX

--Fim em 27-06-2014
where
	AXD.dt_canc is null and
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null 
	and desp_org_hia='N' 
	and (CC.DC_hia = 'D' or CC.DC_hia ='C' and CC.Cd_Tp_Tx in ('XY0','XY1','D2D') or CC.DC_hia ='C' and SPG.Num_Proc is not null )	
	and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1')
	and vlr_org_hia <> 0  
	and ((PS.cd_tp_Ativ = 'AGT' and CC.DC_hia = 'D' and AXP.Tipo = 'F') or (PS.cd_tp_Ativ <> 'AGT' and AXP.Tipo = 'F')) 
--	and @Num_proc = c.num_proc

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
	/*
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*[dbo].[spRateio_Mas](C.num_Proc)
		else vlr_org_hia*[dbo].[spRateio_Mas](C.num_Proc)
	End ,
		case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*[dbo].[spRateio_Mas](C.num_Proc)*isnull(par.par_moeda,1)
		else vlr_org_hia*[dbo].[spRateio_Mas](C.num_Proc)*isnull(par.par_moeda,1)
	End  [BRL Amount],
	*/
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
	Invoice_AX [Invoice],
	'Consolidated Level' [Registered on]
	
From vwcta_cte CC with(nolock)
	Join vwcliente C with(nolock) on c.master=CC.num_proc_hia
	Left Join vwFaturasValidas F with(nolock) on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cc.cd_tp_Tx
	--Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
	--Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
	Left Join Pessoa_ATL_AX AXP with(nolock) on AXP.Cd_Pes = CC.cd_cred_Dev_hia and AXP.Tipo = 'F'
	Left Join dbo.AX_XML_Vendor_Recebido CR with(nolock) on CR.accountnum =AXP.cd_ax
	Left Join Pessoa PS with(nolock) on PS.Cd_Pes = CC.cd_cred_Dev_hia 
	LEft Join registro_financeiro_item RFI with(nolock) on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF with(nolock) on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left Join Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
	--Adicionado em 27-06-2014
	Left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
	Left Join Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and CR.TaxGroup not in ('CUS SER 20','Exempt')
	--left Join dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=CC.num_proc_hia and CC.cd_Tp_Tx=CXA.cd_tp_Tx and CXA.DC_HIA=CC.dc_hia
	--join Tipo_Taxa_AX TTA with(nolock) on 	(CASE When RFI.num_registro is null then cd_Ax_Repasse else cd_Ax_resultado End ) = TTA.Cd_Charge_AX
--Fim em 27-06-2014

where	
AXD.dt_canc is null and
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and  cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null and desp_org_hia='N' and (CC.DC_hia = 'D' or CC.DC_hia ='C' and CC.Cd_Tp_Tx in ('XY0','XY1','D2D'))	
	and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1')
	and vlr_org_hia <> 0 
	and ((PS.cd_tp_Ativ = 'AGT' and CC.DC_hia = 'D' and AXP.Tipo = 'F')
	or (PS.cd_tp_Ativ <> 'AGT')) 
--	and @num_proc = c.num_proc

Union all

SELECT 
	'ATL' [System],
	'PURCHOPS',i.num_proc, 
	convert(varchar(50),convert(datetime,dt_Documento,103),101),
	--convert(varchar,dt_Documento,103),
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
	A.id_AX [AX DOC],
	Invoice_AX [Invoice],
	'Job Level'

FROM 
	AX_DOC A with(nolock)
	jOIN AX_dOC_itEM i with(nolock) ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=Cd_tp_Tx_ATL
	left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_tp_Tx_ATL =AXD.cd_tp_Tx_ATL and AXD.dc=I.dc
	--left Join dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=I.num_proc and I.cd_tp_Tx_ATL=CXA.cd_tp_Tx and CXA.DC_HIA=I.dc
	--join Tipo_Taxa_AX TTA with(nolock) on 	I.CD_Tp_Tx = TTA.Cd_Charge_AX
WHERE 
	TIPO=2 AND A.DT_CANC IS NOT NULL
	and convert(datetime,convert(varchar,dt_ins,103),105) between @DataInicial and @Datafinal
	and Valor <> 0 
--	and @Num_proc = num_proc

Union all
/*
SELECT 
	'ATL' [System],
	'PURCHOPS',num_proc, 
	convert(varchar(50),convert(datetime,dt_canc,103),101),
	--convert(varchar,dt_canc ,103),
	'' Vourcher,
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	'' [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when DC='D' then Valor
		else Valor*-1
	End [ Value], 
	case
		when DC='D' then Valor*paridade
		else Valor*paridade*-1
	End  [BRL Value],
	Cd_Tp_TX_ATL,
	'Void'	
FROM 
	AX_DOC A
	jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
WHERE TIPO=2 and convert(datetime,convert(varchar,DT_CANC,103),105) between @DataInicial and @Datafinal
	 and Valor <> 0 
--	 and @Num_proc = num_proc
*/

SELECT 
	'ATL' [System],
	'PURCHOPS',i.num_proc, 
	convert(varchar(50),convert(datetime,A.dt_canc,103),101),
	--convert(varchar,dt_canc ,103),
	'' [Voucher],
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	''  [Ledger Account],
	
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	/*
	case
		when i.DC='C' then cast((abs(Valor)*-1)+((abs(Valor)*-1)*isnull(Isnull(Porcentagem,0)/100,1))	as decimal(10,2))
		else cast(abs(Valor)-(abs(Valor)*isnull(Porcentagem,0)/100)as decimal(10,2))
	End Value,
	case
		when i.DC='C' then cast(((abs(Valor)*-1)+((abs(Valor)*-1)*isnull(Isnull(Porcentagem,0)/100,1)))*isnull(paridade,1) as  decimal(10,2))
		else cast((abs(Valor)-(abs(Valor)*isnull(Isnull(Porcentagem,0)/100,1)))*isnull(paridade,1)as decimal(10,2))
	End  [BRL Value],
	*/
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
	A.id_AX [AX DOC],
	Invoice_AX + 'V' [Invoice],
	'Void'
FROM 
	AX_DOC A with(nolock)
	jOIN AX_dOC_itEM i with(nolock) ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=Cd_tp_Tx_ATL
	Left Join Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=i.TaxGroup and i.TaxGroup not in ('CUS SER 20','Exempt')
	left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_tp_Tx_ATL =AXD.cd_tp_Tx_ATL and AXD.dc=I.dc
	--join Tipo_Taxa_AX TTA with(nolock) on 	I.CD_Tp_Tx = TTA.Cd_Charge_AX
	--left Join dbo.vwCXAS CXA on CXA.Num_Proc_hia=I.num_proc and I.cd_tp_Tx_ATL=CXA.cd_tp_Tx and CXA.DC_HIA=I.dc
WHERE TIPO=2 and convert(datetime,convert(varchar,A.DT_CANC,103),105) between @DataInicial and @Datafinal
	 and Valor <> 0 
	 --and @num_proc = num_proc

	 

union all


Select
	'ATL' [System],
	'SALESOPS' Type,
	I.Num_Proc Job,
	--convert(varchar,fatdtemissao,105) DocumentDt,
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
/*	
	case
		when I.DC='D' then cast(((abs(Vlr_Org)*-1)*isnull(Isnull(abs(IRRF),0)/100,1))as decimal(10,2))-abs(Vlr_Org)
		else (cast((abs(vlr_org)*isnull(abs(IRRF),0)/100)as decimal(10,2))-abs(vlr_org))*-1
	End Value,
	case
		when I.DC='D' then cast(((abs(Vlr_Org)*-1)*isnull(Isnull(abs(IRRF),0)/100,1))*I.paridade as decimal(10,2))-abs(Vlr_Org)

		else (cast(((abs(vlr_org)*isnull(Isnull(abs(IRRF),0)/100,1)))*I.paridade as decimal(10,2)) - abs(vlr_org))*-1
	End  [BRL Value],
*/
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
	Invoice_AX [Invoice],
	'Job Level'
From
	Fatura F with(nolock)
	Join Item_Fat I with(nolock) on I.fatcod=F.fatcod
	Join Tipo_Taxa TT with(nolock) on Tt.cd_tp_Tx=I.cd_tp_Tx
	Left Join vwFaturasValidasArg FI with(nolock) on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
	Left Join Tipo_Taxa_AX AX with(nolock) on AX.Cd_Charge_AX = TT.Cd_AX 
	Left Join Tipo_TAxa_AX AXPT with(nolock) on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
--Adicionado 27-06-2014
	Left Join PEssoa_ATL_AX PPA with(nolock) on PPA.cd_pes=F.cd_pes and tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido AXC with(nolock) on AXC.AccountNum=PPA.cd_ax
--Fim
--Adicionado em 03-06-2014
	Left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=I.dc 
	Left Join Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and AXC.TaxGroup not in ('CUS SER 20','Exempt')
--Fim em 03-06-2014
--left Join dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=I.num_proc and I.Cd_Tp_Tx=CXA.cd_tp_Tx and CXA.DC_HIA=I.DC
--join Tipo_Taxa_AX TTA with(nolock) on (CASE When FI.ID_FAT is null then cd_Ax_repasse else cd_ax_resultado End) = TTA.Cd_Charge_AX
Where 
	AXD.dt_canc is null and
	convert(Datetime,convert(varchar(10),fatdtemissao,105),103) between @Datainicial and @DataFinal and 
	F.dt_canc is  null
	and len(I.fatcod)=17
	and TT.cd_ax_Resultado <> '000.1'
	and vlr_org <> 0 
	--and I.Num_Proc = 'EMOXT201405191BR'



Union all


select 
	'ATL' System,
	'SALESOPS' [Type],
	CC.Num_Proc_HIA Job,
	--dt_ins_hia, 
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
	Invoice_AX [Invoice],
	'Job Level' [Registered on]
	
From vwcta_cte CC with(nolock)
	Join vwcliente C with(nolock) on c.num_proc=CC.num_proc_hia
	Left Join vwFaturasValidas F with(nolock) on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cc.cd_tp_Tx
	Left Join Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
--Adicionado 27-06-2014
	Left Join PEssoa_ATL_AX PPA with(nolock) on PPA.cd_pes=CC.cd_cred_Dev_hia and tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido AXC with(nolock) on AXC.AccountNum=PPA.cd_ax
--Fim
--Adicionado em 03-06-2014
	Left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
	Left Join Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and AXC.TaxGroup not in ('CUS SER 20','Exempt')
--Fim em 03-06-2014
--left Join dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=CC.num_proc_hia and CC.cd_Tp_Tx=CXA.cd_tp_Tx and CXA.DC_HIA=CC.dc_hia
--join Tipo_Taxa_AX TTA with(nolock) on cd_ax_repasse = TTA.Cd_Charge_AX 
where	
AXD.dt_canc is null and
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal and  
	 --cd_cred_Dev_hia = cd_Cliente
	CC.dc_hia='C' and left(CC.cd_Tp_Tx,1) = 'X'
	and F.num_proc is null 
	and desp_org_hia='N'
	and nome_tp_Tx like 'Adian%'
	and TT.cd_ax_Resultado <> '000.1'
	and vlr_org_hia <> 0 
	and PPA.cd_ax is not null
	--and CC.Num_Proc_HIA = 'IMCSR201404425BR'


Union all

SELECT 
	'ATL' System,
	'SALESOPS',i.num_proc, 
	--convert(varchar,dt_Documento,103),
	convert(varchar(50),convert(datetime,dt_Documento,103),101),
	'' [Voucher],
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	'' [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	/*
	case
		when DC='D' then Valor*-1
		else Valor
	End Value,
	case
		when DC='D' then Valor*-1*paridade
		else Valor*paridade
	End  [BRL Value], 
	*/
	/*
	case
		when I.DC='D' then cast((abs(Valor)*-1)-((abs(Valor)*-1)*isnull(Isnull(abs(porcentagem),0)/100,1))as decimal(10,2))
		else cast(abs(Valor)-(abs(Valor)*isnull(abs(porcentagem),0)/100)as decimal(10,2))
	End Value,
	case
		when I.DC='D' then cast(((abs(Valor)*-1)-((abs(Valor)*-1)*isnull(Isnull(abs(porcentagem),0)/100,1)))*I.paridade as decimal(10,2))
		else cast((abs(Valor)-(abs(Valor)*isnull(Isnull(abs(porcentagem),0)/100,1)))*I.paridade as decimal(10,2))
	End  [BRL Value],
	*/
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
	A.id_AX [AX DOC],
	Invoice_AX [Invoice],
	'Job Level'
FROM 
	AX_DOC A with(nolock)
	jOIN AX_dOC_itEM i with(nolock) ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=Cd_tp_Tx_ATL
	Left Join Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=i.TaxGroup and i.TaxGroup not in ('CUS SER 20','Exempt')
	left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_tp_Tx_ATL =AXD.cd_tp_Tx_ATL and AXD.dc=I.dc
	--Join fatura fat on fat.fatcod=A.invoice_number
--	left Join dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=i.num_proc and CXA.cd_Tp_Tx=i.cd_tp_Tx_ATL and CXA.DC_HIA=i.dc
	--join Tipo_Taxa_AX TTA with(nolock) on cd_ax_repasse = TTA.Cd_Charge_AX 
WHERE 
	TIPO<>2 AND A.dt_Canc IS NOT NULL
	and convert(datetime,convert(varchar,A.dt_ins,103),105) between @DataInicial and @DataFinal
	--and convert(datetime,convert(varchar,A.dt_ins,103),105) between '2014-07-01' and '2014-07-15'
	 and Valor <> 0 
	 --and Num_proc = 'EMSLA201406002BR'


Union all
/*
SELECT 
	'ATL' System,
	'SALESOPS',num_proc, 
	--convert(varchar,dt_canc,103),
	convert(varchar(50),convert(datetime,dt_canc,103),101),
	'' Voucher,
	I.CD_Tp_Tx [AX Charge Code],
	Nome_Tp_TX_Ing,
	'' [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when DC='C' then Valor*-1
		else Valor
	End Value,
	case
		when DC='C' then Valor*-1*paridade
		else Valor*paridade
	End  [BRL Value], 
	Cd_Tp_TX_ATL,

	'Void'

	
FROM 
	AX_DOC A
	jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
WHERE 
	TIPO<>2 and convert(datetime,convert(varchar,DT_CANC,103),105) between @DataInicial and @Datafinal
	 and valor <> 0 
	 */
SELECT 

	'ATL' System,
	'SALESOPS',I.num_proc, 
	--convert(varchar,dt_canc,103),
	convert(varchar(50),convert(datetime,A.dt_canc,103),101),
	'' Voucher,
	I.CD_Tp_Tx [AX Charge Code],
	Nome_Tp_TX_Ing,
	'' [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
/*
	case
		when i.DC='C' then (cast(((abs(Valor)*-1)*isnull(Isnull(abs(IRRF),0),1))/100 as decimal (10,2)) +Valor)*-1
		else cast(((abs(Valor)*-1)*isnull(Isnull(abs(IRRF),0),1))/100 as decimal(10,2))+valor
	End Value,
	case
		when i.DC='C' then cast(((cast(((abs(Valor)*-1)*isnull(Isnull(abs(IRRF),0),1)/100) as  decimal(10,2)) + Valor)*-1)*isnull(paridade,1)as  decimal(10,2))
		else cast((cast((((abs(Valor)*-1)*isnull(Isnull(abs(IRRF),0),1))/100) as decimal(10,2))+valor)*isnull(paridade,1) as decimal(10,2))
	End  [BRL Value],
*/
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
	A.id_AX [AX DOC],
	Invoice_AX +'V' [Invoice],
	'Void'

	
FROM 
	AX_DOC A with(nolock)
	jOIN AX_dOC_itEM i with(nolock) ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=Cd_tp_Tx_ATL
	Left Join Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=i.TaxGroup and A.TaxGroup not in ('CUS SER 20','Exempt')
	left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_tp_Tx_ATL =AXD.cd_tp_Tx_ATL and AXD.dc=I.dc
	--join Tipo_Taxa_AX TTA with(nolock) on I.CD_Tp_Tx = TTA.Cd_Charge_AX 
	--left Join dbo.vwCXAS CXA on CXA.Num_Proc_hia=I.num_proc and I.cd_tp_Tx_ATL=CXA.cd_tp_Tx and CXA.DC_HIA=I.dc
WHERE 
	TIPO<>2 and convert(datetime,convert(varchar,A.DT_CANC,103),105) between @Datainicial and @DataFinal 
	 and valor <> 0 
	 --and num_proc = 'EMATL201401008BR'

Union All

Select
	'ATL' System,
	'SALESOPS' Type,
	C.Num_Proc Job,
	
	--convert(varchar,fatdtemissao,105) DocumentDt,
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
	Invoice_AX [Invoice],
	'Consolidated Level'
From
	Fatura F with(nolock)
	Join Item_Fat I with(nolock) on I.fatcod=F.fatcod
	Join Tipo_Taxa TT with(nolock) on Tt.cd_tp_Tx=I.cd_tp_Tx
	Left Join dbo.vwFaturasValidasArg FI with(nolock) on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
	--Left Join Fatura_Arg_Det FI on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
	Join vwcliente C with(nolock) on C.master=I.num_proc
	--Left Join Fatura_ARg FA on FA.id_Fat=FI.id_fat and [status]<>2
	Left Join Tipo_Taxa_AX AX with(nolock) on AX.Cd_Charge_AX = TT.Cd_AX 
	Left Join Tipo_TAxa_AX AXPT with(nolock) on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
--Adicionado 27-06-2014
	Left Join PEssoa_ATL_AX PPA with(nolock) on PPA.cd_pes=F.cd_pes and tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido AXC with(nolock) on AXC.AccountNum=PPA.cd_ax
--Fim
--Adicionado em 03-06-2014
	Left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=I.num_proc and I.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=I.dc 
	Left Join Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and AXC.TaxGroup not in ('CUS SER 20','Exempt')
--Fim em 03-06-2014
--left Join dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=I.num_proc and I.cd_Tp_Tx=CXA.cd_tp_Tx and CXA.DC_HIA=I.dc
--join Tipo_Taxa_AX TTA with(nolock) on 	(CASE When FI.ID_FAT is null then cd_Ax_repasse else cd_ax_resultado End) = TTA.Cd_Charge_AX 

Where
AXD.dt_canc is null and
	convert(Datetime,convert(varchar(10),fatdtemissao,105),103) between @Datainicial and @DataFinal 
	and F.dt_canc is  null
	and len(I.fatcod)=15
	and TT.cd_ax_Resultado <> '000.1'
	and vlr_org <> 0 
--	and C.Num_Proc = @Num_proc
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

	--Case 
	--	when SPG.Vlr_Ref is null then
	Case
		when cc.cd_Tp_moeda='REL' then 'BRL'
		else cc.cd_tp_moeda
	End 
	--else
	--	Case
	--		when SPG.cd_Tp_moeda='REL' then 'BRL'
	--		else SPG.cd_tp_moeda
	--	End
	--End 
	Currency,
		/*
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1
		else vlr_org_hia
	End Value,
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*isnull(par.par_moeda,1)
		else vlr_org_hia*isnull(par.par_moeda,1)
	End  [BRL Amount],
	*/

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
	isnull(AXD.id_AX,'') [AX DOC],
	isnull(Invoice_AX,'') [Invoice],
	'Job Level' [Registered on]
	
From vwcta_cte CC with(nolock)
	Join vwcliente C with(nolock) on c.num_proc=CC.num_proc_hia
	Left Join vwFaturasValidas F with(nolock) on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cc.cd_tp_Tx
--	Left Join Tipo_Taxa_AX AXR on AX.Cd_Charge_AX = Cd_AX_Resultado 
--	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=cd_Ax_Repasse
	Join Pessoa_ATL_AX AXP with(nolock) on AXP.Cd_Pes = CC.cd_cred_Dev_hia and AXP.Tipo = 'C'
	Left Join dbo.AX_XML_Vendor_Recebido CR with(nolock) on CR.accountnum =AXP.cd_ax
	Left Join Pessoa PS with(nolock) on PS.Cd_Pes = CC.cd_cred_Dev_hia 
	LEft Join registro_financeiro_item RFI with(nolock) on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF with(nolock) on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left Join Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
--Adicionado em 27-06-2014
	Left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
	left Join dbo.vwSolPgtoCtaCteAprovadas SPG with(nolock) on SPG.Num_Proc=CC.num_proc_hia and CC.cd_Tp_Tx=SPG.cd_tp_Tx and SPG.dc=CC.dc_hia 
	Left Join Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and CR.TaxGroup not in ('CUS SER 20','Exempt')
	--left Join dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=CC.num_proc_hia and CC.cd_Tp_Tx=CXA.cd_tp_Tx and CXA.DC_HIA=CC.dc_hia 
	--join Tipo_Taxa_AX TTA with(nolock) on 	(CASE When RFI.num_registro is null then cd_Ax_Repasse else cd_Ax_resultado End ) = TTA.Cd_Charge_AX

--Fim em 27-06-2014
where
	AXD.dt_canc is null and
	AXD.id_AX is null and
	SPG.Vlr_Ref is null and
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  --and cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null 
	--and desp_org_hia='N' 
	--and CC.DC_hia ='C'
	and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1')
	and vlr_org_hia <> 0  
	--and ((PS.cd_tp_Ativ = 'AGT' and CC.DC_hia = 'D' and AXP.Tipo = 'F') or (PS.cd_tp_Ativ <> 'AGT' and AXP.Tipo = 'F')) 
--	and @Num_proc = c.num_proc

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

	--Case 
	--	when SPG.Vlr_Ref is null then
	Case
		when cc.cd_Tp_moeda='REL' then 'BRL'
		else cc.cd_tp_moeda
	End 
	--else
	--	Case
	--		when SPG.cd_Tp_moeda='REL' then 'BRL'
	--		else SPG.cd_tp_moeda
	--	End
	--End 
	Currency,
		/*
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1
		else vlr_org_hia
	End Value,
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*isnull(par.par_moeda,1)
		else vlr_org_hia*isnull(par.par_moeda,1)
	End  [BRL Amount],
	*/

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
	isnull(AXD.id_AX,'') [AX DOC],
	isnull(Invoice_AX,'') [Invoice],
	'Consolidated Level' [Registered on]
	
From vwcta_cte CC with(nolock)
	Join vwcliente C with(nolock) on c.Master=CC.num_proc_hia
	Left Join vwFaturasValidas F with(nolock) on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cc.cd_tp_Tx
--	Left Join Tipo_Taxa_AX AXR on AX.Cd_Charge_AX = Cd_AX_Resultado 
--	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=cd_Ax_Repasse
	Join Pessoa_ATL_AX AXP with(nolock) on AXP.Cd_Pes = CC.cd_cred_Dev_hia and AXP.Tipo = 'C'
	Left Join dbo.AX_XML_Vendor_Recebido CR with(nolock) on CR.accountnum =AXP.cd_ax
	Left Join Pessoa PS with(nolock) on PS.Cd_Pes = CC.cd_cred_Dev_hia 
	LEft Join registro_financeiro_item RFI with(nolock) on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF with(nolock) on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left Join Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
--Adicionado em 27-06-2014
	Left Join dbo.vwAXDocs_ALL AXD with(nolock) on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
	left Join dbo.vwSolPgtoCtaCteAprovadas SPG with(nolock) on SPG.Num_Proc=CC.num_proc_hia and CC.cd_Tp_Tx=SPG.cd_tp_Tx and SPG.dc=CC.dc_hia 
	Left Join Tipo_Tax_AX TXA with(nolock) on Cd_Tax_AX=AXD.Tax_Group and CR.TaxGroup not in ('CUS SER 20','Exempt')
	--left Join dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=CC.num_proc_hia and CC.cd_Tp_Tx=CXA.cd_tp_Tx and CXA.DC_HIA=CC.dc_hia 
	--join Tipo_Taxa_AX TTA with(nolock) on 	(CASE When RFI.num_registro is null then cd_Ax_Repasse else cd_Ax_resultado End ) = TTA.Cd_Charge_AX

--Fim em 27-06-2014
where
	AXD.dt_canc is null and
	AXD.id_AX is null and
	SPG.Vlr_Ref is null and
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  --and cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null 
	--and desp_org_hia='N' 
	--and CC.DC_hia ='C'
	and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1')
	and vlr_org_hia <> 0  
	--and ((PS.cd_tp_Ativ = 'AGT' and CC.DC_hia = 'D' and AXP.Tipo = 'F') or (PS.cd_tp_Ativ <> 'AGT' and AXP.Tipo = 'F')) 
--	and @Num_proc = c.num_proc

update @Temp set Voucher = Num_Lcto from @Temp T
Join dbo.vwCXAS CXA with(nolock) on CXA.Num_Proc_hia=T.JOB and T.ATL_Charge_Code=CXA.cd_tp_Tx and CXA.DC_HIA=T.dc
where Registered_On <> 'Void'

update @Temp set Ledger_Account = TTA.CC_Custo from @Temp T
join Tipo_Taxa_AX TTA with(nolock) on 	AX_Charge_Code = TTA.Cd_Charge_AX
where [Type] = 'PURCHOPS'

update @Temp set Ledger_Account = TTA.CC_Receita from @Temp T
join Tipo_Taxa_AX TTA with(nolock) on 	AX_Charge_Code = TTA.Cd_Charge_AX
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
