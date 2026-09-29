SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_IBrokerCAPI_Sel] 'IMGVD201409005BR'
CREATE procedure [dbo].[spATL_IBrokerCAPINew_Sel](
 @Num_Proc varchar(16)
)
as
Declare	 @03  	varchar(20)
Declare	 @04  	varchar(6)
Declare	 @15  	varchar(3)
Declare  @PaisOrig varchar(50)
Declare	 @24  	varchar(2)
Declare	 @33  	varchar(11)
Declare	 @34  	varchar(11)
Declare	 @35  	varchar(6)
Declare	 @38  	varchar(6)
Declare	 @39  	varchar(15)
Declare	 @40  	varchar(15)
Declare	 @43  	varchar(18)
Declare	 @44  	varchar(18)
--[03],[04]
Declare @Modal_Desc varchar(50)
select Top 1 @03 = PD.Customer_PO,@04 = replace(convert(varchar(10), PD.Dt_Pedido,3),'/',''),@24 =(case when PD.cd_modal = 'O' then '01' when PD.cd_modal = 'A' then '04' when PD.cd_modal ='R' then '06' when PD.cd_modal ='T' then '07' else '01' end),@Modal_Desc =(case when PD.cd_modal = 'O' then 'Ocean' when PD.cd_modal = 'A' then 'Air' when PD.cd_modal ='R' then 'Rail' when PD.cd_modal ='T' then 'Truck' else '01' end) from Pedido_Ship PS with(nolock)
join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
where Num_Proc = @Num_Proc

--[15]
	Select top 1 @15=OrgSis.Cd_Pais_Synchro, @PaisOrig = P.Nome_Pais  from Pedido_Ship PS with(nolock)
	Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
	left Join Pais_Synchro_Int_Dow OrgSis with(nolock) on PD.Cd_Pais_Org = OrgSis.Cd_Pais
	left join Pais P with(nolock) on PD.Cd_Pais_Org = P.Cd_Pais
	where PS.Num_Proc = @Num_Proc

	if left(@Num_Proc,2) = 'IM'
	begin
--[33],[34]
		Select top 1 @33 = HOU.HAWB_HIM, @34=HOU.MAWB_HIM  from House_Imp_Mar HOU  with(nolock)
		join Pedido_Ship PS with(nolock) on HOU.Num_Proc_HIM = PS.Num_Proc
		where Num_proc_him = @Num_Proc
--[35],[43],[44]
		Select top 1 @35= replace(convert(varchar(10), T21.Dt_Conclusao,3),'/',''), @43 = HOU.HAWB_HIM,@44=Hou.MAWB_HIM  from House_Imp_Mar HOU with(nolock)
		join Pedido_Ship PS with(nolock) on HOU.Num_Proc_HIM = PS.Num_Proc
		Join Tarefas_Processos T21 with(nolock) on HOU.Num_Proc_HIM = T21.Num_Proc and T21.ID_Task = 21
		where PS.Num_Proc = @Num_Proc
	--[39],[40]
		Select  @40=cast(isnull(sum(PDet.Peso_Bruto_TOT),0)as decimal (15,04)), @39=cast(isnull(Sum(PDet.Peso_Liquido_TOT),0)as decimal (15,04)) from LLP_Imp_Mar LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lim = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Pedido_Det PDet with(nolock) on PD.Cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
		where LLP.Num_Proc_Lim = @Num_Proc
--[38],[24]
		Select @38=replace(convert(varchar(10), LLP.ATA_Lim,3),'/','')from LLP_Imp_Mar LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lim = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		where LLP.Num_Proc_Lim = @Num_Proc

	end
	
	if left(@Num_Proc,2) = 'IA'
	begin
--[33],[34]
		Select top 1 @33 = HOU.HAWB_HIA, @34=HOU.MAWB_HIA  from House_Imp_Aer HOU with(nolock)
		join Pedido_Ship PS with(nolock) on HOU.Num_Proc_HIA = PS.Num_Proc
		where Num_proc_hia = @Num_Proc
--[35],[43],[44]		
		Select top 1 @35= replace(convert(varchar(10), T21.Dt_Conclusao,3),'/',''), @43 = HOU.HAWB_HIA,@44=Hou.MAWB_HIA  from House_Imp_Aer HOU with(nolock)
		join Pedido_Ship PS with(nolock) on HOU.Num_Proc_HIA = PS.Num_Proc
		Join Tarefas_Processos T21 with(nolock) on HOU.Num_Proc_HIA = T21.Num_Proc and T21.ID_Task = 21
		where PS.Num_Proc = @Num_Proc
--[39],[40]
		Select  @40=cast(isnull(sum(PDet.Peso_Bruto_TOT),0)as decimal (15,04)), @39=cast(isnull(Sum(PDet.Peso_Liquido_TOT),0)as decimal (15,04)) from LLP_Imp_Aer LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lia = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Pedido_Det PDet with(nolock) on PD.Cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
		where LLP.Num_Proc_Lia = @Num_Proc
--[38]
		Select @38=replace(convert(varchar(10), LLP.ATA_Lia,3),'/','') from LLP_Imp_Aer LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lia = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		where LLP.Num_Proc_Lia = @Num_Proc
	end
	if left(@Num_Proc,2) = 'IO'
	begin
--[33],[34]
		Select top 1 @33 = HOU.HAWB_HIO, @34=HOU.MAWB_HIO  from House_Imp_Out HOU with(nolock) 
		join Pedido_Ship PS with(nolock) on HOU.Num_Proc_HIO = PS.Num_Proc
		where Num_proc_hio = @Num_Proc
--[35],[43],[44]		
		Select top 1 @35= replace(convert(varchar(10), T21.Dt_Conclusao,3),'/',''), @43 = HOU.HAWB_HIO,@44=Hou.MAWB_HIO  from House_Imp_out HOU with(nolock)
		join Pedido_Ship PS with(nolock) on HOU.Num_Proc_HIO = PS.Num_Proc
		Join Tarefas_Processos T21 with(nolock) on HOU.Num_Proc_HIO = T21.Num_Proc and T21.ID_Task = 21
		where PS.Num_Proc = @Num_Proc
--[39],[40]
		Select  @40=cast(isnull(sum(PDet.Peso_Bruto_TOT),0)as decimal (15,04)), @39=cast(isnull(Sum(PDet.Peso_Liquido_TOT),0)as decimal (15,04)) from LLP_Imp_Out LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lio = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Pedido_Det PDet with(nolock) on PD.Cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
		where LLP.Num_Proc_Lio = @Num_Proc
--[38]

		Select @38=replace(convert(varchar(10), LLP.ATA_Lio,3),'/','')  from LLP_Imp_Out LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lio = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		where LLP.Num_Proc_Lio = @Num_Proc
	end 
	
	
select
NULL ID, 
@Num_Proc [JOB],
@03[Order Reference] ,
convert(varchar(10), CAST(substring(@04,3,2) + '/' + substring(@04,1,2) + '/' + substring(@04,5,2) as DateTIME),103)  [Order Date],
--substring(@04,3,2) + '/' + substring(@04,1,2) + '/' + substring(@04,5,2),
--SELECT CONVERT(VARCHAR(19), CAST('09/25/14' AS DATETIME), 120)
@24 [Code Modal(RM)],
@Modal_Desc [Modal Description(RM)],
@15[Code Origin Country],
@PaisOrig[Origin Country],
@43 [House] ,
@44 [Master], 
convert(varchar(10), CAST(substring(@35,3,2) + '/' + substring(@35,1,2) + '/' + substring(@35,5,2) as DateTIME),103)[Act. Carrier Payment Date],
convert(varchar(10), CAST(substring(@38,3,2) + '/' + substring(@38,1,2) + '/' + substring(@38,5,2) as DateTIME),103) [ATA Date],
--@38 [ATA Date],
cast(@40 as money) [Gross Weigth],
cast(@39 as money) [Net Weigth],
0 chkRef		,
0 chkPessoa	,
0 chkLocal	,
0 chkTotal	,
0 chkItem	,
0 chkDoc,
0 Status_Doc,
0 Status	

GO
