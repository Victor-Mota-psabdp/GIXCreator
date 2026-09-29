SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Nota_Fiscal_Cliente_Det
-- where id_nf = 2293 and cd_cliente = 'P000004797'
--
--select * from nota_cliente where num_proc = 'IMCEN201304001BR'

CREATE procedure [dbo].[spATL_DraftNFDet_Rel] --[spATL_DraftNFDet_Rel]  'IMUPL201207013BR'
	@Processo varchar(16)
AS

declare @Tab table
(
	[Nota Fiscal]	varchar(20),
	[Item]	int,
	[NCM]	varchar(20),
	[Quantidade]	float,
	[Preço Unit]	float,
	[Preço Total]	float,
	[Frete]	float,
	[Seguro]	float,
	[Acrescimos] float,
	[MLE] float,
	[Siscomex]	float,
	[% II]	float,
	[% ICMS]	float,
	[% IPI]	float,
	[% Cofins]	float,
	[%PIS]	float,
	[Vlr II]	float,
	[Vlr ICMS]	float,
	[Vlr IPI]	float,
	[Vlr Cofins]	float,
	[Vlr PIS]	float,
	[Base PIS]	float,
	[Base Cofins]	float,
	[Base ICMS]	float,
	[Base IPI]	float,
	[Base II]	float,
	[P.Bruto]	float,
	[P. Liq.]	float,
	[Cod. Prod.]	varchar(50),
	[Produto]	varchar(500),
	[Delivery Note] varchar(50),
	[Num PO] Varchar(40)
)

Declare @DADOS varchar(20)
Declare cTemp cursor for select Nota_Fiscal from Nota_Cliente where num_proc = @Processo
open cTemp
	Fetch Next From cTemp Into @DADOS
		While @@FETCH_STATUS = 0
			Begin
				insert @Tab

				select distinct nota_fiscal [Nota Fiscal],PS.item,NCM,				
				sum(Quantidade) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),		
				max(Vlr_Item), 
				sum(Vlr_Total_Item) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto), 
				sum(Vlr_Frete) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto), 
				sum(Vlr_Seguro) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto), 
				sum(ACRESCIMOS) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto), 
				sum((vl_base_II - vlr_frete - vlr_seguro - acrescimos)) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(vlr_Siscomex) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				max(Aliq_II),
				max(Aliq_ICMS),
				max(Aliq_IPI),
				max(Vl_Aliq_Cofins),
				max(Vl_Aliq_PIS),
				sum(Vl_II) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Vl_ICMS) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Vl_IPI) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Vl_Imposto_Cofins) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Vl_Imposto_PIS) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Vl_Base_PIS) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Vl_Base_Cofins)* [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Vl_Base_ICMS) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Vl_Base_IPI)* [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Vl_Base_II)* [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Peso_Bruto)* [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				sum(Peso_Liquido)* [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)*[dbo].[fBuscaPorcentagem_Pedido_Prod] (ps.num_proc,ps.cd_pedido,ps.cd_produto),
				(select top 1  cd_proc_cliente from produto_cliente where cd_prod = DET.Cd_Produto) Cod_Prod, 
				(Select top 1 Produto_descr from produto_cliente where cd_prod = DET.cd_produto) Produto,
				lote,num_pedido
			from
				Nota_Fiscal_Cliente_Det DET with(nolock)
				join nota_cliente NC with(nolock) on NC.id_nf = DET.id_nf and NC.cd_cliente = DET.cd_cliente
				join pedido_ship PS with(nolock) on PS.num_proc=NC.num_proc and Det.cd_produto = Ps.cd_produto
				join pedido P with(nolock) on P.cd_pedido = PS.cd_pedido
			where 
				NC.num_proc = @Processo and NC.nota_fiscal = @Dados
			group by DET.cd_produto,DET.cd_pedido,ps.item,ps.num_proc,ps.item,num_pedido,lote,nota_fiscal,NCM,ps.cd_pedido,ps.cd_produto
					
				insert @Tab
				select 
					'Totais' [Nota Fiscal], null [Item],null [NCM],null [Quantidade],null [Preço Unit], 
					SUM([Preço Total]), SUM([Frete]), SUM([Seguro]), SUM([Acrescimos]), SUM([MLE]), SUM([Siscomex]), null [% II],null [% ICMS],null [% IPI],null [% Cofins],null [%PIS],
					SUM([Vlr II]), SUM([Vlr ICMS]), SUM([Vlr IPI]), SUM([Vlr Cofins]), SUM([Vlr PIS]), SUM([Base PIS]), SUM([Base Cofins]),
					 SUM([Base ICMS]), SUM([Base IPI]), SUM([Base II]), SUM([P.Bruto]), SUM([P. Liq.]),null [Cod. Prod.],null [Produto], null [Delivery Note],null
				from
					@Tab
				where
					[Nota Fiscal] = @Dados

				Fetch Next From cTemp Into @Dados
			end
close cTemp
deallocate cTemp 


select * from @Tab



-----------------------------select antigo

--insert @Tab
--
--				select nota_fiscal [Nota Fiscal],
--					ID_Item, NCM, Quantidade, Vlr_Item, Vlr_Total_Item, Vlr_Frete, Vlr_Seguro, ACRESCIMOS, (vl_base_II - vlr_frete - vlr_seguro - acrescimos)  MLE, Vlr_Siscomex Siscomex,
--					Aliq_II,Aliq_ICMS,Aliq_IPI,Vl_Aliq_Cofins,Vl_Aliq_PIS,
--					Vl_II,Vl_ICMS,Vl_IPI,Vl_Imposto_Cofins,Vl_Imposto_PIS,
--					Vl_Base_PIS, Vl_Base_Cofins,Vl_Base_ICMS,Vl_Base_IPI,Vl_Base_II,Peso_Bruto,Peso_Liquido,
--					(select cd_proc_cliente from produto_cliente where cd_prod = DET.Cd_Produto) Cod_Prod, 
--					(Select Produto_descr from produto_cliente where cd_prod = DET.cd_produto) Produto,
--					(select distinct Lote from pedido_ship where cd_produto = DET.cd_produto and cd_pedido = Det.cd_pedido and num_proc = @Processo and id_item = item) Delivery_Note
--				from
--					Nota_Fiscal_Cliente_Det DET with(nolock)
--					join nota_cliente NC on NC.id_nf = DET.id_nf and NC.cd_cliente = DET.cd_cliente
--				where 
--					NC.num_proc = @Processo and nota_fiscal = @Dados

GO
