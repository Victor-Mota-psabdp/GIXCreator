SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_IBrokerITEA_SelIns](
 @ID_ITDI bigint,
 @Processo varchar(16)
)--
--[spATL_IBrokerITEA_SelIns] 1,'IMOXT21501028BR'
--select * from IBROKER_ITEA
--select * from Pedido_Ship
--where Num_Proc ='IMLVS21502003BR'
as



--select @Cd_Pedido = Cd_Pedido,@CD_Produto=CD_Produto,@Item=Item,@Lote=Lote from Pedido_Ship
--where Num_Proc = @Processo



Declare	@01	varchar(4)
Declare	@02	varchar(15)
Declare	@03	varchar(20)
Declare	@04	varchar(15)
Declare	@05	varchar(2)
Declare	@06	varchar(12)
Declare	@07	varchar(12)
Declare	@08	varchar(1)
Declare	@09	varchar(5)
Declare	@10	varchar(10)
Declare	@11	varchar(2)
Declare	@12	varchar(1)
Declare	@13	varchar(4)
Declare	@14	varchar(4)
Declare	@15	varchar(3)
Declare	@16	varchar(3)
Declare	@17	varchar(10)
Declare	@18	varchar(3)
Declare	@19	varchar(9)
Declare	@20	varchar(9)
Declare	@21	varchar(4)
Declare	@22	varchar(6)
Declare	@23	varchar(10)
Declare	@24	varchar(3)
Declare	@25	varchar(9)
Declare	@26	varchar(9)
Declare	@27	varchar(4)
Declare	@28	varchar(6)
Declare	@29	varchar(10)
Declare	@30	varchar(3)
Declare	@31	varchar(9)
Declare	@32	varchar(9)
Declare	@33	varchar(4)
Declare	@34	varchar(6)
Declare	@35	varchar(4)

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
--select @Processo,@cd_pedido,@cd_produto,@Item,@Lote
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
		Select @CD_Pes_Grupo = PD.Cd_Grupo, @15=OrgSis.Cd_Pais_Synchro, @22 = PS.cd_pedido,@23 = PD.Num_Pedido from LLP_Imp_Mar LLP
		Join Pedido_Ship PS on  LLP.Num_Proc_Lim = PS.Num_Proc
		Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
		left Join Pais_Synchro_Int_Dow OrgSis with(nolock) on PD.Cd_Pais_Org = OrgSis.Cd_Pais
		where LLP.Num_Proc_Lim = @Processo and PS.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
	end
if left(@Processo,2) = 'IA'
	begin
	Select @CD_Pes_Grupo = PD.Cd_Grupo, @15=OrgSis.Cd_Pais_Synchro, @22 = PS.cd_pedido,@23 = PD.Num_Pedido from LLP_Imp_Aer LLP
	Join Pedido_Ship PS on  LLP.Num_Proc_Lia = PS.Num_Proc
	Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	left Join Pais_Synchro_Int_Dow OrgSis with(nolock) on PD.Cd_Pais_Org = OrgSis.Cd_Pais
	where LLP.Num_Proc_Lia = @Processo and PS.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
end
if left(@Processo,2) = 'IO'
	begin
	Select @CD_Pes_Grupo = PD.Cd_Grupo, @15=OrgSis.Cd_Pais_Synchro, @22 = PS.cd_pedido,@23 = PD.Num_Pedido from LLP_Imp_out LLP
	Join Pedido_Ship PS on  LLP.Num_Proc_Lio = PS.Num_Proc
	Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	left Join Pais_Synchro_Int_Dow OrgSis with(nolock) on PD.Cd_Pais_Org = OrgSis.Cd_Pais
	where LLP.Num_Proc_Lio = @Processo and PS.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
end
	
	print @Cd_Pes_Grupo
 --[03],
	select @03=PC.cd_Proc_Cliente from Produto_Cliente PC
	--join @TableProduto TP on PC.cd_prod = TP.CD_Produto 
	where PC.cd_Cliente = @Cd_Pes_Grupo and PC.cd_prod = @CD_Produto
 --[04]
	Select @04 = cast(isnull(PS.QTy,0) as decimal (15,02)) from Pedido_Ship PS 
	--Join @TableProduto TP on PS.cd_pedido = TP.Cd_Pedido and PS.cd_produto = TP.CD_Produto and PS.Item=TP.Item and PS.Lote = TP.Lote 
	 where Ps.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
	--set @04 = (select cast(isnull(@04,0) as decimal (15,02)))
--[13]	
/*	Select @13= right(Cd_Seller,4) from Pedido_Ship PS 
	Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	where PS.Num_Proc = @Processo
*/
select @13=right(isnull(SL.Campo_Dados,'0'),4) from Pedido_Ship PS
join Pedido PD on PS.cd_pedido = PD.Cd_pedido
left join Campo_Pessoa SL on PD.Cd_Seller = SL.Cd_Pes and SL.Id_Campo = 15
where Ps.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 

Declare @UnidadeMedida Table(
			Sigla varchar(4),
			CdSiscomex int
)
insert @UnidadeMedida
select 'KG',10 union select 'LTS',61 union select 'PE',0 union select 'TB',0 union select 'UN',0 union select 'L',50

--[05],[06],[07],[17],[35]
/*
	Select @05 = UM.CdSiscomex ,@06= PDet.Peso_Liquido_TOT,@07=Pdet.Vlr_Item,@17=PDet.NCM,@35=PDet.Item from Pedido_Ship PS
	--Join @TableProduto TP on PS.cd_pedido = TP.Cd_Pedido and PS.cd_produto = TP.CD_Produto and PS.Item=TP.Item and PS.Lote = TP.Lote 
	Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	Join Pedido_Det PDet on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.CD_Produto and PS.Item=PDet.Item and PS.Lote = PDet.Lote  
	Join @UnidadeMedida UM on PDet.UoM = UM.Sigla
	where PS.Num_Proc= @Processo  PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
	*/
	Select @05 = UM.CdSiscomex ,@06= cast(isnull(PDet.Peso_Liquido_TOT,0) as decimal (12,04)),@07=cast(isnull(Pdet.Vlr_Item,0) as decimal (12,04)),@17=PDet.NCM,@35=PDet.Item from Pedido_Det PDet
	left Join @UnidadeMedida UM on PDet.UoM = UM.Sigla
	where PDet.cd_pedido = @Cd_Pedido and PDet.cd_produto = @CD_Produto and PDet.Item=@Item and PDet.Lote = @Lote 
	--set @06 = (select cast(isnull(@06,0) as decimal (12,06)))
	--set @07 = (select cast(isnull(@07,0) as decimal (12,06)))
	
set	@01	=	dbo.PreencheStringV2('ITEA',4,'	')
set	@02	=	dbo.PreencheStringV2(@Processo,15,' ')
set	@03	=	dbo.PreencheStringV2(@03,20,' ') --Product ID
set	@04	=	dbo.PreencheStringV2(@04,15,'0') --Quantity
set	@05	=	dbo.PreencheStringV2(@05,2,' ')--UOM
set	@06	=	dbo.PreencheStringV2(@06,12,'0')--Net Weight
set	@07	=	dbo.PreencheStringV2(@07,12,'0')--Unit Price
set	@08	=	dbo.PreencheStringV2('1',1,' ')
set	@09	=	dbo.PreencheStringV2('0.00',5,'0')
set	@10	=	dbo.PreencheStringV2('0.00',10,'0')
set	@11	=	dbo.PreencheStringV2('',2,' ')
set	@12	=	dbo.PreencheStringV2('1',1,' ')
set	@13	=	dbo.PreencheStringV2(@13,4,' ')--Vendor
set	@14	=	dbo.PreencheStringV2(@13,4,' ')--Vendor
set	@15	=	dbo.PreencheStringV2(@15,3,' ')--Origin Country
set	@16	=	dbo.PreencheStringV2(@15,3,' ')--Origin Country
set	@17	=	dbo.PreencheStringV2(@17,10,' ')
set	@18	=	dbo.PreencheStringV2('',3,' ')
set	@19	=	dbo.PreencheStringV2('',9,' ')
set	@20	=	dbo.PreencheStringV2('',9,' ')
set	@21	=	dbo.PreencheStringV2('',4,' ')
set	@22	=	dbo.PreencheStringV2(@22,6,' ')
set	@23	=	dbo.PreencheStringV2(@23,10,' ')
set	@24	=	dbo.PreencheStringV2('',3,' ')
set	@25	=	dbo.PreencheStringV2('',9,' ')
set	@26	=	dbo.PreencheStringV2('',9,' ')
set	@27	=	dbo.PreencheStringV2('',4,' ')
set	@28	=	dbo.PreencheStringV2('',6,' ')
set	@29	=	dbo.PreencheStringV2('',10,' ')
set	@30	=	dbo.PreencheStringV2('',3,' ')
set	@31	=	dbo.PreencheStringV2('',9,' ')
set	@32	=	dbo.PreencheStringV2('',9,' ')
set	@33	=	dbo.PreencheStringV2('',4,' ')
set	@34	=	dbo.PreencheStringV2('',6,' ')
set	@35	=	dbo.PreencheStringV2(@x,4,'0')--Item

insert dbo.IBROKER_ITEA 
Select 
@ID_ITDI,
@x,
@01	[01],
@02	[02],
@03	[03],	
@04	[04],
@05	[05],
@06	[06],	
@07	[07],
@08	[08],
@09	[09],	
@10	[10],	
@11	[11],	
@12	[12],
@13	[13],
@14	[14],
@15	[15],
@16	[16],
@17	[17],
@18	[18],	
@19	[19],	
@20	[20],	
@21	[21],	
@22	[22],	
@23	[23],	
@24	[24],	
@25	[25],	
@26	[26],	
@27	[27],	
@28	[28],	
@29	[29],	
@30	[30],	
@31	[31],	
@32	[32],	
@33	[33],	
@34	[34],	
@35	[35]
set @x=@x+1
					Fetch Next From Cur_TAB1 Into @Cd_Pedido,@CD_Produto,@Item,@Lote
				end
			close Cur_TAB1
			deallocate Cur_TAB1
GO
