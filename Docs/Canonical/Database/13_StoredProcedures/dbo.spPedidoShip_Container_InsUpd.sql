SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPedidoShip_Container_InsUpd] --'43089845','00234730','990','Dow Brasil S 05042d2','EMCSR20080214001','002', '64139042'

	@Num_Pedido	VarChar(30),
	@Prod_ID 	varchar(30),
	@Qtd	 	float,
	@Shipper	Varchar(50),
	@Consignee	Varchar(50),
	@Num_Proc	varchar(16),
	@Item		Varchar(6),
	@Lote		varchar(30),
	@Usuario	varchar(50),
	
	
	@Num_Cont		varchar(20),
	--@FreeTime		datetime,
	@GoodsActual	datetime,
	@GoodsEstimated	datetime,
	@Num_ContAnt varchar(20) = null --Alessandra 16/07/2020
AS

BEGIN TRANSACTION

	Declare @Cd_Pedido	int
	Declare @Cd_Produto	int
	Declare @Cd_Shipper	varchar(10)
	Declare @Cd_Consignee varchar(10)	
	Declare @Cd_Pes_Grupo varchar(10)
	Declare @Cd_Usuario varchar(10)
	Declare @Item_Cont varchar(10)

	Set @Cd_Usuario = (Select Cd_Usuario from Usuario with(nolock) where Nome_Usuario = @Usuario and Ck_Ativo=1)

	Set @Cd_Shipper = (Select top 1 Cd_pes from Pessoa with(nolock) where apelido = @Shipper)
	Set @Cd_Consignee = (Select top 1 Cd_pes from Pessoa with(nolock) where apelido = @Consignee)
	If left(@Num_Proc,1)= 'E'
		Set @Cd_Pes_Grupo =(select top 1 G.Cd_Pes_Grupo from Pessoa_LLP PL with(nolock) Join Grupo G with(nolock) on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @Cd_Shipper)
	else
		Set @Cd_Pes_Grupo =(select top 1 G.Cd_Pes_Grupo from Pessoa_LLP PL with(nolock)  Join Grupo G with(nolock) on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @Cd_Consignee)
	
	Set @Cd_Pedido = (select top 1 Cd_Pedido from Pedido with(nolock) where Num_Pedido=@Num_Pedido and dt_pedido > getdate() -360  and CD_SELLER=@Cd_Shipper and (CD_BUYER=@Cd_Consignee or CD_Consignee =@Cd_Consignee))
	Set @Cd_Produto = (select top 1 Cd_Prod from produto_cliente with(nolock) where cd_proc_Cliente=@Prod_ID and Cd_Cliente=@Cd_Pes_Grupo)

	If left(@Num_Proc,1)= 'E'
		set @Item_Cont =(select MAS.Item_Cont_EM from Container_Mas_Exp_Mar MAS with(nolock)
		Join Container_Hou_exp_Mar HOU with(nolock) on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM
		--Alessandra 16/07/2020
		where num_proc_hem =@Num_Proc and num_cont_Em = @Num_Cont )
		--where num_proc_hem =@Num_Proc and num_cont_Em =  isnull(@Num_ContAnt,@Num_Cont))
	else
		set @Item_Cont  =(select MAS.Item_Cont_IM from container_mas_imp_mar MAS with(nolock)
		Join Container_Hou_Imp_Mar HOU with(nolock) on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM
		--Alessandra 16/07/2020
		where num_proc_him =@Num_Proc and num_cont_Im = @Num_Cont)
		--where num_proc_him =@Num_Proc and num_cont_Im = isnull(@Num_ContAnt,@Num_Cont))

--PO x Container
if @Num_Cont is not null
	BEGIN
		IF EXISTS(SELECT PS.CD_PEDIDO FROM Pedido_Ship_Container PS 
			--Where PS.Num_Cont = @Num_Cont and PS.cd_pedido=@cd_pedido and PS.cd_produto=@cd_produto and Num_Proc=@Num_Proc and Lote = @Lote and Item = @Item)
			Where PS.Num_Cont = isnull(@Num_ContAnt,@Num_Cont) and PS.cd_pedido=@cd_pedido and PS.cd_produto=@cd_produto and Num_Proc=@Num_Proc and Lote = @Lote and Item = @Item)
			
			BEGIN
					UPDATE
						Pedido_Ship_Container
					SET
						Qty = @Qtd, Dt_Ins = Getdate(), Cd_Usuario = @Cd_Usuario,
						Num_Cont = @Num_Cont, 
						--FreeTime = @FreeTime,
						GA_Ship_Actual_Date = @GoodsActual,
						GA_Ship_Estimated_Date = @GoodsEstimated,
						Item_Cont = @Item_Cont
					WHERE
						Num_Proc = @Num_Proc and cd_pedido = @Cd_Pedido and cd_produto = @Cd_Produto
				END
			ELSE
				BEGIN		
					INSERT INTO				
						Pedido_Ship_Container
						(
							Cd_pedido,
							Cd_Produto,
							Qty,
							Num_Proc,
							Item,
							Lote,
							Dt_Ins,
							Cd_Usuario,
							Num_Cont,
							--FreeTime,
							GA_Ship_Actual_Date,
							GA_Ship_Estimated_Date,
							Item_Cont
						)
					VALUES
						(
							@Cd_Pedido,
							@Cd_Produto,
							@Qtd,
							@Num_Proc,
							@Item,
							@Lote,
							Getdate(),
							@Cd_Usuario,
							@Num_Cont,
							--@FreeTime,
							@GoodsActual,
							@GoodsEstimated,
							@Item_Cont
						)
				END
	END
		
	IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

COMMIT TRANSACTION




GO
