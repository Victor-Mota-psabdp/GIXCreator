SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerCAP2_SelIns](
 @ID_ITDI bigint,
 @Processo varchar(16)
)--spATL_IbrokerCAP2_SelIns 1,'IMCSR21503004BR'
as

--*****CAP2 - Capa da PO/PI
--Declare @Processo varchar(16)
--Set @Processo = 'IMGVD21409005BR'
Declare	 @01   	varchar(4) 
Declare	 @02   	varchar(15)
Declare	 @03  	varchar(4)
Declare	 @04  	varchar(7)
Declare	 @05  	varchar(7)
Declare	 @06   	varchar(3)
Declare	 @07  	varchar(7)
Declare	 @08  	varchar(7)
Declare	 @09   	varchar(3)
Declare	 @10  	varchar(15)
Declare	 @11  	varchar(3)
Declare	 @12  	varchar(15)
Declare	 @13  	varchar(15)
Declare	 @14  	varchar(15)
Declare	 @15  	varchar(3)
Declare	 @16  	varchar(1)
Declare	 @17  	varchar(7)
Declare	 @18  	varchar(15)
Declare	 @19  	varchar(3)
Declare	 @20  	varchar(15)
Declare	 @21  	varchar(3)
Declare	 @22  	varchar(10)
Declare	 @23  	varchar(1)
Declare	 @24  	varchar(4)
Declare	 @25  	varchar(6)
Declare	 @26  	varchar(2)
Declare	 @27  	varchar(1)
Declare	 @28  	varchar(4)
Declare	 @29  	varchar(15)
Declare	 @30  	varchar(3)
Declare	 @31  	varchar(3)
Declare	 @32  	varchar(15)
Declare	 @33  	varchar(2)
Declare	 @34  	varchar(4)
Declare	 @35  	varchar(3)

Declare @Tp_Frete varchar(1)
Declare @Vlr_Frete decimal(15,2)

set @01 = 'CAP2'
set @02 = @Processo

if left(@Processo,2) = 'IM'
	begin
--[09], [10],[21],[32],[19]
		Select @19=TM.Cod_Nac_Moeda, @09=TM.Cod_Nac_Moeda,@10=cast(isnull(PD.vlr_pedido,0) as decimal (15,02)),@21=PD.Incoterm,@32=cast(isnull(PD.vlr_pedido,0) as decimal (15,02)) from LLP_Imp_Mar LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lim = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Tipo_Moeda TM with(nolock) on PD.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where LLP.Num_Proc_Lim = @Processo
--[11],[12],[13]
		Select @11=TM.Cod_Nac_Moeda , @TP_Frete = HOU.Tp_Frete_HIM, @Vlr_Frete = HOU.Vlr_Frete_Efet_HIM  from House_Imp_Mar HOU with(nolock)
		join Tipo_Moeda TM with(nolock) on HOU.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where Num_proc_him = @Processo
--[06]
	Select @06=count(PS.cd_produto) from LLP_Imp_Mar LLP with(nolock)
	Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lim = PS.Num_Proc
	where LLP.Num_Proc_Lim = @Processo
	end
if left(@Processo,2) = 'IA'
	begin
--[09], [10],[21],[32],[19]
		Select @19=TM.Cod_Nac_Moeda, @09=TM.Cod_Nac_Moeda,@10=cast(isnull(PD.vlr_pedido,0) as decimal (15,02)),@21=PD.Incoterm,@32=cast(isnull(PD.vlr_pedido,0) as decimal (15,02)) from LLP_Imp_Aer LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lia = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Tipo_Moeda TM with(nolock) on PD.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where LLP.Num_Proc_Lia = @Processo
--[11],[12],[13]
		Select @11=TM.Cod_Nac_Moeda , @TP_Frete = HOU.Tp_Frete_HIA, @Vlr_Frete = HOU.Vlr_Frete_Efet_HIA  from House_Imp_Aer HOU with(nolock)
		join Tipo_Moeda TM with(nolock) on HOU.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where Num_proc_hia = @Processo
--[06]
	Select @06=count(PS.cd_produto) from LLP_Imp_Aer LLP with(nolock)
	Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lia = PS.Num_Proc
	where LLP.Num_Proc_Lia = @Processo
End
if left(@Processo,2) = 'IO'
	begin
--[09], [10],[21],[32],[19]
		Select @19=TM.Cod_Nac_Moeda, @09=TM.Cod_Nac_Moeda,@10=cast(isnull(PD.vlr_pedido,0) as decimal (15,02)),@21=PD.Incoterm,@32=cast(isnull(PD.vlr_pedido,0) as decimal (15,02)) from LLP_Imp_Out LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lio = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Tipo_Moeda TM with(nolock) on PD.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where LLP.Num_Proc_Lio = @Processo
--[11],[12],[13]
		Select @11=TM.Cod_Nac_Moeda , @TP_Frete = HOU.Tp_Frete_HIO, @Vlr_Frete = HOU.Vlr_Frete_Efet_HIO  from House_Imp_Out HOU with(nolock)
		join Tipo_Moeda TM with(nolock) on HOU.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where Num_proc_hio = @Processo
--[06]
	Select @06=count(PS.cd_produto) from LLP_Imp_Out LLP with(nolock)
	Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lio = PS.Num_Proc
	where LLP.Num_Proc_Lio = @Processo
end
	set @10 = (select cast(isnull(@10,0) as decimal (15,02)))
	print @10
	set @32 = (select cast(isnull(@32,0) as decimal (15,02)))
	print @32
	

	If @Tp_Frete = 'P' 
		Begin
			set @12 = @Vlr_Frete
			set @13 = '0.00'
		End
	else
		Begin
			set @13 = @Vlr_Frete
			set @12 = '0.00'
		End

--[19][20] 
	select @19=TM.Cod_Nac_Moeda,@20=cast(isnull(Vlr_invoice,0) as decimal (15,02)) from vwHouse_Imp HOU with(nolock)
	join Tipo_Moeda TM with(nolock) on HOU.Moeda_invoice = TM.Cd_Tp_Moeda 
	where Num_Proc = @Processo
	
	

set  @01   =  dbo.PreencheStringV2(@01,4,' ')
set  @02   = dbo.PreencheStringV2(@Processo,15,' ')--JOB
set  @03  = dbo.PreencheStringV2('',4,' ')
set  @04  = dbo.PreencheStringV2('',7,' ')
set  @05  = dbo.PreencheStringV2('',7,' ')
set  @06    = dbo.PreencheStringV2(@06,3,'0')--Quantidade de Produtos (Pedido_Ship)
set  @07  = dbo.PreencheStringV2('0.0000',7,'0')
set  @08  = dbo.PreencheStringV2('0.0000',7,'0')
set  @09    = dbo.PreencheStringV2(@09,3,' ') -- Currency
set  @10    = dbo.PreencheStringV2(@10,15,'0')-- Order Value
set  @11  = dbo.PreencheStringV2(@11,3,' ')-- Currency
set  @12  = dbo.PreencheStringV2(@12,15,'0')-- Frete Value (Prepaid)
set  @13  = dbo.PreencheStringV2(@13,15,'0')-- Frete Value (Collect)
set  @14  = dbo.PreencheStringV2('0.00',15,'0')
set  @15  = dbo.PreencheStringV2('',3,' ')
set  @16  = dbo.PreencheStringV2('',1,' ')
set  @17  = dbo.PreencheStringV2('0.0000',7,'0')
set  @18  = dbo.PreencheStringV2('0.00',15,'0')
set  @19  = dbo.PreencheStringV2(@19,3,' ')--Moeda Invoice
set  @20  = dbo.PreencheStringV2(@20,15,'0')--Valor Invoice
set  @21  = dbo.PreencheStringV2(@21,3,' ') --Icoterm
set  @22  = dbo.PreencheStringV2('',10,' ')
set  @23  = dbo.PreencheStringV2('',1,' ')
set  @24  = dbo.PreencheStringV2('0',4,'0')
set  @25  = dbo.PreencheStringV2('',6,' ')
set  @26  = dbo.PreencheStringV2('',2,' ')
set  @27  = dbo.PreencheStringV2('',1,' ')
set  @28  = dbo.PreencheStringV2('',4,' ')
set  @29  = dbo.PreencheStringV2('',15,' ')
set  @30  = dbo.PreencheStringV2('',3,' ')
set  @31  = dbo.PreencheStringV2('',3,' ')
set  @32  = dbo.PreencheStringV2(@32,15,'0')--Order Value
set  @33  = dbo.PreencheStringV2('',2,' ')
set  @34  = dbo.PreencheStringV2('',4,' ')
set  @35  = dbo.PreencheStringV2('',3,' ')

insert IBROKER_CAP2
select  
@ID_ITDI,
@01    [01],
 @02  [02], 
 @03  [03],
 @04  [04],
 @05  [05],
 @06  [06],
 @07  [07],
 @08  [08],
 @09  [09],
 @10  [10],
 @11  [11],
 @12  [12],
 @13  [13],
 @14  [14],
 @15  [15],
 @16  [16],
 @17  [17],
 @18  [18],
 @19  [19],
 @20  [20],
 @21  [21],
 @22  [22],
 @23  [23],
 @24  [24],
 @25  [25],
 @26  [26],
 @27  [27],
 @28  [28],
 @29  [29],
 @30  [30],
 @31  [31],
 @32  [32],
 @33  [33],
 @34  [34],
 @35  [35]
GO
