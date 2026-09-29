SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spAjustaValorPedido_Pedido_Det_Temp_New_Upd]
(
	@ID bigint
)

as

Begin Transaction
	
--	BEGIN
--		--fazer um ajusta Vlr_Pedido depois q já incluiu os valores
--		Begin
--			update Pedido_Temp_New set Vlr_Pedido=[dbo].[fPedido_Det_Temp_New_Vlr_Total_Item](P.ID) from Pedido_Temp_New P
--				join Pedido_Det_Temp_New PD with(nolock) on PD.ID = P.ID
--				left Join Pedido_Ship PS with(nolock) on PD.Item=ps.item and PD.cd_pedido=PS.cd_pedido
--			where 
--				 num_proc is null and P.ID = @ID
--		End		
--	END		

	BEGIN
		--fazer um ajusta Vlr_Pedido depois q já incluiu os valores
		Begin
			update 
				Pedido_Temp_New 
			set 
				Vlr_Pedido=convert(decimal(18,4),[dbo].[fPedido_Det_Temp_New_Vlr_Total_Item](P.ID)) 
			from Pedido_Temp_New P with(nolock)
				join Pedido_Det_Temp_New PD with(nolock) on PD.ID = P.ID
				left Join Pedido_Ship PS with(nolock) on PD.Item=ps.item and PD.cd_pedido=PS.cd_pedido
			where 
				 num_proc is null and P.ID = @ID
		End		
	END		

	--BEGIN
	--	--fazer um ajusta Vlr_Pedido depois q já incluiu os valores
	--	declare @Vlr_Pedido as decimal(18,4)
	--	Begin			
	--		set @Vlr_Pedido = (select sum(convert(decimal(18,4),replace(PD.Vlr_Total_Item,',','.'))) from Pedido_Temp_New P
	--			join Pedido_Det_Temp_New PD with(nolock) on PD.ID = P.ID
	--			left Join Pedido_Ship PS with(nolock) on PD.Item=ps.item and PD.cd_pedido=PS.cd_pedido
	--		where 
	--			 num_proc is null and P.ID = @ID)
	--	End	
		
	--	--print  @Vlr_Pedido
	--	Begin
	--		update Pedido_Temp_New 
	--			set Vlr_Pedido=replace(convert(decimal(18,4),@Vlr_Pedido),'.',',') from Pedido_Temp_New P				
	--		where 
	--			  P.ID = @ID
	--	End		
	--END				

COMMIT TRANSACTION
GO
