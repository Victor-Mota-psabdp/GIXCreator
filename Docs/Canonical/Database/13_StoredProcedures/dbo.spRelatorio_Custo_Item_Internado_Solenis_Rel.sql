SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Tarefas_Processos where Num_Proc = 'IMFMC201612025BR' and ID_Task = 4 
--[spRelatorio_Custo_Item_Internado_Rel]'Grupo FMC','2017-01-03','2017-03-03'
--[spRelatorio_Custo_Item_Internado_Solenis_Rel]'2017-04-11','2018-04-11'
CREATE Procedure [dbo].[spRelatorio_Custo_Item_Internado_Solenis_Rel]
(
	@DtInicial datetime,
	@DtFinal datetime
)
AS

Declare @Grupo varchar(20)
--Declare @DtInicial datetime
--Declare @DtFinal datetime
Declare @Cd_Grupo as varchar(10)

set @Grupo = 'Grupo Solenis'
--set @DtInicial ='2017-03-03' -- '2016-12-29'
--set @DtFinal = '2017-03-03' --'2016-12-29'

Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)
exec dbo.spATL_CalculaPercentual_Ins @Cd_Grupo

	declare @TAB table
	(
		[CNPJ]						varchar(200),
		[Ref. BDP]					char(16),		
		[Ref. Cliente]				varchar(200),
		[NRPEDIDO]					varchar(200),
		[NRREGISTROLI]				varchar(500),
		[Nr. DI]					varchar(50),
		[Data DI]					Datetime,		
		[Adição]					varchar(50),
		[Item]						varchar(50),
		[Modal]						varchar(20),
		[Exportador]				varchar(200),
		[Origem]					varchar(200),	
		[Cód. Produto]				varchar(500),		
		[Desc. Produto]				varchar(1000),
		[Qtde.]						float,
		[Unidade]					varchar(5),				
		[Peso Liq. Total]			float,
		[VUCV Moeda]				float,
		[Valor Total Moeda]			float,
		[Moeda DI]					varchar(200),
		[Taxa Moeda DI]				float,		
		[Taxa USD DI]				varchar(200),--			float,
		
		[Valor Total R$]			float,
		
		[INCOTERM]					varchar(200),
		[Tipo Frete]				varchar(200),
				
		[Valor FOB]					float,
		[Valor Frete Moeda]			float,
		[Moeda Frete]				varchar(200),
		[Taxa Moeda Frete]			varchar(200),
		[Valor Frete R$]			float,
		[Valor Seguro Moeda]		float,
		
		[Moeda Seguro]				varchar(200),	
		[Taxa Moeda Seguro]			varchar(200),		
		[Valor Seguro R$]			float,	
		[Acréscimos R$]				float,
		[Taxa USD]					varchar(200),	
		[Valor Aduaneiro]			float,
		[Regime Tributação II]		varchar(200),
		[Tipo De Processo]			varchar(200),
		
		[Valor II]					float,	
		[II Complementar]			float,	
		[Valor IPI]					float,	
		[IPI Complementar]			float,	
		[Valor PIS]					float,
		[Valor COFINS]				float,	
		[PIS/Cofins Complementar]	float,	
		[Valor Multa]				float,	
		[Valor Tx. Siscomex]		float,	
		[Valor ICMS]				float,	
		[ICMS Complementar]			float,	
		[Valor AFRMM]				float,	
		[Valor Desconsolidação]		float,	
		[Valor Frete Intl. Pago]	float,
		[Valor Capatazias]			float,	
		[Valor Movimentação]		float,	
		[Valor Demurrage]			float,	
		[Depósito Caução (Cntr)]	float,	
		[Outras Desp. Cntr.]		float,	
		[Valor Fumigação]			float,	
		[Valor Armaz ZP]			float,
		[Valor Armaz EADI]			float,	
		[Valor Frete Rem+Entr]		float, 
		[Valor Desp. LI]			float,	
		[Valor SDA]					float,	
		[Valor Outras Despesas]		float,	
		[Valor Serviços]			float,
		
		[Valor Adiantamento]		float,
		[Dt.Faturamento Previo]		Datetime,	
		[Dt.Faturamento Definito]	Datetime,	
		[Aplicação Mercadoria]		varchar(200),
		
		CD_Pedido int, 
		Cd_Produto int,
		[Custo Total]				float,
		[FOB retirar]				float,
		[Percentual]				float,
		[NCM] varchar(50),
		[ImpostosCusto]				float,
		[Honorario]					float,
		[Valor Organização Retirar]			float,
		[Valor Serviços Retirar]			float,
		[Valor administrativa Retirar]			float,
		
		TDespesasServicos				float,
		PISCofinsCSLL				float,
		IRRF				float,
		Adiantamentos				float,
		[Valor InspecaoMadeira Retirar]  		float,
		[Porcentagem]				float,
		[Frete consta na DI retirar]			float,
		[Valor a Retirar]			float
		
	)


	Begin
		insert into
			@TAB (
					[CNPJ],[Ref. BDP],[Ref. Cliente],[NRPEDIDO],
					[NRREGISTROLI],[Nr. DI],[Data DI],
					--[Adição],
					[Item],
					[Modal],[Exportador],[Origem],[Cód. Produto],[Desc. Produto],
					[Qtde.],[Unidade],
					--[Peso Liq. Total],
					[VUCV Moeda],[Valor Total Moeda],
					[Moeda DI],[Taxa Moeda DI],
					--[Taxa USD DI],
					[INCOTERM],[Tipo Frete],[Valor Frete Moeda],
					[Moeda Seguro],
					CD_Pedido,
					Cd_Produto,[Moeda Frete],[Tipo De Processo],
					[Dt.Faturamento Previo],[Dt.Faturamento Definito],[Percentual],[NCM]
				)
		select
				CNS.Num_CPF_CNPJ,HOU.Num_Proc,[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,1),[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,9),
				[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,23),--DI.numero_po_him,DI.data_po_him,
				[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,5),[dbo].[fBusca_DATA_PO_Modal](HOU.num_proc,5),
				--'??','??',
				pd.Item,
				(case when left(HOU.num_proc,2) = 'IM' THEN 'Marítima' ELSE
					(case when left(HOU.num_proc,2) = 'IO' THEN 'Rodoviário' ELSE
						(case when left(HOU.num_proc,2) = 'IA' THEN 'Aéreo'				
				End) End) End),
				SHI.Apelido,Org.Nome_Local,PC.cd_Proc_Cliente, PC.Produto_Descr, 
				PD.Qty,PD.UoM,
				--HOU.Peso_Liquido_HIM,
				PD.Vlr_Item,PD.Vlr_Total_Item, --LLP.Vlr_Invoice,
				HOU.[Moeda_invoice] Cd_Moeda_Invoice,cast( replace(isnull(PAR.campo_dados,1),',','.') as decimal(18,4)),
				--'?',
				HOU.cd_tp_oper,--(case when HOU.Tp_Frete_HIM = 'P' then 'Prepaid' else 'Collect' end)
				HOU.[Tipo_Frete],HOU.[Frete_BL] Vlr_Frete_Efet,
				HOU.[Moeda_invoice] Cd_Moeda_Invoice,
				PS.CD_Pedido, 
				PS.Cd_Produto,'USD',
				--'Sea Import',
				HOU.Modal,
				TP79.Dt_Conclusao,TP76.Dt_Conclusao,PP.Percentual,
				PD.NCM
		from
			vwHouse_Imp			HOU	with(nolock)
			--join llp_imp_mar		LLP	with(nolock) on LLP.num_proc_lim = HOU.num_proc_him
			join pessoa_LLP			GR with(nolock) on GR.cd_pes = HOU.Cd_Consig and GR.cd_pes_grupo = @Cd_Grupo
			join pessoa				CNS	with(nolock) on CNS.cd_pes = HOU.cd_consig
			--left join po_him		DI with(nolock) on DI.num_proc_him = HOU.num_proc and DI.id_dc = 5
			join pessoa				SHI	with(nolock) on SHI.cd_pes = HOU.Cd_Export
			join Localidade			ORG	with(nolock) on Org.Cd_Local = HOU.Cd_Org
			join Pedido_Ship		PS with(nolock) on HOU.num_proc = PS.num_proc
			join Pedido				P  with(nolock) on P.Cd_Pedido = PS.Cd_Pedido 
			join Pedido_Det			PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
			join Produto_Cliente	PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
			join Tarefas_Processos	TP4 with(nolock) on HOU.num_proc = TP4.num_proc and TP4.id_task = 4								
			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.num_proc and PAR.id_campo = 31	
			join Percentual_Produto_Hexion PP with(nolock) on PS.Cd_Pedido = PP.Cd_pedido and PS.Cd_Produto = PP.Cd_Produto and PS.Num_Proc = PP.Num_Proc and PS.Item = PP.Item
			
			left join Tarefas_Processos	TP79 with(nolock) on HOU.num_proc = TP79.num_proc and TP79.id_task = 79
			left join Tarefas_Processos	TP76 with(nolock) on HOU.num_proc = TP76.num_proc and TP76.id_task = 76	
		where	
			TP4.dt_conclusao between @DtInicial and @DtFinal						
			----and 
			--HOU.Num_Proc in ('IASOL201805003BR') --'IMSOL201803009BR')
			--HOU.Num_Proc in ('IMSOL201804038BR','IASOL201806010BR','IMSOL201805001BR')	
		
	End

	Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set 
			--[CIF Total Item Value] = totCIF,
			[Valor Frete R$] = totFrete, 
			[Valor FOB]	 = totFOB,
			[Valor Seguro R$] = totSeguro,
			[Valor II] = totII,
			[Valor IPI] = totIPI,
			[Valor PIS] = totPis,
			[Valor COFINS] =totCofins,
			[Valor ICMS] = totICMS,
			[Valor Tx. Siscomex]= totSiscomex,
			[Valor Aduaneiro] = totItem,
			[Peso Liq. Total] = totPesoLiquido
			--[Aplicação Mercadoria] = (case 
			--							when CFOP = '3101' then 'INDUSTRIALIZAÇÃO' 
			--							else 
			--							(case when CFOP = '3102' then 'COMERCIALIZAÇÃO' 
			--							else 
			--							(case when CFOP = '3949' then 'OUTRAS ENTRADAS' 
			--							else 
			--								CFOP								
			--						 End)End)End)
			--T.[Item] = ID_Item
			
		from 
			@TAB T
			join
			(
			Select 
				sum(CIF) totCIF, 
				sum((CIF - vlr_frete - vlr_seguro - isnull(acrescimos,0))) totFOB,
				sum(Vlr_FRETE) totFrete,
				sum(vlr_Seguro) totSeguro,
				sum(VL_II) totII, 
				sum(VL_IPI) totIPI,
				sum(VL_IMPOSTO_PIS) totPis,
				sum(VL_IMPOSTO_COFINS) totCofins,
				sum(VL_ICMS) totICMS,
				sum(Vlr_Siscomex) totSiscomex,
				--Vlr_Total_Item	totItem,
				sum(CIF)	totItem,							
				Cd_Produto,
				--cd_pedido, 
				num_proc,
				replace(CFOP,'.','')CFOP,
				sum(Peso_Liquido) totPesoLiquido
				--,NFCD.ID_Item ID_Item
			from nota_fiscal_cliente_det NFCD with(nolock)
			join nota_cliente NC with(nolock) on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
			group by Cd_Produto,num_proc,Cd_Pedido,CFOP
			) A on A.num_proc = T.[Ref. BDP] and A.cd_produto = T.cd_produto --and A.cd_pedido=T.CD_Pedido
	End

	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set
	--		--[SISCOMEX (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Siscomex%'),			
			--[Valor Desconsolidação] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Desconsolidacao%'),
			--[Valor Movimentação] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Movimentacao%'),
			[Valor AFRMM] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%AFRMM%'),
			[Valor Armaz ZP] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Armazenagem%'),
			[Acréscimos R$]= dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'VALOR%DOS%ACRÉSCIMOS%'),
			--[Valor Demurrage] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Demurrage%') ,
			[Valor Capatazias] =(dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'THC%') 
					+ dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Capatazia%')) ,
					
			--[Depósito Caução (Cntr)] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Depósito%Caução%'),
			
			[Valor Multa] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Multa%'),
						
			--[Outras Desp. Cntr.] = (
			--	dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Lavagem%CNTR%')+
			--	dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Avaria%') + 
			--	dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'DESPESA%CONTAINER%')	+ 
			--	dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Reparo%Container%')+ 
			--	dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Devolução%CNTR%')
			--	),	
			
			[Valor Frete Intl. Pago]= dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'FRETE%CHB%'),
			
			--[Valor Fumigação] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Fumigação%'),
			
			[Valor Armaz EADI] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Armaz%EADI%'),
			
			[Valor Desp. LI] = (dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Emissão%LI%')
				+ dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'SUB%LI%')),
			
			--[Valor SDA] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'SDA%'),
			
						
			--[Custo Total] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%'),
			
			[Valor Frete Rem+Entr] = 0,
		
	
			[FOB retirar]= dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'FOB%CHARGES%'),		
	--		--[FRETE (CONSTA NA DI)]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'FRETE%'),
	
			[Frete consta na DI retirar]= dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Frete%consta na DI%'),	
	
	--		--[Imposto de Importação - CHB]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Imposto%de%Importação%') ,
	--		--[Seguro]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Seguro%') ,
	--		--[Outras despesas]= dbo.fBusca_Custo_OutrasDespesas([BDP Job],CD_Pedido, Cd_Produto),
	--		--[Emissao de NFE] = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Serviços%Prestados%','C') ,
	--		--[Serviços Prestados] = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Emissão%de%nfe%','C'),
	--		--[Emissao LI]  = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Emissão%LI%','C'),
	
			[Valor Adiantamento]  = [dbo].[fBusca_CtaCteTaxaVlr]([Ref. BDP],'Transf.%Processos%ATL%','C'),
	--[Valor Outras Despesas]= 
	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Liberação%')+
	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Correio%')+
	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'ISPS%')+
	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Drop%') +
	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Desconsolidação%') +
	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'taxa%siscarga%') 
				
				--valores para serem retirados da conta do [Valor Outras Despesas]
				--7,00 - Organização de Arquivo 1				
				--[Valor Organização Retirar] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Organização%'),
				----650,00 - Serviços Prestados 1 - DESPACHO
				--[Valor Serviços Retirar] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Serviços%Prestados%DESPACHO%'),
				----97,14 - Taxa administrativa financeira 1
				--[Valor administrativa Retirar] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Taxa administrativa%'),
				
				[Valor a Retirar] = (	
					[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'%Armazenagem%') +			
					[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'%AFRMM%') +
					[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'%THC%') +
					[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'%Frete%') +
					[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'SUB%LI%') +
					[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'Emissão%LI%') +					
					[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'Demurrage%') +
					--[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'Multa%') +
					--[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'Armaz%EADI%') +				
					
					--[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'Organização%') +
					[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'Serviços%Prestados%DESPACHO%')
					--[dbo].[fBusca_Custo_Processo_FMC]([Ref. BDP],'Taxa administrativa%') 
				
					--dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Damage Protection%')+
					--dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'ISPS - CHB%') + 
					--dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Liberação de BL%CHB%')+
					--dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Liberação%BL%')+
					--dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Taxa do Agente%CHB%') + 
					--dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'THC - CHB%')
				
				
				--dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Liberação%BL%')+
				--dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Logistic Fee%') + 
				--dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Damage Protection%')
				)
								
	End

	
	Begin
		Update @TAB
		set
			[Taxa Moeda DI] = (case when [Taxa Moeda DI]= 0 then 1 when [Taxa Moeda DI] is null then 1 else [Taxa Moeda DI] end)
	End
	
	Begin
		Update @TAB
		set				
			[Valor Total R$]		=	isnull([Valor Total Moeda],0) * isnull([Taxa Moeda DI],1),
			[Valor Seguro Moeda]	=	isnull([Valor Seguro R$],0) / isnull([Taxa Moeda DI],1)
			
	End
	
	Begin
		Update @TAB
		set		
			[Valor Frete Moeda] = 	isnull([Valor Frete R$],0) / isnull([Taxa Moeda DI],1)
			--Valor Frete Moeda = Valor Frete R$ dividido pela Taxa Moeda Frete
	End
	
	Begin
		Update @TAB
		set		
		[Taxa Moeda Frete]	=	isnull(replace(CONVERT(varchar(10),[Taxa Moeda DI]),'.',','),'0.00'),
		[Taxa Moeda Seguro]	=	isnull(replace(CONVERT(varchar(10),[Taxa Moeda DI]),'.',','),'0.00'),
		[Taxa USD]			=	isnull(replace(CONVERT(varchar(10),[Taxa Moeda DI]),'.',','),'0.00')
	
	End
	
	--Begin
	----precisa ver as outras taxas II, IPI
	--	Update @TAB
	--	set	
	--		[Valor Outras Despesas] = [Custo Total] - 
	--		(
	--			--[Valor FOB] 
	--			[FOB retirar]+ [Valor AFRMM]+[Valor Armaz ZP]+[Valor COFINS]+
	--			[Valor ICMS]+[Valor II]+[Valor IPI]+[Valor PIS]+[Valor Seguro R$]+
	--			[Valor Tx. Siscomex]+[Valor Capatazias]+[Acréscimos R$]+[Valor Multa]+
	--			[Valor Armaz EADI]+ [Valor Desp. LI]+	
	--			[Valor Organização Retirar]+[Valor Serviços Retirar]+[Valor administrativa Retirar]
	--		)
	
	--End
	--Update T
	--	set [Valor Serviços] = Valor
	--	from 
	--		@TAB T
	--		join
	--		(select distinct FAT.Processo_PC, abs(sum(IFAT.Vlr_PC*-1)) Valor from Fatura_CHB FAT
	--			join Fatura_CHB_Item IFAT with(nolock)  on FAT.Fatura_PC = IFAT.Fatura_CC
	--			left join vwSolPgtoCtaCteAprovadas SOL with(nolock) on SOL.Num_Proc = FAT.Processo_PC and SOL.Cd_Tp_Tx = IFAT.cd_tp_tx and sol.DC = IFAT.DC
	--			left join vwFaturasValidasArg AFAT with(nolock) on AFAT.Num_Proc = FAT.Processo_PC and AFAT.Cd_Tp_Tx = IFAT.cd_tp_tx and AFAT.DC = IFAT.DC
	--			join Tipo_Taxa TT with(nolock)  on IFAT.Cd_tp_tx = TT.Cd_Tp_Tx
	--			join @TAB T on T.[Ref. BDP] = FAT.Processo_PC
	--			where IFAT.TP_PGTO = 'C' and (AFAT.ID_Fat IS not NULL or TT.Cd_AX_Repasse IN ('000.1'))group by FAT.Processo_PC )A on A.Processo_PC = T.[Ref. BDP]
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
					join @TAB T on T.[Ref. BDP] = FAT.Processo_PC
				WHERE 
				--ITM.Imprime='S' 
				--and 
				FAT.Status_PC = 'E'
		--select * from 	@TABCusto where Processo_PC = 	'IMSOL201712006BR'
	--update T set T.Honorario = SUM(VLR_PC) from @TAB T
	--join @TABCusto TC on T.[Ref. BDP] = TC.Processo_PC and T.Cd_Produto = TC.Cd_Produto and T.CD_Pedido = TC.CD_Pedido
	--where TC.TP_PGTO = 'D' group by VLR_PC
	
	--update T set T.ImpostosCusto = SUM(VLR_PC) from @TAB T
	--join @TABCusto TC on T.[Ref. BDP] = TC.Processo_PC and T.Cd_Produto = TC.Cd_Produto and T.CD_Pedido = TC.CD_Pedido
	--where TC.TP_PGTO = 'S' group by VLR_PC
				
	update @TAB set ImpostosCusto = (select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC and TP_PGTO = 'R') 
	
	update @TAB  set Honorario = (select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC  and TP_PGTO = 'D'
		and Nome_Tp_Tx not like ('%BDP%'))		
			
	--{@TDespesasServicos} = if {spPrestCC_REL;1.TP_PGTO} = "D" or {spPrestCC_REL;1.TP_PGTO} = "S" then {spPrestCC_REL;1.VLR_PC}	
	--update @TAB  set TDespesasServicos = (select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC and TP_PGTO = 'D') + 
	--	(select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC  and TP_PGTO = 'S')
		
	update @TAB  set TDespesasServicos = 
		(select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC and TP_PGTO = 'D' and Nome_Tp_Tx not like ('%BDP%')) + 
		(select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC  and TP_PGTO = 'S')
		
	--{@PISCofinsCSLL} = if {spPrestCC_REL;1.TP_PGTO} = "R" and left({spPrestCC_REL;1.NOME_TP_TX},4)<> "IRRF" then {spPrestCC_REL;1.VLR_PC}	
	update @TAB set PISCofinsCSLL = (select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC and TP_PGTO = 'R' 
		and left(NOME_TP_TX,4)<> 'IRRF' ) 
	--{@IRRF} = if {spPrestCC_REL;1.TP_PGTO} = "R" and left({spPrestCC_REL;1.NOME_TP_TX},4)= "IRRF" then {spPrestCC_REL;1.VLR_PC}
	update @TAB set IRRF = (select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC and TP_PGTO = 'R' 
		and left(NOME_TP_TX,4)= 'IRRF' ) 
	--{@Adiantamentos} if {spPrestCC_REL;1.TP_PGTO} = "A" then {spPrestCC_REL;1.VLR_PC}
	update @TAB set Adiantamentos = (select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC and TP_PGTO = 'A')
	
	update @TAB  set [Valor a Retirar] = (select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC and TP_PGTO = 'D') + 
		(select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC  and TP_PGTO = 'S' and
					(nome_tp_tx like '%Armazenagem%' or
					nome_tp_tx like '%AFRMM%' or
					nome_tp_tx like '%THC%' or
					nome_tp_tx like '%Frete%' or
					nome_tp_tx like 'SUB%LI%' or
					nome_tp_tx like 'Emissão%LI%' or
					nome_tp_tx like 'Capatazias%CHB%' or					
					nome_tp_tx like 'Demurrage%') 		
		)
	
		
	
	--Begin
	--	Update @TAB
	--	set	
	--		[Custo Total]= 
	--		isnull(abs(TDespesasServicos),'0.00')
	--		-isnull(abs(PISCofinsCSLL),'0.00')
	--		-isnull(abs(IRRF),'0.00')
	--		-isnull(abs(Adiantamentos),'0.00') 	
	--End	
	
		--Begin
		--	update 
		--		@TAB 
		--	set 
		--		[Valor a Retirar] = (select sum(isnull([Valor AFRMM],0)+isnull([Valor Armaz ZP],0)+
		--			isnull([Valor Capatazias],0)+isnull([Valor Multa],0)+isnull([Valor Armaz EADI],0)+ 
		--			isnull([Valor Desp. LI],0)+	isnull([Valor Organização Retirar],0)+isnull([Valor Serviços Retirar],0)+
		--			isnull([Valor administrativa Retirar],0)+isnull([Valor Demurrage],0)+isnull([Valor Frete Intl. Pago],0)+
		--			isnull([Valor InspecaoMadeira Retirar],0)) from @TAB)		
		--End
	
	Begin
		Update @TAB
		set	
			[Valor Outras Despesas] = ABS(
			isnull(abs(TDespesasServicos),'0.00')			
			---isnull(abs(PISCofinsCSLL),'0.00')
			---isnull(abs(IRRF),'0.00')
			---isnull(abs(Adiantamentos),'0.00') 			
			- 
			(	
				isnull([Valor a Retirar],0)	
				--isnull([Valor AFRMM],0)+
				--isnull([Valor Armaz ZP],0)+
				--isnull([Valor Capatazias],0)+
				--isnull([Valor Multa],0)+
				--isnull([Valor Armaz EADI],0)+ 
				--isnull([Valor Desp. LI],0)+	
				--isnull([Valor Organização Retirar],0)+
				--isnull([Valor Serviços Retirar],0)+
				--isnull([Valor administrativa Retirar],0)+
				--isnull([Valor Demurrage],0)+
				--isnull([Valor Frete Intl. Pago],0)+
				--isnull([Valor InspecaoMadeira Retirar],0)

				--+isnull([Acréscimos R$],0)+
				--isnull([Frete consta na DI retirar],0)+
				--isnull([Outras Desp. Cntr.],0) 		
			))
	
	End
	
	Begin
		Update @TAB
		set	
			[Porcentagem]= dbo.fBuscaPorcentagem_Pedido_Prod([Ref. BDP],CD_Pedido,Cd_Produto)*
							dbo.fBuscaPorcentagem_CdProduto([Ref. BDP],Cd_Produto)*
							Percentual
	End	
	
	--select [Desc. Produto] , 
	--Honorario , ImpostosCusto, [Porcentagem],
	--isnull(abs(TDespesasServicos),'0.00')TDespesasServicos ,
	--isnull([Valor a Retirar],0)[Valor a Retirar],
	--[Valor Outras Despesas],
	--[Porcentagem],	
	--cast(isnull([Valor Outras Despesas],'0.00')*  [Porcentagem] as decimal(18,2))[Valor Outras Despesas],
	--cast(isnull(Honorario + ImpostosCusto,'0.00')* [Porcentagem]  as decimal(18,2))[Valor Serviços],
	--cast(isnull(Honorario + ImpostosCusto,'0.00') as decimal(18,2)),
	--	* from @tab
	
select 
[Ref. BDP],
[Ref. Cliente],
--[NRPEDIDO],
--[NRREGISTROLI],
[Nr. DI],
[Data DI],
--[Adição],
[Modal],
[Exportador],
[Item],
--[Origem],
[Cód. Produto],
[Desc. Produto],
[Qtde.],
[Unidade],
--[Peso Liq. Total],
--cast(isnull([Peso Liq. Total],'0.00')* [Porcentagem] as decimal(18,2))  [Peso Liq. Total],
cast(isnull([Peso Liq. Total],'0.00')* Percentual as decimal(18,2))  [Peso Liq. Total],
--cast(isnull([Peso Liq. Total],'0.00')* dbo.fBuscaPorcentagem_Pedido_Prod([Ref. BDP],CD_Pedido,Cd_Produto)*
--							dbo.fBuscaPorcentagem_CdProduto([Ref. BDP],Cd_Produto)as decimal(18,2))  [Peso Liq. Total],
[VUCV Moeda],
[Valor Total Moeda],
[Moeda DI],
replace(CONVERT(varchar(10),[Taxa Moeda DI]),'.',',') [Taxa Moeda DI],
[Valor Total R$],
[INCOTERM],
[Tipo Frete],
--[Valor FOB],
--cast(isnull([Valor FOB],'0.00')*  [Porcentagem] as decimal(18,2))  [Valor FOB],
cast([Valor FOB] * [Percentual] as decimal(18,2)) [Valor FOB],
--[Valor Frete Moeda],
--cast(isnull([Valor Frete Moeda],'0.00')*  [Porcentagem] as decimal(18,2)) [Valor Frete Moeda],
cast([Valor Frete Moeda] * [Percentual] as decimal(18,2)) [Valor Frete Moeda],
[Moeda Frete],
[Taxa Moeda Frete],
--[Valor Frete R$],
--cast(isnull([Valor Frete R$],'0.00')*  [Porcentagem] as decimal(18,2)) [Valor Frete R$],
cast([Valor Frete R$] * [Percentual] as decimal(18,2)) [Valor Frete R$],
--[Valor Seguro Moeda],
--cast(isnull([Valor Seguro Moeda],'0.00')*  [Porcentagem] as decimal(18,2)) [Valor Seguro Moeda],
cast([Valor Seguro Moeda] * [Percentual] as decimal(18,2)) [Valor Seguro Moeda],
[Moeda Seguro],
[Taxa Moeda Seguro],
--[Valor Seguro R$],
--cast(isnull([Valor Seguro R$],'0.00')*  [Porcentagem] as decimal(18,2)) [Valor Seguro R$],
cast(isnull([Valor Seguro R$],'0.00') * [Percentual] as decimal(18,2))[Valor Seguro R$],
--[Acréscimos R$],
cast(isnull([Acréscimos R$],'0.00') * [Percentual] as decimal(18,2))[Acréscimos R$],
[Taxa USD],
--[Valor Aduaneiro],
--cast(isnull([Valor Aduaneiro],'0.00')* [Porcentagem] as decimal(18,2))  [Valor Aduaneiro],
cast([Valor Aduaneiro] * [Percentual] as decimal(18,2)) [Valor Aduaneiro],
(Case when isnull([Valor II],'0.00') = '0.00' then 'Regime Especial' else 'Recolhimento Integral' end) [Regime Tributação II],
--'Recolhimento Integral' [Regime Tributação II],
--[Tipo De Processo],


--isnull([Valor II],'0.00')[Valor II],
--cast(isnull([Valor II],'0.00')* [Porcentagem] as decimal(18,2))  [Valor II],
cast(isnull([Valor II],'0.00')* [Percentual] as decimal(18,2))  [Valor II],

--isnull([II Complementar],'0.00')[II Complementar],
--cast(isnull([II Complementar],'0.00')* [Porcentagem] as decimal(18,2))  [II Complementar],
cast(isnull([II Complementar],'0.00')* [Percentual] as decimal(18,2))  [II Complementar],

--isnull([Valor IPI],'0.00')[Valor IPI],
--cast(isnull([Valor IPI],'0.00')* [Porcentagem] as decimal(18,2))  [Valor IPI],
cast(isnull([Valor IPI],'0.00')* [Percentual] as decimal(18,2))  [Valor IPI],

--isnull([IPI Complementar],'0.00')[IPI Complementar],
--cast(isnull([IPI Complementar],'0.00')* [Porcentagem] as decimal(18,2))  [IPI Complementar],
cast(isnull([IPI Complementar],'0.00')* [Percentual] as decimal(18,2))  [IPI Complementar],

--isnull([Valor PIS],'0.00')[Valor PIS],
--cast(isnull([Valor PIS],'0.00')* [Porcentagem] as decimal(18,2))  [Valor PIS],
cast(isnull([Valor PIS],'0.00')* [Percentual] as decimal(18,2))  [Valor PIS],

--isnull([Valor COFINS],'0.00')[Valor COFINS],
--cast(isnull([Valor COFINS],'0.00')* [Porcentagem] as decimal(18,2))  [Valor COFINS],
cast(isnull([Valor COFINS],'0.00')* [Percentual] as decimal(18,2))  [Valor COFINS],

--isnull([PIS/Cofins Complementar],'0.00')[PIS/Cofins Complementar],
--cast(isnull([PIS/Cofins Complementar],'0.00')* [Porcentagem] as decimal(18,2))  [PIS/Cofins Complementar],
cast(isnull([PIS/Cofins Complementar],'0.00')* [Percentual] as decimal(18,2))  [PIS/Cofins Complementar],

--isnull([Valor Multa],'0.00')[Valor Multa],
--cast(isnull([Valor Multa],'0.00')* [Porcentagem] as decimal(18,2))  [Valor Multa],
cast(isnull([Valor Multa],'0.00')* [Percentual] as decimal(18,2))  [Valor Multa],

--isnull([Valor Tx. Siscomex],'0.00')[Valor Tx. Siscomex],
--cast(isnull([Valor Tx. Siscomex],'0.00')* [Porcentagem] as decimal(18,2))  [Valor Tx. Siscomex],
cast(isnull([Valor Tx. Siscomex],'0.00')* [Percentual] as decimal(18,2))  [Valor Tx. Siscomex],

--isnull([Valor ICMS],'0.00')[Valor ICMS],
--cast(isnull([Valor ICMS],'0.00')* [Porcentagem] as decimal(18,2))  [Valor ICMS],
cast(isnull([Valor ICMS],'0.00')* [Percentual] as decimal(18,2))  [Valor ICMS],

--isnull([ICMS Complementar],'0.00')[ICMS Complementar],
--cast(isnull([ICMS Complementar],'0.00')* [Porcentagem] as decimal(18,2))  [ICMS Complementar],
cast(isnull([ICMS Complementar],'0.00')* [Percentual] as decimal(18,2))  [ICMS Complementar],

--isnull([Valor AFRMM],'0.00')[Valor AFRMM],
--cast(isnull([Valor AFRMM],'0.00')* [Porcentagem] as decimal(18,2))  [Valor AFRMM],
cast(isnull([Valor AFRMM],'0.00') * [Percentual] as decimal(18,2))[Valor AFRMM],

--isnull([Valor Desconsolidação],'0.00')[Valor Desconsolidação],

--(Case when [Tipo Frete] = 'Collect' then  
--	 cast(isnull([Valor Frete Intl. Pago],'0.00')* [Porcentagem] as decimal(18,2))
--else '0.00' end)							[Valor Frete Intl. Pago],

(Case when [Tipo Frete] = 'Collect' then [Valor Frete Intl. Pago] 
	else '0.00'
end)							[Valor Frete Intl. Pago],

--isnull([Valor Capatazias],'0.00')[Valor Capatazias],
--cast(isnull([Valor Capatazias],'0.00')* [Porcentagem] as decimal(18,2)) [Valor Capatazias],
cast(isnull([Valor Capatazias],'0.00') * [Percentual] as decimal(18,2))[Valor Capatazias],

--isnull([Valor Movimentação],'0.00')[Valor Movimentação],

--isnull([Valor Demurrage],'0.00')[Valor Demurrage],
--cast(isnull([Valor Demurrage],'0.00')* [Porcentagem] as decimal(18,2)) [Valor Demurrage],
cast(isnull([Valor Demurrage],'0.00')* [Percentual] as decimal(18,2)) [Valor Demurrage],

--isnull([Depósito Caução (Cntr)],'0.00')[Depósito Caução (Cntr)],
--isnull([Outras Desp. Cntr.],'0.00')[Outras Desp. Cntr.],
--isnull([Valor Fumigação],'0.00')[Valor Fumigação],

--isnull([Valor Armaz ZP],'0.00')[Valor Armaz ZP],
--cast(isnull([Valor Armaz ZP],'0.00')* [Porcentagem] as decimal(18,2)) [Valor Armaz ZP],
cast(isnull([Valor Armaz ZP],'0.00') * [Percentual] as decimal(18,2)) [Valor Armaz ZP],

--isnull([Valor Armaz EADI],'0.00')[Valor Armaz EADI],
--cast(isnull([Valor Armaz EADI],'0.00')* [Porcentagem] as decimal(18,2)) [Valor Armaz EADI],
cast(isnull([Valor Armaz EADI],'0.00')* [Percentual] as decimal(18,2)) [Valor Armaz EADI],

--isnull([Valor Frete Rem+Entr],'0.00')[Valor Frete Rem+Entr],

--isnull([Valor Desp. LI],'0.00')[Valor Desp. LI],
--cast(isnull([Valor Desp. LI],'0.00')* [Porcentagem] as decimal(18,2)) [Valor Desp. LI],
cast(isnull([Valor Desp. LI],'0.00') * [Percentual] as decimal(18,2)) [Valor Desp. LI],

--isnull([Valor SDA],'0.00')[Valor SDA],

--cast(isnull([Valor Outras Despesas],'0.00')* [Percentual] as decimal(18,2))[Valor Outras Despesas],
cast(isnull([Valor Outras Despesas],'0.00')*  [Porcentagem] as decimal(18,2))[Valor Outras Despesas],

--cast(isnull(Honorario + ImpostosCusto,'0.00')*dbo.fBuscaPorcentagem_Pedido_Prod([Ref. BDP],CD_Pedido,Cd_Produto)*dbo.fBuscaPorcentagem_CdProduto([Ref. BDP],Cd_Produto)   as decimal(18,2))[Valor Serviços],
--cast(isnull(Honorario + ImpostosCusto,'0.00')* [Percentual] as decimal(18,2))[Valor Serviços],
cast(isnull(Honorario + ImpostosCusto,'0.00')* [Porcentagem]  as decimal(18,2))[Valor Serviços],


--isnull([Valor Adiantamento],'0.00')[Valor Adiantamento],
--cast(isnull([Valor Adiantamento],'0.00')* [Porcentagem] as decimal(18,2))[Valor Adiantamento],
cast(isnull([Valor Adiantamento],'0.00')* [Percentual] as decimal(18,2))[Valor Adiantamento],

[NCM],
--Honorario, ImpostosCusto,[Percentual] 
[Dt.Faturamento Previo]


from @TAB



--select 
--[Ref. BDP],
--[Ref. Cliente],
----[NRPEDIDO],
----[NRREGISTROLI],
--[Nr. DI],
--[Data DI],
----[Adição],
--[Modal],
--[Exportador],
--[Item],
----[Origem],
--[Cód. Produto],
--[Desc. Produto],
--[Qtde.],
--[Unidade],
----[Peso Liq. Total],
--cast([Peso Liq. Total] * [Percentual] as decimal(18,2)) [Peso Liq. Total],
--[VUCV Moeda],
--[Valor Total Moeda],
--[Moeda DI],
--replace(CONVERT(varchar(10),[Taxa Moeda DI]),'.',',') [Taxa Moeda DI],
--[Valor Total R$],
--[INCOTERM],
--[Tipo Frete],
----[Valor FOB],
--cast([Valor FOB] * [Percentual] as decimal(18,2)) [Valor FOB],
----[Valor Frete Moeda],
--cast([Valor Frete Moeda] * [Percentual] as decimal(18,2)) [Valor Frete Moeda],
--[Moeda Frete],
--[Taxa Moeda Frete],
----[Valor Frete R$],
--cast([Valor Frete R$] * [Percentual] as decimal(18,2)) [Valor Frete R$],
----[Valor Seguro Moeda],
--cast([Valor Seguro Moeda] * [Percentual] as decimal(18,2)) [Valor Seguro Moeda],
--[Moeda Seguro],
--[Taxa Moeda Seguro],
--[Valor Seguro R$],
--[Acréscimos R$],
--[Taxa USD],
----[Valor Aduaneiro],
--cast([Valor Aduaneiro] * [Percentual] as decimal(18,2)) [Valor Aduaneiro],
--'Recolhimento Integral' [Regime Tributação II],
----[Tipo De Processo],
--isnull([Valor II],'0.00')[Valor II],
--isnull([II Complementar],'0.00')[II Complementar],
--isnull([Valor IPI],'0.00')[Valor IPI],
--isnull([IPI Complementar],'0.00')[IPI Complementar],
--isnull([Valor PIS],'0.00')[Valor PIS],
--isnull([Valor COFINS],'0.00')[Valor COFINS],
--isnull([PIS/Cofins Complementar],'0.00')[PIS/Cofins Complementar],
--isnull([Valor Multa],'0.00')[Valor Multa],
----isnull([Valor Tx. Siscomex],'0.00')[Valor Tx. Siscomex],
--cast(isnull([Valor Tx. Siscomex],'0.00') * [Percentual] as decimal(18,2)) [Valor Tx. Siscomex],
--isnull([Valor ICMS],'0.00')[Valor ICMS],
--isnull([ICMS Complementar],'0.00')[ICMS Complementar],
--isnull([Valor AFRMM],'0.00')[Valor AFRMM],
----isnull([Valor Desconsolidação],'0.00')[Valor Desconsolidação],
--isnull([Valor Frete Intl. Pago],'0.00')[Valor Frete Intl. Pago],
--isnull([Valor Capatazias],'0.00')[Valor Capatazias],
----isnull([Valor Movimentação],'0.00')[Valor Movimentação],
----isnull([Valor Demurrage],'0.00')[Valor Demurrage],
----isnull([Depósito Caução (Cntr)],'0.00')[Depósito Caução (Cntr)],
----isnull([Outras Desp. Cntr.],'0.00')[Outras Desp. Cntr.],
----isnull([Valor Fumigação],'0.00')[Valor Fumigação],
--isnull([Valor Armaz ZP],'0.00')[Valor Armaz ZP],
--isnull([Valor Armaz EADI],'0.00')[Valor Armaz EADI],
----isnull([Valor Frete Rem+Entr],'0.00')[Valor Frete Rem+Entr],
--isnull([Valor Desp. LI],'0.00')[Valor Desp. LI],
----isnull([Valor SDA],'0.00')[Valor SDA],
--cast(isnull([Valor Outras Despesas],'0.00')* [Percentual] as decimal(18,2))[Valor Outras Despesas],
--cast(isnull(Honorario + ImpostosCusto,'0.00')*dbo.fBuscaPorcentagem_Pedido_Prod([Ref. BDP],CD_Pedido,Cd_Produto)*dbo.fBuscaPorcentagem_CdProduto([Ref. BDP],Cd_Produto)   as decimal(18,2))[Valor Serviços],
--isnull([Valor Adiantamento],'0.00')[Valor Adiantamento],
--[NCM],
----Honorario, ImpostosCusto,[Percentual] 
--[Dt.Faturamento Previo]
----[Dt.Faturamento Definito],
----[Aplicação Mercadoria]

--,isnull(abs(TDespesasServicos),'0.00')  TDespesasServicos

--,isnull([Porcentagem],'0.00')[Porcentagem],				
--[Custo Total],
--isnull([Valor AFRMM],0)+isnull([Valor Armaz ZP],0)+
--isnull([Valor Capatazias],0)+isnull([Valor Multa],0)+isnull([Valor Armaz EADI],0)+ 
--isnull([Valor Desp. LI],0)+	isnull([Valor Organização Retirar],0)+isnull([Valor Serviços Retirar],0)+
--isnull([Valor administrativa Retirar],0)+isnull([Valor Demurrage],0)+isnull([Valor Frete Intl. Pago],0)+
--isnull([Valor InspecaoMadeira Retirar],0)+isnull([Acréscimos R$],0)+
--isnull([Frete consta na DI retirar],0)+	isnull([Outras Desp. Cntr.],0) [Valor a Retirar],			

--cast(isnull([Valor Outras Despesas],'0.00')* [Percentual] as decimal(18,2))[Valor Outras Despesas],

--[Custo Total] - (isnull([Valor AFRMM],0)+isnull([Valor Armaz ZP],0)+
--isnull([Valor Capatazias],0)+isnull([Valor Multa],0)+isnull([Valor Armaz EADI],0)+ 
--isnull([Valor Desp. LI],0)+	isnull([Valor Organização Retirar],0)+isnull([Valor Serviços Retirar],0)+
--isnull([Valor administrativa Retirar],0)+isnull([Valor Demurrage],0)+isnull([Valor Frete Intl. Pago],0)+
--isnull([Valor InspecaoMadeira Retirar],0)+isnull([Acréscimos R$],0)+
--isnull([Frete consta na DI retirar],0)+	isnull([Outras Desp. Cntr.],0))  [Custo Total - Valor a Retirar],
--[Custo Total] - [Valor a Retirar]  [Custo Total - Valor a Retirar]

--from @TAB


---XXXXXXXXXXXXXXXXXXXXXX codigo antigo XXXXXXXXXXXXXXXXXXXXXXXX--------------
--ALTER Procedure [dbo].[spRelatorio_Custo_Item_Internado_Solenis_Rel]
--(
--	@DtInicial datetime,
--	@DtFinal datetime
--)
--AS

--Declare @Grupo varchar(20)
----Declare @DtInicial datetime
----Declare @DtFinal datetime
--Declare @Cd_Grupo as varchar(10)

--set @Grupo = 'Grupo Solenis'
----set @DtInicial ='2017-03-03' -- '2016-12-29'
----set @DtFinal = '2017-03-03' --'2016-12-29'

--Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)
--exec dbo.spATL_CalculaPercentual_Ins @Cd_Grupo

--	declare @TAB table
--	(
--		[CNPJ]						varchar(200),
--		[Ref. BDP]					char(16),		
--		[Ref. Cliente]				varchar(200),
--		[NRPEDIDO]					varchar(200),
--		[NRREGISTROLI]				varchar(500),
--		[Nr. DI]					varchar(50),
--		[Data DI]					Datetime,		
--		[Adição]					varchar(50),
--		[Item]						varchar(50),
--		[Modal]						varchar(20),
--		[Exportador]				varchar(200),
--		[Origem]					varchar(200),	
--		[Cód. Produto]				varchar(500),		
--		[Desc. Produto]				varchar(1000),
--		[Qtde.]						float,
--		[Unidade]					varchar(5),				
--		[Peso Liq. Total]			float,
--		[VUCV Moeda]				float,
--		[Valor Total Moeda]			float,
--		[Moeda DI]					varchar(200),
--		[Taxa Moeda DI]				float,		
--		[Taxa USD DI]				varchar(200),--			float,
		
--		[Valor Total R$]			float,
		
--		[INCOTERM]					varchar(200),
--		[Tipo Frete]				varchar(200),
				
--		[Valor FOB]					float,
--		[Valor Frete Moeda]			float,
--		[Moeda Frete]				varchar(200),
--		[Taxa Moeda Frete]			varchar(200),
--		[Valor Frete R$]			float,
--		[Valor Seguro Moeda]		float,
		
--		[Moeda Seguro]				varchar(200),	
--		[Taxa Moeda Seguro]			varchar(200),		
--		[Valor Seguro R$]			float,	
--		[Acréscimos R$]				float,
--		[Taxa USD]					varchar(200),	
--		[Valor Aduaneiro]			float,
--		[Regime Tributação II]		varchar(200),
--		[Tipo De Processo]			varchar(200),
		
--		[Valor II]					float,	
--		[II Complementar]			float,	
--		[Valor IPI]					float,	
--		[IPI Complementar]			float,	
--		[Valor PIS]					float,
--		[Valor COFINS]				float,	
--		[PIS/Cofins Complementar]	float,	
--		[Valor Multa]				float,	
--		[Valor Tx. Siscomex]		float,	
--		[Valor ICMS]				float,	
--		[ICMS Complementar]			float,	
--		[Valor AFRMM]				float,	
--		[Valor Desconsolidação]		float,	
--		[Valor Frete Intl. Pago]	float,
--		[Valor Capatazias]			float,	
--		[Valor Movimentação]		float,	
--		[Valor Demurrage]			float,	
--		[Depósito Caução (Cntr)]	float,	
--		[Outras Desp. Cntr.]		float,	
--		[Valor Fumigação]			float,	
--		[Valor Armaz ZP]			float,
--		[Valor Armaz EADI]			float,	
--		[Valor Frete Rem+Entr]		float, 
--		[Valor Desp. LI]			float,	
--		[Valor SDA]					float,	
--		[Valor Outras Despesas]		float,	
--		[Valor Serviços]			float,
		
--		[Valor Adiantamento]		float,
--		[Dt.Faturamento Previo]		Datetime,	
--		[Dt.Faturamento Definito]	Datetime,	
--		[Aplicação Mercadoria]		varchar(200),
		
--		CD_Pedido int, 
--		Cd_Produto int,
--		[Custo Total]				float,
--		[FOB retirar]				float,
--		[Percentual]				float,
--		[NCM] varchar(50),
--		[ImpostosCusto]				float,
--		[Honorario]					float,
--		[Valor Organização Retirar]			float,
--		[Valor Serviços Retirar]			float,
--		[Valor administrativa Retirar]			float
		
--	)


--	Begin
--		insert into
--			@TAB (
--					[CNPJ],[Ref. BDP],[Ref. Cliente],[NRPEDIDO],
--					[NRREGISTROLI],[Nr. DI],[Data DI],
--					--[Adição],[Item],
--					[Modal],[Exportador],[Origem],[Cód. Produto],[Desc. Produto],
--					[Qtde.],[Unidade],
--					--[Peso Liq. Total],
--					[VUCV Moeda],[Valor Total Moeda],
--					[Moeda DI],[Taxa Moeda DI],
--					--[Taxa USD DI],
--					[INCOTERM],[Tipo Frete],[Valor Frete Moeda],
--					[Moeda Seguro],
--					CD_Pedido,
--					Cd_Produto,[Moeda Frete],[Tipo De Processo],
--					[Dt.Faturamento Previo],[Dt.Faturamento Definito],[Percentual],[NCM]
--				)
--		select
--				CNS.Num_CPF_CNPJ,HOU.Num_Proc,[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,1),[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,9),
--				[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,23),--DI.numero_po_him,DI.data_po_him,
--				[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,5),[dbo].[fBusca_DATA_PO_Modal](HOU.num_proc,5),
--				--'??','??',
--				(case when left(HOU.num_proc,2) = 'IM' THEN 'Marítima' ELSE
--					(case when left(HOU.num_proc,2) = 'IO' THEN 'Rodoviário' ELSE
--						(case when left(HOU.num_proc,2) = 'IA' THEN 'Aéreo'				
--				End) End) End),
--				SHI.Apelido,Org.Nome_Local,PC.cd_Proc_Cliente, PC.Produto_Descr, 
--				PD.Qty,PD.UoM,
--				--HOU.Peso_Liquido_HIM,
--				PD.Vlr_Item,PD.Vlr_Total_Item, --LLP.Vlr_Invoice,
--				HOU.[Moeda_invoice] Cd_Moeda_Invoice,cast( replace(isnull(PAR.campo_dados,1),',','.') as decimal(18,4)),
--				--'?',
--				HOU.cd_tp_oper,--(case when HOU.Tp_Frete_HIM = 'P' then 'Prepaid' else 'Collect' end)
--				HOU.[Tipo_Frete],HOU.[Frete_BL] Vlr_Frete_Efet,
--				HOU.[Moeda_invoice] Cd_Moeda_Invoice,
--				PS.CD_Pedido, 
--				PS.Cd_Produto,'USD',
--				--'Sea Import',
--				HOU.Modal,
--				TP79.Dt_Conclusao,TP76.Dt_Conclusao,PP.Percentual,
--				PD.NCM
--		from
--			vwHouse_Imp			HOU	with(nolock)
--			--join llp_imp_mar		LLP	with(nolock) on LLP.num_proc_lim = HOU.num_proc_him
--			join pessoa_LLP			GR with(nolock) on GR.cd_pes = HOU.Cd_Consig and GR.cd_pes_grupo = @Cd_Grupo
--			join pessoa				CNS	with(nolock) on CNS.cd_pes = HOU.cd_consig
--			--left join po_him		DI with(nolock) on DI.num_proc_him = HOU.num_proc and DI.id_dc = 5
--			join pessoa				SHI	with(nolock) on SHI.cd_pes = HOU.Cd_Export
--			join Localidade			ORG	with(nolock) on Org.Cd_Local = HOU.Cd_Org
--			join Pedido_Ship		PS with(nolock) on HOU.num_proc = PS.num_proc
--			join Pedido				P  with(nolock) on P.Cd_Pedido = PS.Cd_Pedido 
--			join Pedido_Det			PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
--			join Produto_Cliente	PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
--			join Tarefas_Processos	TP4 with(nolock) on HOU.num_proc = TP4.num_proc and TP4.id_task = 4								
--			left join campo_processo PAR with(nolock) on PAR.num_proc = HOU.num_proc and PAR.id_campo = 31	
--			join Percentual_Produto_Hexion PP with(nolock) on PS.Cd_Pedido = PP.Cd_pedido and PS.Cd_Produto = PP.Cd_Produto and PS.Num_Proc = PP.Num_Proc and PS.Item = PP.Item
			
--			left join Tarefas_Processos	TP79 with(nolock) on HOU.num_proc = TP79.num_proc and TP79.id_task = 79
--			left join Tarefas_Processos	TP76 with(nolock) on HOU.num_proc = TP76.num_proc and TP76.id_task = 76	
--		where	
--			TP4.dt_conclusao between @DtInicial and @DtFinal						
--			--and 
--			--HOU.Num_Proc_HIM = 'IMFMC201612025BR'		
		
--	End

--	Begin
--	--Update com base na NOTA_CLIENTE
--		Update T
--		set 
--			--[CIF Total Item Value] = totCIF,
--			[Valor Frete R$] = totFrete, 
--			[Valor FOB]	 = totFOB,
--			[Valor Seguro R$] = totSeguro,
--			[Valor II] = totII,
--			[Valor IPI] = totIPI,
--			[Valor PIS] = totPis,
--			[Valor COFINS] =totCofins,
--			[Valor ICMS] = totICMS,
--			[Valor Tx. Siscomex]= totSiscomex,
--			[Valor Aduaneiro] = totItem,
--			[Peso Liq. Total] = totPesoLiquido,
--			[Aplicação Mercadoria] = (case 
--										when CFOP = '3101' then 'INDUSTRIALIZAÇÃO' 
--										else 
--										(case when CFOP = '3102' then 'COMERCIALIZAÇÃO' 
--										else 
--										(case when CFOP = '3949' then 'OUTRAS ENTRADAS' 
--										else 
--											CFOP								
--									 End)End)End)
--			--,T.[Item] = ID_Item
			
--		from 
--			@TAB T
--			join
--			(
--			Select 
--				sum(CIF) totCIF, 
--				sum((CIF - vlr_frete - vlr_seguro - isnull(acrescimos,0))) totFOB,
--				sum(Vlr_FRETE) totFrete,
--				sum(vlr_Seguro) totSeguro,
--				sum(VL_II) totII, 
--				sum(VL_IPI) totIPI,
--				sum(VL_IMPOSTO_PIS) totPis,
--				sum(VL_IMPOSTO_COFINS) totCofins,
--				sum(VL_ICMS) totICMS,
--				sum(Vlr_Siscomex) totSiscomex,
--				--Vlr_Total_Item	totItem,
--				sum(CIF)	totItem,							
--				Cd_Produto,
--				--cd_pedido, 
--				num_proc,
--				replace(CFOP,'.','')CFOP,
--				sum(Peso_Liquido) totPesoLiquido
--				--,NFCD.ID_Item ID_Item
--			from nota_fiscal_cliente_det NFCD with(nolock)
--			join nota_cliente NC with(nolock) on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
--			group by Cd_Produto,num_proc,Cd_Pedido,CFOP
--			) A on A.num_proc = T.[Ref. BDP] and A.cd_produto = T.cd_produto --and A.cd_pedido=T.CD_Pedido
--	End

--	Begin
--		--Update com base na CUSTO_CLIENTE
--		Update @TAB
--		set
--	--		--[SISCOMEX (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Siscomex%'),			
--			--[Valor Desconsolidação] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Desconsolidacao%'),
--			--[Valor Movimentação] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Movimentacao%'),
--			[Valor AFRMM] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%AFRMM%'),
--			[Valor Armaz ZP] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Armazenagem%'),
--			[Acréscimos R$]= dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'VALOR%DOS%ACRÉSCIMOS%'),
--			--[Valor Demurrage] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Demurrage%') ,
--			[Valor Capatazias] =(dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'THC%') 
--					+ dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Capatazia%')) ,
					
--			--[Depósito Caução (Cntr)] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Depósito%Caução%'),
			
--			[Valor Multa] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Multa%'),
						
--			--[Outras Desp. Cntr.] = (
--			--	dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Lavagem%CNTR%')+
--			--	dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Avaria%') + 
--			--	dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'DESPESA%CONTAINER%')	+ 
--			--	dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Reparo%Container%')+ 
--			--	dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Devolução%CNTR%')
--			--	),	
			
			
			
--			--[Valor Fumigação] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Fumigação%'),
			
--			[Valor Armaz EADI] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Armaz%EADI%'),
			
--			[Valor Desp. LI] = (dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Emissão%LI%')
--				+ dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'SUB%LI%')),
			
--			--[Valor SDA] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'SDA%'),
			
			
				
--			[Custo Total] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%'),
			
--			[Valor Frete Rem+Entr] = 0,
		
	
--			[FOB retirar]= dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'FOB%CHARGES%'),		
--	--		--[FRETE (CONSTA NA DI)]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'FRETE%'),	
	
--	--		--[Imposto de Importação - CHB]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Imposto%de%Importação%') ,
--	--		--[Seguro]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Seguro%') ,
--	--		--[Outras despesas]= dbo.fBusca_Custo_OutrasDespesas([BDP Job],CD_Pedido, Cd_Produto),
--	--		--[Emissao de NFE] = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Serviços%Prestados%','C') ,
--	--		--[Serviços Prestados] = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Emissão%de%nfe%','C'),
--	--		--[Emissao LI]  = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Emissão%LI%','C'),
	
--			[Valor Adiantamento]  = [dbo].[fBusca_CtaCteTaxaVlr]([Ref. BDP],'Transf.%Processos%ATL%','C'),
--	--[Valor Outras Despesas]= 
--	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Liberação%')+
--	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Correio%')+
--	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'ISPS%')+
--	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Drop%') +
--	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Desconsolidação%') +
--	--				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'taxa%siscarga%') 
				
--				--valores para serem retirados da conta do [Valor Outras Despesas]
--				--7,00 - Organização de Arquivo 1				
--				[Valor Organização Retirar] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Organização%'),
--				--650,00 - Serviços Prestados 1 - DESPACHO
--				[Valor Serviços Retirar] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Serviços%Prestados%DESPACHO%'),
--				--97,14 - Taxa administrativa financeira 1
--				[Valor administrativa Retirar] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Taxa administrativa%')
								
--	End

	
--	Begin
--		Update @TAB
--		set
--			[Taxa Moeda DI] = (case when [Taxa Moeda DI]= 0 then 1 when [Taxa Moeda DI] is null then 1 else [Taxa Moeda DI] end)
--	End
	
--	Begin
--		Update @TAB
--		set				
--			[Valor Total R$]		=	isnull([Valor Total Moeda],0) * isnull([Taxa Moeda DI],1),
--			[Valor Seguro Moeda]	=	isnull([Valor Seguro R$],0) / isnull([Taxa Moeda DI],1)
			
--	End
	
--	Begin
--		Update @TAB
--		set		
--			[Valor Frete Moeda] = 	isnull([Valor Frete R$],0) / isnull([Taxa Moeda DI],1)
--			--Valor Frete Moeda = Valor Frete R$ dividido pela Taxa Moeda Frete
--	End
	
--	Begin
--		Update @TAB
--		set		
--		[Taxa Moeda Frete]	=	isnull(replace(CONVERT(varchar(10),[Taxa Moeda DI]),'.',','),'0.00'),
--		[Taxa Moeda Seguro]	=	isnull(replace(CONVERT(varchar(10),[Taxa Moeda DI]),'.',','),'0.00'),
--		[Taxa USD]			=	isnull(replace(CONVERT(varchar(10),[Taxa Moeda DI]),'.',','),'0.00')
	
--	End
	
--	Begin
--	--precisa ver as outras taxas II, IPI
--		Update @TAB
--		set	
--			[Valor Outras Despesas] = [Custo Total] - 
--			(
--				--[Valor FOB] 
--				[FOB retirar]+ [Valor AFRMM]+[Valor Armaz ZP]+[Valor COFINS]+
--				[Valor ICMS]+[Valor II]+[Valor IPI]+[Valor PIS]+[Valor Seguro R$]+
--				[Valor Tx. Siscomex]+[Valor Capatazias]+[Acréscimos R$]+[Valor Multa]+
--				[Valor Armaz EADI]+ [Valor Desp. LI]+	
--				[Valor Organização Retirar]+[Valor Serviços Retirar]+[Valor administrativa Retirar]
--			)
	
--	End
--	--Update T
--	--	set [Valor Serviços] = Valor
--	--	from 
--	--		@TAB T
--	--		join
--	--		(select distinct FAT.Processo_PC, abs(sum(IFAT.Vlr_PC*-1)) Valor from Fatura_CHB FAT
--	--			join Fatura_CHB_Item IFAT with(nolock)  on FAT.Fatura_PC = IFAT.Fatura_CC
--	--			left join vwSolPgtoCtaCteAprovadas SOL with(nolock) on SOL.Num_Proc = FAT.Processo_PC and SOL.Cd_Tp_Tx = IFAT.cd_tp_tx and sol.DC = IFAT.DC
--	--			left join vwFaturasValidasArg AFAT with(nolock) on AFAT.Num_Proc = FAT.Processo_PC and AFAT.Cd_Tp_Tx = IFAT.cd_tp_tx and AFAT.DC = IFAT.DC
--	--			join Tipo_Taxa TT with(nolock)  on IFAT.Cd_tp_tx = TT.Cd_Tp_Tx
--	--			join @TAB T on T.[Ref. BDP] = FAT.Processo_PC
--	--			where IFAT.TP_PGTO = 'C' and (AFAT.ID_Fat IS not NULL or TT.Cd_AX_Repasse IN ('000.1'))group by FAT.Processo_PC )A on A.Processo_PC = T.[Ref. BDP]
--	declare @TABCusto table
--	(
--	[Processo_PC] varchar(16),
--	Nome_Tp_Tx varchar(50),
--	VLR_PC	float,
--	TP_PGTO varchar(10)
	
--	)
--	insert @TABCusto
--			SELECT 
--			distinct
--			FAT.Processo_PC,
--				TT.Nome_Tp_Tx,
--					VLR_PC,
--					(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then 'A' else
--						(Case when ITM.TP_PGTO = 'C' then 'C' else
--							(Case when SOL.ID IS not NULL then 'S' else
--								(case when TT.Cd_AX_Repasse IN ('000.1') then 'R' else
--									'D' END)END)END)END) TP_PGTO						
--				FROM 
--				--vwFaturasValidasCHB FAT with(nolock)
--					FATURA_CHB FAT with(nolock)
--					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC					
--					Left Join Fatura F with(nolock) on F.FatCod=FAT.FATURA_PC
--					JOIN PESSOA PP with(nolock) ON PP.CD_PES=FAT.CD_PES_PC 
--					LEFT JOIN vwcta_Cte CCH with(nolock) on CCH.Num_Proc_HIA = LEFT(FAT.FATURA_PC,16) and CCH.Num_NF_HIA is not null AND CCH.Ref_Acesso_NF_HIA <> 'P' AND CCH.Ref_Acesso_NF_HIA is not null and cch.cd_tp_tx = itm.Cd_Tp_Tx
--					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=ITM.cd_tp_Tx
--					left join vwSolPgtoCtaCteAprovadas SOL with(nolock) on SOL.Num_Proc = LEFT(iTM.Fatura_CC,16) and SOL.Cd_Tp_Tx = ITM.cd_tp_tx and sol.DC = ITM.DC
--					join @TAB T on T.[Ref. BDP] = FAT.Processo_PC
--				WHERE ITM.Imprime='S' and FAT.Status_PC = 'E'
--		--select * from 	@TABCusto where Processo_PC = 	'IMSOL201712006BR'
--	--update T set T.Honorario = SUM(VLR_PC) from @TAB T
--	--join @TABCusto TC on T.[Ref. BDP] = TC.Processo_PC and T.Cd_Produto = TC.Cd_Produto and T.CD_Pedido = TC.CD_Pedido
--	--where TC.TP_PGTO = 'D' group by VLR_PC
	
--	--update T set T.ImpostosCusto = SUM(VLR_PC) from @TAB T
--	--join @TABCusto TC on T.[Ref. BDP] = TC.Processo_PC and T.Cd_Produto = TC.Cd_Produto and T.CD_Pedido = TC.CD_Pedido
--	--where TC.TP_PGTO = 'S' group by VLR_PC
	
				
--	update @TAB set ImpostosCusto = (select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC and TP_PGTO = 'R') 
	
--	update @TAB  set Honorario = (select Sum(VLR_PC) from @TABCusto TC where [Ref. BDP] = Processo_PC  and TP_PGTO = 'D')

--select 
--[Ref. BDP],
--[Ref. Cliente],
----[NRPEDIDO],
----[NRREGISTROLI],
--[Nr. DI],
--[Data DI],
----[Adição],
--[Modal],
--[Exportador],
--[Item],
----[Origem],
--[Cód. Produto],
--[Desc. Produto],
--[Qtde.],
--[Unidade],
----[Peso Liq. Total],
--cast([Peso Liq. Total] * [Percentual] as decimal(18,2)) [Peso Liq. Total],
--[VUCV Moeda],
--[Valor Total Moeda],
--[Moeda DI],
--replace(CONVERT(varchar(10),[Taxa Moeda DI]),'.',',') [Taxa Moeda DI],
--[Valor Total R$],
--[INCOTERM],
--[Tipo Frete],
----[Valor FOB],
--cast([Valor FOB] * [Percentual] as decimal(18,2)) [Valor FOB],
----[Valor Frete Moeda],
--cast([Valor Frete Moeda] * [Percentual] as decimal(18,2)) [Valor Frete Moeda],
--[Moeda Frete],
--[Taxa Moeda Frete],
----[Valor Frete R$],
--cast([Valor Frete R$] * [Percentual] as decimal(18,2)) [Valor Frete R$],
----[Valor Seguro Moeda],
--cast([Valor Seguro Moeda] * [Percentual] as decimal(18,2)) [Valor Seguro Moeda],
--[Moeda Seguro],
--[Taxa Moeda Seguro],
--[Valor Seguro R$],
--[Acréscimos R$],
--[Taxa USD],
----[Valor Aduaneiro],
--cast([Valor Aduaneiro] * [Percentual] as decimal(18,2)) [Valor Aduaneiro],
--'Recolhimento Integral' [Regime Tributação II],
----[Tipo De Processo],
--isnull([Valor II],'0.00')[Valor II],
--isnull([II Complementar],'0.00')[II Complementar],
--isnull([Valor IPI],'0.00')[Valor IPI],
--isnull([IPI Complementar],'0.00')[IPI Complementar],
--isnull([Valor PIS],'0.00')[Valor PIS],
--isnull([Valor COFINS],'0.00')[Valor COFINS],
--isnull([PIS/Cofins Complementar],'0.00')[PIS/Cofins Complementar],
--isnull([Valor Multa],'0.00')[Valor Multa],
----isnull([Valor Tx. Siscomex],'0.00')[Valor Tx. Siscomex],
--cast(isnull([Valor Tx. Siscomex],'0.00') * [Percentual] as decimal(18,2)) [Valor Tx. Siscomex],
--isnull([Valor ICMS],'0.00')[Valor ICMS],
--isnull([ICMS Complementar],'0.00')[ICMS Complementar],
--isnull([Valor AFRMM],'0.00')[Valor AFRMM],
----isnull([Valor Desconsolidação],'0.00')[Valor Desconsolidação],
--isnull([Valor Frete Intl. Pago],'0.00')[Valor Frete Intl. Pago],
--isnull([Valor Capatazias],'0.00')[Valor Capatazias],
----isnull([Valor Movimentação],'0.00')[Valor Movimentação],
----isnull([Valor Demurrage],'0.00')[Valor Demurrage],
----isnull([Depósito Caução (Cntr)],'0.00')[Depósito Caução (Cntr)],
----isnull([Outras Desp. Cntr.],'0.00')[Outras Desp. Cntr.],
----isnull([Valor Fumigação],'0.00')[Valor Fumigação],
--isnull([Valor Armaz ZP],'0.00')[Valor Armaz ZP],
--isnull([Valor Armaz EADI],'0.00')[Valor Armaz EADI],
----isnull([Valor Frete Rem+Entr],'0.00')[Valor Frete Rem+Entr],
--isnull([Valor Desp. LI],'0.00')[Valor Desp. LI],
----isnull([Valor SDA],'0.00')[Valor SDA],
--cast(isnull([Valor Outras Despesas],'0.00')* [Percentual] as decimal(18,2))[Valor Outras Despesas],
--cast(isnull(Honorario + ImpostosCusto,'0.00')*dbo.fBuscaPorcentagem_Pedido_Prod([Ref. BDP],CD_Pedido,Cd_Produto)*dbo.fBuscaPorcentagem_CdProduto([Ref. BDP],Cd_Produto)   as decimal(18,2))[Valor Serviços],
--isnull([Valor Adiantamento],'0.00')[Valor Adiantamento],
--[NCM],
----Honorario, ImpostosCusto,[Percentual] 
--[Dt.Faturamento Previo]
----[Dt.Faturamento Definito],
----[Aplicação Mercadoria]

--from @TAB


GO
