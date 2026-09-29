SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNF_Import_Rateio_AFRMM_ITEM_Rel] --[spNF_Import_Rateio_AFRMM_ITEM_Rel]'IMSWB202110094BR'
	@Num_Proc varchar(16)
as
--Itens 
SET NOCOUNT ON
declare @PBruto	        decimal(18,3),  
        @PLiq           decimal(18,3),  	
        @Quantidade     decimal(18,3), 	
        @PrecoUnit      decimal(18,3), 	
        @MLE            decimal(18,3),  	
        @Frete	        decimal(18,3),
        @Seguro	        decimal(18,3),    
        @Acrescimos     decimal(18,3), 	
        @Siscomex	    decimal(18,3),  
        @AFRMM	        decimal(18,3),  
        @THC            decimal(18,3),	
        @THD            decimal(18,3),	
        @VlrII	        decimal(18,3), 
        @VlrICMS	    decimal(18,3),
        @VlrIPI	        decimal(18,3),
        @VlrCofins	    decimal(18,3),  
        @VlrPIS	        decimal(18,3),
		@BasePIS	    decimal(18,3), 
		@BaseCofins	    decimal(18,3), 
        @BaseICMS	    decimal(18,3),
        @BaseIPI	    decimal(18,3),
        @BaseII	        decimal(18,3),
		@ValorTotalNF   decimal(18,3),
		@VlrTotAFRMM_CC decimal(18,3),  
		@PercCalcAFRMM  decimal(18,14), 
		@PesoBrutoTotal decimal(18,3)    

DECLARE @Nota_Fiscal_Item TABLE 
(
[Item]	            varchar(20),
[Cod. Prod.]	    varchar(20),    
[Produto]	        varchar(500), 
[P.Bruto]	        decimal(18,3),  
[P. Liq.]           decimal(18,3),  	
[Delivery Note]     varchar(2),  	
[Quantidade]        decimal(18,3), 	
[Preco Unit]        decimal(18,3), 	
[MLE]               decimal(18,3),  	
[Frete]	            decimal(18,3),
[Seguro]	        decimal(18,3),    
[Acrescimos]        decimal(18,3), 	
[Siscomex]	        decimal(18,3),  
[AFRMM]	            decimal(18,3),  
[THC]               decimal(18,3),	
[THD]               decimal(18,3),	
[% II]	            decimal(18,3),
[% ICMS]	        decimal(18,3),
[% IPI]             decimal(18,3),
[% Cofins]	        decimal(18,3),
[% PIS]             decimal(18,3),
[Vlr II]	        decimal(18,3), 
[Vlr ICMS]	        decimal(18,3),
[Vlr IPI]	        decimal(18,3),
[Vlr Cofins]	    decimal(18,3),  
[Vlr PIS]	        decimal(18,3),
[Base PIS]	        decimal(18,3), 
[Base Cofins]	    decimal(18,3), 
[Base ICMS]	        decimal(18,3),
[Base IPI]	        decimal(18,3),
[Base II]	        decimal(18,3),
[Valor Total NF]    decimal(18,3)
)
---produtos
insert into @Nota_Fiscal_Item 
(
	[Item]	        ,
	[Cod. Prod.]	,    
	[Produto]	    , 
	[P.Bruto]	    ,  
	[P. Liq.]       ,  	
	[Delivery Note] ,  	
	[Quantidade]    , 	
	[Preco Unit]    , 	
	[MLE]           ,  	
	[Frete]	        ,
	[Seguro]	    ,    
	[Acrescimos]    , 	
	[Siscomex]	    ,  
	[AFRMM]	        ,  
	[THC]           ,	
	[THD]           ,	
	[% II]	        ,
	[% ICMS]	    ,
	[% IPI]         ,
	[% Cofins]	    ,
	[% PIS]         ,
	[Vlr II]	    , 
	[Vlr ICMS]	    ,
	[Vlr IPI]	    ,
	[Vlr Cofins]	,  
	[Vlr PIS]	    ,
	[Base PIS]	    , 
	[Base Cofins]	, 
	[Base ICMS]	    ,
	[Base IPI]	    ,
	[Base II]	    ,
	[Valor Total NF]
	)
			select 
			NFD.ID_Item                                                    [Item],
			PC.cd_Proc_Cliente	                                           [Codigo Do Produto],
			PC.Produto_Descr                                               [Produto], 
			CONVERT(varchar(20),CAST(NFD.Peso_Bruto as Decimal(18,3)))     [Peso Bruto],
			CONVERT(varchar(20),CAST(NFD.Peso_Liquido as Decimal(18,3)))   [Peso Liqueido],
			ps.Lote										                   [Delivery Note],
			CONVERT(varchar(20),CAST(NFD.Quantidade as Decimal(18,6)))     [Quantidade],
			CONVERT(varchar(20),CAST(NFD.Vlr_Item as Decimal(18,6)))       [Preco Unitario],
			CONVERT(varchar(20),CAST(NFD.Vlr_Total_Item as Decimal(18,6))) [MLE],
			CONVERT(varchar(20),CAST(NFD.Vlr_Frete as Decimal(18,6)))      [Frete],
			CONVERT(varchar(20),CAST(NFD.Vlr_Seguro as Decimal(18,6)))     [Seguro],
			CONVERT(varchar(20),CAST(NFD.ACRESCIMOS as Decimal(18,6)))     [Acrescimos],
			CONVERT(varchar(20),CAST(NFD.Vlr_Siscomex as Decimal(18,6)))   [SISCOMEX],

			CONVERT(varchar(30),CAST(0 as Decimal(18,2)))                  [AFRMM],

			CONVERT(varchar(30),CAST(dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%THC - CHB%')
			as Decimal(18,2)))                                             [THC],
	
			CONVERT(varchar(30),CAST(dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%THD 1 - CHB%')
			as Decimal(18,2)))                                             [THD],

			CONVERT(varchar(30),CAST(NFD.ALIQ_II as Decimal(18,2)))        [Percentual II],
			CONVERT(varchar(30),CAST(NFD.ALIQ_ICMS as Decimal(18,2)))      [Percentual ICMS],
			CONVERT(varchar(30),CAST(NFD.ALIQ_IPI as Decimal(18,2)))       [Percentual IPI],
			CONVERT(varchar(30),CAST(NFD.VL_ALIQ_COFINS as Decimal(18,2))) [Percentual Cofins],
			CONVERT(varchar(30),CAST(NFD.VL_ALIQ_PIS as Decimal(18,2)))    [Percentual PIS],

			CONVERT(varchar(30),CAST(NFD.VL_II as Decimal(18,2)))          [Valor II],
			CONVERT(varchar(30),CAST(NFD.VL_ICMS as Decimal(18,2)))        [Valor ICMS],
			CONVERT(varchar(30),CAST(NFD.VL_IPI as Decimal(18,2)))         [Valor IPI],
			CONVERT(varchar(30),CAST(NFD.VL_IMPOSTO_COFINS as Decimal(18,2))) 
																		   [Valor COFINS],
			CONVERT(varchar(30),CAST(NFD.VL_IMPOSTO_PIS as Decimal(18,2))) 
																		   [Valor PIS],

			CONVERT(varchar(30),CAST(NFD.VL_BASE_PIS as Decimal(18,2)))    [Base PIS],
			CONVERT(varchar(30),CAST(NFD.VL_BASE_COFINS as Decimal(18,2))) [Base Cofins],
			CONVERT(varchar(30),CAST(NFD.VL_BASE_ICMS as Decimal(18,2)))   [Base ICMS],
			CONVERT(varchar(30),CAST(NFD.VL_BASE_IPI as Decimal(18,2)))    [Base IPI],
			CONVERT(varchar(30),CAST(NFD.VL_BASE_II as Decimal(18,2)))     [Base II],

			CONVERT(varchar(30),CAST(NFD.VL_BASE_ICMS as Decimal(18,2)))   [Valor Total NF]
		from vwhouse_imp HOU					with(nolock)
		Left join localidade LO					with(nolock) on HOU.Cd_Org = LO.Cd_Local
		Left join localidade LD					with(nolock) on HOU.Cd_Dst = LD.Cd_Local		
		join Pedido_Ship PS				with(nolock) on HOU.num_proc = PS.Num_Proc
		join Nota_Cliente NC				with(nolock) on HOU.num_proc = NC.Num_Proc --Ticket 100-447748 --Join incluido --Leandro 11/04/2024
		join Nota_Fiscal_Cliente_Det NFD	with(nolock) on PS.cd_produto = NFD.Cd_Produto and PS.cd_pedido = NFD.Cd_Pedido and NFD.ID_NF = NC.ID_NF and nfd.Cd_Cliente = nc.CD_Cliente --Ticket 100-447748 --incluido id_nf e cd_cliente --Leandro 11/04/2024
		join Produto_Cliente PC			with(nolock) on nfd.cd_produto = PC.cd_prod 
		Left join Campo_Processo CP				with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '25' 
		Left join Localidade LCP				with(nolock) on CP.Campo_Dados = LCP.Cd_Local
		Left Join Tarefas_Processos TP4			with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = '4'
		Left Join Pessoa P						with(nolock) on HOU.Cd_Consig = P.Cd_Pes
		Left Join Pessoa_LLP PL					with(nolock) on HOU.Cd_export = PL.Cd_Pes
		Left join Campo_Processo CP31			with(nolock) on HOU.Num_Proc = CP31.Num_Proc and CP31.Id_Campo = '31'
		where	
			HOU.Num_Proc = @Num_Proc
			and TP4.Dt_Conclusao is not null
			order by NFD.ID_Item 


/*
		montar o Rateio do AFRMM
		1 - pegar na aba do conta corrente o valor total pago de AFRMM  -> (@VlrTotAFRMM_CC)
		2 - pegar o total acumulado no campo  [Peso Bruto Total]  - >  @PesoBrutoTotal
		3 - percentual(@PercCalcAFRMM) = (@VlrTotAFRMM_CC /  @PesoBrutoTotal)
		4 - AFRMM por item = [P.Bruto] * @PercCalcAFRMM
*/
	SELECT 
	    @PesoBrutoTotal = SUM(ISNULL([P.Bruto],0))
	FROM @Nota_Fiscal_Item 

	set @VlrTotAFRMM_CC = (select dbo.fBusca_CtaCteTaxaVlr(@Num_Proc,'AFRMM - CHB','D'))
	set @PercCalcAFRMM  =  @VlrTotAFRMM_CC / @PesoBrutoTotal   

	update @Nota_Fiscal_Item set 
	    [AFRMM] = (ISNULL([P.Bruto],0) * @PercCalcAFRMM)

	SELECT 
	    @PBruto	          = SUM(ISNULL([P.Bruto],0)),
        @PLiq             = SUM(ISNULL([P. Liq.],0)),
        @Quantidade       = SUM(ISNULL([Quantidade],0)),
        @PrecoUnit        = SUM(ISNULL([Preco Unit],0)),
        @MLE              = SUM(ISNULL([MLE],0)), 	
        @Frete	          = SUM(ISNULL([Frete],0)),
        @Seguro	          = SUM(ISNULL([Seguro],0)),
        @Acrescimos       = SUM(ISNULL([Acrescimos],0)),
        @Siscomex	      = SUM(ISNULL([Siscomex],0)),
		@AFRMM	          = SUM(ISNULL([AFRMM],0)),
	    @THC              = SUM(ISNULL([THC],0)),
	    @THD              = SUM(ISNULL([THD],0)),
        @VlrII	          = SUM(ISNULL([Vlr II],0)),
        @VlrICMS	      = SUM(ISNULL([Vlr ICMS],0)),
        @VlrIPI	          = SUM(ISNULL([Vlr IPI],0)),
        @VlrCofins	      = SUM(ISNULL([Vlr Cofins],0)), 
        @VlrPIS	          = SUM(ISNULL([Vlr PIS],0)),
		@BasePIS	      = SUM(ISNULL([Base PIS],0)) ,
		@BaseCofins	      = SUM(ISNULL([Base Cofins],0)) ,
        @BaseICMS	      = SUM(ISNULL([Base ICMS],0)) ,
        @BaseIPI	      = SUM(ISNULL([Base IPI],0)) ,
        @BaseII	          = SUM(ISNULL([Base II],0)) ,
		@ValorTotalNF     = SUM(ISNULL([Valor Total NF],0))  

	FROM @Nota_Fiscal_Item 
	   	  
	if exists(select * from @Nota_Fiscal_Item)
	begin
		INSERT INTO @Nota_Fiscal_Item
		(
		[Item],
		[P.Bruto],
        [P. Liq.],
        [Quantidade],
        [Preco Unit],
        [MLE],	
        [Frete],
        [Seguro],
        [Acrescimos],
        [Siscomex],
        [AFRMM],
        [THC],
        [THD],
        [Vlr II],
        [Vlr ICMS],
        [Vlr IPI],
        [Vlr Cofins],
        [Vlr PIS],
		[Base PIS],
		[Base Cofins],
        [Base ICMS],
        [Base IPI],
        [Base II],
		[Valor Total NF]
		)
		SELECT 
		'TOTAIS',
        @PBruto,
        @PLiq,
        @Quantidade,
        @PrecoUnit,
        @MLE, 	
        @Frete,
        @Seguro,
        @Acrescimos,
        @Siscomex,
        @AFRMM,
        @THC,
        @THD,
        @VlrII,
        @VlrICMS,
        @VlrIPI,
        @VlrCofins, 
        @VlrPIS,
		@BasePIS,
		@BaseCofins,
        @BaseICMS,
        @BaseIPI,
        @BaseII,
		@ValorTotalNF  
	end

select * from @Nota_Fiscal_Item



GO
