SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_DespesasSolenisMensal_Rel] '2018-08-01','2018-08-30'

CREATE procedure [dbo].[spATL_DespesasSolenisMensal_Rel_test] 
(
@DataInicial datetime,
@DataFinal datetime
)
as

Declare @Grupo varchar(20)
--Declare @DtInicial datetime
--Declare @DtFinal datetime
Declare @Cd_Grupo as varchar(10)

set @Grupo = 'Grupo Solenis'
set @DataInicial = '2021-01-01'-- '2016-12-29'
set @DataFinal = '2021-05-30'  --'2016-12-29'

Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)

Declare @Temp table(
	[Destino final] varchar(50),
	[Ref. BDP] varchar(16),
	[Ref. Cliente] varchar(50),
	[Nr. DI] varchar(100),
	[Data DI] datetime,
	[Modal]varchar(50),
	[Exportador]varchar(200),
	[Desc. Produto] varchar(max),
	[Peso Liq. Total] float,
	[INCOTERM] varchar(3),
	[Valor AFRMM] float,
	[Valor Capatazias] float,
	[Frete Internacional] float,
	[Valor Armaz ZP] float,
	[Valor Desp. LI] float,
	[Valor Outras Despesas] float,
	[Valor Serviços com impostos] float,
	[Valor total (despesas + honorario BDP)] float,
	[Dt.Faturamento Previo] datetime
)

insert @Temp
Select 
DstFinal.Nome_Local [Destino final],
HOU.Num_Proc [Ref. BDP],
left(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,9),30) [Ref. Cliente],
left(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,5),100) [Nr. DI],
cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,5) as datetime) [Data DI],
HOU.Modal [Modal],
S.Nome_Raz_Soc [Exportador],
replace(dbo.fBusca_PRODUTO_Produto_Descr(HOU.Num_Proc),'|',char(13)+char(10))  [Desc. Produto],
HOU.Peso_Liquido [Peso Liq. Total],
HOU.cd_tp_oper [INCOTERM],
dbo.fBusca_Custo_Processo(HOU.Num_Proc,'%AFRMM%') [Valor AFRMM],
dbo.fBusca_Custo_Processo(HOU.Num_Proc,'Capatazia%') + dbo.fBusca_Custo_Processo(HOU.Num_Proc,'THC%') [Valor Capatazias],
(case when HOU.Tipo_Frete = 'Collect' then dbo.fBusca_Custo_Processo(HOU.Num_Proc,'FRETE%CHB%')
	else '0.00'end) [Frete Internacional],
dbo.fBusca_Custo_Processo(HOU.Num_Proc,'%Armazenagem%') [Valor Armaz ZP],
dbo.fBusca_Custo_Processo(HOU.Num_Proc,'Emissão%LI%') [Valor Desp. LI],
NULL [Valor Outras Despesas],
NULL [Valor Serviços com impostos],
NULL [Valor total (Despesas + Honorario BDP)],
TP79.Dt_Conclusao [Dt.Faturamento Previo]
From vwHouse_Imp HOU
left Join Localidade DstFinal with(nolock) on DstFinal.cd_local=HOU.cd_Dstfinal
left Join Pessoa S with(nolock) on S.Cd_Pes=HOU.Cd_Export
join Tarefas_Processos TP79 with(nolock) on HOU.Num_Proc = TP79.Num_Proc and TP79.ID_Task = '79'
join pessoa_LLP			GR with(nolock) on GR.cd_pes = HOU.Cd_Consig and GR.cd_pes_grupo = @Cd_Grupo
--left join Tarefas_Processos TP4 with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = '4'
where TP79.Dt_Conclusao between @DataInicial and @DataFinal
and HOU.Num_Proc in  ('IMSOL202011107BR','IMSOL202101002BR','IOSOL202102001BR','IMSOL202010067BR')
/*

select * from tipo_tarefas
where nome_task like '%faturamento%'
update HOU set HOU.[Valor AFRMM] = totAFRMM  from @Temp HOU
  join  (select C.Num_Proc, sum(vlr_item_Custo) totAFRMM from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					where nome_tp_Tx like '%AFRMM%' group by C.Num_Proc) S on HOU.[Ref. BDP] = S.Num_Proc

update HOU set HOU.[Valor AFRMM] = totAFRMM  from @Temp HOU
  join  (select C.Num_Proc, sum(vlr_item_Custo) totAFRMM from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					where (nome_tp_Tx like 'Capatazia%' and nome_tp_Tx like 'THC%') group by C.Num_Proc) S on HOU.[Ref. BDP] = S.Num_Proc
					
	
*/
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
					join @Temp T on T.[Ref. BDP] = FAT.Processo_PC
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
					join @Temp T on T.[Ref. BDP] = J.Num_Proc
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

				SELECT Sum(VLR_PC) FROM @TABCusto

				select [Valor AFRMM],[Valor Capatazias],[Frete Internacional],[Valor Armaz ZP],[Valor Desp. LI],* from @Temp

update @Temp  set [Valor Outras Despesas] =  
		cast((select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC  and TP_PGTO = 'S') - [Valor AFRMM] - [Valor Capatazias] - [Frete Internacional] 
		- [Valor Armaz ZP] - [Valor Desp. LI] as decimal(18,2))
		
		
update @Temp  set [Valor Serviços com impostos] = 	
		(select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC  and TP_PGTO = 'D'
		and Nome_Tp_Tx not like ('%BDP%'))
		
update @Temp  set [Valor total (despesas + honorario BDP)] = cast([Valor Serviços com impostos] + (select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC  and TP_PGTO = 'S')  as decimal(18,2))



select * from @Temp

--select * from @TABCusto
GO
