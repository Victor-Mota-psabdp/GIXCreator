SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAtualiza_AX_DailyReport_YEAR_Temp]

As

Declare	@DataInicial	Datetime
Declare @DataFinal		Datetime
Declare	@Tipo			Varchar(5)

set @Tipo = 'Year'

If @Tipo = 'Year'
	Begin
		Set @DataInicial= cast(year(getdate()-1)as varchar(4))+ '-01'+'-01'
		SEt @DataFinal=getdate()-1
	End	


Begin transaction

	delete AX_DailyReport where date between @DataInicial and @DataFinal
--pra não ter q toda vez alterar em 3 locais, estou usando a tabela principal pra atualizar os dados
	insert into AX_DailyReport
			--exec [dbo].[spAXDailyReport_Rel]@DataInicial,@DataFinal, @Tipo				
			exec [dbo].[spAXDailyReport_Teste_Rel]@DataInicial,@DataFinal, @Tipo		

Commit Transaction


--**********************Stored antiga**************************

--select 
--				'ATL' [System],
--				'PURCHOPS' [Type],
--				CC.Num_Proc_HIA Job,
--				convert(varchar(50),convert(datetime,dt_ins_hia,103),101) [Transaction Dt], 
--				'' Voucher,
--				(
--					CASE  
--							When RFI.num_registro is null then cd_Ax_Repasse
--							else cd_Ax_resultado
--					End	
--				)
--				[AX Charge Code],
--				Nome_Tp_Tx_Ing [ATL Charge Description],
--				'' [Ledger Account],

--				Case
--					when cc.cd_Tp_moeda='REL' then 'BRL'
--					else cc.cd_tp_moeda
--				End Currency,
--					/*
--				case
--					when CC.DC_HIA='D' then Vlr_Org_HIA*-1
--					else vlr_org_hia
--				End Value,
--				case
--					when CC.DC_HIA='D' then Vlr_Org_HIA*-1*isnull(par.par_moeda,1)
--					else vlr_org_hia*isnull(par.par_moeda,1)
--				End  [BRL Amount],
--				*/
--				case
--					when CC.DC_hia='D' then cast((abs(Vlr_Org_hia)*-1)-((abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1))	as decimal(10,2))
--					else cast(abs(vlr_org_hia)-(abs(vlr_org_hia)*isnull(IRRF,0)/100)as decimal(10,2))
--				End Value,
--				case
--					when CC.DC_hia='D' then cast(((abs(Vlr_Org_hia)*-1)-((abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1)))*isnull(par.par_moeda,1) as  decimal(10,2))
--					else cast((abs(vlr_org_hia)-(abs(vlr_org_hia)*isnull(Isnull(IRRF,0)/100,1)))*isnull(par.par_moeda,1)as decimal(10,2))
--				End  [BRL Value],
--				Upper(CC.Cd_Tp_TX) [ATL Charge Code],
--				'Job Level' [Registered on],
--				convert(Datetime,dt_ins_hia,105)	
--			From vwcta_cte CC
--				Join vwcliente C on c.num_proc=CC.num_proc_hia
--				Left Join vwFaturasValidas F on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
--				Join Tipo_Taxa TT on TT.cd_tp_Tx=cc.cd_tp_Tx
--			--	Left Join Tipo_Taxa_AX AXR on AX.Cd_Charge_AX = Cd_AX_Resultado 
--			--	Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=cd_Ax_Repasse
--				Left Join Pessoa_ATL_AX AXP on AXP.Cd_Pes = CC.cd_cred_Dev_hia and AXP.Tipo = 'F'
--				Left Join dbo.AX_XML_Vendor_Recebido CR on CR.accountnum =AXP.cd_ax
--				Left Join Pessoa PS on PS.Cd_Pes = CC.cd_cred_Dev_hia 
--				LEft Join registro_financeiro_item RFI on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
--				Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
--				Left Join Paridade PAR on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
--			--Adicionado em 27-06-2014
--				Left Join dbo.vwAXDocs AXD on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
--				Left Join Tipo_Tax_AX TXA on Cd_Tax_AX=AXD.Tax_Group and CR.TaxGroup not in ('CUS SER 20','Exempt')
--			--Fim em 27-06-2014
--			where	
--				convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and cd_cred_Dev_hia <> cd_Cliente
--				and F.num_proc is null 
--				and desp_org_hia='N' 
--				and (CC.DC_hia = 'D' or CC.DC_hia ='C' and CC.Cd_Tp_Tx in ('XY0','XY1','D2D'))	
--				and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1')
--				and vlr_org_hia <> 0  
--				and ((PS.cd_tp_Ativ = 'AGT' and CC.DC_hia = 'D' and AXP.Tipo = 'F') or (PS.cd_tp_Ativ <> 'AGT' and AXP.Tipo = 'F')) 
--			--	and @Num_proc = c.num_proc

--				Union all

--			select 
--				'ATL' [System],
--				'PURCHOPS' [Type],
--				C.Num_Proc Job,
--				convert(varchar(50),convert(datetime,dt_ins_hia,103),101), 
--				'' Voucher,
--				(
--					CASE  
--							When RFI.num_registro is null then cd_Ax_Repasse
--							else cd_Ax_resultado
--					End	
--				)
--				[AX Charge Code],
--				Nome_Tp_Tx_Ing [ATL Charge Description],
--				'' [Ledger Account],
--				Case
--					when cc.cd_Tp_moeda='REL' then 'BRL'
--					else cc.cd_tp_moeda
--				End,
--				/*
--				case
--					when CC.DC_HIA='D' then Vlr_Org_HIA*-1*[dbo].[spRateio_Mas](C.num_Proc)
--					else vlr_org_hia*[dbo].[spRateio_Mas](C.num_Proc)
--				End ,
--					case
--					when CC.DC_HIA='D' then Vlr_Org_HIA*-1*[dbo].[spRateio_Mas](C.num_Proc)*isnull(par.par_moeda,1)
--					else vlr_org_hia*[dbo].[spRateio_Mas](C.num_Proc)*isnull(par.par_moeda,1)
--				End  [BRL Amount],
--				*/
--					case
--					when CC.DC_hia='D' then cast(([dbo].[spRateio_Mas](c.num_proc)*abs(Vlr_Org_hia)*-1)-([dbo].[spRateio_Mas](c.num_proc)*abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1) as decimal(10,2))
--					else cast([dbo].[spRateio_Mas](c.num_proc)*abs(vlr_org_hia)-([dbo].[spRateio_Mas](c.num_proc)*abs(Vlr_Org_hia))*isnull(Isnull(IRRF,0)/100,1)as decimal(10,2))
--				End Value,
--				case
--					when CC.DC_hia='D' then cast((([dbo].[spRateio_Mas](c.num_proc)*abs(Vlr_Org_hia)*-1)-([dbo].[spRateio_Mas](c.num_proc)*abs(Vlr_Org_hia)*-1)*isnull(Isnull(IRRF,0)/100,1))*isnull(par.par_moeda,1) as decimal(10,2))
--					else cast(([dbo].[spRateio_Mas](CC.num_Proc_hia)*abs(vlr_org_hia)-([dbo].[spRateio_Mas](CC.num_Proc_hia)*abs(Vlr_Org_hia))*isnull(Isnull(IRRF,0)/100,1))*isnull(par.par_moeda,1) as decimal(10,2))
--				End [BRL Value],
--				Upper(CC.Cd_Tp_TX) [ATL Charge Code],
--				'Consolidated Level' [Registered on],
--				convert(Datetime,dt_ins_hia,105)					
--			From vwcta_cte CC
--				Join vwcliente C on c.master=CC.num_proc_hia
--				Left Join vwFaturasValidas F on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
--				Join Tipo_Taxa TT on TT.cd_tp_Tx=cc.cd_tp_Tx
--				--Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_AX 
--				--Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
--				Left Join Pessoa_ATL_AX AXP on AXP.Cd_Pes = CC.cd_cred_Dev_hia and AXP.Tipo = 'F'
--				Left Join dbo.AX_XML_Vendor_Recebido CR on CR.accountnum =AXP.cd_ax
--				Left Join Pessoa PS on PS.Cd_Pes = CC.cd_cred_Dev_hia 
--				LEft Join registro_financeiro_item RFI on CC.num_proc_hia=rfi.num_proc and CC.dc_hia=rfi.dc and CC.cd_Tp_tx=RFI.cd_tp_tx
--				Left Join Registro_Financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rf.num_registro=RFI.num_registro
--				Left Join Paridade PAR on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia
--				--Adicionado em 27-06-2014
--				Left Join dbo.vwAXDocs AXD on AXD.num_proc=CC.num_proc_hia and CC.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CC.dc_hia 
--				Left Join Tipo_Tax_AX TXA on Cd_Tax_AX=AXD.Tax_Group and CR.TaxGroup not in ('CUS SER 20','Exempt')
--			--Fim em 27-06-2014

--			where	
--				convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and  cd_cred_Dev_hia <> cd_Cliente
--				and F.num_proc is null and desp_org_hia='N' and (CC.DC_hia = 'D' or CC.DC_hia ='C' and CC.Cd_Tp_Tx in ('XY0','XY1','D2D'))	
--				and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1')
--				and vlr_org_hia <> 0 
--				and ((PS.cd_tp_Ativ = 'AGT' and CC.DC_hia = 'D' and AXP.Tipo = 'F')
--				or (PS.cd_tp_Ativ <> 'AGT')) 
--			--	and @num_proc = c.num_proc

--			Union all

--			SELECT 
--				'ATL' [System],
--				'PURCHOPS',num_proc, 
--				convert(varchar(50),convert(datetime,dt_Documento,103),101),
--				--convert(varchar,dt_Documento,103),
--				'' Vourcher,
--				I.CD_Tp_Tx,
--				Nome_Tp_TX_Ing,
--				'' [Ledger Account],
--				Case
--					when Moeda='REL' then 'BRL'
--					else Moeda
--				End Currency,
--				case
--					when DC='D' then Valor*-1
--					else Valor
--				End [ Value], 
--					case
--					when DC='D' then Valor*paridade*-1
--					else Valor*paridade
--				End  [BRL Value],
--				Cd_Tp_TX_ATL,
--				'Job Level',
--				convert(datetime,convert(varchar,dt_ins,103),105)
--			FROM 
--				AX_DOC A
--				jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
--				Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
				
--			WHERE 
--				TIPO=2 AND DT_CANC IS NOT NULL
--				and convert(datetime,convert(varchar,dt_ins,103),105) between @DataInicial and @Datafinal
--				and Valor <> 0 
--			--	and @Num_proc = num_proc

--			Union all
--			/*
--			SELECT 
--				'ATL' [System],
--				'PURCHOPS',num_proc, 
--				convert(varchar(50),convert(datetime,dt_canc,103),101),
--				--convert(varchar,dt_canc ,103),
--				'' Vourcher,
--				I.CD_Tp_Tx,
--				Nome_Tp_TX_Ing,
--				'' [Ledger Account],
--				Case
--					when Moeda='REL' then 'BRL'
--					else Moeda
--				End Currency,
--				case
--					when DC='D' then Valor
--					else Valor*-1
--				End [ Value], 
--				case
--					when DC='D' then Valor*paridade
--					else Valor*paridade*-1
--				End  [BRL Value],
--				Cd_Tp_TX_ATL,
--				'Void'	
--			FROM 
--				AX_DOC A
--				jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
--				Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
--			WHERE TIPO=2 and convert(datetime,convert(varchar,DT_CANC,103),105) between @DataInicial and @Datafinal
--				 and Valor <> 0 
--			--	 and @Num_proc = num_proc
--			*/

--			SELECT 
--				'ATL' [System],
--				'PURCHOPS',num_proc, 
--				convert(varchar(50),convert(datetime,dt_canc,103),101),
--				--convert(varchar,dt_canc ,103),
--				'' Vourcher,
--				I.CD_Tp_Tx,
--				Nome_Tp_TX_Ing,
--				'' [Ledger Account],
				
--				Case
--					when Moeda='REL' then 'BRL'
--					else Moeda
--				End Currency,
--				case
--					when i.DC='C' then cast((abs(Valor)*-1)+((abs(Valor)*-1)*isnull(Isnull(Porcentagem,0)/100,1))	as decimal(10,2))
--					else cast(abs(Valor)-(abs(Valor)*isnull(Porcentagem,0)/100)as decimal(10,2))
--				End Value,
--				case
--					when i.DC='C' then cast(((abs(Valor)*-1)+((abs(Valor)*-1)*isnull(Isnull(Porcentagem,0)/100,1)))*isnull(paridade,1) as  decimal(10,2))
--					else cast((abs(Valor)-(abs(Valor)*isnull(Isnull(Porcentagem,0)/100,1)))*isnull(paridade,1)as decimal(10,2))
--				End  [BRL Value],
--				Cd_Tp_TX_ATL,
--				'Void',
--				convert(datetime,convert(varchar,DT_CANC,103),105)
--			FROM 
--				AX_DOC A
--				jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
--				Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
--				Left Join Tipo_Tax_AX TXA on Cd_Tax_AX=i.TaxGroup and i.TaxGroup not in ('CUS SER 20','Exempt')
--			WHERE TIPO=2 and convert(datetime,convert(varchar,DT_CANC,103),105) between @DataInicial and @Datafinal
--				 and Valor <> 0 
--				 --and @num_proc = num_proc					 

--			union all
			
--			Select
--				'ATL' [System],
--				'SALESOPS' Type,
--				I.Num_Proc Job,
--				--convert(varchar,fatdtemissao,105) DocumentDt,
--				convert(varchar(50),convert(datetime,fatdtemissao,103),101),
--				'' Voucher,
--				(
--					CASE  
--							When FI.ID_FAT is null then cd_Ax_repasse 
--							else cd_ax_resultado
--					End	
--				) [AX Charge Code],
--				(Nome_Tp_Tx_ing),
--				'' [Ledger Account],
--				Case
--					when I.cd_Tp_moeda='REL' then 'BRL'
--					else I.cd_tp_moeda
--				End Currency,
--				case
--					when I.DC='D' then (abs(Vlr_Org)*-1)-((abs(Vlr_Org)*-1)*isnull(Isnull(IRRF,0)/100,1))		
--					else abs(vlr_org)-(abs(vlr_org)*isnull(IRRF,0)/100)
--				End Value,
--				case
--					when I.DC='D' then ((abs(Vlr_Org)*-1)-((abs(Vlr_Org)*-1)*isnull(Isnull(IRRF,0)/100,1)))*I.paridade
--					else (abs(vlr_org)-(abs(vlr_org)*isnull(Isnull(IRRF,0)/100,1)))*I.paridade
--				End  [BRL Value],
--				Upper(TT.cd_Tp_Tx) [ATL Charge Code],
--				'Job Level',
--				convert(Datetime,convert(varchar(10),fatdtemissao,105),103)
--			From
--				Fatura F
--				Join Item_Fat I on I.fatcod=F.fatcod
--				Join Tipo_Taxa TT on Tt.cd_tp_Tx=I.cd_tp_Tx
--				Left Join vwFaturasValidasArg FI on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
--				Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
--				Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
--			--Adicionado 27-06-2014
--				Left Join PEssoa_ATL_AX PPA on PPA.cd_pes=F.cd_pes and tipo='C'
--				Left Join dbo.AX_XML_Customer_Recebido AXC on AXC.AccountNum=PPA.cd_ax
--			--Fim
--			--Adicionado em 03-06-2014
--				Left Join dbo.vwAXDocs AXD on AXD.num_proc=I.num_proc and I.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=I.dc 
--				Left Join Tipo_Tax_AX TXA on Cd_Tax_AX=AXD.Tax_Group and AXC.TaxGroup not in ('CUS SER 20','Exempt')
--			--Fim em 03-06-2014


--			Where
--				convert(Datetime,convert(varchar(10),fatdtemissao,105),103) between @Datainicial and @DataFinal and 
--				dt_canc is  null
--				and len(I.fatcod)=17
--				and TT.cd_ax_Resultado <> '000.1'
--				and vlr_org <> 0 
--				--and I.Num_Proc = @Num_proc

--			Union all
			
--			select 
--				'ATL' System,
--				'SALESOPS' [Type],
--				CC.Num_Proc_HIA Job,
--				--dt_ins_hia, 
--				convert(varchar(50),convert(datetime,dt_ins_hia,103),101),
--				'' Voucher,
--				cd_ax_repasse	[AX Charge Code],
--				Nome_Tp_Tx_Ing [ATL Charge Description],
--				'' [Ledger Account],
--				Case
--					when cc.cd_Tp_moeda='REL' then 'BRL'
--					else cc.cd_tp_moeda
--				End Currency,
--				case
--					when CC.DC_HIA='D' then Vlr_Org_HIA*-1
--					else vlr_org_hia
--				End Value,
--				case
--					when CC.DC_HIA='D' then Vlr_Org_HIA*-1*isnull(par.par_moeda,1)
--					else vlr_org_hia*isnull(par.par_moeda,1)
--				End [BRL Value],
--				Upper(CC.Cd_Tp_TX) [ATL Charge Code],
--				'Job Level' [Registered on],
--				convert(Datetime,dt_ins_hia,105)
				
--			From vwcta_cte CC
--				Join vwcliente C on c.num_proc=CC.num_proc_hia
--				Left Join vwFaturasValidas F on F.num_proc=CC.num_proc_hia and F.cd_Tp_Tx=Cc.cd_tp_Tx and F.dc=cc.dc_hia
--				Join Tipo_Taxa TT on TT.cd_tp_Tx=cc.cd_tp_Tx
--				Left Join Paridade PAR on PAR.Cd_Tp_Moeda = cc.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia

--			where	
--				convert(Datetime,dt_ins_hia,105) between @DataInicial and @dataFinal  and cd_cred_Dev_hia = cd_Cliente
--				and F.num_proc is null 
--				and desp_org_hia='N'
--				and nome_tp_Tx like 'Adian%'
--				and TT.cd_ax_Resultado <> '000.1'
--				and vlr_org_hia <> 0 
--			--	and CC.Num_Proc_HIA = @Num_proc

--			Union all

--			SELECT 
--				'ATL' System,
--				'SALESOPS',num_proc, 
--				--convert(varchar,dt_Documento,103),
--				convert(varchar(50),convert(datetime,dt_Documento,103),101),
--				'' Voucher,
--				I.CD_Tp_Tx,
--				Nome_Tp_TX_Ing,
--				'' [Ledger Account],
--				Case
--					when Moeda='REL' then 'BRL'
--					else Moeda
--				End Currency,
--				case
--					when DC='D' then Valor*-1
--					else Valor
--				End Value,
--				case
--					when DC='D' then Valor*-1*paridade
--					else Valor*paridade
--				End  [BRL Value], 
--				Cd_Tp_TX_ATL,
--				'Job Level',
--				convert(datetime,convert(varchar,A.dt_ins,103),105)
--			FROM 
--				AX_DOC A
--				jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
--				Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
--				--Join fatura fat on fat.fatcod=A.invoice_number
				
--			WHERE 
--				TIPO<>2 AND A.dt_Canc IS NOT NULL
--				and convert(datetime,convert(varchar,A.dt_ins,103),105) between @DataInicial and @DataFinal
--				 and Valor <> 0 
--				 --and Num_proc = 'IMOCV201312010BR'


--			Union all
--			/*
--			SELECT 
--				'ATL' System,
--				'SALESOPS',num_proc, 
--				--convert(varchar,dt_canc,103),
--				convert(varchar(50),convert(datetime,dt_canc,103),101),
--				'' Voucher,
--				I.CD_Tp_Tx [AX Charge Code],
--				Nome_Tp_TX_Ing,
--				'' [Ledger Account],
--				Case
--					when Moeda='REL' then 'BRL'
--					else Moeda
--				End Currency,
--				case
--					when DC='C' then Valor*-1
--					else Valor
--				End Value,
--				case
--					when DC='C' then Valor*-1*paridade
--					else Valor*paridade
--				End  [BRL Value], 
--				Cd_Tp_TX_ATL,

--				'Void'

				
--			FROM 
--				AX_DOC A
--				jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
--				Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
--			WHERE 
--				TIPO<>2 and convert(datetime,convert(varchar,DT_CANC,103),105) between @DataInicial and @Datafinal
--				 and valor <> 0 
--				 */
--			SELECT 
--				'ATL' System,
--				'SALESOPS',num_proc, 
--				--convert(varchar,dt_canc,103),
--				convert(varchar(50),convert(datetime,dt_canc,103),101),
--				'' Voucher,
--				I.CD_Tp_Tx [AX Charge Code],
--				Nome_Tp_TX_Ing,
--				'' [Ledger Account],
--				Case
--					when Moeda='REL' then 'BRL'
--					else Moeda
--				End Currency,
--				/*
--				case
--					when DC='C' then Valor*-1
--					else Valor
--				End Value,
--				case
--					when DC='C' then Valor*-1*paridade
--					else Valor*paridade
--				End  [BRL Value], */
--					case
--					when i.DC='C' then cast((abs(Valor)*-1)-((abs(Valor)*-1)*isnull(Isnull(IRRF,0)/100,1))	as decimal(10,2))
--					else cast(abs(Valor)+(abs(Valor)*isnull(IRRF,0)/100)as decimal(10,2))
--				End Value,
--				case
--					when i.DC='C' then cast(((abs(Valor)*-1)-((abs(Valor)*-1)*isnull(Isnull(IRRF,0)/100,1)))*isnull(paridade,1) as  decimal(10,2))
--					else cast((abs(Valor)+(abs(Valor)*isnull(Isnull(IRRF,0)/100,1)))*isnull(paridade,1)as decimal(10,2))
--				End  [BRL Value],
--				Cd_Tp_TX_ATL,
--				'Void',
--				convert(datetime,convert(varchar,DT_CANC,103),105)					
--			FROM 
--				AX_DOC A
--				jOIN AX_dOC_itEM i ON I.id_Ax=A.id_Ax
--				Join Tipo_Taxa TT on TT.cd_tp_tx=Cd_tp_Tx_ATL
--				Left Join Tipo_Tax_AX TXA on Cd_Tax_AX=i.TaxGroup and i.TaxGroup not in ('CUS SER 20','Exempt')
--			WHERE 
--				TIPO<>2 and convert(datetime,convert(varchar,DT_CANC,103),105) between @Datainicial and @DataFinal 
--				 and valor <> 0 
--			--	 and num_proc = @num_proc

--			Union All

--			Select
--				'ATL' System,
--				'SALESOPS' Type,
--				C.Num_Proc Job,
				
--				--convert(varchar,fatdtemissao,105) DocumentDt,
--				convert(varchar(50),convert(datetime,fatdtemissao,103),101),
--				'' Voucher,
--				(
--					CASE  
--							When FI.ID_FAT is null then cd_Ax_repasse 
--							else cd_ax_resultado
--					End	
--				) [AX Charge Code],
--				(Nome_Tp_Tx_ing),
--				'' [Ledger Account],
--				Case
--					when I.cd_Tp_moeda='REL' then 'BRL'
--					else I.cd_tp_moeda
--				End Currency,
--				case
--					when I.DC='D' then ([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1)-([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1)*isnull(Isnull(IRRF,0)/100,1)
--					else [dbo].[spRateio_Mas](C.num_Proc)*abs(vlr_org)-([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org))*isnull(Isnull(IRRF,0)/100,1)
--				End Value,
--				case
--					when I.DC='D' then (([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1)-([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org)*-1)*isnull(Isnull(IRRF,0)/100,1))*I.paridade
--					else ([dbo].[spRateio_Mas](C.num_Proc)*abs(vlr_org)-([dbo].[spRateio_Mas](C.num_Proc)*abs(Vlr_Org))*isnull(Isnull(IRRF,0)/100,1))*I.paridade
--				End [BRL Value],
--				TT.cd_Tp_Tx [ATL Charge Code],
--				'Consolidated Level',
--				convert(Datetime,convert(varchar(10),fatdtemissao,105),103)
--			From
--				Fatura F
--				Join Item_Fat I on I.fatcod=F.fatcod
--				Join Tipo_Taxa TT on Tt.cd_tp_Tx=I.cd_tp_Tx
--				Left Join dbo.vwFaturasValidasArg FI on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
--				--Left Join Fatura_Arg_Det FI on FI.num_proc=I.num_proc and FI.cd_tp_Tx=I.cD_tp_Tx and FI.dc=I.dc
--				Join vwcliente C on C.master=I.num_proc
--				--Left Join Fatura_ARg FA on FA.id_Fat=FI.id_fat and [status]<>2
--				Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = TT.Cd_AX 
--				Left Join Tipo_TAxa_AX AXPT on AX.CD_Charge_AX_PT=AXPT.cd_Charge_AX
--			--Adicionado 27-06-2014
--				Left Join PEssoa_ATL_AX PPA on PPA.cd_pes=F.cd_pes and tipo='C'
--				Left Join dbo.AX_XML_Customer_Recebido AXC on AXC.AccountNum=PPA.cd_ax
--			--Fim
--			--Adicionado em 03-06-2014
--				Left Join dbo.vwAXDocs AXD on AXD.num_proc=I.num_proc and I.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=I.dc 
--				Left Join Tipo_Tax_AX TXA on Cd_Tax_AX=AXD.Tax_Group and AXC.TaxGroup not in ('CUS SER 20','Exempt')
--			--Fim em 03-06-2014

--			Where
--				convert(Datetime,convert(varchar(10),fatdtemissao,105),103) between @Datainicial and @DataFinal 
--				and dt_canc is  null
--				and len(I.fatcod)=15
--				and TT.cd_ax_Resultado <> '000.1'
--				and vlr_org <> 0 
--			--	and C.Num_Proc = @Num_proc













GO
