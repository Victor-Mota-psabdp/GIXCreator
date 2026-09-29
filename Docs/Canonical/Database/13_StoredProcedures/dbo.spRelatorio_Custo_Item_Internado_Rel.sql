SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Tarefas_Processos where Num_Proc = 'IMFMC201612025BR' and ID_Task = 4 
--[spRelatorio_Custo_Item_Internado_Rel]'Grupo FMC','2012-01-01','2012-01-31'
CREATE Procedure [dbo].[spRelatorio_Custo_Item_Internado_Rel]--'Grupo FMC','2016-12-29','2016-12-29'
(
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
AS

--Declare @Grupo varchar(20)
--Declare @DtInicial datetime
--Declare @DtFinal datetime
Declare @Cd_Grupo as varchar(10)

--set @Grupo = 'Grupo FMC'
--set @DtInicial ='2017-03-03' -- '2016-12-29'
--set @DtFinal = '2017-03-03' --'2016-12-29'

Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
--exec dbo.spATL_CalculaPercentual_Ins @Cd_Grupo
if @Grupo = 'Grupo FMC'
	exec spATL_CalculaPercentual_FMC_Ins @Cd_Grupo,@DtInicial
else
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
		[Valor Frete Rem+Entr]				float, 
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
		[Percentual]				float		
		
	)


	Begin
		insert into
			@TAB (
					[CNPJ],[Ref. BDP],[Ref. Cliente],[NRPEDIDO],
					[NRREGISTROLI],[Nr. DI],[Data DI],
					--[Adição],[Item],
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
					[Dt.Faturamento Previo],[Dt.Faturamento Definito],[Percentual]
				)
		select
				CNS.Num_CPF_CNPJ,HOU.Num_Proc,[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,1),[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,9),
				[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,23),--DI.numero_po_him,DI.data_po_him,
				[dbo].[fBusca_Docs_PO_Modal](HOU.num_proc,5),[dbo].[fBusca_DATA_PO_Modal](HOU.num_proc,5),
				--'??','??',
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
				TP79.Dt_Conclusao,TP76.Dt_Conclusao,PP.Percentual
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
			--and 
			--HOU.Num_Proc_HIM = 'IMFMC201612025BR'		
		
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
			[Peso Liq. Total] = totPesoLiquido,
			[Aplicação Mercadoria] = (case 
										when CFOP = '3101' then 'INDUSTRIALIZAÇÃO' 
										else 
										(case when CFOP = '3102' then 'COMERCIALIZAÇÃO' 
										else 
										(case when CFOP = '3949' then 'OUTRAS ENTRADAS' 
										else 
											CFOP								
									 End)End)End)	

			
		from 
			@TAB T
			join
			(
			Select 
				CIF totCIF, 
				(CIF - vlr_frete - vlr_seguro - isnull(acrescimos,0)) totFOB,
				Vlr_FRETE totFrete,
				vlr_Seguro totSeguro,
				VL_II totII, 
				VL_IPI totIPI,
				VL_IMPOSTO_PIS totPis,
				VL_IMPOSTO_COFINS totCofins,
				VL_ICMS totICMS,
				Vlr_Siscomex totSiscomex,
				--Vlr_Total_Item	totItem,
				CIF	totItem,							
				Cd_Produto,
				--cd_pedido, 
				num_proc,
				replace(CFOP,'.','')CFOP,
				Peso_Liquido totPesoLiquido		
			from nota_fiscal_cliente_det NFCD
			join nota_cliente NC on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
			--group by Cd_Produto,num_proc,Cd_Pedido,CIF,
			) A on A.num_proc = T.[Ref. BDP] and A.cd_produto = T.cd_produto --and A.cd_pedido=T.CD_Pedido
	End

	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set
	--		--[SISCOMEX (Custo) Value] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Siscomex%'),			
			[Valor Desconsolidação] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Desconsolidacao%'),
			[Valor Movimentação] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Movimentacao%'),
			[Valor AFRMM] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%AFRMM%'),
			[Valor Armaz ZP] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Armazenagem%'),
			[Acréscimos R$]= dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'VALOR%DOS%ACRÉSCIMOS%'),
			[Valor Demurrage] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%Demurrage%') ,
			[Valor Capatazias] =(dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'THC%') 
					+ dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Capatazia%')) ,
					
			[Depósito Caução (Cntr)] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Depósito%Caução%'),
			
			[Valor Multa] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Multa%'),
						
			[Outras Desp. Cntr.] = (
				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Lavagem%CNTR%')+
				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Avaria%') + 
				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'DESPESA%CONTAINER%')	+ 
				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Reparo%Container%')+ 
				dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Devolução%CNTR%')
				),	
			
			
			
			[Valor Fumigação] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Fumigação%'),
			
			[Valor Armaz EADI] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Armaz%EADI%'),
			
			[Valor Desp. LI] = (dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Emissão%LI%')
				+ dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'SUB%LI%')),
			[Valor SDA] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'SDA%'),
			
			[Valor Serviços] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'Serviços%Prestados%DESPACHO%'),	
				
			[Custo Total] = dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'%'),
			
			[Valor Frete Rem+Entr] = 0,
		
	
			[FOB retirar]= dbo.fBusca_Custo([Ref. BDP],CD_Pedido, Cd_Produto,'FOB%CHARGES%'),		
	--		--[FRETE (CONSTA NA DI)]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'FRETE%'),	
	
	--		--[Imposto de Importação - CHB]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Imposto%de%Importação%') ,
	--		--[Seguro]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Seguro%') ,
	--		--[Outras despesas]= dbo.fBusca_Custo_OutrasDespesas([BDP Job],CD_Pedido, Cd_Produto),
	--		--[Emissao de NFE] = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Serviços%Prestados%','C') ,
	--		--[Serviços Prestados] = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Emissão%de%nfe%','C'),
	--		--[Emissao LI]  = [dbo].[fBusca_CtaCteTaxaVlr]([BDP Job],'Emissão%LI%','C'),
	
	[Valor Adiantamento]  = [dbo].[fBusca_CtaCteTaxaVlr]([Ref. BDP],'Transf.%Processos%ATL%','C')
					
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
	
	Begin
		Update @TAB
			set
			[Valor Outras Despesas] =	
			(isnull([Custo Total],0) - 						
			isnull([Valor II],0) - 
			isnull([II Complementar],0) - 
			isnull([Valor IPI],0) - 
			isnull([IPI Complementar],0) - 
			isnull([Valor PIS],0) - 
			isnull([Valor COFINS],0) - 
			isnull([PIS/Cofins Complementar],0) - 
			isnull([Valor Multa],0) - 
			isnull([Valor Tx. Siscomex],0) - 
			isnull([Valor ICMS],0) - 
			isnull([ICMS Complementar],0) - 
			isnull([Valor AFRMM],0) - 
			isnull([Valor Desconsolidação],0) - 
			isnull([Valor Frete Intl. Pago],0) - 
			isnull([Valor Capatazias],0) - 
			isnull([Valor Movimentação],0) - 
			isnull([Valor Demurrage],0) - 
			isnull([Depósito Caução (Cntr)],0) - 
			isnull([Outras Desp. Cntr.],0) - 
			isnull([Valor Fumigação],0) - 
			isnull([Valor Armaz ZP],0) - 
			isnull([Valor Armaz EADI],0) - 
			isnull([Valor Frete Rem+Entr],0) - 
			isnull([Valor Desp. LI],0) - 
			isnull([Valor SDA],0) - 
			isnull([Valor Serviços],0) - 
			--isnull([Valor Adiantamento],0)- 			
			isnull([Acréscimos R$],0) -
			--isnull([Valor FOB],0) -
			isnull([Valor Seguro R$],0) -
			isnull([FOB retirar],0)						
			)								
	End
	
	
select 
[Ref. BDP],
[Ref. Cliente],
[NRPEDIDO],
[NRREGISTROLI],
[Nr. DI],
[Data DI],
[Adição],
[Item],
[Modal],
[Exportador],
[Origem],
[Cód. Produto],
[Desc. Produto],
[Qtde.],
[Unidade],
--[Peso Liq. Total],
cast([Peso Liq. Total] * [Percentual] as decimal(18,2)) [Peso Liq. Total],
[VUCV Moeda],
[Valor Total Moeda],
[Moeda DI],
replace(CONVERT(varchar(10),[Taxa Moeda DI]),'.',',') [Taxa Moeda DI],
[Valor Total R$],
[INCOTERM],
[Tipo Frete],
--[Valor FOB],
cast([Valor FOB] * [Percentual] as decimal(18,2)) [Valor FOB],
--[Valor Frete Moeda],
cast([Valor Frete Moeda] * [Percentual] as decimal(18,2)) [Valor Frete Moeda],
[Moeda Frete],
[Taxa Moeda Frete],
--[Valor Frete R$],
cast([Valor Frete R$] * [Percentual] as decimal(18,2)) [Valor Frete R$],
--[Valor Seguro Moeda],
cast([Valor Seguro Moeda] * [Percentual] as decimal(18,2)) [Valor Seguro Moeda],
[Moeda Seguro],
[Taxa Moeda Seguro],
[Valor Seguro R$],
[Acréscimos R$],
[Taxa USD],
--[Valor Aduaneiro],
cast([Valor Aduaneiro] * [Percentual] as decimal(18,2)) [Valor Aduaneiro],
'Recolhimento Integral' [Regime Tributação II],
[Tipo De Processo],
isnull([Valor II],'0.00')[Valor II],
isnull([II Complementar],'0.00')[II Complementar],
isnull([Valor IPI],'0.00')[Valor IPI],
isnull([IPI Complementar],'0.00')[IPI Complementar],
isnull([Valor PIS],'0.00')[Valor PIS],
isnull([Valor COFINS],'0.00')[Valor COFINS],
isnull([PIS/Cofins Complementar],'0.00')[PIS/Cofins Complementar],
isnull([Valor Multa],'0.00')[Valor Multa],
--isnull([Valor Tx. Siscomex],'0.00')[Valor Tx. Siscomex],
cast(isnull([Valor Tx. Siscomex],'0.00') * [Percentual] as decimal(18,2)) [Valor Tx. Siscomex],
isnull([Valor ICMS],'0.00')[Valor ICMS],
isnull([ICMS Complementar],'0.00')[ICMS Complementar],
isnull([Valor AFRMM],'0.00')[Valor AFRMM],
isnull([Valor Desconsolidação],'0.00')[Valor Desconsolidação],
isnull([Valor Frete Intl. Pago],'0.00')[Valor Frete Intl. Pago],
isnull([Valor Capatazias],'0.00')[Valor Capatazias],
isnull([Valor Movimentação],'0.00')[Valor Movimentação],
isnull([Valor Demurrage],'0.00')[Valor Demurrage],
isnull([Depósito Caução (Cntr)],'0.00')[Depósito Caução (Cntr)],
isnull([Outras Desp. Cntr.],'0.00')[Outras Desp. Cntr.],
isnull([Valor Fumigação],'0.00')[Valor Fumigação],
isnull([Valor Armaz ZP],'0.00')[Valor Armaz ZP],
isnull([Valor Armaz EADI],'0.00')[Valor Armaz EADI],
isnull([Valor Frete Rem+Entr],'0.00')[Valor Frete Rem+Entr],
isnull([Valor Desp. LI],'0.00')[Valor Desp. LI],
isnull([Valor SDA],'0.00')[Valor SDA],
isnull([Valor Outras Despesas],'0.00')[Valor Outras Despesas],
isnull([Valor Serviços],'0.00')[Valor Serviços],
isnull([Valor Adiantamento],'0.00')[Valor Adiantamento],
[Dt.Faturamento Previo],
[Dt.Faturamento Definito],
[Aplicação Mercadoria]
from @TAB
GO
