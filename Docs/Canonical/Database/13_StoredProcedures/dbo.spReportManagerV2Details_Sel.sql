SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--cadu @ICMSBase=	cast(sum(cast(VL_BASE_ICMS as decimal(18,2))) as varchar(40)), alterado p 18,2
--Cadu - incluido isnull(@Import1Duty1Value,'0.00') Import1Duty1Value - 28/02/2014
--[dbo].[spReportManagerV2Details_Sel] '	IMCSR201601032BR','00069731'
/*09/11/2016 - Cadu - incluido as contas do RM nesta stored - FOB - USD e Freight - USD e CFR - USD 
e TP - Despesas Acessorias - Value e ICMS Base e CIF Value
retirei o --@ICMSBase ICMS1Base q nao valia p nada
*/
--spReportManagerV2Details_Sel 'IMSLA201804020BR','GMN 50148553'
CREATE   Procedure [dbo].[spReportManagerV2Details_Sel]
		@Num_Proc	Varchar(16),
		@Cd_Prod	Varchar(50)
AS
/*

	Definição:
	_ = ' - '
	1 = Espaço
	@ = 1
	9 = _
	8 = – traço grande
	A0 = 1Espaço ( 1 )
	A2 = 2Espaço ( 2 )
	P0 = %
	
*/
--Declare @Num_Proc	Varchar(16)
--Declare @Cd_Prod	Varchar(50)

--set @Num_Proc =  'IACSR201903037BR'
--set @Cd_Prod  = '97030145'

--select * from Pedido_Ship where Num_Proc = 'IAHEX201610002BR'
--select * from Produto_Cliente where cd_prod in ('89464','89795','89937')
--21280713
--5849763
--6625403

Declare @QtyKG varchar(40)
Declare @UnitPrice	Varchar(60)
Declare @CFOP		Varchar(10)
Declare @ICMSBase	Varchar(40)
Declare @TP_Despesas1Calc1ICMS_Value varchar(40)
Declare @Freight1Value	varchar(30)
declare @NCM			Varchar(8)
Declare @Warehousing1Value Varchar(20)
Declare @Siscomex1Value Varchar(20)
Declare @Gross1Weight_NF Varchar(40)
Declare @FOB	Varchar(40)
Declare @Product1Value Varchar(40)
Declare @NCM1PO	Varchar(10)

Declare @ALIQ_ICMS as decimal(10,2)
Declare @ALIQ_II as decimal(10,2)
Declare @ALIQ_IPI as decimal(10,2)
Declare @ALIQ_PIS as decimal(10,2)
Declare @ALIQ_Cofins as decimal(10,2)

Declare	@Qty		float
--Declare	@NCM		varchar(12)
Declare @Reponsible1PO varchar(30)
Declare @Business1Name varchar(50)
Declare @Value1Center varchar(50)
Declare @Product1Description varchar(200)
Declare @Net1Weight1KG float
Declare @Gross1Weight1KG float
Declare @Order1Type varchar(30)
Declare @PO1Group char(3)
Declare @Business1Group varchar(50)

-- Antonio 17-11-2022 - Ticket 100-360110 -------------
declare @SOP1Value varchar(50)
---- fim ticket 100-360110 ----------------------------

exec dbo.[spReportManagerV2_PedidoShip] @Num_Proc, @Cd_Prod, @Qty output, @NCM output, @Reponsible1PO output, @Business1Name output, @Value1Center output, @Product1Description output,
	@Net1Weight1KG output, @Gross1Weight1KG output, @Order1Type output, @PO1Group output, @Business1Group output
set @Product1Description =  replace(@Product1Description,'''','')
	if left(@Num_Proc,1)='I'
		Begin
			select 
				@QtyKG  = cast(sum(cast(peso_liquido as decimal(18,2))) as varchar(40)),
				@ICMSBase=	cast(sum(cast(VL_BASE_ICMS as decimal(18,2))) as varchar(40)),
				@TP_Despesas1Calc1ICMS_Value=cast(cast(sum(ACRESCIMOS) as decimal(10,2)) as varchar(40)),
				@Freight1Value=cast(cast(sum(Vlr_Frete) as decimal(10,2)) as varchar(40)),
				@NCM=Max(NCM),
				@Gross1Weight_NF=cast(sum(cast(peso_bruto as decimal(18,2))) as varchar(40)),
				@FOB = cast(cast(sum(Vlr_Total_ITem-isnull(vlr_frete,0)-isnull(vlr_seguro,0)-isnull(vl_ii,0)-isnull(ACRESCIMOS,0)) as decimal(18,2)) as varchar(40)),
				@Product1Value =cast(cast(sum(Vlr_Total_ITem ) as decimal(18,2)) as varchar(40)),
				
				@ALIQ_ICMS =  cast(max(ALIQ_ICMS) as decimal(10,2)),
				@ALIQ_II = cast(max(ALIQ_II) as decimal(10,2)),
				@ALIQ_IPI = cast(max(ALIQ_IPI) as decimal(10,2)),
				@ALIQ_Cofins = cast(max(VL_ALIQ_COFINS) as decimal(10,2)),
				@ALIQ_PIS = cast(max(vl_aliq_pis) as decimal(10,2))
				
			from 
				Nota_Cliente NC with(nolock)	
				Join Nota_Fiscal_Cliente_det NCD With(nolock) on NCD.cd_cliente=NC.cd_cliente and Nc.id_nf=ncd.id_nf
				Join Produto_Cliente PC with(nolock)  on cd_produto=cd_prod

			Where 
				Num_Proc=@Num_Proc and Cd_Proc_cliente=@cd_Prod
			Group by num_proc,cd_proc_Cliente

			Set @CFOP=cast((select 
				MAX(CFOP)
			from 
				Nota_Cliente NC with(nolock)	
				Join Nota_Fiscal_Cliente_det NCD With(nolock) on NCD.cd_cliente=NC.cd_cliente and Nc.id_nf=ncd.id_nf
				Join Produto_Cliente PC with(nolock)  on cd_produto=cd_prod

			Where 
				Num_Proc=@Num_Proc and Cd_Proc_cliente=@cd_Prod
			) as varchar(10))
		End
	Else
		Begin
			Set @CFOP=(select top 1 left(campo_Dados,10) from campo_processo with(nolock) where id_campo=134 and num_proc=@Num_Proc)
			exec [dbo].[spReportManagerExpV2FOB_Sel] @Num_Proc,@Cd_Prod,@Fob output
			Set @Product1Value=@FOB
		End


set @qtykg=replace(@qtykg,',','.')
print @qtykg
Set @UnitPrice=cast(cast((

				select max(vlr_item) from pedido_det PD with(nolock) 
				Join Pedido_Ship PS with(nolock) on PS.cd_pedido=PD.cd_pedido and PS.cd_produto=PD.cd_produto
				Join Produto_Cliente PC with(nolock) on Ps.cd_produto=cd_prod
				where
						PS.num_proc=@num_proc
						
						and Cd_Proc_cliente=@cd_Prod
				)as decimal(18,2)) as varchar(50))
				
SEt @UnitPrice=replace(@UnitPrice,',','.')				
set @ICMSBase=replace(@ICMSBase,',','.')
set @Freight1Value=replace(@Freight1Value,',','.')
set @Gross1Weight_NF=replace(@Gross1Weight_NF,',','.') 

Declare	@UOM		varchar(5)

			select top 1 @NCM1PO= ncm, @UOM= (case when @Cd_Prod = 'N/A' then 'N/A' else UOM end) from pedido_Det PD with(nolock)
			join pedido_ship PS with(nolock)  on PS.cd_pedido=PD.cd_pedido and Ps.cd_produto=PD.cd_produto and ps.lote=pd.lote and PS.item=PD.item
			Join produto_Cliente PC with(nolock) on PC.cd_prod=PD.cd_produto 
			where 
				num_proc=@Num_Proc
				and cd_proc_cliente=@cd_prod

---CUSTOS
	Declare @Seal_Value varchar(50)
	
	Set @Seal_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where nome_tp_Tx like 'Lacre%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Seal_Value=replace(@Seal_Value,',','.')

	Declare @NFE1Issue1Cost_Value varchar(50)

	Set @NFE1Issue1Cost_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where nome_tp_Tx like 'Emissão de NFE%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @NFE1Issue1Cost_Value=replace(@NFE1Issue1Cost_Value,',','.')

	Declare @COO_Value varchar(50)
	
	Set @COO_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where nome_tp_Tx like 'Certificado de Origem%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @COO_Value=replace(@COO_Value,',','.')


	Declare @TUP_Value varchar(50)
	
	Set @TUP_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where nome_tp_Tx like 'TUP%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @TUP_Value=replace(@TUP_Value,',','.')
	
	Declare @IPI_Value varchar(50)
	Set @IPI_Value='0.00'
	if left(@Num_Proc,1)='I'
		Begin
	
			Set @IPI_Value=cast((
							select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
							Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
							Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
							where nome_tp_Tx like 'IPI%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
												) as varchar(50))
			set @IPI_Value=replace(@IPI_Value,',','.')
		End
		
	Declare @DocumentDelivery_Value Varchar(50)

	Set @DocumentDelivery_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where (nome_tp_Tx like 'DELIVERY FEE%' or  nome_tp_Tx like 'Taxa de retirada de doc%' or nome_tp_Tx like 'Liberação de Documentos - CHB%' or nome_tp_Tx like 'Despesas Administrativas - CHB%') and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @DocumentDelivery_Value=replace(@COO_Value,',','.')
	
	-- Antonio 17-11-2022 -  ticket 100-360110 -------------------------------------------------------------
	--Declare @SDA_Value Varchar(50)

	--Set @SDA_Value=cast((
	--				select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
	--				Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
	--				Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
	--				where nome_tp_Tx like 'SDA %' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
	--									) as varchar(50))
	--set @SDA_Value=replace(@SDA_Value,',','.')
    -- fim Ticket 100-360110 --------------------------------------------------------------------------------  

	if left(upper(@num_proc),1)='I' 
		Begin
			Set @Siscomex1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where (nome_tp_Tx like '%Siscomex%' )and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
			set @Siscomex1Value=replace(@Siscomex1Value,',','.')
		End
		
	Set @Warehousing1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where (nome_tp_Tx like 'VISTORIA DE CNTR%' or nome_tp_Tx like 'Posicionamento de CNTR%'  or nome_tp_Tx like 'Armazenagem%' or nome_tp_Tx like 'Estadia%' or nome_tp_Tx like 'Movimentação de Container%' or nome_tp_Tx like 'Movimentacao CNTR%' or Nome_Tp_Tx like 'Pesagem%'or Nome_Tp_Tx like 'Posicionamento%' )and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Warehousing1Value=replace(@Warehousing1Value,',','.')


	Declare @Courier_Value Varchar(50)

	Set @Courier_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where nome_tp_Tx like 'Motoboy%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Courier_Value=replace(@Courier_Value,',','.')
	
--Incluido por Rafael Lindenberg - INICIO
	Declare @THC1Value Varchar(50)

	Set @THC1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where (nome_tp_Tx like 'THC%'or Nome_Tp_Tx like 'capatazias%') and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @THC1Value=replace(@THC1Value,',','.')
	
	Declare @Unloaded1Value Varchar(50)

	Set @Unloaded1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where nome_tp_Tx like 'Desova%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Unloaded1Value=replace(@Unloaded1Value,',','.')
	
	Declare @Demurrage1Value Varchar(50)

	Set @Demurrage1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where nome_tp_Tx like 'Demurrage%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Demurrage1Value=replace(@Demurrage1Value,',','.')
	
	Declare @Desconsolidation1Value Varchar(50)

	Set @Desconsolidation1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where nome_tp_Tx like 'Desconsolida%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Desconsolidation1Value=replace(@Desconsolidation1Value,',','.')
	
	Declare @ISPS1Value Varchar(50)

	Set @ISPS1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like 'ISPS%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @ISPS1Value=replace(@ISPS1Value,',','.')
	
	Declare @Customs1Brokerage1Value Varchar(50)

	Set @Customs1Brokerage1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like '%DESPACHO' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Customs1Brokerage1Value=replace(@Customs1Brokerage1Value,',','.')
	
		Declare @Inland1Freight1Value Varchar(50)

	Set @Inland1Freight1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where (nome_tp_Tx like '%Frete Interno%' or Nome_Tp_Tx like '%Inland%') and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Inland1Freight1Value=replace(@Inland1Freight1Value,',','.')
	
		Declare @BL1Fee1Value Varchar(50)

	Set @BL1Fee1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like 'Liberação de BL%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @BL1Fee1Value=replace(@BL1Fee1Value,',','.')
	
		Declare @Container1Cleaning1value Varchar(50)

	Set @Container1Cleaning1value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like 'Lavagem%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Container1Cleaning1value=replace(@Container1Cleaning1value,',','.')

		Declare @PIS_Value Varchar(50)

	Set @PIS_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like 'PIS%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @PIS_Value=replace(@PIS_Value,',','.')
	
		Declare @Posicionamento_Value Varchar(50)

	Set @Posicionamento_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like 'Posicionamento%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Posicionamento_Value=replace(@Posicionamento_Value,',','.')
	
		Declare @Pesagem_Value Varchar(50)

	Set @Pesagem_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like 'Pesagem%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Pesagem_Value=replace(@Pesagem_Value,',','.')
	
		
	--Declare @CPMF_Value Varchar(50)
	--Set @CPMF_Value=cast((
	--				select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
	--				Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
	--				Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
	--				where nome_tp_Tx like 'CPMF%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
	--									) as varchar(50))
	--set @CPMF_Value=replace(@CPMF_Value,',','.')
	
	Declare @Agency1Fee1Value Varchar(50)
	Set @Agency1Fee1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like 'Agency%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Agency1Fee1Value=replace(@Agency1Fee1Value,',','.')
	
		Declare @Intervenciones1INAL_Value Varchar(50)

	Set @Intervenciones1INAL_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like '% INAL %' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Intervenciones1INAL_Value=replace(@Intervenciones1INAL_Value,',','.')
	
		Declare @Intervenciones1SENAZA_Value Varchar(50)

	Set @Intervenciones1SENAZA_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like '% SENAZA %' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Intervenciones1SENAZA_Value=replace(@Intervenciones1SENAZA_Value,',','.')
	
	Declare @AntiDumping1Value Varchar(50)

	Set @AntiDumping1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like '%Antidumping%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @AntiDumping1Value=replace(@AntiDumping1Value,',','.')
--Incluido por Rafael Lindenberg - FIM

	Declare @Redex_Value Varchar(50)

	Set @Redex_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where nome_tp_Tx like 'Redex%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Redex_Value=replace(@Redex_Value,',','.')


	Declare @Import1License_Value varchar(50)

	Set @Import1License_Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
					where nome_tp_Tx like 'LI %' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @Import1License_Value=replace(@Import1License_Value,',','.')
	
	Declare @Term1Payment1Code Varchar(10)
	
	set @Term1Payment1Code =(select top 1 payment from pedido PD with(nolock)  join pedido_ship PS with(nolock) on PS.cd_pedido=PD.cd_pedido where num_proc=@Num_Proc)
	
	Declare @AFRMM1Value varchar(40)
	
	If left(@Num_Proc,2)='IM'
		Begin
	
			Set @AFRMM1Value=cast((
							select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
							Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
							Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
							where nome_tp_Tx like 'AFRMM%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
												) as varchar(50))
			set @AFRMM1Value=replace(@AFRMM1Value,',','.')
	
		End	
	Declare @ICMS_Value Varchar(50)
	Declare @Cofins_Value Varchar(50)
	Declare @Import1Duty1Value Varchar(50)
	Declare @Insurance1Value Varchar(50)
	
	If left(@Num_Proc,1)='I'
		Begin
		
			Set @Insurance1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like '%Seguro%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
			set @Insurance1Value=replace(@Insurance1Value,',','.')
			
			Set @Import1Duty1Value =cast((
							select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
							Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
							Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
							where nome_tp_Tx like '%Imposto de Importaç%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
												) as varchar(50))
			set @Import1Duty1Value =replace(@Import1Duty1Value,',','.')
			
			Set @ICMS_Value=cast((
							select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
							Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
							Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
							where nome_tp_Tx like 'ICMS%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
												) as varchar(50))
			set @ICMS_Value=replace(@ICMS_Value,',','.')

			Set @Cofins_Value=cast((
							select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
							Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
							Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
							where nome_tp_Tx like 'Cofins%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
												) as varchar(50))
			
			set @Cofins_Value=replace(@Cofins_Value,',','.')

		End	
		
	If left(@Num_Proc,1)='E'	
		Begin
			set @Insurance1Value =(select top 1 vlr_seguro from invoice_cliente with(nolock) 
			where num_proc = @Num_Proc and left(@Num_Proc,1) = 'E'
			order by id_inv desc)
			
			if 	@Insurance1Value is null
				begin		
					Set @Insurance1Value=cast((
					select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
					Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
					Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
					where nome_tp_Tx like '%Seguro%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
					set @Insurance1Value=replace(@Insurance1Value,',','.')
				End
		End
		

--Manufacturer Cadu 10/06/2015
Declare @Manufacturer Varchar(50)
Set @Manufacturer=(select top 1 nome_raz_Soc from pedido_Det PD with(nolock)
						join pedido_ship PS with(nolock)on PS.cd_pedido=PD.cd_pedido and PS.cd_produto=PD.cd_produto and PS.lote=pd.lote and PS.item=PD.item
						join pedido_det_complementar PDC with(nolock)  on PDC.cd_pedido=PD.cd_pedido and PDC.cd_produto=PD.cd_produto and PDC.lote=PD.lote and PDC.item=PD.item
						Join produto_Cliente PC with(nolock) on PC.cd_prod=PD.cd_produto
						join Pessoa P with(nolock) on P.Cd_Pes = PDC.cd_pes_fabricante
					where 
						PS.Num_Proc=@Num_Proc and cd_proc_cliente=@cd_Prod
				)
			
--Country1Manufacturer
	Declare @Country1Manufacturer varchar(50)
	Set @Country1Manufacturer = (select top 1 Nome_Pais from pedido_Det PD with(nolock)
									join pedido_ship PS with(nolock)on PS.cd_pedido=PD.cd_pedido and PS.cd_produto=PD.cd_produto and PS.lote=pd.lote and PS.item=PD.item
									join pedido_det_complementar PDC with(nolock)  on PDC.cd_pedido=PD.cd_pedido and PDC.cd_produto=PD.cd_produto and PDC.lote=PD.lote and PDC.item=PD.item
									Join produto_Cliente PC with(nolock) on PC.cd_prod=PD.cd_produto
									join Pais P with(nolock) on P.Cd_Pais = PDC.cd_pais_fabricante
								where 
									PS.Num_Proc=@Num_Proc and cd_proc_cliente=@cd_Prod
								)
								
--Campos que eram direto no Report Manager - agora sao feitos aqui
--FOB USD
--Update dados_por_produto
--	Set [FOB - USD]=CAST(([FOB Value])/[Exchange Rates Value] as decimal(10,2))
--where ([FOB - USD] is null or CAST(([FOB Value])/[Exchange Rates Value] as decimal(10,2)) <> [FOB - USD])
--	and left([BDP REF.],1)='I'
--	and [BDP System Code]='ATLBR' and [Exchange Rates Value] <> 0

--Freight - USD
--Update dados_por_produto
--	Set [Freight - USD]=CAST(([Freight Value])/[Exchange Rates Value] as decimal(10,2))

--where ([FOB - USD] is null or CAST(([Freight Value])/[Exchange Rates Value] as decimal(10,2)) <> [Freight Value])
--	and left([BDP REF.],1)='I'
--	and [BDP System Code]='ATLBR' and [Exchange Rates Value] <> 0

--[CFR - USD]
--Update dados_por_produto
--	Set [CFR - USD]=[FOB - USD]+[Freight - USD]

--where (ISNULL([CFR - USD],0)<> [FOB - USD]+[Freight - USD])
--	and left([BDP REF.],1)='I'
--	and [BDP System Code]='ATLBR' and [Exchange Rates Value] <> 0

Declare @ExchangeRatesValue	as Decimal(18,4)
Declare @FOB1Invoice as Decimal(18,2)
Declare @Freight1Invoice as Decimal(18,2)
Declare @CFR1Invoice as Decimal(18,2)


if LEFT(@Num_Proc,1) = 'I' and RIGHT(@Num_Proc,2) = 'BR'
	BEGIN
		Set @ExchangeRatesValue=(select 
			(case when campo_dados is null or campo_dados = '' then 0 
				else		
			cast(campo_dados as decimal(18,4)) end) Paridade 
			from campo_processo with(nolock) where id_campo=31 and num_proc=@Num_Proc)
		
		if @ExchangeRatesValue <> 0	
			Begin
				Set @FOB1Invoice = CAST((@FOB) /@ExchangeRatesValue as decimal(10,2))
				Set @Freight1Invoice = CAST((@Freight1Value) /@ExchangeRatesValue as decimal(10,2))
				Set @CFR1Invoice = @FOB1Invoice + @Freight1Invoice
			End				

	END	
	
--Declare @FOB_USD as Decimal(18,2)
--Declare @Freight_USD as Decimal(18,2)
--Declare @CFR_USD as Decimal(18,2)
--if LEFT(@Num_Proc,1) = 'I' and RIGHT(@Num_Proc,2) = 'BR'
--	BEGIN
--		Set @ExchangeRatesValue=(select 
--			(case when campo_dados is null or campo_dados = '' then 0 
--				else		
--			cast(campo_dados as decimal(18,4)) end) Paridade 
--			from campo_processo with(nolock) where id_campo=31 and num_proc=@Num_Proc)
		
--		if @ExchangeRatesValue <> 0	
--			Begin
--				Set @FOB_USD = CAST((@FOB) /@ExchangeRatesValue as decimal(10,2))
--				Set @Freight_USD = CAST((@Freight1Value) /@ExchangeRatesValue as decimal(10,2))
--				Set @CFR_USD = @FOB_USD + @Freight_USD
--			End
--	END

Declare @ExchangeRatesUSDValue	as Decimal(18,4)
Declare @FOB_USD as Decimal(18,2)
Declare @Freight_USD as Decimal(18,2)
Declare @CFR_USD as Decimal(18,2)
Declare @CFR_Value as Decimal(18,2)

--176	10017	F	Paridade Dolar D.I.
if LEFT(@Num_Proc,1) = 'I' and RIGHT(@Num_Proc,2) = 'BR'
	BEGIN
		Set @ExchangeRatesUSDValue=(select 
			(case when campo_dados is null or campo_dados = '' then 0 
				else		
			cast(campo_dados as decimal(18,4)) end) Paridade 
			from campo_processo with(nolock) where id_campo=176 and num_proc=@Num_Proc)
		
		if @ExchangeRatesUSDValue <> 0	
			Begin
				Set @FOB_USD = CAST((@FOB) /@ExchangeRatesUSDValue as decimal(10,2))
				Set @Freight_USD = CAST((@Freight1Value) /@ExchangeRatesUSDValue as decimal(10,2))
				Set @CFR_USD = @FOB_USD + @Freight_USD
			End				

		
		set @CFR_Value =(isnull(cast(@FOB as Decimal(18,2)),0) 
					+ isnull(cast(@Freight1Value as Decimal(18,2)),0) --
					)
	END
	
--[Weighing] - Cadu - nao estava incluindo este campo - 9/11/2016
Declare @Weighing Varchar(50)	
	set @Weighing=replace(@Pesagem_Value,',','.')

Declare @TP_Despesas1Acessorias_Value as Decimal(18,2)
	set @TP_Despesas1Acessorias_Value = 
		Isnull(cast(@Container1Cleaning1value as Decimal(18,2)),0)+
		Isnull(cast(@DocumentDelivery_Value as Decimal(18,2)),0)+ 
		Isnull(cast(@Desconsolidation1Value as Decimal(18,2)),0)+
		Isnull(cast(@BL1Fee1Value as Decimal(18,2)),0)+
		isnull(cast(@Courier_Value as Decimal(18,2)),0)+
		isnull(cast(@Weighing as Decimal(18,2)),0)+
		isnull(cast(@Warehousing1Value as Decimal(18,2)),0)+
		isnull(cast(@Demurrage1Value as Decimal(18,2)),0)
	
Declare @CustomsClearanceDate Datetime
Set @CustomsClearanceDate=(select top 1 dt_conclusao from Tarefas_Processos with (nolock) 
	where num_proc=@Num_PRoc and id_task=4 and dt_conclusao is not null)
					
--[ICMS Base]
--update dados_por_produto
--	SEt [ICMS Base]=(
--				[FOB Value] +[Freight Value] + [Insurance Value] + [TP - Despesas Calc ICMS - Value]+ 
--				[Import Duty Value] + [IPI - Value] + [Siscomex Value] + [PIS - Value]  + [Cofins - Value] 
--				+ [AFRMM Value] + [AntiDumping Value]
--				 )  /(1-([% ICMS]/100))
--Where 	
--	[BDP System Code]='ATLBR'
--	and left([BDP Ref.],1)='I'
--	and 
--	[ICMS Base]<>
--	(
--		(
--				[FOB Value] +[Freight Value] + [Insurance Value] + [TP - Despesas Calc ICMS - Value]+ 
--				[Import Duty Value] + [IPI - Value] + [Siscomex Value] + [PIS - Value]  + [Cofins - Value] 
--				+ [AFRMM Value] + [AntiDumping Value]
--				 )  /(1-([% ICMS]/100))
--	) and [Customs Clearance Date] >'2014-01-01'
Declare @ICMS1Base as Decimal(18,2)
if LEFT(@Num_Proc,1) = 'I' and RIGHT(@Num_Proc,2) = 'BR' and @CustomsClearanceDate >'2014-01-01' 
	set @ICMS1Base =(isnull(cast(@FOB as Decimal(18,2)),0) --
					+ isnull(cast(@Freight1Value as Decimal(18,2)),0) --
					+ isnull(cast(@Insurance1Value as Decimal(18,2)),0) --
					+ isnull(cast(@TP_Despesas1Calc1ICMS_Value as Decimal(18,2)),0) --
					+ isnull(cast(@Import1Duty1Value as Decimal(18,2)),0) 
					+ isnull(cast(@IPI_Value as Decimal(18,2)),0) 
					+ isnull(cast(@Siscomex1Value as Decimal(18,2)),0) 
					+ isnull(cast(@PIS_Value as Decimal(18,2)),0) --
					+ isnull(cast(@Cofins_Value as Decimal(18,2)),0) 
					+ isnull(cast(@AFRMM1Value as Decimal(18,2)),0) --
					+ isnull(cast(@AntiDumping1Value as Decimal(18,2)),0)) 	--				
					/(1-(@ALIQ_ICMS/100))
				 
	
--update dados_por_produto
--	SEt [ICMS Base]=(
--				[FOB Value] +[Freight Value] + [Insurance Value] + [TP - Despesas Calc ICMS - Value]+ 
--				[Import Duty Value] + [IPI - Value] + [Siscomex Value] + [PIS - Value]  + [Cofins - Value]
--				 )  /(1-([% ICMS]/100))
--Where 	
--	[BDP System Code]='ATLBR'
--	and left([BDP Ref.],1)='I'
--	and 
--	[ICMS Base]<>
--	(
--		(
--				[FOB Value] +[Freight Value] + [Insurance Value] + [TP - Despesas Calc ICMS - Value]+ 
--				[Import Duty Value] + [IPI - Value] + [Siscomex Value] + [PIS - Value]  + [Cofins - Value]
--				 )  /(1-([% ICMS]/100))
--	)  and [Customs Clearance Date] <= '2014-01-01'			 
				 
if LEFT(@Num_Proc,1) = 'I' and RIGHT(@Num_Proc,2) = 'BR' and @CustomsClearanceDate <='2014-01-01' 
		set @ICMS1Base =(isnull(cast(@FOB as Decimal(18,2)),0) 
					+ isnull(cast(@Freight1Value as Decimal(18,2)),0) 
					+ isnull(cast(@Insurance1Value as Decimal(18,2)),0) 
					+ isnull(cast(@TP_Despesas1Calc1ICMS_Value as Decimal(18,2)),0) 
					+ isnull(cast(@Import1Duty1Value as Decimal(18,2)),0) 
					+ isnull(cast(@IPI_Value as Decimal(18,2)),0) 
					+ isnull(cast(@Siscomex1Value as Decimal(18,2)),0) 
					+ isnull(cast(@PIS_Value as Decimal(18,2)),0) 
					+ isnull(cast(@Cofins_Value as Decimal(18,2)),0))	
					/(1-(@ALIQ_ICMS/100))
				 
--[CIF Value]			 
--update dados_por_produto
--		Set [CIF Value] = [FOB Value]+[Insurance Value]+[Freight Value]
--	where 
--		[BDP System Code]='ATLBR' 
--		and left([BDP Ref.],1)='I'
--	and 
--		isnull([CIF Value],0) <> ([FOB Value]+[Insurance Value]+[Freight Value])
Declare @CIF1Value as Decimal(18,2)
if LEFT(@Num_Proc,1) = 'I' and RIGHT(@Num_Proc,2) = 'BR'
	set @CIF1Value = (isnull(cast(@FOB as Decimal(18,2)),0) 
			+ isnull(cast(@Freight1Value as Decimal(18,2)),0) 
			+ isnull(cast(@Insurance1Value as Decimal(18,2)),0))
		
Declare @Delivery1Note varchar(100)	
select @Delivery1Note=COALESCE(@Delivery1Note +'-','')+lote from pedido_ship PS With(nolock) 
Join Produto_Cliente PC With(nolock) on PC.cd_prod=ps.cd_produto 
where num_proc=@Num_Proc and PC.cd_proc_cliente=@cd_Prod



--cadu LI Penalty - Value - 100-101108- 9/1/2018 - MULTA LI 2 - CHB e MULTA LI 1 - CHB
Declare @LI1Penalty_Value Varchar(50)
Set @LI1Penalty_Value=cast((
				select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
				Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
				Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
				where nome_tp_Tx like 'MULTA LI%CHB%' 
				and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
				) as varchar(50))
set @LI1Penalty_Value=replace(@LI1Penalty_Value,',','.')

--[ICMS Penalty - Value] - MULTA ICMS 1 - CHB
Declare @ICMS1Penalty_Value Varchar(50)
Set @ICMS1Penalty_Value=cast((
				select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
				Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
				Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
				where nome_tp_Tx like 'MULTA ICMS%CHB%'  
				and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
				) as varchar(50))
set @ICMS1Penalty_Value=replace(@ICMS1Penalty_Value,',','.')

--[Over 1% PIS BULK - Value] - ACRESCIMO 1% PIS GRANEL 1 - CHB 
Declare @Over1A4P01PIS1BULK_Value Varchar(50)
Set @Over1A4P01PIS1BULK_Value=cast((
				select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
				Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
				Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
				where nome_tp_Tx like 'ACRESCIMO 1%PIS%GRANEL%'  
				and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
				) as varchar(50))
set @Over1A4P01PIS1BULK_Value=replace(@Over1A4P01PIS1BULK_Value,',','.')

--[Over 1% COFINS BULK - Value] - ACRESCIMO 1% COFINS GRANEL 1 - CHB"
Declare @Over1A4P01COFINS1BULK_Value Varchar(50)
Set @Over1A4P01COFINS1BULK_Value=cast((
				select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
				Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
				Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
				where nome_tp_Tx like 'ACRESCIMO 1%COFINS%GRANEL%' 
				and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
				) as varchar(50))
set @Over1A4P01COFINS1BULK_Value=replace(@Over1A4P01COFINS1BULK_Value,',','.')

--[Over 1% II BULK - Value]- ACRESCIMO 1% II GRANEL 1 - CHB
Declare @Over1A4P01II1BULK_Value Varchar(50)
Set @Over1A4P01II1BULK_Value=cast((
				select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
				Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
				Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
				where nome_tp_Tx like 'ACRESCIMO 1%II%GRANEL%' 
				and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
				) as varchar(50))
set @Over1A4P01II1BULK_Value=replace(@Over1A4P01II1BULK_Value,',','.')

--[Penalty 1% CIF - Value] - "MULTA 1% CIF 1 - CHB"
Declare @Penalty1A4P01CIF_Value Varchar(50)
Set @Penalty1A4P01CIF_Value=cast((
				select sum(vlr_item_Custo) from Custo_Cliente C with(nolock)
				Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx
				Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto
				where nome_tp_Tx like 'MULTA 1% CIF%CHB'
				and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
				) as varchar(50))
set @Penalty1A4P01CIF_Value=replace(@Penalty1A4P01CIF_Value,',','.')
Declare @Plant1ID varchar(50)
set @Plant1ID = (select top 1
(case when substring(PS.Num_Proc,1,1) = 'E' then PP.cd_planta else 
			ISNULL(cast(Planta as varchar(50)),cast(CS.CD_PLANTA as varchar(50)))End)  
			From
				Pedido_Ship PS With(nolock)
				Join Pedido_Det PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and PDD.cd_produto=PS.cd_produto and PDD.item=ps.item and pdd.lote=ps.lote
				Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto
				Left Join Pedido PD With(nolock) on PD.cd_pedido=PS.cd_pedido
				LEft Join Pessoa_LLP PP With(nolock) on pp.cd_pes=cd_seller
				LEft Join Pessoa_LLP CS With(nolock) on CS.cd_pes=CD_BUYER
			Where
				ps.num_proc= @Num_Proc and PC.cd_Proc_Cliente = @Cd_Prod)
				
--Agreement
	Declare @Agreement varchar(200)
	Set @Agreement = (select top 1 p.NOME_TP_AC from pedido_Det PD with(nolock)
						join pedido_ship PS with(nolock)on PS.cd_pedido=PD.cd_pedido and PS.cd_produto=PD.cd_produto and PS.lote=pd.lote and PS.item=PD.item
						join pedido_det_complementar PDC with(nolock)  on PDC.cd_pedido=PD.cd_pedido and PDC.cd_produto=PD.cd_produto and PDC.lote=PD.lote and PDC.item=PD.item
						Join produto_Cliente PC with(nolock) on PC.cd_prod=PD.cd_produto
						join Tipo_Acordo_Comercial P with(nolock) on p.ID_TP_AC = PDC.ID_TP_AC
								where 
									PS.Num_Proc=@Num_Proc and cd_proc_cliente=@cd_Prod
								)
								
--100-158821								
--GR Original - Date @GR1Original_Date PD.DL_Chegada
Declare @GR1Original_Date DateTime							
set @GR1Original_Date =(select top 1 PD.DL_Chegada from pedido PD with(nolock)  
		join pedido_ship PS with(nolock) on PS.cd_pedido=PD.cd_pedido where num_proc=@Num_Proc)								

-- Antonio 17-11-2022 - Ticket 100-360110 -------------
-- Valor SOP 
	Set @SOP1Value=cast((
	select sum(vlr_item_Custo) from Custo_Cliente C with(nolock) 
	Join Tipo_Taxa TT with(nolock)  on TT.cd_tp_tx=c.cd_tp_Tx 
	Join Produto_Cliente CC with(nolock)  on CC.cd_prod=cd_produto 
	where nome_tp_Tx like 'SOP 1 - CHB%' and num_proc=@num_proc and cd_proc_cliente=@cd_Prod
										) as varchar(50))
	set @SOP1Value=replace(@SOP1Value,',','.')
-- fim - Ticket 100-360110 -------------


-- XXXXXXXXX Ticket#200-16884 
Declare @Dangerous1Goods varchar(3)
set @Dangerous1Goods = (select top 1(case when
	(
		(PP.cd_prod is Not null and PP.Uncode <> 'NH') 
			or 
		CP.Campo_Dados = 1
	)  then  'YES' else 'NO' End)
From vwCliente C    
    left join  Pedido_Ship PS With(nolock) on C.num_proc = PS.Num_Proc    
    left Join Pedido_Det PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and PDD.cd_produto=PS.cd_produto and PDD.item=ps.item and pdd.lote=ps.lote    
    left Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto    
    left join Produto_Perigoso PP with(nolock) on PC.cd_prod = PP.cd_prod    
    left join Campo_Processo CP with(nolock) on CP.Num_Proc = @Num_Proc and Id_Campo = '185'    
 Where C.num_proc= @Num_Proc and PC.cd_proc_cliente=@cd_Prod)  

 if	(@Dangerous1Goods is null or @Dangerous1Goods = '')
	 set @Dangerous1Goods = 
		(select (case Campo_Dados when '1' then 'YES' when '2' then 'NO' end) 
		from Campo_Processo  where id_campo = '185' and num_proc=@Num_Proc)
 
----XXXXXXXXX

Select 
	@QtyKG Qty1KG,@UnitPrice Unit1Price, @Seal_Value Seal_Value, @NFE1Issue1Cost_Value NFE1Issue1Cost_Value, 
	@COO_Value COO_Value, @DocumentDelivery_Value Document1Delivery_Value, @Courier_Value Courier_Value, 
	isnull(@THC1Value,'0.00') THC1Value, isnull(@Unloaded1Value,'0.00') Unloaded1Value, 
	@CFOP CFOP,	isnull(@Desconsolidation1Value,'0.00') Desconsolidation1Value, isnull(@ISPS1Value,'0.00') ISPS1Value, 
	isnull(@Customs1Brokerage1Value,'0.00') Customs1Brokerage1Value, isnull(@Inland1Freight1Value,'0.00') Inland1Freight1Value, 
	isnull(@Insurance1Value,'0.00') Insurance1Value, isnull(@BL1Fee1Value,'0.00') BL1Fee1Value, isnull(@Container1Cleaning1Value,'0.00') Container1Cleaning1Value,
	isnull(@Demurrage1Value,'0.00') Demurrage1Value, isnull(@PIS_Value,'0.00') PIS_Value, isnull(@Posicionamento_Value,'0.00') Posicionamento_Value, isnull(@Pesagem_Value,'0.00') Pesagem_Value,
	isnull(@Agency1Fee1Value,'0.00') Agency1Fee1Value, isnull(@Intervenciones1INAL_Value,'0.00') Intervenciones1INAL_Value, 
	isnull(@Intervenciones1SENAZA_Value,'0.00') Intervenciones1SENAZA_Value, isnull(@AntiDumping1Value,'0.00') AntiDumping1Value, 
	--@ICMSBase ICMS1Base, 
	isnull(@TUP_Value,'0.00') TUP_Value, 
	--- Antonio 17-11-2022  -  ticket 100-360110----------------------------------------------------------------  
	--isnull(@SDA_Value,'0.00') SDA1Value,
	-------------------------------- fim ticket 100-360110------------------------------------------------------
	@Import1License_Value Import1License_Value, 
	@Term1Payment1Code Term1Payment1Code, isnull(@TP_Despesas1Calc1ICMS_Value,'0.00') TP_Despesas1Calc1ICMS_Value, 
	@NCM NCM, ISnull(@AFRMM1Value,'0.00') AFRMM1Value, isnull(@ICMS_Value,'0.00') ICMS_Value, Isnull(@Cofins_Value,'0.00') Cofins_Value, 
	isnull(@Import1Duty1Value,'0.00') Import1Duty1Value, isnull(@Warehousing1Value,'0.00') Warehousing1Value,isnull(@Siscomex1Value,'0.00') Siscomex1Value,
	@Gross1Weight_NF Gross1Weight_NF, replace(@Product1Value,',','.') Product1Value,
	@NCM1PO NCM1PO, isnull(@IPI_Value,'0.00') IPI_Value, @Manufacturer Manufacturer, @Country1Manufacturer Country1Manufacturer

	,replace(@TP_Despesas1Acessorias_Value,',','.') TP_Despesas1Acessorias_Value
	,replace(@Weighing,',','.') Weighing
	,replace(@ICMS1Base,',','.') ICMS1Base
	,replace(@CIF1Value,',','.') CIF1Value
	,replace(@ALIQ_II,',','.') [P01II],
	replace( @ALIQ_ICMS ,',','.') [P01ICMS],
	replace( @ALIQ_IPI ,',','.') [P01IPI],
	replace( @ALIQ_PIS ,',','.') [P01PIS],
	replace( @ALIQ_Cofins ,',','.') [P01Cofins],
	@Delivery1Note Delivery1Note, --Incluido por Erbson 2017-05-05
	@UOM UOM,
	replace(@Qty,',','.') QTY,
	@Reponsible1PO Reponsible1PO,
	@Business1Name Business1Name,
	@Value1Center Value1Center,
	@Product1Description Product1Description,
	replace(@Net1Weight1KG,',','.') Net1Weight1KG,
	replace(@Gross1Weight1KG,',','.') Gross1Weight1KG,
	@Order1Type Order1Type,
	@Plant1ID Plant1ID,
	@PO1Group PO1Group,
	@Business1Group Business1Group,
	
	@LI1Penalty_Value LI1Penalty_Value,-- cadu 10/01/2018
	@ICMS1Penalty_Value ICMS1Penalty_Value,-- cadu 10/01/2018	
	@Over1A4P01PIS1BULK_Value [Over1A4P01PIS1BULK_Value],-- cadu 10/01/2018
	@Over1A4P01COFINS1BULK_Value [Over1A4P01COFINS1BULK_Value],-- cadu 10/01/2018
	@Over1A4P01II1BULK_Value [Over1A4P01II1BULK_Value],-- cadu 10/01/2018
	@Penalty1A4P01CIF_Value [Penalty1A4P01CIF_Value]-- cadu 10/01/2018
	
	
	--,replace(@FOB1Invoice,',','.') FOB_Invoice --FOB_USD [FOB - Invoice]
	--replace(@FOB,',','.') FOB1Value,
	,(case when left(@Num_Proc,1) = 'I' THEN replace(@FOB1Invoice,',','.') ELSE replace(@FOB,',','.') END)FOB_Invoice -- [FOB - Invoice]
	,replace(@Freight1Invoice,',','.') Freight_Invoice --Freight_USD [Freight - Invoice]
	,replace(@CFR1Invoice,',','.') CFR_Invoice --CFR_USD [CFR -Invoice]		
	
	,replace(@FOB_USD,',','.') FOB_USD --[FOB - USD]
	,replace(@Freight_USD,',','.') Freight_USD --[Freight - USD]
	,replace(@CFR_USD,',','.') CFR_USD --[CFR - USD]	
	
	,(case when left(@Num_Proc,1) = 'I' THEN replace(@FOB,',','.') ELSE '0.00' END) FOB_BRL -- FOB - BRL
	--,replace(@FOB,',','.') FOB_BRL -- FOB - BRL
	
	,@Freight1Value FREIGHT_BRL --[FREIGHT - BRL]
	--@Freight1Value Freight1Value,
	
	,replace(@CFR_Value,',','.')CFR_BRL -- cadu 11/04/2018-- [CFR - BRL]
	,@Agreement Agreement
	,@GR1Original_Date GR1Original_Date --  GR Original - Date @GR1Original_Date PD.DL_Chegada
	--- Antonio 17-11-2022  -  ticket 100-360110 -  [SDA Value] -- [SOP Value]
	,isnull(@SOP1Value,'0.00') SOP1Value

	,@Dangerous1Goods Dangerous1Goods

	--set @SOP1Value=replace(@SOP1Value,',','.')

	-------------------------------- fim ticket 100-360110------------------------------------------------------

	

GO
