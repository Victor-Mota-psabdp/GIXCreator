SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_ValoresSolenisMensal_Rel '2021-01-08 00:00:00','2021-01-18 00:00:00'
--select * from Tipo_Campo_Cliente where Descr_Campo like '%despa%'
--cadu 18/01/2021 - estava dando erro pois estava com paridade = 0 qdo nao tivesse paridade no JOB, alterei p 1 e avisei a camila sobre
--(case when CP176.campo_dados is null or CP176.campo_dados = '' then 0 else cast(CP176.campo_dados as decimal(18,4)) end) ExchangeRatesUSDValue,
CREATE procedure [dbo].[spATL_ValoresSolenisMensal_Rel]
(
	@DataInicial datetime,
	@DataFinal datetime
)
as


Declare @Grupo varchar(20)
--Declare @DataInicial datetime
--Declare @DataFinal datetime
Declare @Cd_Grupo as varchar(10)

set @Grupo = 'Grupo Solenis'
--set @DataInicial ='2020-12-08 00:00:00'
--set @DataFinal = '2021-01-18 00:00:00' 

Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)



declare @Temp table (
 [Final Destination] varchar(200),
 [Consignee] varchar(200),
 [BDP Ref.] varchar(16),
 [PO Number] varchar(500),
 [Shipper] varchar(200),
 [Origin] varchar(200),
 [Destination] varchar(200),
 [Netweight KG– Shipment] float ,
 [Gross Weight KG] float,
 [Container Type] varchar(200),
 [Incoterm] varchar(3),
 [Valor total da invoice] varchar(100),
 [Valor total da invoice - USD] float,
 [FOB - USD] float,
 [Freight - USD] float,
 [CIF - USD] float,
 [CIF - R$] float,
 [II - R$] float,
 [IPI - R$] float,
 [PIS - R$] float,
 [Cofins - R$] float,
 [ICMS - R$] float,
 [Siscomex - R$] float,
 [Honorario] float,
 [Dt.Faturamento Previo] datetime,
 ExchangeRatesUSDValue  Decimal(18,4),
 InsuranceValue float,
 [FOB BRL] float
)


insert @Temp
select 
DstFinal.Nome_Local [Final Destination],
C.Nome_Raz_Soc [Consignee],
HOU.Num_Proc [BDP Ref.],
left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,1),500) [PO Number],
S.Nome_Raz_Soc [Shipper],
Org.Nome_Local [Origin],
DST.Nome_Local [Destination],
HOU.Peso_Liquido [Netweight KG – Shipment],
HOU.Peso_Bruto [Gross Weight KG],
left([dbo].[fBusca_Containers_TP](HOU.Num_Proc),120) [Container Type],
HOU.cd_tp_oper [Incoterm],
HOU.Moeda_invoice + ' ' + replace(cast(cast(HOU.Vlr_invoice as decimal(18,2)) as varchar(50)),'.',',') [Valor total da invoice],
NULL [Valor total da invoice - USD],
NULL [FOB - USD],
NULL [Freight - USD],
NULL [CIF - USD],
NULL [CIF - R$],
NULL [II - R$],
NULL [IPI - R$],
NULL [PIS - R$],
NULL [Cofins - R$],
NULL [ICMS - R$],
NULL [Siscomex - R$],
NULL [Honorario],
TP79.Dt_Conclusao [Dt.Faturamento Previo],
(case when CP176.campo_dados is null or CP176.campo_dados = '' then 1 else cast(CP176.campo_dados as decimal(18,4)) end) ExchangeRatesUSDValue,
NULL InsuranceValue,
NULL [FOB BRL]
from vwHouse_Imp HOU
left Join Localidade DstFinal with(nolock) on DstFinal.cd_local=HOU.cd_Dstfinal
left Join Pessoa C with(nolock) on C.Cd_Pes=HOU.Cd_Consig
left Join Pessoa S with(nolock) on S.Cd_Pes=HOU.Cd_Export
join pessoa_LLP	GR with(nolock) on GR.cd_pes = HOU.Cd_Consig and GR.cd_pes_grupo = @Cd_Grupo
left Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org
left Join Localidade Dst with(nolock) on DST.cd_local=HOU.cd_dst
left Join Campo_Processo CP176 with(nolock) on CP176.Num_Proc = HOU.Num_Proc and CP176.id_campo=176
join Tarefas_Processos TP79 with(nolock) on HOU.Num_Proc = TP79.Num_Proc and TP79.ID_Task = '79'
where  TP79.Dt_Conclusao between @DataInicial and @DataFinal
--and (CP176.campo_dados is null or CP176.campo_dados = '')
--select * from Tipo_Campo_Cliente
--where Descr_Campo like '%CIF%'



update HOU set [CIF - R$] = cast(Campo_Dados as decimal(18,2)), [CIF - USD] = cast(Campo_Dados/ExchangeRatesUSDValue as decimal(18,2))   from @Temp HOU
  join  (select Num_Proc,Campo_Dados from Campo_Processo C where C.Id_Campo = 110 ) S on HOU.[BDP Ref.] = S.Num_Proc
					
update HOU set HOU.InsuranceValue = totSeguro  from @Temp HOU
  join  (select C.Num_Proc, sum(vlr_item_Custo) totSeguro from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					where nome_tp_Tx like '%Seguro%' group by C.Num_Proc) S on HOU.[BDP Ref.] = S.Num_Proc

update HOU set 
				HOU.[FOB - USD] = cast(fobusd /ExchangeRatesUSDValue as decimal(18,2)),
				HOU.[Freight - USD] = cast(FreightUSD /ExchangeRatesUSDValue as decimal(18,2)),
				--HOU.[CIF - R$] = cast(CIFRS as decimal(18,2)),
				--HOU.[CIF - USD] = cast(CIFRS/ExchangeRatesUSDValue as decimal(18,2)),
				[II - R$] = totII,
				[IPI - R$] = totIPI,
				[PIS - R$] = totPis,
				[Cofins - R$] = totCofins,
				[ICMS - R$] = totICMS,
				[Siscomex - R$] = totSiscomex,
				[FOB BRL] = FOB_BRL
				
from  @Temp HOU
	join (select 
			NC.Num_Proc,
			cast(sum(Vlr_Total_ITem-isnull(vlr_frete,0)-isnull(vlr_seguro,0)-isnull(vl_ii,0)-isnull(ACRESCIMOS,0)) as decimal(18,2)) fobusd,
			cast(sum(Vlr_Total_ITem-isnull(vlr_frete,0)-isnull(vlr_seguro,0)-isnull(vl_ii,0)-isnull(ACRESCIMOS,0)) as decimal(18,2)) FOB_BRL,
			cast(sum(Vlr_Frete)as decimal(18,2))FreightUSD,
			--cast(sum(Vlr_Total_ITem-isnull(vl_ii,0)-isnull(ACRESCIMOS,0)) as decimal(18,2)) CIFRS,
			sum(VL_II) totII, 
			sum(VL_IPI) totIPI,
			sum(VL_IMPOSTO_PIS) totPis,
			sum(VL_IMPOSTO_COFINS) totCofins,
			sum(VL_ICMS) totICMS,
			sum(Vlr_Siscomex) totSiscomex
			--sum(NCD.Vlr_Item) totVlr_Item,
			--sum(NCD.Vlr_Total_Item) totVlr_Total_Item,
 from Nota_Cliente NC with(nolock)
left Join Nota_Fiscal_Cliente_det NCD With(nolock) on NCD.cd_cliente=NC.cd_cliente and Nc.id_nf=ncd.id_nf group by NC.Num_Proc) N on N.Num_Proc = HOU.[BDP Ref.]


declare @TABCusto table
	(
	[Processo_PC] varchar(16),
	Nome_Tp_Tx varchar(50),
	VLR_PC	float,
	TP_PGTO varchar(10)
	
	)
	insert @TABCusto
			SELECT 
			distinct
			FAT.Processo_PC,
				TT.Nome_Tp_Tx,
					VLR_PC,
					--(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then 'A' else
					--	(Case when ITM.TP_PGTO = 'C' then 'C' else
					--		(Case when SOL.ID IS not NULL then 'S' else
					--			(case when TT.Cd_AX_Repasse IN ('000.1') then 'R' else
					--				'D' END)END)END)END) TP_PGTO									
									
				(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then 'A' else
						(Case when ITM.TP_PGTO = 'C'  then 'C' else
							(Case when (SOL.ID IS not NULL or TT.NF = 'N') and TT.Cd_AX_Repasse not IN ('000.1')   then 'S'  else
								(case when TT.Cd_AX_Repasse IN ('000.1')  then 'R' else
									'D' END)END)END)END) TP_PGTO
														
				FROM 
				--vwFaturasValidasCHB FAT with(nolock)
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC					
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=FAT.CD_PES_PC 
					LEFT JOIN vwcta_Cte CCH with(nolock) on CCH.Num_Proc_HIA = LEFT(FAT.FATURA_PC,16) and CCH.Num_NF_HIA is not null AND CCH.Ref_Acesso_NF_HIA <> 'P' AND CCH.Ref_Acesso_NF_HIA is not null and cch.cd_tp_tx = itm.Cd_Tp_Tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=ITM.cd_tp_Tx
					left join vwSolPgtoCtaCteAprovadas SOL with(nolock) on SOL.Num_Proc = LEFT(iTM.Fatura_CC,16) and SOL.Cd_Tp_Tx = ITM.cd_tp_tx and sol.DC = ITM.DC
					join @Temp T on T.[BDP Ref.] = FAT.Processo_PC
				WHERE 
				--ITM.Imprime='S' 
				--and 
				FAT.Status_PC = 'E'
				
				union ALL
				
							SELECT 
			distinct
			J.Num_Proc,
				TT.Nome_Tp_Tx,
					VLR_PC,
					--(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then 'A' else
					--	(Case when ITM.TP_PGTO = 'C' then 'C' else
					--		(Case when SOL.ID IS not NULL then 'S' else
					--			(case when TT.Cd_AX_Repasse IN ('000.1') then 'R' else
					--				'D' END)END)END)END) TP_PGTO									
									
				(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then 'A' else
						(Case when ITM.TP_PGTO = 'C'  then 'C' else
							(Case when (SOL.ID IS not NULL or TT.NF = 'N') and TT.Cd_AX_Repasse not IN ('000.1')   then 'S'  else
								(case when TT.Cd_AX_Repasse IN ('000.1')  then 'R' else
									'D' END)END)END)END) TP_PGTO
														
				FROM 
				--vwFaturasValidasCHB FAT with(nolock)
					FATURA_CHB FAT with(nolock)
					left join JOB_HBO J on J.Num_Proc_HBO = FAT.Processo_PC
					join @Temp T on T.[BDP Ref.] = J.Num_Proc
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC					
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=FAT.CD_PES_PC 
					LEFT JOIN vwcta_Cte CCH with(nolock) on CCH.Num_Proc_HIA = LEFT(FAT.FATURA_PC,16) and CCH.Num_NF_HIA is not null AND CCH.Ref_Acesso_NF_HIA <> 'P' AND CCH.Ref_Acesso_NF_HIA is not null and cch.cd_tp_tx = itm.Cd_Tp_Tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=ITM.cd_tp_Tx
					left join vwSolPgtoCtaCteAprovadas SOL with(nolock) on SOL.Num_Proc = LEFT(iTM.Fatura_CC,16) and SOL.Cd_Tp_Tx = ITM.cd_tp_tx and sol.DC = ITM.DC
					
				WHERE 
				--ITM.Imprime='S' 
				--and 
				FAT.Status_PC = 'E'


update @Temp  set Honorario = cast((select Sum(VLR_PC) from @TABCusto TC where [BDP Ref.] = Processo_PC  and TP_PGTO = 'D'
		and Nome_Tp_Tx not like ('%BDP%')) as decimal(18,2))
		
		

update @Temp set [Valor total da invoice - USD] = cast((select sum(A.FOB_USD) from ATL_Capa_Valores A where [BDP Ref.] = Num_Proc) as decimal(18,2))

--update HOU set  

-- HOU.[FOB - USD] = cast(sum(Vlr_Total_ITem-isnull(vlr_frete,0)-isnull(vlr_seguro,0)-isnull(vl_ii,0)-isnull(ACRESCIMOS,0))*ExchangeRatesUSDValue as decimal(18,2)),
-- HOU.[Freight - USD] = cast(sum(Vlr_Frete)*ExchangeRatesUSDValue as decimal(18,2)),
-- HOU.[CIF - R$] = (isnull(cast(sum(NCD.Vlr_Total_ITem-isnull(NCD.vlr_frete,0)-isnull(NCD.vlr_seguro,0)-isnull(vl_ii,0)-isnull(ACRESCIMOS,0)) as Decimal(18,2)),0) 
--			+ isnull(cast(sum(NCD.Vlr_Frete) as Decimal(18,2)),0) 
--			+ isnull(cast(HOU.InsuranceValue as Decimal(18,2)),0)),
-- [CIF - USD] = cast(HOU.[CIF - R$]*ExchangeRatesUSDValue as decimal(18,2))
 
-- from @Temp HOU
--left Join Nota_Cliente NC with(nolock)on NC.Num_Proc = HOU.[BDP Ref.] 
--left Join Nota_Fiscal_Cliente_det NCD With(nolock) on NCD.cd_cliente=NC.cd_cliente and Nc.id_nf=ncd.id_nf
--where NC.Num_Proc = HOU.[BDP Ref.]
--select * from @Temp
select  [Final Destination],
 [Consignee],
 [BDP Ref.],
 [PO Number],
 [Shipper],
 [Origin],
 [Destination],
 [Netweight KG– Shipment] ,
 [Gross Weight KG],
 [Container Type],
 [Incoterm],
 [Valor Total da Invoice],
 [Valor Total da Invoice - USD],
 [FOB - USD],
 [Freight - USD],
 [CIF - USD],
 [CIF - R$],
 [II - R$],
 [IPI - R$],
 [PIS - R$],
 [Cofins - R$],
 [ICMS - R$],
 [Siscomex - R$],
 [Honorario],
 [Dt.Faturamento Previo] from @Temp
GO
