SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spRateioSunChemical_Rel 'IMSUN201201023BR'
--spRateioSunChemicalDet_Rel 'IMSUN201201023BR'
--
--spRateioDetalhe_Rel'IMSUN201201023BR'
--spRateioDespachante_Rel'IMSUN201201023BR'
--spRateioImpostosRecuperaveis_Rel 'IMSUN201201023BR'
--spRateioImpostos_Rel'IMSUN201201023BR'

CREATE procedure [dbo].[spRateioSunChemicalALL_Rel]--'Grupo Sun Chemical','2011-01-01','2012-10-16' 
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as

	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

select 
		SHP.apelido										[Fornecedor],
		DI.numero_po_him								[DI],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_proc_him,1)	[Ref. Sun],
		HOU.Num_proc_him								[Ref. BDP],
		HOU.cd_tp_oper									[Incoterm],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_proc_him,10)	[NF Sun],
		TRA.Apelido										[Transportadora],
		LLP.Cd_Moeda_Invoice							[Moeda],
		convert(float,
				isnull(dbo.fBusca_CampoCliente(HOU.Num_proc_him,119),
					convert(float,isnull(dbo.fBusca_CampoCliente(HOU.Num_proc_him,31),1)))) [Taxa], 		
		convert(float,isnull(dbo.fBusca_CampoCliente(HOU.Num_proc_him,31),1))			[Taxa Dolar],
		PROD.Produto_Descr																[Produto],
		PROD.cd_proc_cliente															[Cod. Produto],
		sum(isnull(NFDet.Peso_Liquido,isnull(DII.PesoLiquido,0)))						[Quantidade em kg],
		(case when HOU.cd_tp_oper in ('FOB','FCA','CFR','EXW') then sum(isnull(NFDet.FOB,isnull(DII.FOB_Reais,0)))
				else sum(isnull(NFDet.FOB - NFDet.Vlr_Frete ,isnull(DII.FOB_Reais - DII.Frete_Reais,0))) end)[FOB R$],
		(case when HOU.cd_tp_oper in ('CFR') then 0 else	sum(isnull(NFDet.vlr_frete,isnull(DII.Frete_Reais,0))) end)								[Frete R$],
		sum(isnull(NFDet.vlr_seguro,isnull(DII.Seguro_Reais,0)))							[Seguro R$],
		sum(isnull(NFDet.acrescimos,isnull(DII.Acrescimos_Reais,0)))						[Handling R$],
		(case when HOU.cd_tp_oper in ('CFR') then 0 else	sum(isnull(NFDet.vlr_frete,isnull(DII.Frete_Reais,0))) end) + sum(isnull(NFDet.CIF, (isnull(DII.FOB_Reais,0) + isnull(DII.Seguro_Reais,0)))) + sum(isnull(NFDet.acrescimos,isnull(DII.Acrescimos_Reais,0))) Vlr_CIF,

		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'%AFRMM%')			[AFRMM],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'%Armazenagem%')	[Armazenagem],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'BAF - CHB')		[BAF - CHB],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Capatazia%')		[Capatazia],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Courier%')			[Courier],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Desconso%')		[Desconsolidacao],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'%Desov%')			[Desova],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Despesas Administrativas%') [Despesas Administrativas],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Devolu%')				[Devolução de CNTR],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Handling%')			[Handling],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Lib%BL%')				[Liberacao_BL],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Monitoramento%CNTR%')	[Monitoramento CNTR],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'%Remo%')				[Remocao],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Serv%Desp%') + 
			dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Gestão%')			[Serviços de Despacho],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Taxa%de%origem%')		[Taxa de Origem],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'TAXA%SISCARGA%%')		[TAXA SISCARGA],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'THC%')					[THC],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Frete Int%') +
			dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Transp%')			[Transporte],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'SDA%')					[SDA],		
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'LI %') +
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'%licen%')				[Pagamento LI],	
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'%Demurrage%') + dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'%Depos%Cont%') [Demurrage],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'%Fumiga%')				[Fumigacao],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Frete') +
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'FRETE - CHB') +
			dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Fretes - CHB')		[Frete],
--		(case when dbo.FBusca_ADTOTX(HOU.Num_proc_him,'%ICMS%',getdate()-365, getdate(),'C') = 0 then dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'%ICMS%') else 0 end) [ICMS],
			
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'IRRF%') *-1 [IR s/ Honorários do Despachante],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'CSLL (01) (1,00%)')*-1 [CSLL s/ Honorários do Despachante],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'PIS(01) (0,65%) ')*-1 [PIS s/ Honorários do Despachante],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'Cofins (01) (3,00%)')*-1 [COFINS s/ Honorários do Despachante],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.cd_pedido, NFDet.cd_produto,'ICMS s/ Transp.') *-1 [ICMS s/ Transporte],

		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.CD_Pedido, NFDet.Cd_Produto,'%Imp%Imp%') [I.I],
		isnull(NFDet.Aliq_II,0) / 100 [% II],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.CD_Pedido, NFDet.Cd_Produto,'IPI - CHB%') [I.P.I],
		isnull(NFDet.Aliq_IPI,0) / 100 [% IPI],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.CD_Pedido, NFDet.Cd_Produto,'IPI Compl%') [DIFERENÇA DE IPI],
		(case when dbo.FBusca_ADTOTX(HOU.Num_proc_him,'%ICMS%',getdate()-365, getdate(),'B') = 0 then dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.CD_Pedido, NFDet.Cd_Produto,'ICMS - CHB%') else 0 end) [ICMS],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.CD_Pedido, NFDet.Cd_Produto,'%SISCOMEX%') [TAXA SISCOMEX],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.CD_Pedido, NFDet.Cd_Produto,'PIS - CHB%') [RECOLHIMENTO PIS],
		dbo.fBusca_Custo(HOU.Num_proc_him,NFDet.CD_Pedido, NFDet.Cd_Produto,'COFINS - CHB%') [RECOLHIMENTO COFINS]

	from
		house_imp_mar				HOU with(nolock)
		join llp_imp_mar			LLP with(nolock) on LLP.num_proc_lim = HOU.num_proc_him
		left join po_him			DI with(nolock) on DI.num_proc_him = HOU.num_proc_him and DI.id_dc = 5
		left join pessoa_llp		PLL with(nolock) on PLL.cd_pes = HOU.cd_consig_him and PLL.cd_pes_grupo = 'P000004208'
		join pessoa					SHP with(nolock) on SHP.cd_pes = HOU.cd_export_him
		left join pessoa			TRA with(nolock) on TRA.cd_pes = LLp.cd_transportadora	
	
		join nota_cliente			NF with(nolock) on NF.num_proc = Hou.num_proc_him
		join nota_fiscal_cliente_det NFDet with(nolock) on NFDet.id_nf = NF.id_nf and NFDet.cd_cliente = NF.cd_cliente and NFDet.cd_produto = NFDet.cd_produto
		left join produto_cliente PROD with(nolock) on PROD.cd_prod = NFDet.cd_produto
		left join ATL_Capa_Valores ADT with(nolock) on ADT.num_proc=NF.num_proc
		left join DI_Item_BR		DII with(nolock) on DII.num_proc = NF.num_proc and DII.cd_produto = NFDet.cd_produto and DII.item = NFDet.id_item
	Where	
		substring(num_proc_lim,3,3) = @grupo and
		atd_lim  between @DtInicial and @DtFinal
		and isnull(id_status,0) <> 9
--		HOU.num_proc_him = 'IMSUN201201023BR'
Group by
		SHP.apelido,
		DI.numero_po_him,
		HOU.Num_proc_him,
		HOU.cd_tp_oper,
		TRA.Apelido,
		LLP.Cd_Moeda_Invoice,
		PROD.Produto_Descr,
		PROD.cd_proc_cliente,
		NFDet.cd_pedido, 
		NFDet.cd_produto,
		NFDet.Aliq_II,
		NFDet.Aliq_IPI

order by 4


GO
