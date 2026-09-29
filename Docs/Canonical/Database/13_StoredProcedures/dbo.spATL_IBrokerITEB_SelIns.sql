SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerITEB_SelIns](
 @ID_ITDI bigint,
 @Processo varchar(16)
)--
--spATL_IbrokerITEB_SelIns 1,'IMLVS21502003BR'

as

Declare @01 varchar(4)
Declare @02 varchar(15)
Declare @03 varchar(10)
Declare @04 varchar(3)
Declare @05 varchar(9)
Declare @06 varchar(9)
Declare @07 varchar(4)
Declare @08 varchar(6)
Declare @10 varchar(2)
Declare @11 varchar(4)
Declare @12 varchar(1)
Declare @13 varchar(1)
Declare @14 varchar(1)
Declare @15 varchar(6)
Declare @16 varchar(6)
Declare @17 varchar(3)
Declare @21 varchar(3)
Declare @22 varchar(10)
Declare @23 varchar(1)
Declare @24 varchar(2)
Declare @25 varchar(1)
Declare @26 varchar(3)
Declare @27 varchar(9)
Declare @28 varchar(9)
Declare @29 varchar(4)
Declare @30 varchar(6)
Declare @31 varchar(7)
Declare @32 varchar(7)
Declare @33 varchar(7)
Declare @34 varchar(7)
Declare @35 varchar(12)
Declare @36 varchar(2)
Declare @37 varchar(3)
Declare @38 varchar(1)
Declare @39 varchar(9)
Declare @40 varchar(9)
Declare @41 varchar(4)
Declare @42 varchar(6)
Declare @43 varchar(2)
Declare @44 varchar(7)
Declare @45 varchar(7)
Declare @46 varchar(7)
Declare @47 varchar(10)
Declare @48 varchar(1)


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

if left(@Processo,2) = 'IM'
	begin
		Select top 1 @17=TM.Cod_Nac_Moeda from LLP_Imp_Mar LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lim = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Tipo_Moeda TM with(nolock) on PD.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where LLP.Num_Proc_Lim = @Processo
	end
if left(@Processo,2) = 'IA'
	begin
		Select top 1 @17=TM.Cod_Nac_Moeda from LLP_Imp_Aer LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lia = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Tipo_Moeda TM on PD.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where LLP.Num_Proc_Lia = @Processo
	end
if left(@Processo,2) = 'IM'
	begin
		Select top 1 @17=TM.Cod_Nac_Moeda from LLP_Imp_Out LLP with(nolock)
		Join Pedido_Ship PS with(nolock) on  LLP.Num_Proc_Lio = PS.Num_Proc
		Join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
		Join Tipo_Moeda TM with(nolock) on PD.cd_tp_moeda = TM.Cd_Tp_Moeda 
		where LLP.Num_Proc_Lio = @Processo
	end
/*
Declare @Cd_Pes_Grupo varchar(10)

	Select @CD_Pes_Grupo = PD.Cd_Grupo, @15=OrgSis.Cd_Pais_Synchro from LLP_Imp_Mar LLP
	Join Pedido_Ship PS on  LLP.Num_Proc_Lim = PS.Num_Proc
	Join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	left Join Pais_Synchro_Int_Dow OrgSis with(nolock) on PD.Cd_Pais_Org = OrgSis.Cd_Pais
	where LLP.Num_Proc_Lim = @Processo and PS.Num_Proc = @Processo and PS.cd_pedido = @Cd_Pedido and PS.cd_produto = @CD_Produto and PS.Item=@Item and PS.Lote = @Lote 
	print @Cd_Pes_Grupo
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
set @01= dbo.PreencheStringV2('ITEB',4,'	')
set @02= dbo.PreencheStringV2(@Processo,15,' ')
set @03= dbo.PreencheStringV2('',10,' ')
set @04= dbo.PreencheStringV2('',3,' ')
set @05= dbo.PreencheStringV2('',9,' ')
set @06= dbo.PreencheStringV2('',9,' ')
set @07= dbo.PreencheStringV2('',4,' ')
set @08= dbo.PreencheStringV2('',6,' ')
set @10= dbo.PreencheStringV2('',2,' ')
set @11= dbo.PreencheStringV2('',4,' ')
set @12= dbo.PreencheStringV2('',1,' ')
set @13= dbo.PreencheStringV2('',1,' ')
set @14= dbo.PreencheStringV2('',1,' ')
set @15= dbo.PreencheStringV2('0.00',6,'0')
set @16= dbo.PreencheStringV2('0.00',6,'0')
set @17= dbo.PreencheStringV2(@17,3,' ')
set @21= dbo.PreencheStringV2('',3,' ')
set @22= dbo.PreencheStringV2('',10,' ')
set @23= dbo.PreencheStringV2('',1,' ')
set @24= dbo.PreencheStringV2('',2,' ')
set @25= dbo.PreencheStringV2('',1,' ')
set @26= dbo.PreencheStringV2('',3,' ')
set @27= dbo.PreencheStringV2('',9,' ')
set @28= dbo.PreencheStringV2('',9,' ')
set @29= dbo.PreencheStringV2('',4,' ')
set @30= dbo.PreencheStringV2('',6,' ')
set @31= dbo.PreencheStringV2('0',7,'0.00')
set @32= dbo.PreencheStringV2('',7,' ')
set @33= dbo.PreencheStringV2('0',7,'0.00')
set @34= dbo.PreencheStringV2('0',7,'0.00')
set @35= dbo.PreencheStringV2('',12,' ')
set @36= dbo.PreencheStringV2('',2,' ')
set @37= dbo.PreencheStringV2('',3,' ')
set @38= dbo.PreencheStringV2('',1,' ')
set @39= dbo.PreencheStringV2('',9,' ')
set @40= dbo.PreencheStringV2('',9,' ')
set @41= dbo.PreencheStringV2('',4,' ')
set @42= dbo.PreencheStringV2('',6,' ')
set @43= dbo.PreencheStringV2('',2,' ')
set @44= dbo.PreencheStringV2('0',7,'0.00')
set @45= dbo.PreencheStringV2('0',7,'0.00')
set @46= dbo.PreencheStringV2('0',7,'0.00')
set @47= dbo.PreencheStringV2('',10,' ')
set @48= dbo.PreencheStringV2('',1,' ')



insert dbo.IBROKER_ITEB 
Select 
@ID_ITDI,
@x,
@01 [01],
@02 [02],
@03 [03],
@04 [04],
@05 [05],
@06 [06],
@07 [07],
@08 [08],
@10 [10],
@11 [11],
@12 [12],
@13 [13],
@14 [14],
@15 [15],
@16 [16],
@17 [17],
@21 [21],
@22 [22],
@23 [23],
@24 [24],
@25 [25],
@26 [26],
@27 [27],
@28 [28],
@29 [29],
@30 [30],
@31 [31],
@32 [32],
@33 [33],
@34 [34],
@35 [35],
@36 [36],
@37 [37],
@38 [38],
@39 [39],
@40 [40],
@41 [41],
@42 [42],
@43 [43],
@44 [44],
@45 [45],
@46 [46],
@47 [47],
@48 [48]
set @x=@x+1
					Fetch Next From Cur_TAB1 Into @Cd_Pedido,@CD_Produto,@Item,@Lote
				end
			close Cur_TAB1
			deallocate Cur_TAB1
GO
