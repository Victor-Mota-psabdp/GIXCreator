SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerAG4A_SelIns](
 @ID_ITDI bigint,
 @Processo varchar(16)
)
--spATL_IbrokerAG4A_SelIns 37,'IMGVD21503002BR'
as
--*****CAPI - Capa da PO/PI
--Set @ID_ITDI = 1
--Set @Processo = 'IMGVD21409005BR'

Declare	 @01	varchar(4)
Declare	 @02	varchar(60)
Declare	 @03  	varchar(80)
Declare	 @04  	varchar(70)
Declare	 @05  	varchar(06)
Declare	 @06  	varchar(3)
Declare	 @07	varchar(4)
Declare	 @08  	varchar(10)
Declare	 @09  	varchar(3)


--[02]
	Select @02= SL.Nome_Raz_Soc, @03 = EN.Rua, @04 = EN.Compl_End, @05=EN.Numero, @06=ENSL.Cd_Pais_Synchro,@07 =right(SL.Cd_Pes,4), @08 = SL.Cd_Pes   from Pedido_Ship PS with(nolock)
	Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
	join Pessoa SL with(nolock) on PD.Cd_Seller = SL.Cd_Pes
	left join Endereco EN with(nolock) on SL.Cd_Pes = EN.Cd_Pes and EN.Cd_Tp_End = 'COM'
	left Join Pais_Synchro_Int_Dow ENSL  with(nolock) on EN.Cd_Pais = ENSL.Cd_Pais
	where PS.Num_Proc = @Processo
	
/*
--[03]
select Top 1 @03 = PD.Customer_PO,@04 = replace(convert(varchar(10), PD.Dt_Pedido,3),'/','') from Pedido_Ship PS
join Pedido PD on PS.cd_pedido = PD.Cd_pedido
where Num_Proc = @Processo

--[38]
Select @38=replace(convert(varchar(10), LLP.ATA_Lim,3),'/','')  from LLP_Imp_Mar LLP
Join Pedido_Ship PS on  LLP.Num_Proc_Lim = PS.Num_Proc
Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
where LLP.Num_Proc_Lim = @Processo
--[39],[40]
Select  @39=sum(PDet.Peso_Bruto_TOT), @40=Sum(PDet.Peso_Liquido_TOT) from LLP_Imp_Mar LLP
Join Pedido_Ship PS on  LLP.Num_Proc_Lim = PS.Num_Proc
Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
Join Pedido_Det PDet on PD.Cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
where LLP.Num_Proc_Lim = @Processo
set @39 = (select cast(isnull(@39,0) as decimal (15,04)))
set @40 = (select cast(isnull(@40,0) as decimal (15,04)))

--[07],[08],[11]
select top 1 @07=BU.Campo_Dados, @08=CS.Campo_Dados, @11=SL.Campo_Dados from Pedido_Ship PS
join Pedido PD on PS.cd_pedido = PD.Cd_pedido
left join Campo_Pessoa BU on PD.Cd_Buyer = BU.Cd_Pes and BU.Id_Campo = 14
left join Campo_Pessoa CS on PD.Cd_Consignee = CS.Cd_Pes and BU.Id_Campo = 14
left join Campo_Pessoa SL on PD.Cd_Seller = SL.Cd_Pes and BU.Id_Campo = 15
where Num_Proc = @Processo


--[15]
	Select top 1 @15=OrgSis.Cd_Pais_Synchro from Pedido_Ship PS 
	Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	left Join Pais_Synchro_Int_Dow OrgSis with(nolock) on PD.Cd_Pais_Org = OrgSis.Cd_Pais
	where PS.Num_Proc = @Processo
--[33],[34]
	Select top 1 @33 = HOU.HAWB_HIM, @34=HOU.MAWB_HIM  from House_Imp_Mar HOU 
	join Pedido_Ship PS on HOU.Num_Proc_HIM = PS.Num_Proc
	where Num_proc_him = @Processo
--[35],[43],[44]
	Select top 1 @35= replace(convert(varchar(10), T21.Dt_Conclusao,3),'/',''), @43 = HOU.HAWB_HIM,@44=Hou.MAWB_HIM  from House_Imp_Mar HOU 
	join Pedido_Ship PS on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Tarefas_Processos T21 with(nolock) on HOU.Num_Proc_HIM = T21.Num_Proc and T21.ID_Task = 21
	where PS.Num_Proc = @Processo
	*/
set  @01  = dbo.PreencheStringV2('AG4A',4,' ')
set  @02  = dbo.PreencheStringV2(@02,60,' ')
set  @03  = dbo.PreencheStringV2(@03,80,' ')
set  @04  = dbo.PreencheStringV2(@04,70,' ')
set  @05  = dbo.PreencheStringV2(@05,6,' ')
set  @06  = dbo.PreencheStringV2(@06,3,' ')
set  @07  = dbo.PreencheStringV2(@07,4,' ')
set  @08  = dbo.PreencheStringV2(@08,10,' ')
set  @09  = dbo.PreencheStringV2(@09,3,' ')


insert  IBROKER_AG4A
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
 @09  [09]

GO
