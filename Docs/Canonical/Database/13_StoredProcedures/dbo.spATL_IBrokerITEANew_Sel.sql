SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_IBrokerITEA_Sel] 'IMLVS201503019BR'
CREATE procedure [dbo].[spATL_IBrokerITEANew_Sel](
 @Processo varchar(16)
)

as

Declare	@03	varchar(20)
Declare @Descricao varchar(max)
Declare	@04	varchar(15)
Declare	@05	varchar(2)
Declare	@06	varchar(12)
Declare	@07	varchar(12)
--Declare	@13	varchar(4)
--Declare	@15	varchar(3)
Declare	@17	varchar(10)
Declare	@22	varchar(6)
Declare	@23	varchar(10)
Declare	@35	varchar(4)

Declare @TableTemp Table(
	t03	varchar(20),
	Item int,
	Descricao varchar(max),
	t04	varchar(15),
	t05	varchar(2),
	UOM varchar(10),
	t06	varchar(12),
	t07	varchar(12),
--t13	varchar(4),
--t15	varchar(3),
	t17	varchar(10),
	t22	varchar(6),
	t23	varchar(10),
	t35	varchar(4)
)
Declare @TableProduto Table(
							Cd_Pedido int,
							CD_Produto int,
							Item varchar(6),
							Lote varchar(30)
							)
						
Declare @Cd_Pedido int
Declare @CD_Produto int
Declare @Item varchar(6)
Declare @Lote varchar(30)

insert @TableProduto
select Cd_Pedido,CD_Produto,Item,Lote from Pedido_Ship
where Num_Proc = @Processo order by  Cd_Pedido,CD_Produto,Item,Lote

Declare  @x int
set @x=1
Declare Cur_TAB1 cursor for
--Carrega campos chaves para buscar registro tipo 3 (Detalhes do registro 2)
			Select Cd_Pedido,CD_Produto,Item,Lote from @TableProduto
	Open Cur_TAB1
		Fetch Next From Cur_TAB1 Into @Cd_Pedido,@CD_Produto,@Item,@Lote
		
			While @@FETCH_STATUS = 0
				Begin	
print @Cd_Pedido 
print @CD_Produto 
print @Item 
print @Lote

Declare @Cd_Pes_Grupo varchar(10)
if left(@Processo,2) = 'IM'
	begin
		Select @CD_Pes_Grupo = PD.Cd_Grupo, @22 = PS.cd_pedido,@23 = PD.Num_Pedido from LLP_Imp_Mar LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lim = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		where LLP.Num_Proc_Lim = @Processo and PS.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
	end
if left(@Processo,2) = 'IA'
	begin
	Select @CD_Pes_Grupo = PD.Cd_Grupo,  @22 = PS.cd_pedido,@23 = PD.Num_Pedido from LLP_Imp_Aer LLP with(nolock)
	Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lia = PS.Num_Proc
	Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
	where LLP.Num_Proc_Lia = @Processo and PS.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
end
if left(@Processo,2) = 'IO'
	begin
	Select @CD_Pes_Grupo = PD.Cd_Grupo,  @22 = PS.cd_pedido,@23 = PD.Num_Pedido from LLP_Imp_out LLP with(nolock)
	Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lio = PS.Num_Proc 
	Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
	where LLP.Num_Proc_Lio = @Processo and PS.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
end
	
	--print @Cd_Pes_Grupo
 --[03],
	select @03=PC.cd_Proc_Cliente from Produto_Cliente PC with(nolock)
	where PC.cd_Cliente = @Cd_Pes_Grupo and PC.cd_prod = @CD_Produto
 --[04]
	Select @04 = cast(isnull(PS.QTy,0) as decimal (15,02)) from Pedido_Ship PS with(nolock)
	 where Ps.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
--[13]	
	--Select @13= right(Cd_Seller,4) from Pedido_Ship PS 
	--Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	--where PS.Num_Proc = @Processo
	
--select @13=right(isnull(SL.Campo_Dados,'0'),4) from Pedido_Ship PS
--join Pedido PD on PS.cd_pedido = PD.Cd_pedido
--left join Campo_Pessoa SL on PD.Cd_Seller = SL.Cd_Pes and SL.Id_Campo = 15
--where Ps.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
		
Declare @UnidadeMedida Table(
			Sigla varchar(4),
			CdSiscomex int
)
insert @UnidadeMedida
select 'KG',10 union select 'LTS',61 union select 'PE',0 union select 'TB',0 union select 'UN',11 union select 'L',50 union select 'MT',34

--[05],[06],[07],[17],[35]
/*
	Select @05 = UM.CdSiscomex ,@06= PDet.Peso_Liquido_TOT,@07=Pdet.Vlr_Item,@17=PDet.NCM,@35=PDet.Item from Pedido_Ship PS
	--Join @TableProduto TP on PS.cd_pedido = TP.Cd_Pedido and PS.cd_produto = TP.CD_Produto and PS.Item=TP.Item and PS.Lote = TP.Lote 
	Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	Join Pedido_Det PDet on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.CD_Produto and PS.Item=PDet.Item and PS.Lote = PDet.Lote  
	Join @UnidadeMedida UM on PDet.UoM = UM.Sigla
	where PS.Num_Proc= @Processo  PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
	*/
	Declare @UOM varchar(10)
	Select @05 = UM.CdSiscomex, @UOM=PDet.UoM  ,@06= cast(isnull(PDet.Peso_Liquido_TOT,0) as decimal (12,04)),@07=cast(isnull(Pdet.Vlr_Item,0) as decimal (12,04)),@17=PDet.NCM, @35 = PDet.Item from Pedido_Det PDet with(nolock)
	left Join @UnidadeMedida UM on PDet.UoM = UM.Sigla
	where PDet.cd_pedido = @Cd_Pedido and PDet.cd_produto = @CD_Produto and PDet.Item=@Item and PDet.Lote = @Lote 
	
	set @Descricao =''
	select @Descricao = replace(replace(PCD.Descricao_Longa, CHAR(13), CHAR(32)), CHAR(10), CHAR(32)) from Produto_Cliente PC with(nolock)
	join Produto_CHB PCD with(nolock) on  PC.cd_prod = PCD.cd_prod
	where PC.cd_prod = @CD_Produto
	print @Descricao
--set	@03	=	dbo.PreencheStringV2(@03,20,' ') --Product ID
--set	@04	=	dbo.PreencheStringV2(@04,15,'0') --Quantity
--set	@05	=	dbo.PreencheStringV2(@05,2,' ')--UOM
--set	@06	=	dbo.PreencheStringV2(@06,12,'0')--Net Weight
--set	@07	=	dbo.PreencheStringV2(@07,12,'0')--Unit Price
----set	@13	=	dbo.PreencheStringV2(@13,4,' ')--Vendor
-----set	@15	=	dbo.PreencheStringV2(@15,3,' ')--Origin Country
--set	@17	=	dbo.PreencheStringV2(@17,10,' ')
--set	@22	=	dbo.PreencheStringV2(@22,6,' ')
--set	@23	=	dbo.PreencheStringV2(@23,10,' ')
--set	@35	=	dbo.PreencheStringV2(@x,4,'0')--Item

insert @TableTemp
Select 
@03	[03],	
@x Item,
@Descricao [Descricao],
@04	[04],
@05	[05],
@UOM[UOM],
@06	[06],	
@07	[07],
--@13	[13],
--@15	[15],
@17	[17],
@22	[22],	
@23	[23],	
@35	[35]

set @x=@x+1
					Fetch Next From Cur_TAB1 Into @Cd_Pedido,@CD_Produto,@Item,@Lote
				end
			close Cur_TAB1
			deallocate Cur_TAB1

select 
t03 [Product ID],
Item [ID Item],
cast(t04 as money) [Qty],
t05 [UOM - Siscomex],
UOM [UOM],
cast(t06 as money) [Net Weight],
cast(t07 as money) [Unit Price],
--t13,
--t15 ,
t17 [NCM],
t22 [ID (RM)],
t23 [Order Reference],
t35 [Item],
Descricao [Full Description]
from @TableTemp
GO
