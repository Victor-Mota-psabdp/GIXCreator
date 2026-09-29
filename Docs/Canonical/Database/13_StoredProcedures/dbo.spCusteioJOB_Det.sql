SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spCusteioJOB_Det 'IOSUN201108001BR'
--spCusteioJOB_Rel 'IMSUN201106001BR'

CREATE procedure [dbo].[spCusteioJOB_Det]
(
	@JOB varchar(16)
)
as

declare @Tab table 
(
	[Código Produto] varchar(50),
	[Estoque] varchar(2),
	[Decrição Produto] varchar(100),
	[FOB Valor] float,
	[Frete Valor] float,
	[Seguro Valor] float,
	[Valor TOTAL] float,
	[FOB Unitário Valor] float,
	[CIF Unitário Valor] float,
--	[Despachante] float,
	[Serviço de Gerenciamento - Honorários Valor] float,
	[Remoção Valor] float,
	[S.D.A. Valor] float,
	[Armazenagem Valor] float,
	[Liberação BL Valor] float,
	[Pagamento LI Valor] float,
	[Capatazia Valor] float,
	[Desconsolidação Valor] float,
	[Marinha Mercante Valor] float,
	[Demurrage Valor] float,
	[Desova Valor] float,
	[Fumigação Valor] float,
--	[CPMF] float,
	[Frete Externo Valor - Despachante] float,
	[ICMS Valor - Despachante] float,
	[Outros Valores] float,
	[Transporte Interno Valor] float,
	[TOTAL BRUTO NF SERVIÇO Valor] float,
--	[IMPOSTOS RETIDOS NOTA DE SERVIÇO] float,
	[IR Valor s/ Honorários do Despachante] float,
	[CSLL Valor s/ Honorários do Despachante] float,
	[PIS Valor s/ Honorários do Despachante] float,
	[COFINS Valor s/ Honorários do Despachante] float,
	[Sub Total Impostos Retidos Valor] float,
	[TOTAL LIQUIDO NF SERVIÇO Valor] float,
	[ICMS Valor] float,
	[Imposto de Importação Valor] float,
	[IPI Valor] float,
	[PIS Valor] float,
	[COFINS Valor] float,
	[Utilização SISCOMEX Valor] float,
	[TOTAL SISCOMEX Valor] float,
	[Frete Fornecedor Valor] float,
	[Frete Interno Valor] float,
	[Transportadora Valor] float,
	[TOTAL DESPESAS Valor] float,
	[VALOR DA MERCADORIA] float,
	[Quantidade - Value] float,
	[Custo Unitário S/ ICMS/IPI/PIS/COFINS Valor] float,
	[Custo de Internação - Valor] float
)

	Begin
		insert @tab

		select
			PC.cd_proc_cliente [Código Produto], 'MP' [Estoque], PC.produto_descr [Decrição Produto],
			sum(isnull(NFDet.FOB,0)) [Valor da Mercadoria], /*sum(isnull(NFDet.vlr_frete,0))*/ '' [Frete], sum(isnull(NFDet.vlr_seguro,0)) [Seguro],
			sum(isnull(NFDet.FOB,0) + /*isnull(NFDet.vlr_frete,0) +*/ isnull(NFDet.vlr_seguro,0)) [Valor TOTAL],
			sum(isnull(NFDet.FOB,0)) / isnull(NFDet.quantidade,1) [FOB Unitário],
			sum(isnull(NFDet.FOB,0) + /*isnull(NFDet.vlr_frete,0) +*/ isnull(NFDet.vlr_seguro,0)) / isnull(NFDet.quantidade,1) [CIF Unitário],
--			'' [Despachante],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Serv%Desp%') + dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Gestão%') + dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Emissão de NFE') [Serviço de Gerenciamento - Honorários],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'%Remo%') [Remoção],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'SDA%') [S.D.A.],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'%Armazenagem%') [Armazenagem],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Lib%BL%') [Liberação BL],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'LI %') + dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'%licen%') [Pagamento de LI],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'THC%') +	dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Capatazia%') [Capatazia],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Desconso%') [Desconsolidação],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'%AFRMM%') [Marinha Mercante],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'%Demurrage%') [Demurrage],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'%Desov%') [Desova],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'%Fumiga%') [Fumigação],
	--		'' [CPMF],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Frete') + dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'FRETE - CHB') +	dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Fretes - CHB') [Frete Externo - Despachante],
			(case when dbo.FBusca_ADTOTX(@JOB,'%ICMS%',getdate()-365, getdate(),'C') = 0 then dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'%ICMS%') else 0 end) [ICMS - Despachante],
			dbo.fBusca_Custo_SEM_Impostos(@JOB,PS.CD_Pedido, PS.Cd_Produto,'%') [Outros],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Frete Int%') + dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Transport%') [Transporte Interno],
			'' [TOTAL BRUTO NOTA FISCAL DE SERVIÇO],
--			'' [IMPOSTOS RETIDOS NOTA DE SERVIÇO],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'IRRF%') [IR s/ Honorários do Despachante],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'CSLL (01) (1,00%)') [CSLL s/ Honorários do Despachante],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'PIS(01) (0,65%) ') [PIS s/ Honorários do Despachante],
			dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Cofins (01) (3,00%)') [COFINS s/ Honorários do Despachante],
			'' [Sub Total Impostos Retidos],
			'' [TOTAL LIQUIDO NOTA FISCAL DE SERVIÇO],
			sum(isnull(NFDet.vl_ICMS,0)) [ICMS],
			sum(isnull(NFDet.vl_II,0)) [Imposto de Importação],
			sum(isnull(NFDet.vl_IPI,0)) [IPI],
			sum(isnull(NFDet.vl_imposto_PIS,0)) [PIS],
			sum(isnull(NFDet.vl_imposto_COFINS,0)) [COFINS],
			sum(isnull(NFDet.vlr_Siscomex,0)) [Taxa de Utilização SISCOMEX],
			'' [TOTAL SISCOMEX],
			'' [Frete pago ao Fornecedor],
			'' [Frete Interno],
			'' [Transportadora],
			'' [TOTAL DESPESAS],
			'' [VALOR DA MERCADORIA],
			isnull(NFDet.quantidade,0) [Quantidade],
			'' [Custo Unitário S/ ICMS/IPI/PIS/COFINS],
			'' [Custo de Internação]
		from
			pedido_ship PS with(nolock)
			join produto_cliente PC with(nolock) on PC.cd_prod = PS.cd_produto
			left join nota_cliente NF with(nolock) on NF.num_proc = @JOB
			left join nota_fiscal_cliente_det NFDet with(nolock) on NFDet.id_nf = NF.id_nf and NFDet.cd_cliente = NF.cd_cliente and PS.Cd_Produto = NFDet.cd_produto
		where
			PS.num_proc = @JOB
		group by	
			PC.cd_proc_cliente, PC.produto_descr,NFDet.quantidade,PS.CD_Pedido, PS.Cd_Produto
	End

/* se Prepaid – [Frete Fornecedor Valor] / Se Collect - [Frete Externo Valor - Despachante] */
	Begin
		declare @Tp_Frete char(1)
		set @Tp_Frete =(select tp_frete_hia from house_imp_aer where num_proc_hia = @JOB UNION ALL
						select tp_frete_him from house_imp_mar where num_proc_him = @JOB UNION ALL
						select tp_frete_hio from house_imp_out where num_proc_hio = @JOB)
		if @Tp_Frete = 'P'
			Begin
				Update @Tab 
				set [Frete Fornecedor Valor] = [Frete Externo Valor - Despachante],
					[Frete Externo Valor - Despachante] = 0
			End
	End

	Begin
		Update 
			@Tab 
		set 
			[TOTAL BRUTO NF SERVIÇO Valor] = [Serviço de Gerenciamento - Honorários Valor] + [Remoção Valor] + [S.D.A. Valor] +	[Armazenagem Valor] +	[Liberação BL Valor] + [Pagamento LI Valor] + [Capatazia Valor] + [Desconsolidação Valor] + [Marinha Mercante Valor] + [Demurrage Valor] + [Desova Valor] + [Fumigação Valor] + [Frete Externo Valor - Despachante] + [ICMS Valor - Despachante] + /*[Outros Valores]*/ + [Transporte Interno Valor],
			[Sub Total Impostos Retidos Valor] = [IR Valor s/ Honorários do Despachante] + [CSLL Valor s/ Honorários do Despachante] + [PIS Valor s/ Honorários do Despachante] + [COFINS Valor s/ Honorários do Despachante]
	End

	Begin
		Update 
			@Tab 
		set 
			[TOTAL LIQUIDO NF SERVIÇO Valor] = [TOTAL BRUTO NF SERVIÇO Valor] - [Sub Total Impostos Retidos Valor],
			[TOTAL SISCOMEX Valor] = [Imposto de Importação Valor] + [IPI Valor] + [PIS Valor] + [COFINS Valor] + [Utilização SISCOMEX Valor]
	End

	Begin
		Update 
			@Tab 
		set 
			[TOTAL DESPESAS Valor] = [TOTAL LIQUIDO NF SERVIÇO Valor] + [TOTAL SISCOMEX Valor],
			[Outros Valores] = [Outros Valores] -  [ICMS Valor] - [Utilização SISCOMEX Valor] - [TOTAL BRUTO NF SERVIÇO Valor]
	End

	Begin
		Update 
			@Tab 
		set 
			[VALOR DA MERCADORIA] = [Valor TOTAL] + [TOTAL BRUTO NF SERVIÇO Valor] + [Imposto de Importação Valor] + [Utilização SISCOMEX Valor],
			[TOTAL BRUTO NF SERVIÇO Valor] = [TOTAL BRUTO NF SERVIÇO Valor] + [Outros Valores]
	End	

	Begin
		Update 
			@Tab 
		set 
			[Custo Unitário S/ ICMS/IPI/PIS/COFINS Valor] = [VALOR DA MERCADORIA] / (case when [Quantidade - Value] = 0 then 1 end)
	End	

select --[VALOR DA MERCADORIA], [Valor TOTAL], 
* from @Tab






GO
