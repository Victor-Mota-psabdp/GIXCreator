SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerCAP2New_Sel](
 @Num_Proc varchar(16)
)
as

--*****CAP2 - Capa da PO/PI
--Declare @Num_Proc varchar(16)
--Set @Num_Proc = 'IMGVD201409005BR'
Declare	 @06   		varchar(3)
Declare	 @09   		varchar(3)
Declare	 @NomeMoedaOrdem varchar(50)
Declare	 @10  		varchar(15)
Declare	 @11  		varchar(3)
Declare  @NomeMoedaFrete varchar(50)
Declare	 @12  		varchar(15)
Declare	 @13  		varchar(15)
Declare	 @19  		varchar(15)
Declare	 @20  		varchar(15)
Declare  @NomeMoedaInvoice varchar(50)
Declare	 @21  		varchar(3)
Declare  @NomeOper	varchar(50)

Declare @Tp_Frete varchar(1)
Declare @Vlr_Frete decimal(15,2)


if left(@Num_Proc,2) = 'IM'
	begin
--[09], [10],[21],[32],[19]
		Select @09=TM.Cod_Nac_Moeda,@NomeMoedaOrdem = TM.Nome_Tp_Moeda ,@21=PD.Incoterm,@NomeOper = INC.Nome_Tp_Oper from LLP_Imp_Mar LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on LLP.Num_Proc_Lim = PS.Num_Proc
		Join Pedido PD		with(nolock) on PS.cd_pedido = PD.Cd_pedido
		left Join Tipo_Moeda TM with(nolock) on PD.cd_tp_moeda = TM.Cd_Tp_Moeda 
		left Join tipo_oper INC with(nolock) on PD.Incoterm = INC.Cd_Tp_Oper
		where LLP.Num_Proc_Lim = @Num_Proc
--[11],[12],[13]
		Select @11=TM.Cod_Nac_Moeda ,@NomeMoedaFrete = TM.Nome_Tp_Moeda , @TP_Frete = HOU.Tp_Frete_HIM, @Vlr_Frete = HOU.Vlr_Frete_Efet_HIM  from House_Imp_Mar HOU 
		join Tipo_Moeda TM with(nolock) on HOU.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where Num_proc_him = @Num_Proc
--[06]
		Select @06=count(PS.cd_produto) from LLP_Imp_Mar LLP
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lim = PS.Num_Proc
		where LLP.Num_Proc_Lim = @Num_Proc
		
		Select @10=cast(SUM(isnull(PDet.Vlr_Total_Item,0)) as decimal (15,02)) from LLP_Imp_Mar LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lim = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido 
		Join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_pedido and PS.cd_produto = PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
		left Join Tipo_Moeda TM with(nolock) on PD.cd_tp_moeda = TM.Cd_Tp_Moeda 
		left Join tipo_oper INC with(nolock) on PD.Incoterm = INC.Cd_Tp_Oper
		where LLP.Num_Proc_Lim = @Num_Proc
		


	end
if left(@Num_Proc,2) = 'IA'
	begin
--[09], [10],[21],[32],[19]
		Select @09=TM.Cod_Nac_Moeda,@NomeMoedaOrdem = TM.Nome_Tp_Moeda ,@10=cast(isnull(PD.vlr_pedido,0) as decimal (15,02)),@21=PD.Incoterm,@NomeOper = INC.Nome_Tp_Oper from LLP_Imp_Aer LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lia = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Tipo_Moeda TM with(nolock) on PD.cd_tp_moeda = TM.Cd_Tp_Moeda 
		left Join tipo_oper INC with(nolock) on PD.Incoterm = INC.Cd_Tp_Oper
		where LLP.Num_Proc_Lia = @Num_Proc
--[11],[12],[13]
		Select @11=TM.Cod_Nac_Moeda ,@NomeMoedaFrete = TM.Nome_Tp_Moeda, @TP_Frete = HOU.Tp_Frete_HIA, @Vlr_Frete = HOU.Vlr_Frete_Efet_HIA  from House_Imp_Aer HOU  with(nolock)
		join Tipo_Moeda TM with(nolock) on HOU.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where Num_proc_hia = @Num_Proc
--[06]
	Select @06=count(PS.cd_produto) from LLP_Imp_Aer LLP with(nolock)
	Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lia = PS.Num_Proc
	where LLP.Num_Proc_Lia = @Num_Proc
End
if left(@Num_Proc,2) = 'IO'
	begin
--[09], [10],[21],[32],[19]
		Select @09=TM.Cod_Nac_Moeda,@NomeMoedaOrdem = TM.Nome_Tp_Moeda ,@21=PD.Incoterm,@NomeOper = INC.Nome_Tp_Oper from LLP_Imp_Out LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lio = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Tipo_Moeda TM with(nolock) on PD.cd_tp_moeda = TM.Cd_Tp_Moeda 
		left Join tipo_oper INC with(nolock) on PD.Incoterm = INC.Cd_Tp_Oper
		where LLP.Num_Proc_Lio = @Num_Proc
--[11],[12],[13]
		Select @11=TM.Cod_Nac_Moeda ,@NomeMoedaFrete = TM.Nome_Tp_Moeda, @TP_Frete = HOU.Tp_Frete_HIO, @Vlr_Frete = HOU.Vlr_Frete_Efet_HIO  from House_Imp_Out HOU  with(nolock)
		join Tipo_Moeda TM with(nolock) on HOU.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where Num_proc_hio = @Num_Proc
--[06]
	Select @06=count(PS.cd_produto) from LLP_Imp_Out LLP with(nolock)
	Join Pedido_Ship PS with(nolock) on LLP.Num_Proc_Lio = PS.Num_Proc
	where LLP.Num_Proc_Lio = @Num_Proc
end
	set @10 = (select cast(isnull(@10,0) as decimal (15,02)))
	
	--[19][20] 
	select @19=TM.Cod_Nac_Moeda,@NomeMoedaInvoice=Nome_Tp_Moeda ,@20=cast(isnull(Vlr_invoice,0) as decimal (15,02)) from vwHouse_Imp HOU with(nolock)
	join Tipo_Moeda TM with(nolock) on HOU.Moeda_invoice = TM.Cd_Tp_Moeda 
	where Num_Proc = @Num_Proc
	--If @Tp_Frete = 'P' 
	--	Begin
	--		set @12 = @Vlr_Frete
	--		set @13 = '0.00'
	--	End
	--else
	--	Begin
	--		set @13 = @Vlr_Frete
	--		set @12 = '0.00'
	--	End

select  
 @06  [Qty Item],
 @09  [Cod. Currency(Order)],
 @NomeMoedaOrdem  [Currency(Order)],
 cast(@10 as money)  [Order Value],
 @11  [Cod. Currency(Freight)],
 @NomeMoedaFrete [Currency(Freight)],
 cast(@Vlr_Frete as money) [Freight Value],
 @Tp_Frete [Freight Type],
 @19 [Cod. Currency(Invoice)],
 @NomeMoedaInvoice [Currency(Invoice)],
  cast(@20 as money) [Invoice Value],
 @21  [Incoterm],
 right(@NomeOper,len(@NomeOper)-6) [Incoterm Descr]
 

 
GO
