SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_IBrokerCAPI_V2_SelIns](
 @ID_ITDI bigint,
 @ID_View Bigint
)--spATL_IbrokerCAPI_SelIns 1,'IMOXT201501028BR'
as
--*****CAPI - Capa da PO/PI
--Set @ID_ITDI = 1
--Set @Processo = 'IMGVD201409005BR'
--Select * from IBROKER_CAP1
Declare	 @01	varchar(4)
Declare	 @02	varchar(15)
Declare	 @03  	varchar(20)
Declare	 @04  	varchar(6)
Declare	 @05  	varchar(2)
Declare	 @06  	varchar(1)
Declare	 @07	varchar(4)
Declare	 @08  	varchar(4)
Declare	 @09  	varchar(1)
Declare	 @10  	varchar(1)
Declare	 @11  	varchar(4)
Declare	 @12  	varchar(4)
Declare	 @13  	varchar(3)
Declare	 @14  	varchar(7)
Declare	 @15  	varchar(3)
Declare	 @16  	varchar(1)
Declare	 @17  	varchar(1)
Declare	 @18  	varchar(2)
Declare	 @19  	varchar(1)
Declare	 @20  	varchar(1)
Declare	 @21  	varchar(1)
Declare	 @22  	varchar(1)
Declare	 @23  	varchar(1)
Declare	 @24  	varchar(2)
Declare	 @25  	varchar(1)
Declare	 @26  	varchar(4)
Declare	 @27  	varchar(15)
Declare	 @28  	varchar(30)
Declare	 @29  	varchar(3)
Declare	 @30  	varchar(1)
Declare	 @31  	varchar(15)
Declare	 @32  	varchar(2)
Declare	 @33  	varchar(11)
Declare	 @34  	varchar(11)
Declare	 @35  	varchar(6)
Declare	 @36  	varchar(10)
Declare	 @37  	varchar(1)
Declare	 @38  	varchar(6)
Declare	 @39  	varchar(15)
Declare	 @40  	varchar(15)
Declare	 @41  	varchar(3)
Declare	 @42  	varchar(1)
Declare	 @43  	varchar(18)
Declare	 @44  	varchar(18)

select 
	@02 = JOB,
	@03 = Order_Reference, 
	@04 = replace(convert(varchar(10), Order_Date,3),'/',''),
	@15 = Code_Origin_Country,
	@24 = Code_Modal_RM,
	@33 = House,
	@34 = [Master],
	@35 = replace(convert(varchar(10), Act_Carrier_Payment_Date,3),'/',''),
	@38 = replace(convert(varchar(10), ATA_DATE,3),'/',''),
	@39 = Net_Weigth,
	@40 = Gross_Weigth,
	@43 = House,
	@44 =[Master]
	
from IBROKER_CAPI_V2
where ID = @ID_View


select 
	@07 = Ibroker
from IBROKER_Pessoa_V2 where ID = @ID_View and Tipo =  'B'
select 
	@08 =Ibroker

from IBROKER_Pessoa_V2 where ID = @ID_View and Tipo =  'C'
select 
	@11 = Ibroker
from IBROKER_Pessoa_V2 where ID = @ID_View and Tipo =  'S'

----[03]
--select Top 1 @03 = PD.Customer_PO,@04 = replace(convert(varchar(10), PD.Dt_Pedido,3),'/','') from Pedido_Ship PS
--join Pedido PD on PS.cd_pedido = PD.Cd_pedido
--where Num_Proc = @Processo


----[07],[08],[11]
--select top 1 @07=right(Isnull(BU.Campo_Dados,'0'),4), @08=right(isnull(CS.Campo_Dados,'0'),4), @11=right(isnull(SL.Campo_Dados,'0'),4) from Pedido_Ship PS
--join Pedido PD on PS.cd_pedido = PD.Cd_pedido
--left join Campo_Pessoa BU on PD.Cd_Buyer = BU.Cd_Pes and BU.Id_Campo = 14
--left join Campo_Pessoa CS on PD.Cd_Consignee = CS.Cd_Pes and CS.Id_Campo = 14
--left join Campo_Pessoa SL on PD.Cd_Seller = SL.Cd_Pes and SL.Id_Campo = 15
--where Num_Proc = @Processo


----[15]
--	Select top 1 @15=OrgSis.Cd_Pais_Synchro from Pedido_Ship PS 
--	Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
--	left Join Pais_Synchro_Int_Dow OrgSis with(nolock) on PD.Cd_Pais_Org = OrgSis.Cd_Pais
--	where PS.Num_Proc = @Processo

--	if left(@Processo,2) = 'IM'
--	begin
----[33],[34]
--		Select top 1 @33 = HOU.HAWB_HIM, @34=HOU.MAWB_HIM  from House_Imp_Mar HOU 
--		join Pedido_Ship PS on HOU.Num_Proc_HIM = PS.Num_Proc
--		where Num_proc_him = @Processo
----[35],[43],[44]
		--Select top 1 @35= replace(convert(varchar(10), T21.Dt_Conclusao,3),'/',''), @43 = HOU.HAWB_HIM,@44=Hou.MAWB_HIM  from House_Imp_Mar HOU 
		--join Pedido_Ship PS on HOU.Num_Proc_HIM = PS.Num_Proc
		--Join Tarefas_Processos T21 with(nolock) on HOU.Num_Proc_HIM = T21.Num_Proc and T21.ID_Task = 21
		--where PS.Num_Proc = @Processo
	--[39],[40]
		--Select  @40=cast(isnull(sum(PDet.Peso_Bruto_TOT),0)as decimal (15,04)), @39=cast(isnull(Sum(PDet.Peso_Liquido_TOT),0)as decimal (15,04)) from LLP_Imp_Mar LLP
		--Join Pedido_Ship PS on  LLP.Num_Proc_Lim = PS.Num_Proc
		--Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
		--Join Pedido_Det PDet on PD.Cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
		--where LLP.Num_Proc_Lim = @Processo
--[38],[24]
		--Select @38=replace(convert(varchar(10), LLP.ATA_Lim,3),'/',''), @24 =(case when PD.cd_modal = 'O' then '01' when PD.cd_modal = 'A' then '04' when PD.cd_modal ='R' then '06' when PD.cd_modal ='T' then '07' else '01' end)  from LLP_Imp_Mar LLP
		--Join Pedido_Ship PS on  LLP.Num_Proc_Lim = PS.Num_Proc
		--Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
		--where LLP.Num_Proc_Lim = @Processo

--	end
	
--	if left(@Processo,2) = 'IA'
--	begin
----[33],[34]
--		Select top 1 @33 = HOU.HAWB_HIA, @34=HOU.MAWB_HIA  from House_Imp_Aer HOU 
--		join Pedido_Ship PS on HOU.Num_Proc_HIA = PS.Num_Proc
--		where Num_proc_hia = @Processo
----[35],[43],[44]		
--		Select top 1 @35= replace(convert(varchar(10), T21.Dt_Conclusao,3),'/',''), @43 = HOU.HAWB_HIA,@44=Hou.MAWB_HIA  from House_Imp_Aer HOU 
--		join Pedido_Ship PS on HOU.Num_Proc_HIA = PS.Num_Proc
--		Join Tarefas_Processos T21 with(nolock) on HOU.Num_Proc_HIA = T21.Num_Proc and T21.ID_Task = 21
--		where PS.Num_Proc = @Processo
----[39],[40]
--		Select  @40=cast(isnull(sum(PDet.Peso_Bruto_TOT),0)as decimal (15,04)), @39=cast(isnull(Sum(PDet.Peso_Liquido_TOT),0)as decimal (15,04)) from LLP_Imp_Aer LLP
--		Join Pedido_Ship PS on  LLP.Num_Proc_Lia = PS.Num_Proc
--		Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
--		Join Pedido_Det PDet on PD.Cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
--		where LLP.Num_Proc_Lia = @Processo
----[38]
--		Select @38=replace(convert(varchar(10), LLP.ATA_Lia,3),'/',''),@24 =(case when PD.cd_modal = 'O' then '01' when PD.cd_modal = 'A' then '04' when PD.cd_modal ='R' then '06' when PD.cd_modal ='T' then '07' else '01' end)  from LLP_Imp_Aer LLP
--		Join Pedido_Ship PS on  LLP.Num_Proc_Lia = PS.Num_Proc
--		Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
--		where LLP.Num_Proc_Lia = @Processo
--	end
--	if left(@Processo,2) = 'IO'
--	begin
----[33],[34]
--		Select top 1 @33 = HOU.HAWB_HIO, @34=HOU.MAWB_HIO  from House_Imp_Out HOU 
--		join Pedido_Ship PS on HOU.Num_Proc_HIO = PS.Num_Proc
--		where Num_proc_hio = @Processo
----[35],[43],[44]		
--		Select top 1 @35= replace(convert(varchar(10), T21.Dt_Conclusao,3),'/',''), @43 = HOU.HAWB_HIO,@44=Hou.MAWB_HIO  from House_Imp_out HOU 
--		join Pedido_Ship PS on HOU.Num_Proc_HIO = PS.Num_Proc
--		Join Tarefas_Processos T21 with(nolock) on HOU.Num_Proc_HIO = T21.Num_Proc and T21.ID_Task = 21
--		where PS.Num_Proc = @Processo
----[39],[40]
--		Select  @40=cast(isnull(sum(PDet.Peso_Bruto_TOT),0)as decimal (15,04)), @39=cast(isnull(Sum(PDet.Peso_Liquido_TOT),0)as decimal (15,04)) from LLP_Imp_Out LLP
--		Join Pedido_Ship PS on  LLP.Num_Proc_Lio = PS.Num_Proc
--		Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
--		Join Pedido_Det PDet on PD.Cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
--		where LLP.Num_Proc_Lio = @Processo
----[38]
--		Select @38=replace(convert(varchar(10), LLP.ATA_Lio,3),'/',''),@24 =(case when PD.cd_modal = 'O' then '01' when PD.cd_modal = 'A' then '04' when PD.cd_modal ='R' then '06' when PD.cd_modal ='T' then '07' else '01' end)  from LLP_Imp_Out LLP
--		Join Pedido_Ship PS on  LLP.Num_Proc_Lio = PS.Num_Proc
--		Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
--		where LLP.Num_Proc_Lio = @Processo
--	end 
	
set  @01  = dbo.PreencheStringV2('CAPI',4,' ')
set  @02  = dbo.PreencheStringV2(@02,15,' ')
set  @03  = dbo.PreencheStringV2(@03,20,' ')
set  @04  = dbo.PreencheStringV2(@04,6,' ')
set  @05  = dbo.PreencheStringV2('',2,' ')
set  @06  = dbo.PreencheStringV2('T',1,' ')
set  @07  = dbo.PreencheStringV2(@07,4,' ')
set  @08  = dbo.PreencheStringV2(@08,4,' ')
set  @09  = dbo.PreencheStringV2('F',1,' ')
set  @10  = dbo.PreencheStringV2('T',1,' ')
set  @11  = dbo.PreencheStringV2(@11,4,' ')
set  @12  = dbo.PreencheStringV2(@11,4,' ')
set  @13  = dbo.PreencheStringV2('',3,' ')
set  @14  = dbo.PreencheStringV2('',7,' ')
set  @15  = dbo.PreencheStringV2(@15,3,' ')
set  @16  = dbo.PreencheStringV2('F',1,' ')
set  @17  = dbo.PreencheStringV2('1',1,' ')
set  @18  = dbo.PreencheStringV2('',2,' ')
set  @19  = dbo.PreencheStringV2('F',1,' ')
set  @20  = dbo.PreencheStringV2('1',1,' ')
set  @21  = dbo.PreencheStringV2('1',1,' ')
set  @22  = dbo.PreencheStringV2('3',1,' ')
set  @23  = dbo.PreencheStringV2('',1,' ')
set  @24  = dbo.PreencheStringV2(@24,2,' ')
set  @25  = dbo.PreencheStringV2('',1,' ')
set  @26  = dbo.PreencheStringV2('',4,' ')
set  @27  = dbo.PreencheStringV2('',15,' ')
set  @28  = dbo.PreencheStringV2('',30,' ')
set  @29  = dbo.PreencheStringV2('',3,' ')
set  @30  = dbo.PreencheStringV2('',1,' ')
set  @31  = dbo.PreencheStringV2('',15,' ')
set  @32  = dbo.PreencheStringV2('',2,' ')
set  @33  = dbo.PreencheStringV2(@33,11,' ')
set  @34  = dbo.PreencheStringV2(@34,11,' ')
set  @35  = dbo.PreencheStringV2(@35,6,' ')
set  @36  = dbo.PreencheStringV2('',10,' ')
set  @37  = dbo.PreencheStringV2('',1,' ')
set  @38  = dbo.PreencheStringV2(@38,6,' ')
set  @39  = dbo.PreencheStringV2(@39,15,'0')
set  @40  = dbo.PreencheStringV2(@40,15,'0')
set  @41  = dbo.PreencheStringV2('',3,' ')
set  @42  = dbo.PreencheStringV2('',1,' ')
set  @43  = dbo.PreencheStringV2(@43,18,' ')
set  @44  = dbo.PreencheStringV2(@44,18,' ')

insert  IBROKER_CAP1
Select 
 @ID_ITDI,
 @01  [01],
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
 @35  [35],
 @36  [36],
 @37  [37],
 @38  [38],
 @39  [39],
 @40  [40],
 @41  [41],
 @42  [42],
 @43  [43],
 @44  [44]
GO
