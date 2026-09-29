SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spAXDailyReport_Stephan_Rel] NULL, NULL
CREATE Procedure [dbo].[spAXDailyReport_Stephan_Rel]
(
	@DataInicial	Datetime,
	@DataFinal		Datetime
	)
AS

Set @DataInicial = (select cast(year(getdate()-1)as varchar(4))+ '-' + cast(month(getdate()-1)as varchar(2))+'-01')
sEt @DataFinal=getdate()


select 
	'ATL' [System],
	'PURCHOPS' [Type],
	CC.Num_Proc_HIA Job,
	dt_ins_hia [Transaction Dt], 
	'' Voucher,
	(
		CASE  
				When RFI.num_registro is null then cd_Ax_Repasse
				else cd_Ax_resultado
		End	
	)
	[AX Charge Code],
	Nome_Tp_Tx_Ing [ATL Charge Description],
	TTA.CC_Custo [Ledger Account],
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
	End  [BRL Amount],
	Upper(CC.Cd_Tp_TX) [ATL Charge Code],
	'BR' [Company],
	--''[Journal number],
	--convert(Datetime,F.FatDtEmissao,105) [Date],
	--''[Amount currency],
	--''[Amount],
	--''[Amount secondary currency],
	F.Fatcod [AR Reference],
	--''[Consol number],
	--''[CSR Email],
	dbo.fbusca_docs_po_modal(CC.num_proc_hia,'1')	[Customer reference 1],
	dbo.fbusca_docs_po_modal(CC.num_proc_hia,'3')	[Customer reference 2],	
	AL.HAWB [House BOL Nbr],
	--''[Journal],
	--''[Responsibility Center],
	--''[Product],
	--''[Global Customer],
	--''[Location],
	--''[Global COA],
	--''[Management Reporting],
	--''[Global Vendor],
	C.Dt_Criacao [JOB CREATION DATE],
	convert(char(10),convert(datetime,[dbo].[fBusca_CampoLLP_Data](CC.num_proc_hia,'ETD'),103),103)[SAIL DATE],
	convert(char(10),convert(datetime,[dbo].[fBusca_CampoLLP_Data](CC.num_proc_hia,'ETA'),103),103)[ARRIVAL DATE],
	Convert(varchar(10),TT4.Dt_Conclusao,103)[CUSTOMS CLEARANCE DATE],
	''[Other dates],
	'Job Level' [Registered on]

From vwcta_cte CC
	Join vwcliente C on c.num_proc=CC.num_proc_hia
	Left Join vwFaturasValidas F on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cc.cd_tp_Tx
--	Left Join Tipo_Taxa_AX AXR on AX.Cd_Charge_AX = Cd_AX_Resultado 
--	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=cd_Ax_Repasse
	LEft Join registro_financeiro_item RFI on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
	Left Join Tipo_Taxa_AX TTA on TT.CD_AX = TTA.CC_Custo 
	Left Join vwALL_JOBs AL on C.num_proc=AL.Num_Proc
	Left Outer Join Tarefas_Processos TT4 With(Nolock) on AL.Num_Proc = TT4.num_proc and TT4.ID_Task=4

where	
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null and desp_org_hia='N'
	and TT.cd_ax <> '000.1'
	and vlr_org_hia <> 0 --and @Num_proc = c.num_proc

Union all

select 
	'ATL' [System],
	'PURCHOPS' [Type],
	C.Num_Proc Job,
	dt_ins_hia, 
	'' Voucher,
	(
		CASE  
				When RFI.num_registro is null then cd_Ax_Repasse
				else cd_Ax_resultado
		End	
	)
	[AX Charge Code],
	Nome_Tp_Tx_Ing [ATL Charge Description],
	TTA.CC_Custo [Ledger Account],
	Case
		when cc.cd_Tp_moeda='REL' then 'BRL'
		else cc.cd_tp_moeda
	End,
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*[dbo].[spRateio_Mas](C.num_Proc)
		else vlr_org_hia*[dbo].[spRateio_Mas](C.num_Proc)
	End ,
		case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*[dbo].[spRateio_Mas](C.num_Proc)*isnull(par.par_moeda,1)
		else vlr_org_hia*[dbo].[spRateio_Mas](C.num_Proc)*isnull(par.par_moeda,1)
	End  [BRL Amount],
	Upper(CC.Cd_Tp_TX) [ATL Charge Code],
	'BR' [Company],
	--''[Journal number],
	--convert(Datetime,F.FatDtEmissao,105) [Date],
	--''[Amount currency],
	--''[Amount],
	--''[Amount secondary currency],
	F.Fatcod [AR Reference],
	--''[Consol number],
	--''[CSR Email],
	dbo.fbusca_docs_po_modal(CC.num_proc_hia,'1')	[Customer reference 1],
	dbo.fbusca_docs_po_modal(CC.num_proc_hia,'3')	[Customer reference 2],	
	AL.HAWB [House BOL Nbr],
	--''[Journal],
	--''[Responsibility Center],
	--''[Product],
	--''[Global Customer],
	--''[Location],
	--''[Global COA],
	--''[Management Reporting],
	--''[Global Vendor],
	C.Dt_Criacao [JOB CREATION DATE],
	convert(char(10),convert(datetime,[dbo].[fBusca_CampoLLP_Data](CC.num_proc_hia,'ETD'),103),103)[SAIL DATE],
	convert(char(10),convert(datetime,[dbo].[fBusca_CampoLLP_Data](CC.num_proc_hia,'ETA'),103),103)[ARRIVAL DATE],
	Convert(varchar(10),TT4.Dt_Conclusao,103)[CUSTOMS CLEARANCE DATE],
	''[Other dates],
	'Consolidated Level' [Registered on]
	
From vwcta_cte CC
	Join vwcliente C on c.master=CC.num_proc_hia
	Left Join vwFaturasValidas F on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cc.cd_tp_Tx
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
	LEft Join registro_financeiro_item RFI on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
	Left Join Tipo_Taxa_AX TTA on TT.CD_AX = TTA.CC_Custo 
	Left Join vwALL_JOBs AL on C.num_proc=AL.Num_Proc
	Left Outer Join Tarefas_Processos TT4 With(Nolock) on AL.Num_Proc = TT4.num_proc and TT4.ID_Task=4

where	
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and  cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null and desp_org_hia='N'
	and TT.cd_ax <> '000.1'
	and vlr_org_hia <> 0 --and @num_proc = c.num_proc

Union all

SELECT 
	'ATL' [System],
	'PURCHOPS',
	num_proc, 
	convert(varchar,dt_Documento,103),
	'' Vourcher,
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	TTA.CC_Custo [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when DC='D' then Valor*-1
		else Valor
	End [ Value], 
		case
		when DC='D' then Valor*paridade*-1
		else Valor*paridade
	End  [BRL Value],
	Cd_Tp_TX_ATL,
	'BR' [Company],
	--''[Journal number],
	--'' [Date],
	--''[Amount currency],
	--''[Amount],
	--''[Amount secondary currency],
	''[AR Reference],
	--''[Consol number],
	--''[CSR Email],
	''[Customer reference 1],
	''[Customer reference 2],	
	'' [House BOL Nbr],	
	--''[Journal],
	--''[Responsibility Center],
	--''[Product],
	--''[Global Customer],
	--''[Location],
	--''[Global COA],
	--''[Management Reporting],
	--''[Global Vendor],
	'' [JOB CREATION DATE],
	''[SAIL DATE],
	''[ARRIVAL DATE],
	''[CUSTOMS CLEARANCE DATE],
	''[Other dates],
	'Job Level'

FROM 
	AX_DOC A
	jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
	Left Join Tipo_Taxa_AX TTA on TT.CD_AX = TTA.CC_Custo 

	
WHERE 
	TIPO=2 AND DT_CANC IS NOT NULL
	and convert(datetime,convert(varchar,dt_ins,103),105) between @DataInicial and @Datafinal
	and Valor <> 0 --and @Num_proc = num_proc

/*
select * from AX_DOC_item
where Num_proc = 'IMFMC201311022BR' and cd_tp_tx_ATL = 'ICM'
*/
Union all

SELECT 
	'ATL' [System],
	'PURCHOPS',num_proc, 
	convert(varchar,dt_canc ,103),
	'' Vourcher,
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	TTA.CC_Custo [Ledger Account],
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
	'BR' [Company],
	--''[Journal number],
	--NULL [Date],
	--''[Amount currency],
	--''[Amount],
	--''[Amount secondary currency],
	'' [AR Reference],
	--''[Consol number],
	--''[CSR Email],
	''	[Customer reference 1],
	''	[Customer reference 2],	
	'' [House BOL Nbr],
	--''[Journal],
	--''[Responsibility Center],
	--''[Product],
	--''[Global Customer],
	--''[Location],
	--''[Global COA],
	--''[Management Reporting],
	--''[Global Vendor],
	'' [JOB CREATION DATE],
	''[SAIL DATE],
	''[ARRIVAL DATE],
	''[CUSTOMS CLEARANCE DATE],
	''[Other dates],
	'Void'	
FROM 
	AX_DOC A
	jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
	Left Join Tipo_Taxa_AX TTA on TT.CD_AX = TTA.CC_Custo
	
WHERE TIPO=2 and convert(datetime,convert(varchar,DT_CANC,103),105) between @DataInicial and @Datafinal
	 and Valor <> 0 --and @Num_proc = num_proc
	
union all


Select
	'ATL' [System],
	'SALESOPS' Type,
	I.Num_Proc Job,
	convert(varchar,fatdtemissao,105) DocumentDt,
	'' Voucher,
	(
		CASE  
				When FA.ID_FAT is null then cd_Ax_repasse 
				else cd_ax_resultado
		End	
	) [AX Charge Code],
	(Nome_Tp_Tx_ing),
	TTA.CC_Custo [Ledger Account],
	Case
		when I.cd_Tp_moeda='REL' then 'BRL'
		else I.cd_tp_moeda
	End Currency,
	case
		when I.DC='D' then abs(Vlr_Org)*-1
		else abs(vlr_org)
	End Value,
	case
		when I.DC='D' then abs(Vlr_Org)*-1*I.paridade
		else abs(vlr_org)*I.paridade
	End  [BRL Value],
	Upper(TT.cd_Tp_Tx) [ATL Charge Code],
	'BR' [Company],
	--''[Journal number],
	--convert(Datetime,F.FatDtEmissao,105) [Date],
	--''[Amount currency],
	--''[Amount],
	--''[Amount secondary currency],
	F.Fatcod [AR Reference],
	--''[Consol number],
	--''[CSR Email],
	''[Customer reference 1],
	''	[Customer reference 2],	
	'' [House BOL Nbr],
	--''[Journal],
	--''[Responsibility Center],
	--''[Product],
	--''[Global Customer],
	--''[Location],
	--''[Global COA],
	--''[Management Reporting],
	--''[Global Vendor],
	''[JOB CREATION DATE],
	''[SAIL DATE],
	''[ARRIVAL DATE],
	''[CUSTOMS CLEARANCE DATE],
	''[Other dates],
	'Job Level'
From
	Fatura F
	Join Item_Fat I on I.fatcod=F.fatcod
	Join Tipo_Taxa TT on Tt.cd_tp_Tx=I.cd_tp_Tx
	Left Join Fatura_Arg_Det FI on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
	Left Join Fatura_ARg FA on FA.id_Fat=FI.id_fat and status=0
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
	Left Join Tipo_Taxa_AX TTA on TT.CD_AX = TTA.CC_Custo 
Where
	convert(Datetime,convert(varchar(10),fatdtemissao,105),103) between @Datainicial and @DataFinal 
	and dt_canc is  null
	and len(I.fatcod)=17
	and TT.cd_ax <> '000.1'
	and vlr_org <> 0 --and I.Num_Proc = @Num_proc

Union all


select 
	'ATL' System,
	'SALESOPS' [Type],
	CC.Num_Proc_HIA Job,
	dt_ins_hia, 
	'' Voucher,
	cd_ax_repasse	[AX Charge Code],
	Nome_Tp_Tx_Ing [ATL Charge Description],
	TTA.CC_Custo [Ledger Account],
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
	'BR' [Company],
	--''[Journal number],
	--convert(Datetime,F.FatDtEmissao,105) [Date],
	--''[Amount currency],
	--''[Amount],
	--''[Amount secondary currency],
	F.Fatcod [AR Reference],
	--''[Consol number],
	--''[CSR Email],
	dbo.fbusca_docs_po_modal(CC.num_proc_hia,'1')	[Customer reference 1],
	dbo.fbusca_docs_po_modal(CC.num_proc_hia,'3')	[Customer reference 2],	
	AL.HAWB [House BOL Nbr],
	--''[Journal],
	--''[Responsibility Center],
	--''[Product],
	--''[Global Customer],
	--''[Location],
	--''[Global COA],
	--''[Management Reporting],
	--''[Global Vendor],
	C.Dt_Criacao [JOB CREATION DATE],
	convert(char(10),convert(datetime,[dbo].[fBusca_CampoLLP_Data](CC.num_proc_hia,'ETD'),103),103)[SAIL DATE],
	convert(char(10),convert(datetime,[dbo].[fBusca_CampoLLP_Data](CC.num_proc_hia,'ETA'),103),103)[ARRIVAL DATE],
	Convert(varchar(10),TT4.Dt_Conclusao,103)[CUSTOMS CLEARANCE DATE],
	''[Other dates],
	'Job Level' [Registered on]
	
From vwcta_cte CC
	Join vwcliente C on c.num_proc=CC.num_proc_hia
	Left Join vwFaturasValidas F on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cc.cd_tp_Tx
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
	Left Join Tipo_Taxa_AX TTA on TT.CD_AX = TTA.CC_Custo 
	Left Join vwALL_JOBs AL on C.num_proc=AL.Num_Proc
	Left Outer Join Tarefas_Processos TT4 With(Nolock) on AL.Num_Proc = TT4.num_proc and TT4.ID_Task=4

where	
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and cd_cred_Dev_hia = cd_Cliente
	and F.num_proc is null 
	and desp_org_hia='N'
	and nome_tp_Tx like 'Adian%'
	and TT.cd_ax <> '000.1'
	and vlr_org_hia <> 0 --and CC.Num_Proc_HIA = @Num_proc


Union all

SELECT 
	'ATL' System,
	'PURCHOPS',num_proc, 
	convert(varchar,dt_Documento,103),
	'' Voucher,
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	TTA.CC_Custo [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when DC='D' then Valor*-1
		else Valor
	End Value,
	case
		when DC='D' then Valor*-1*paridade
		else Valor*paridade
	End  [BRL Value], 
	Cd_Tp_TX_ATL,
	'BR' [Company],
	--''[Journal number],
	--'' [Date],
	--''[Amount currency],
	--''[Amount],
	--''[Amount secondary currency],
	'' [AR Reference],
	--''[Consol number],
	--''[CSR Email],
	''	[Customer reference 1],
	''	[Customer reference 2],	
	'' [House BOL Nbr],
	--''[Journal],
	--''[Responsibility Center],
	--''[Product],
	--''[Global Customer],
	--''[Location],
	--''[Global COA],
	--''[Management Reporting],
	--''[Global Vendor],
	'' [JOB CREATION DATE],
	''[SAIL DATE],
	''[ARRIVAL DATE],
	''[CUSTOMS CLEARANCE DATE],
	''[Other dates],	
	'Job Level'
	
FROM 
	AX_DOC A
	jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
	Left Join Tipo_Taxa_AX TTA on TT.CD_AX = TTA.CC_Custo 
	
WHERE 
	TIPO<>2 AND DT_CANC IS NOT NULL
	and convert(datetime,convert(varchar,dt_ins,103),105) between @DataInicial and @Datafinal
	 and Valor <> 0 --and @Num_proc = num_proc

Union all

SELECT 
	'ATL' System,
	'PURCHOPS',num_proc, 
	convert(varchar,dt_canc,103),
	'' Voucher,
	I.CD_Tp_Tx [AX Charge Code],
	Nome_Tp_TX_Ing,
	TTA.CC_Custo [Ledger Account],
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
	'BR' [Company],
	--''[Journal number],
	--NULL [Date],
	--''[Amount currency],
	--''[Amount],
	--''[Amount secondary currency],
	''[AR Reference],
	--''[Consol number],
	--''[CSR Email],
	''	[Customer reference 1],
	''	[Customer reference 2],	
	'' [House BOL Nbr],
	--''[Journal],
	--''[Responsibility Center],
	--''[Product],
	--''[Global Customer],
	--''[Location],
	--''[Global COA],
	--''[Management Reporting],
	--''[Global Vendor],
	'' [JOB CREATION DATE],
	''[SAIL DATE],
	''[ARRIVAL DATE],
	''[CUSTOMS CLEARANCE DATE],
	''[Other dates],
	'Void'

	
FROM 
	AX_DOC A
	jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
	Left Join Tipo_Taxa_AX TTA on TT.CD_AX = TTA.CC_Custo 

WHERE 
	TIPO<>2 and convert(datetime,convert(varchar,DT_CANC,103),105) between @DataInicial and @Datafinal
	 and valor <> 0 --and num_proc = @num_proc

Union All

Select
	'ATL' System,
	'SALESOPS' Type,
	C.Num_Proc Job,
	
	convert(varchar,fatdtemissao,105) DocumentDt,
	'' Voucher,
	(
		CASE  
				When FA.ID_FAT is null then cd_Ax_repasse 
				else cd_ax_resultado
		End	
	) [AX Charge Code],
	(Nome_Tp_Tx_ing),
	TTA.CC_Custo [Ledger Account],
	Case
		when I.cd_Tp_moeda='REL' then 'BRL'
		else I.cd_tp_moeda
	End Currency,
	case
		when I.DC='D' then [dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1
		else [dbo].[spRateio_Mas](C.num_Proc)*abs(vlr_org)
	End Value,
	case
		when I.DC='D' then [dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1*I.paridade
		else [dbo].[spRateio_Mas](C.num_Proc)*abs(vlr_org)*I.paridade
	End [BRL Value],
	TT.cd_Tp_Tx [ATL Charge Code],
	'BR' [Company],
	--''[Journal number],
	--convert(Datetime,F.FatDtEmissao,105) [Date],
	--''[Amount currency],
	--''[Amount],
	--''[Amount secondary currency],
	F.Fatcod [AR Reference],
	--''[Consol number],
	--''[CSR Email],
	''	[Customer reference 1],
	''	[Customer reference 2],	
	AL.HAWB [House BOL Nbr],
	--''[Journal],
	--''[Responsibility Center],
	--''[Product],
	--''[Global Customer],
	--''[Location],
	--''[Global COA],
	--''[Management Reporting],
	--''[Global Vendor],
	C.Dt_Criacao [JOB CREATION DATE],
	''[SAIL DATE],
	''[ARRIVAL DATE],
	Convert(varchar(10),TT4.Dt_Conclusao,103)[CUSTOMS CLEARANCE DATE],
	''[Other dates],
	'Consolidated Level'
From
	Fatura F
	Join Item_Fat I on I.fatcod=F.fatcod
	Join Tipo_Taxa TT on Tt.cd_tp_Tx=I.cd_tp_Tx
	Left Join Fatura_Arg_Det FI on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
	Join vwcliente C on C.master=I.num_proc
	Left Join Fatura_ARg FA on FA.id_Fat=FI.id_fat and status=0
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
	Left Join Tipo_Taxa_AX TTA on TT.CD_AX = TTA.CC_Custo 
	Left Join vwALL_JOBs AL on C.num_proc=AL.Num_Proc
	Left Outer Join Tarefas_Processos TT4 With(Nolock) on AL.Num_Proc = TT4.num_proc and TT4.ID_Task=4
Where
	convert(Datetime,convert(varchar(10),fatdtemissao,105),103) between @Datainicial and @DataFinal 
	and dt_canc is  null
	and len(I.fatcod)=15
	and TT.cd_ax <> '000.1'
	and vlr_org <> 0 --and C.Num_Proc = @Num_proc
	
--FIM
/*
select 
	'ATL' [System],
	'PURCHOPS' [Type],
	CC.Num_Proc_HIA Job,
	dt_ins_hia [Transaction Dt], 
	'' Voucher,
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
	End Currency,
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1
		else vlr_org_hia
	End Value,
	case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*isnull(par.par_moeda,1)
		else vlr_org_hia*isnull(par.par_moeda,1)
	End  [BRL Amount],
	Upper(CC.Cd_Tp_TX) [ATL Charge Code],
	'Job Level' [Registered on]
	
	
From vwcta_cte CC
	Join vwcliente C on c.num_proc=CC.num_proc_hia
	Left Join vwFaturasValidas F on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cc.cd_tp_Tx
--	Left Join Tipo_Taxa_AX AXR on AX.Cd_Charge_AX = Cd_AX_Resultado 
--	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=cd_Ax_Repasse
	LEft Join registro_financeiro_item RFI on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia

where	
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null and desp_org_hia='N'
	and TT.cd_ax <> '000.1'
	and vlr_org_hia <> 0
	
Union All

select 
	'ATL' [System],
	'PURCHOPS' [Type],
	C.Num_Proc Job,
	dt_ins_hia, 
	'' Voucher,
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
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*[dbo].[spRateio_Mas](C.num_Proc)
		else vlr_org_hia*[dbo].[spRateio_Mas](C.num_Proc)
	End ,
		case
		when CC.DC_HIA='D' then Vlr_Org_HIA*-1*[dbo].[spRateio_Mas](C.num_Proc)*isnull(par.par_moeda,1)
		else vlr_org_hia*[dbo].[spRateio_Mas](C.num_Proc)*isnull(par.par_moeda,1)
	End  [BRL Amount],
	Upper(CC.Cd_Tp_TX) [ATL Charge Code],
	'Consolidated Level' [Registered on]
	
From vwcta_cte CC
	Join vwcliente C on c.master=CC.num_proc_hia
	Left Join vwFaturasValidas F on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cc.cd_tp_Tx
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
	LEft Join registro_financeiro_item RFI on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
	Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia

where	
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and  cd_cred_Dev_hia <> cd_Cliente
	and F.num_proc is null and desp_org_hia='N'
	and TT.cd_ax <> '000.1'
	and vlr_org_hia <> 0

Union all

SELECT 
	'ATL' [System],
	'PURCHOPS',num_proc, 
	convert(varchar,dt_Documento,103),
	'' Vourcher,
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	'' [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when DC='D' then Valor*-1
		else Valor
	End [ Value], 
		case
		when DC='D' then Valor*-1*paridade
		else Valor*paridade
	End  [BRL Value],
	Cd_Tp_TX_ATL,
	'Job Level'

FROM 
	AX_DOC A
	jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
	
WHERE 
	TIPO=2 AND DT_CANC IS NOT NULL
	and convert(datetime,convert(varchar,dt_ins,103),105) between @DataInicial and @Datafinal
	and Valor <> 0

Union all

SELECT 
	'ATL' [System],
	'PURCHOPS',num_proc, 
	convert(varchar,dt_canc ,103),
	'' Vourcher,
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	'' [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when DC='D' then Valor*-1
		else Valor
	End [ Value], 
	case
		when DC='D' then Valor*-1*paridade
		else Valor*paridade
	End  [BRL Value],
	Cd_Tp_TX_ATL,
	'Void'	
FROM 
	AX_DOC A
	jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
WHERE TIPO=2 and convert(datetime,convert(varchar,DT_CANC,103),105) between @DataInicial and @Datafinal
	 and Valor <> 0

union all


Select
	'ATL' [System],
	'SALESOPS' Type,
	I.Num_Proc Job,
	convert(varchar,fatdtemissao,105) DocumentDt,
	'' Voucher,
	(
		CASE  
				When FA.ID_FAT is null then cd_Ax_repasse 
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
		when I.DC='D' then abs(Vlr_Org)*-1
		else abs(vlr_org)
	End Value,
	case
		when I.DC='D' then abs(Vlr_Org)*-1*I.paridade
		else abs(vlr_org)*I.paridade
	End  [BRL Value],
	Upper(TT.cd_Tp_Tx) [ATL Charge Code],
	'Job Level'
From
	Fatura F
	Join Item_Fat I on I.fatcod=F.fatcod
	Join Tipo_Taxa TT on Tt.cd_tp_Tx=I.cd_tp_Tx
	Left Join Fatura_Arg_Det FI on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
	Left Join Fatura_ARg FA on FA.id_Fat=FI.id_fat and status=0
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
Where
	convert(Datetime,convert(varchar(10),fatdtemissao,105),103) between @Datainicial and @DataFinal 
	and dt_canc is  null
	and len(I.fatcod)=17
	and TT.cd_ax <> '000.1'
	and vlr_org <> 0


Union all


select 
	'ATL' System,
	'SALESOPS' [Type],
	CC.Num_Proc_HIA Job,
	dt_ins_hia, 
	'' Voucher,
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
	'Job Level' [Registered on]
	
From vwcta_cte CC
	Join vwcliente C on c.num_proc=CC.num_proc_hia
	Left Join vwFaturasValidas F on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cc.cd_tp_Tx
	Left Join Paridade PAR on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia

where	
	convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and cd_cred_Dev_hia = cd_Cliente
	and F.num_proc is null 
	and desp_org_hia='N'
	and nome_tp_Tx like 'Adian%'
	and TT.cd_ax <> '000.1'
	and vlr_org_hia <> 0

Union all

SELECT 
	'ATL' System,
	'PURCHOPS',num_proc, 
	convert(varchar,dt_Documento,103),
	'' Voucher,
	I.CD_Tp_Tx,
	Nome_Tp_TX_Ing,
	'' [Ledger Account],
	Case
		when Moeda='REL' then 'BRL'
		else Moeda
	End Currency,
	case
		when DC='D' then Valor*-1
		else Valor
	End Value,
	case
		when DC='D' then Valor*-1*paridade
		else Valor*paridade
	End  [BRL Value], 
	Cd_Tp_TX_ATL,
	
	'Job Level'
	
FROM 
	AX_DOC A
	jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
	Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
	
WHERE 
	TIPO<>2 AND DT_CANC IS NOT NULL
	and convert(datetime,convert(varchar,dt_ins,103),105) between @DataInicial and @Datafinal
	 and Valor <> 0

Union all

SELECT 
	'ATL' System,
	'PURCHOPS',num_proc, 
	convert(varchar,dt_canc,103),
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
Union All

Select
	'ATL' System,
	'SALESOPS' Type,
	C.Num_Proc Job,
	
	convert(varchar,fatdtemissao,105) DocumentDt,
	'' Voucher,
	(
		CASE  
				When FA.ID_FAT is null then cd_Ax_repasse 
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
		when I.DC='D' then [dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1
		else [dbo].[spRateio_Mas](C.num_Proc)*abs(vlr_org)
	End Value,
	case
		when I.DC='D' then [dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1*I.paridade
		else [dbo].[spRateio_Mas](C.num_Proc)*abs(vlr_org)*I.paridade
	End [BRL Value],
	TT.cd_Tp_Tx [ATL Charge Code],
	'Consolidated Level'
From
	Fatura F
	Join Item_Fat I on I.fatcod=F.fatcod
	Join Tipo_Taxa TT on Tt.cd_tp_Tx=I.cd_tp_Tx
	Left Join Fatura_Arg_Det FI on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
	Join vwcliente C on C.master=I.num_proc
	Left Join Fatura_ARg FA on FA.id_Fat=FI.id_fat and status=0
	Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
Where
	convert(Datetime,convert(varchar(10),fatdtemissao,105),103) between @Datainicial and @DataFinal 
	and dt_canc is  null
	and len(I.fatcod)=15
	and TT.cd_ax <> '000.1'
	and vlr_org <> 0
*/
GO
