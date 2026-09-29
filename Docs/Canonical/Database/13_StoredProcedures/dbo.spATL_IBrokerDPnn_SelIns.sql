SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_IbrokerDPnn_SelIns 19,'IMFMC21503001BR'
CREATE procedure [dbo].[spATL_IBrokerDPnn_SelIns](
 @ID_ITDI bigint,
  @Processo varchar(16)
)

as



Declare	@01	varchar(4)
Declare	@02	varchar(15)
Declare	@03	varchar(4)
Declare	@04	varchar(16)
Declare	@05	varchar(201)


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
select Cd_Pedido,CD_Produto,Item,Lote from Pedido_Ship with(nolock)
where Num_Proc = @Processo order by  Cd_Pedido,CD_Produto,Item,Lote
--select @Processo,@cd_pedido,@cd_produto,@Item,@Lote
Declare  @x int
set @x=1
Declare @xIDnn int 
Declare @yIDnn int 
Declare  @t int

set @xIDnn = 0

Declare Cur_TAB1 cursor for
--Carrega campos chaves para buscar registro tipo 3 (Detalhes do registro 2)
			Select Cd_Pedido,CD_Produto,Item,Lote from @TableProduto
	Open Cur_TAB1
		Fetch Next From Cur_TAB1 Into @Cd_Pedido,@CD_Produto,@Item,@Lote
		
			While @@FETCH_STATUS = 0
				Begin	

set @yIDnn = 0
set @xIDnn = 0
set @t=1
Declare @Cd_Pes_Grupo varchar(10)
Declare @Descricao varchar(max)

	--select @xIDnn=len(isnull(PCD.MEM_DESCRICAOPORTUGUES,PCD.Produto_Descr)) from Produto_Cliente PC
	--join produto_cliente_ddgip PCD on  dbo.PreencheStringV2(PC.cd_Proc_Cliente,30,'0') = dbo.PreencheStringV2(PCD.cd_Proc_Cliente,30,'0')
	--where PC.cd_prod = @CD_Produto
	
	select @xIDnn=len(replace(replace(PCD.Descricao_Longa, CHAR(13), CHAR(32)), CHAR(10), CHAR(32))), @Descricao = replace(replace(PCD.Descricao_Longa, CHAR(13), CHAR(32)), CHAR(10), CHAR(32)) from Produto_Cliente PC with(nolock)
	join Produto_CHB PCD with(nolock) on  PC.cd_prod = PCD.cd_prod
	where PC.cd_prod = @CD_Produto

WHILE @xIDnn>0
begin
--[05]	
	
	if @xIDnn >= 201
	begin
		
		--select @05=substring(isnull(PCD.MEM_DESCRICAOPORTUGUES,PCD.Produto_Descr),@yIDnn,@yIDnn +201) from Produto_Cliente PC
		--join produto_cliente_ddgip PCD on  dbo.PreencheStringV2(PC.cd_Proc_Cliente,30,'0') = dbo.PreencheStringV2(PCD.cd_Proc_Cliente,30,'0')
		--where PC.cd_prod = @CD_Produto
		select @05=substring(@Descricao,@yIDnn,@yIDnn +201)
		--select @05=substring(PCD.Descricao_Longa,@yIDnn,@yIDnn +201) from Produto_Cliente PC
		--join Produto_CHB PCD on  PC.cd_prod = PCD.cd_prod
		--where PC.cd_prod = @CD_Produto
		set  @yIDnn = @yIDnn +201 
	end
	else
		begin 
		select @05=right(@Descricao,@xIDnn)
			--select @05=right(PCD.Descricao_Longa,@xIDnn) from Produto_Cliente PC
			--join Produto_CHB PCD on  PC.cd_prod = PCD.cd_prod
			--where PC.cd_prod = @CD_Produto
		end
	/*
 --[03],
	select @03=PC.cd_Proc_Cliente from Produto_Cliente PC
	--join @TableProduto TP on PC.cd_prod = TP.CD_Produto 
	where PC.cd_Cliente = @Cd_Pes_Grupo and PC.cd_prod = @CD_Produto
 --[04]
	Select @04 = PS.Qty from Pedido_Ship PS 
	--Join @TableProduto TP on PS.cd_pedido = TP.Cd_Pedido and PS.cd_produto = TP.CD_Produto and PS.Item=TP.Item and PS.Lote = TP.Lote 
	 where Ps.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
	set @04 = (select cast(@04 as decimal (15,02)))
--[13]	
	Select @13=PLLP.Cd_Vendor from Pedido_Ship PS 
	Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	Join Pessoa_LLP PLLP on PLLP.Cd_Pes = PD.Cd_Seller
	where PS.Num_Proc = @Processo
		
Declare @UnidadeMedida Table(
			Sigla varchar(4),
			CdSiscomex int
)
insert @UnidadeMedida
select 'KG',10 union select 'LTS',0 union select 'PE',0 union select 'TB',0 union select 'UN',0

--[05],[06],[07],[17],[35]
	Select @05 = UM.CdSiscomex ,@06= PDet.Peso_Liquido_TOT,@07=Pdet.Vlr_Item,@17=PDet.NCM,@35=PDet.Item from Pedido_Ship PS
	--Join @TableProduto TP on PS.cd_pedido = TP.Cd_Pedido and PS.cd_produto = TP.CD_Produto and PS.Item=TP.Item and PS.Lote = TP.Lote 
	Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	Join Pedido_Det PDet on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.CD_Produto and PS.Item=PDet.Item and PS.Lote = PDet.Lote  
	Join @UnidadeMedida UM on PDet.UoM = UM.Sigla
	where PS.Num_Proc= @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
	set @06 = (select cast(@06 as decimal (12,06)))
	set @07 = (select cast(@07 as decimal (12,06)))
*/	
set	@01	=	dbo.PreencheStringV2('DP'+right('00'+cast(@t as varchar(10)),2),4,' ')
set	@02	=	dbo.PreencheStringV2(@Processo,15,' ')
set	@03	=	dbo.PreencheStringV2(@x,4,'0') 
set	@04	=	dbo.PreencheStringV2('',16,' ') 
set	@05	=	dbo.PreencheStringV2(@05,201,' ')

insert dbo.IBROKER_DPnn 
Select 
@ID_ITDI,
@x,
@t,
@01	[01],
@02	[02],
@03	[03],	
@04	[04],
@05	[05]
set @t=@t+1
set @xIDnn = @xIDnn - 201
end
set @x=@x+1
					Fetch Next From Cur_TAB1 Into @Cd_Pedido,@CD_Produto,@Item,@Lote
				end
			close Cur_TAB1
			deallocate Cur_TAB1
GO
